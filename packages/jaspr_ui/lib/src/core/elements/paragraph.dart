import 'package:jaspr/jaspr.dart';
import 'package:jaspr_ui/src/core/elements/base.dart';

class Paragraph extends BaseElement {
  final String text;

  Paragraph(
    this.text, {
    super.key,
    super.id,
    super.styles,
    super.classes,
    super.attributes,
    super.events,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(
      tag: 'p',
      id: id,
      styles: styles,
      classes: classes,
      attributes: attributes,
      events: events,
      child: Text(text),
    );
  }
}