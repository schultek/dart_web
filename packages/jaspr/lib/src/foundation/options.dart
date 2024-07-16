import 'dart:convert';

import '../framework/framework.dart';

/// Main class for initializing the jaspr framework.
///
/// Call [Jaspr.initializeApp()] at the start of your app, before any calls to [runApp].
class Jaspr {
  static void initializeApp({JasprOptions options = const JasprOptions(), bool useIsolates = true}) {
    _options = options;
    _useIsolates = useIsolates;
  }

  static bool get isInitialized => _options != null;

  static JasprOptions get options => _options ?? const JasprOptions();
  static JasprOptions? _options;

  static bool get useIsolates => _useIsolates;
  static bool _useIsolates = true;
}

/// Global options for configuring jaspr. DO NOT USE DIRECTLY.
/// Use the generated [defaultJasprOptions] instead.
class JasprOptions {
  const JasprOptions({this.targets = const {}});

  final Map<Type, ClientTarget> targets;
}

/// The target configuration for a @client component. DO NOT USE DIRECTLY.
/// Use the generated [defaultJasprOptions] instead.
class ClientTarget<T extends Component> {
  const ClientTarget(this.name, {this.params});

  final String name;
  final Map<String, dynamic> Function(T component)? params;

  String? dataFor(T component) {
    if (params == null) return null;
    return const HtmlEscape(HtmlEscapeMode(escapeLtGt: true)).convert(jsonEncode(params!(component)));
  }
}
