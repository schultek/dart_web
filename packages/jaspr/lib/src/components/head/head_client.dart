import 'dart:html' as html;

import '../../../browser.dart';

class PlatformHead extends Component {
  const PlatformHead(this.children, {super.key});

  final List<Component> children;

  @override
  Element createElement() => HeadElement(this);
}

class HeadElement extends MultiChildRenderObjectElement {
  HeadElement(super.component);

  @override
  RenderObject createRenderObject() {
    return HeadRenderObject(depth);
  }

  @override
  void updateRenderObject() {}

  @override
  void activate() {
    super.activate();
    (renderObject as HeadRenderObject).depth = depth;
  }

  @override
  void detachRenderObject() {
    super.detachRenderObject();
    (renderObject as HeadRenderObject).unregister();
  }

  @override
  Iterable<Component> build() {
    return (component as PlatformHead).children;
  }
}

class HeadAdapter {
  static HeadAdapter instance = HeadAdapter();

  static final html.HeadElement head = html.document.head!;

  static final (html.Node, html.Node) headBoundary = () {
    var iterator = html.NodeIterator(head, html.NodeFilter.SHOW_COMMENT);

    html.Node? start, end;

    html.Comment? currNode;
    while ((currNode = iterator.nextNode() as html.Comment?) != null) {
      var value = currNode!.nodeValue ?? '';
      if (value == r'$') {
        start = currNode;
      } else if (value == '/') {
        end = currNode;
      }
    }

    if (start == null) {
      start = html.Comment(r'$');
      head.insertBefore(start, end);
    }
    if (end == null) {
      end = html.Comment('/');
      head.insertBefore(end, start.nextNode);
    }
    return (start, end);
  }();

  static List<html.Node> get liveHeadNodes {
    var nodes = <html.Node>[];
    html.Node? curr = headBoundary.$1.nextNode;
    while (curr != null && curr != headBoundary.$2) {
      nodes.add(curr);
      curr = curr.nextNode;
    }
    return nodes;
  }

  static final List<html.Node> headNodes = liveHeadNodes;

  HeadAdapter();

  final List<HeadRenderObject> _headRenderObjects = [];
  bool _needsResorting = true;

  String? keyFor(html.Node node) {
    return switch (node) {
      html.Element(tagName: "TITLE" || "BASE") => node.tagName,
      html.Element(tagName: "META", attributes: var attrs) =>
        'meta:${attrs.containsKey('charset') ? 'charset' : attrs['name']}',
      _ => null,
    };
  }

  void update() {
    if (_needsResorting) {
      _headRenderObjects.sort((a, b) => a._depth - b._depth);
      _needsResorting = false;
    }

    Map<String, html.Node> keyedNodes = {};
    List<html.Node> children = [];

    for (var renderObject in _headRenderObjects) {
      for (var node in renderObject.children) {
        var key = keyFor(node);
        if (key != null) {
          var shadowedNode = keyedNodes[key];
          keyedNodes[key] = node;
          if (shadowedNode != null) {
            children[children.indexOf(shadowedNode)] = node;
            continue;
          }
        }
        children.add(node);
      }
    }

    html.Node? current = headBoundary.$1.nextNode;

    for (var node in children) {
      if (current == node) {
        current = current?.nextNode;
      } else if (current != null && keyFor(node) == keyFor(current)) {
        current.replaceWith(node);
        current = node.nextNode;
      } else {
        head.insertBefore(node, current);
      }
    }

    while (current != null && current != headBoundary.$2) {
      var next = current.nextNode;
      current.remove();
      current = next;
    }
  }

  void register(HeadRenderObject renderObject) {
    _headRenderObjects.add(renderObject);
    _needsResorting = true;
  }

  void unregister(HeadRenderObject renderObject) {
    _headRenderObjects.remove(renderObject);
    update();
  }
}

class HeadRenderObject extends DomRenderObject {
  HeadRenderObject(this._depth) {
    node = html.Text('');
    toHydrate = HeadAdapter.headNodes;
    HeadAdapter.instance.register(this);
  }

  final List<html.Node> children = [];

  int _depth;
  set depth(int depth) {
    if (_depth == depth) return;
    _depth = depth;
    HeadAdapter.instance._needsResorting = true;
    HeadAdapter.instance.update();
  }

  @override
  void attach(DomRenderObject child, {DomRenderObject? after}) {
    try {
      var childNode = child.node;
      if (childNode == null) return;

      var afterNode = after?.node;
      if (afterNode == null && children.contains(childNode)) {
        // Keep child in current place.
        return;
      }

      if (afterNode != null && !children.contains(afterNode)) {
        afterNode = null;
      }

      children.remove(childNode);
      children.insert(afterNode != null ? children.indexOf(afterNode) + 1 : 0, childNode);
      HeadAdapter.instance.update();
    } finally {
      child.finalize();
    }
  }

  @override
  void remove(DomRenderObject child) {
    super.remove(child);
    children.remove(child.node);
    HeadAdapter.instance.update();
  }

  void unregister() {
    HeadAdapter.instance.unregister(this);
  }

  @override
  void finalize() {
    html.window.requestAnimationFrame((highResTime) {
      super.finalize();
    });
  }
}