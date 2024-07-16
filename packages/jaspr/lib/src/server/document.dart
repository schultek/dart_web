import 'dart:async';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

import '../../server.dart';
import 'child_nodes.dart';

export '../components/style.dart' hide Style;

abstract class Document extends StatelessComponent {
  const factory Document({
    String? title,
    String? lang,
    String? base,
    String? charset,
    String? viewport,
    Map<String, String>? meta,
    List<StyleRule>? styles,
    List<Component> head,
    required Component body,
  }) = _BaseDocument;

  const factory Document.template({
    String name,
    String attachTo,
    required Component child,
  }) = _TemplateDocument;

  const Document._() : super();

  // only allow a single document
  static final _key = GlobalKey();

  @override
  Key get key => _key;
}

class _BaseDocument extends Document {
  const _BaseDocument({
    this.title,
    this.lang,
    this.base,
    this.charset = 'utf-8',
    this.viewport = 'width=device-width, initial-scale=1.0',
    this.meta,
    this.styles,
    this.head = const [],
    required this.body,
  }) : super._();

  final String? title;
  final String? lang;
  final String? base;
  final String? charset;
  final String? viewport;
  final Map<String, String>? meta;
  final List<StyleRule>? styles;
  final List<Component> head;
  final Component body;

  String? get _normalizedBase {
    var base = this.base;
    if (base == null) return null;
    if (!base.startsWith('/')) base = '/$base';
    if (!base.endsWith('/')) base = '$base/';
    return base;
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(
      tag: 'html',
      attributes: {
        if (lang != null) 'lang': lang!,
      },
      children: [
        DomComponent(
          tag: 'head',
          children: [
            if (base != null) DomComponent(tag: 'base', attributes: {'href': _normalizedBase!}),
            if (charset != null) DomComponent(tag: 'meta', attributes: {'charset': charset!}),
            Head(
              title: title,
              meta: {
                if (viewport != null) 'viewport': viewport!,
                ...?meta,
              },
            ),
            if (styles != null) //
              Style(styles: styles!),
            ...head,
          ],
        ),
        DomComponent(tag: 'body', child: body),
      ],
    );
  }
}

class _TemplateDocument extends Document {
  const _TemplateDocument({
    this.name = 'index',
    this.attachTo = 'body',
    required this.child,
  }) : super._();

  final String name;
  final String attachTo;
  final Component child;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield child;
  }

  @override
  Element createElement() => _TemplateDocumentElement(this);
}

class _TemplateDocumentElement extends StatelessElement {
  _TemplateDocumentElement(_TemplateDocument super.component);

  Future<String?>? _templateFuture;

  @override
  Iterable<Component> build() {
    (binding as ServerAppBinding).addRenderAdapter(_TemplateDocumentAdapter(this));
    _templateFuture ??=
        (binding as ServerAppBinding).loadFile('${(component as _TemplateDocument).name}.template.html');
    return super.build();
  }
}

class _TemplateDocumentAdapter extends ElementBoundaryAdapter {
  _TemplateDocumentAdapter(super.element);

  late String template;

  @override
  FutureOr<void> prepare() async {
    final template = await (element as _TemplateDocumentElement)._templateFuture;
    if (template == null) {
      throw TemplateNotFoundError((element.component as _TemplateDocument).name);
    }
    this.template = template;
    return super.prepare();
  }

  @override
  void applyBoundary(ChildListRange range) {
    var curr = range.start.prev!;
    range.remove();
    final document = parse(template);
    final target = document.querySelector((element.component as _TemplateDocument).attachTo)!;

    MarkupRenderObject? createTree(dom.Node node) {
      final n = element.parentRenderObjectElement!.renderObject.createChildRenderObject() as MarkupRenderObject;

      if (node is dom.Text) {
        if (node.text.trim().isEmpty) {
          return null;
        }
        n.updateText(node.text.trim(), true);
      } else if (node is dom.Comment) {
        n.updateText('<!--${node.data}-->', true);
      } else if (node is dom.Element) {
        n.updateElement(node.localName!, null, null, null, node.attributes.cast(), null);
      } else if (node is dom.DocumentType) {
        n.updateText(node.toString(), true);
      } else {
        throw UnsupportedError('Unsupported node type ${node.nodeType}');
      }

      if (node == target) {
        n.children.insertNodeAfter(range);
      } else {
        for (final c in node.nodes) {
          final o = createTree(c);
          if (o != null) {
            n.children.insertBefore(o);
          }
        }
      }

      return n;
    }

    for (final n in document.nodes) {
      final o = createTree(n);
      if (o != null) {
        final next = ChildNodeData(o);
        curr.insertNext(next);
        curr = next;
      }
    }
  }
}

class TemplateNotFoundError extends Error {
  TemplateNotFoundError(this.name);

  final String name;

  @override
  String toString() {
    return 'TemplateNotFoundError: The template "$name.template.html" was not found.';
  }
}
