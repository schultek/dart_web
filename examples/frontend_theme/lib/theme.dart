import 'package:jaspr/jaspr.dart';

enum AppTheme with AppThemeMixin {
  counterButtonColor(
    light: Var(Colors.red),
    dark: Var(Colors.darkRed),
  ),
  counterButtonBorderColor(
    light: Var(Colors.darkRed),
    dark: Var(Colors.red),
  ),
  counterButtonTextColor(
    light: Var(Colors.black),
    dark: Var(Colors.white),
  ),
  counterTextFontFamily(
    light: Var(Unit.points(16)),
    dark: Var(Unit.points(12)),
  ),
  counterTextFontSize(
    light: Var(FontFamilies.arial),
    dark: Var(FontFamilies.timesNewRoman),
  );

  const AppTheme({required this.light, required this.dark});

  final Var light;
  final Var dark;

  static Var? getStyleByMode(BaseTheme mode, style) {
    switch (mode) {
      case ThemeMode.light:
        return style.light;
      case ThemeMode.dark:
        return style.dark;
    }
    return null;
  }

  static StyleRule get styles => ThemeUtils.getStyles(values, ThemeMode.values, getStyleByMode);
}

enum ThemeMode with BaseTheme {
  light,
  dark;

  @override
  String getName() => name;
}
