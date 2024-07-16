import '../../jaspr.dart';

class Style extends StatelessComponent {
  const Style({required this.styles, super.key});

  final List<StyleRule> styles;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(
      tag: 'style',
      child: RawText(styles.map((s) => s._toCss()).join(cssPropSpace)),
    );
  }
}

/// Utility method to create nested style definitions.
NestedStyleRule css(String selector, [List<StyleRule> children = const []]) =>
    NestedStyleRule._(_BlockStyleRule(selector: Selector(selector), styles: const Styles()), children);

abstract class StyleRule {
  const factory StyleRule({required Selector selector, required Styles styles}) = _BlockStyleRule;

  const factory StyleRule.import(String url) = _ImportStyleRule;
  const factory StyleRule.fontFace({required String fontFamily, FontStyle? fontStyle, required String url}) =
      _FontFaceStyleRule;
  const factory StyleRule.media({required MediaRuleQuery query, required List<StyleRule> styles}) = _MediaStyleRule;

  String _toCss([String indent]);
}

class NestedStyleRule with StylesMixin<NestedStyleRule> implements StyleRule {
  NestedStyleRule._(this._self, this._children);

  final _BlockStyleRule _self;
  final List<StyleRule> _children;

  @override
  NestedStyleRule combine(Styles styles) {
    return NestedStyleRule._(
        _BlockStyleRule(selector: _self.selector, styles: _self.styles.combine(styles)), _children);
  }

  @override
  String _toCss([String indent = '', String parent = '']) {
    final rules = <String>[];

    final self = _self;
    final curr = self.selector.selector.startsWith('&') || parent.isEmpty
        ? self.selector.selector.replaceAll('&', parent)
        : '$parent ${self.selector.selector}';

    if (_self.styles.styles.isNotEmpty) {
      rules.add(_self._toCssWithParent(indent, parent));
    }

    for (final child in _children) {
      if (child is NestedStyleRule) {
        rules.add(child._toCss(indent, curr));
      } else if (child is _BlockStyleRule) {
        rules.add(child._toCssWithParent(indent, curr));
      } else {
        throw UnsupportedError('Cannot nest ${child.runtimeType} inside other StyleRule.');
      }
    }

    return rules.join(cssPropSpace);
  }
}

extension on _BlockStyleRule {
  String _toCssWithParent(String indent, String parent) {
    final child = _BlockStyleRule(
      selector: Selector(selector.selector.startsWith('&') || parent.isEmpty
          ? selector.selector.replaceAll('&', parent)
          : '$parent ${selector.selector}'),
      styles: styles,
    );
    return child._toCss(indent);
  }
}

class _BlockStyleRule implements StyleRule {
  const _BlockStyleRule({required this.selector, required this.styles});

  final Selector selector;
  final Styles styles;

  @override
  String _toCss([String indent = '']) {
    return '$indent${selector.selector} {$cssPropSpace'
        '${styles.styles.entries.map((e) => '$indent$cssBlockInset${e.key}: ${e.value};$cssPropSpace').join()}'
        '$indent}';
  }
}

class _MediaStyleRule implements StyleRule {
  const _MediaStyleRule({required this.query, required this.styles});

  final MediaRuleQuery query;
  final List<StyleRule> styles;

  @override
  String _toCss([String indent = '']) {
    return '$indent@media ${query._value} {$cssPropSpace'
        '${styles.map((r) => r._toCss(kDebugMode ? '$indent  ' : '') + cssPropSpace).join()}'
        '$indent}';
  }
}

enum MediaRuleTarget {
  all,
  screen,
  print;
}

abstract class MediaRuleQuery {
  const factory MediaRuleQuery({
    MediaRuleTarget target,
    Unit? minWidth,
    Unit? maxWidth,
    Unit? minHeight,
    Unit? maxHeight,
    Orientation? orientation,
    bool? canHover,
    String? aspectRatio,
  }) = _MediaRuleQuery;

  const factory MediaRuleQuery.not(MediaRuleQuery query) = _NotMediaRuleQuery;
  const factory MediaRuleQuery.any(List<MediaRuleQuery> queries) = _AnyMediaRuleQuery;

  static const MediaRuleQuery all = MediaRuleQuery();
  static const MediaRuleQuery screen = MediaRuleQuery(target: MediaRuleTarget.screen);
  static const MediaRuleQuery print = MediaRuleQuery(target: MediaRuleTarget.print);

  String get _value;
}

enum Orientation { portrait, landscape }

class _MediaRuleQuery implements MediaRuleQuery {
  const _MediaRuleQuery({
    this.target = MediaRuleTarget.all,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.orientation,
    this.canHover,
    this.aspectRatio,
  });

  final MediaRuleTarget target;
  final Unit? minWidth;
  final Unit? maxWidth;
  final Unit? minHeight;
  final Unit? maxHeight;
  final Orientation? orientation;
  final bool? canHover;
  final String? aspectRatio;

  @override
  String get _value => '${target.name}'
      '${minWidth != null ? ' and (min-width: ${minWidth!.value})' : ''}'
      '${maxWidth != null ? ' and (max-width: ${maxWidth!.value})' : ''}'
      '${minHeight != null ? ' and (min-height: ${minHeight!.value})' : ''}'
      '${maxHeight != null ? ' and (max-height: ${maxHeight!.value})' : ''}'
      '${orientation != null ? ' and (orientation: ${orientation!.name})' : ''}'
      '${canHover != null ? ' and (hover: ${canHover! ? 'hover' : 'none'})' : ''}'
      '${aspectRatio != null ? ' and (aspect-ratio: ${aspectRatio!})' : ''}';
}

class _NotMediaRuleQuery implements MediaRuleQuery {
  const _NotMediaRuleQuery(this.query);

  final MediaRuleQuery query;

  @override
  String get _value {
    assert((() {
      if (query is _AnyMediaRuleQuery) {
        throw 'Cannot apply MediaRuleQuery.not() on MediaRuleQuery.any(). Apply on each individual rule instead.';
      }
      if (query is _NotMediaRuleQuery) {
        throw 'Cannot apply MediaRuleQuery.not() twice.';
      }
      return true;
    })());
    return 'not ${query._value}';
  }
}

class _AnyMediaRuleQuery implements MediaRuleQuery {
  const _AnyMediaRuleQuery(this.queries);

  final List<MediaRuleQuery> queries;

  @override
  String get _value => queries.join(', ');
}

class _ImportStyleRule implements StyleRule {
  const _ImportStyleRule(this.url);

  final String url;

  @override
  String _toCss([String indent = '']) {
    return '$indent@import url($url);';
  }
}

class _FontFaceStyleRule implements StyleRule {
  const _FontFaceStyleRule({required this.fontFamily, this.fontStyle, required this.url});

  final String fontFamily;
  final FontStyle? fontStyle;
  final String url;

  @override
  String _toCss([String indent = '']) {
    return '$indent@font-face {$cssPropSpace'
        '$indent${cssBlockInset}font-family: "$fontFamily";$cssPropSpace'
        '${fontStyle != null ? '$indent${cssBlockInset}font-style: ${fontStyle!.value};$cssPropSpace' : ''}'
        '$indent${cssBlockInset}src: url($url);$cssPropSpace'
        '$indent}';
  }
}

bool unallowedList(Selector selector) {
  if (selector is _ListSelector) {
    throw 'Cannot further chain selector list, only single selector supported.';
  }
  return true;
}

extension SelectorMixin on Selector {
  Selector tag(String tag) {
    assert(unallowedList(this));
    return Selector.chain([this, Selector.tag(tag)]);
  }

  Selector id(String id) {
    assert(unallowedList(this));
    return Selector.chain([this, Selector.id(id)]);
  }

  Selector className(String className) {
    assert(unallowedList(this));
    return Selector.chain([this, Selector.className(className)]);
  }

  Selector dot(String className) {
    assert(unallowedList(this));
    return Selector.chain([this, Selector.dot(className)]);
  }

  Selector descendant(Selector next) {
    assert(unallowedList(this));
    return Selector.combine([this, next]);
  }

  Selector child(Selector next) {
    assert(unallowedList(this));
    return Selector.combine([this, next], combinator: Combinator.child);
  }

  Selector sibling(Selector next) {
    assert(unallowedList(this));
    return Selector.combine([this, next], combinator: Combinator.sibling);
  }

  Selector adjacentSibling(Selector next) {
    assert(unallowedList(this));
    return Selector.combine([this, next], combinator: Combinator.adjacentSibling);
  }
}

class Selector {
  const Selector(this.selector);

  const Selector.tag(String tag) : selector = tag;
  const Selector.id(String id) : selector = '#$id';
  const Selector.dot(String className) : selector = '.$className';
  const Selector.className(String className) : selector = '.$className';
  const factory Selector.attr(String attr, {AttrCheck check}) = _AttrSelector;

  const Selector.pseudoClass(String name) : selector = ':$name';
  const Selector.pseudoElem(String name) : selector = '::$name';

  const factory Selector.chain(List<Selector> selectors) = _ChainSelector;

  const factory Selector.combine(List<Selector> selectors, {Combinator combinator}) = _CombineSelector;

  const factory Selector.list(List<Selector> selectors) = _ListSelector;

  static const Selector all = Selector('*');

  /// The css selector
  final String selector;
}

class _AttrSelector implements Selector {
  const _AttrSelector(this.attr, {this.check = const AttrCheck.exists()});

  final String attr;
  final AttrCheck check;

  @override
  String get selector => '[$attr${check.value}${!check.caseSensitive ? ' i' : ''}]';
}

class AttrCheck {
  const AttrCheck.exists()
      : value = '',
        caseSensitive = true;
  const AttrCheck.exactly(String value, {this.caseSensitive = true}) : value = '="$value"';
  const AttrCheck.containsWord(String value, {this.caseSensitive = true}) : value = '~="$value"';
  const AttrCheck.startsWith(String prefix, {this.caseSensitive = true}) : value = '^="$prefix"';
  const AttrCheck.endsWith(String suffix, {this.caseSensitive = true}) : value = '\$="$suffix"';
  const AttrCheck.dashPrefixed(String prefix, {this.caseSensitive = true}) : value = '|="$prefix"';
  const AttrCheck.contains(String prefix, {this.caseSensitive = true}) : value = '*="$prefix"';

  final String value;
  final bool caseSensitive;
}

class _ChainSelector implements Selector {
  const _ChainSelector(this.selectors);

  final List<Selector> selectors;

  @override
  String get selector {
    assert((() {
      if (selectors.any((s) => s is _ListSelector)) {
        throw 'Cannot further chain selector list, only single selectors supported.';
      }
      return true;
    })());
    return selectors.map((s) => s.selector).join();
  }
}

enum Combinator {
  descendant(' '),
  child(' > '),
  sibling(' ~ '),
  adjacentSibling(' + ');

  const Combinator(this.separator);
  final String separator;
}

class _CombineSelector implements Selector {
  const _CombineSelector(this.selectors, {this.combinator = Combinator.descendant});

  final List<Selector> selectors;
  final Combinator combinator;

  @override
  String get selector => selectors.map((s) => s.selector).join(combinator.separator);
}

class _ListSelector implements Selector {
  const _ListSelector(this.selectors);

  final List<Selector> selectors;

  @override
  String get selector => selectors.map((s) => s.selector).join(', ');
}

const cssBlockInset = kDebugMode || kGenerateMode ? '  ' : '';
const cssPropSpace = kDebugMode || kGenerateMode ? '\n' : ' ';
