import 'package:jaspr/jaspr.dart';

abstract class BaseElement extends StatelessComponent {
  final String? id;
  final String tag;
  final Styles? style;
  final List<String>? classes;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  final Component? _child;
  final List<Component>? _children;

  const BaseElement({
    Key? key,
    Component? child,
    List<Component>? children,
    this.id,
    required this.tag,
    this.style,
    this.classes,
    this.attributes,
    this.events,
  })  : _child = child,
        _children = children,
        super(key: key);

  List<Component> getChildren() => _children ?? [];

  List<String> getClasses() => classes ?? [];

  Styles getStyles() => style ?? Styles.empty();

  Map<String, String> getAttributes() => attributes ?? {};

  Map<String, EventCallback> getEvents() => events ?? {};

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(
      id: id,
      tag: tag,
      styles: getStyles(),
      classes: getClasses(),
      attributes: getAttributes(),
      events: getEvents(),
      children: [if (_child != null) _child!, ...getChildren()],
    );
  }
}
