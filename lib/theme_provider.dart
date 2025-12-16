import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme {
  light,
  dark,
  blue,
  green,
  orange,
}

class ThemeProvider with ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;
  static const String _themeKey = 'app_theme';

  AppTheme get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _currentTheme = AppTheme.values[themeIndex];
    notifyListeners();
  }

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
    notifyListeners();
  }

  ThemeData get currentThemeData {
    switch (_currentTheme) {
      case AppTheme.dark:
        return darkTheme;
      case AppTheme.blue:
        return blueTheme;
      case AppTheme.green:
        return greenTheme;
      case AppTheme.orange:
        return orangeTheme;
      case AppTheme.light:
        return lightTheme;
    }
  }

  // الثيم الفاتح (الإفتراضي)
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF0f766e),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF14b8a6),
      surface: const Color(0xFFf8fafc),
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf8fafc),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0f766e),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
  );

  // الثيم الداكن
  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF14b8a6),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(
      secondary: const Color(0xFF0f766e),
      surface: const Color(0xFF1a1a1a),
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1a1a1a),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF14b8a6),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1a1a1a),
    ),
  );

  // الثيم الأزرق
  static final ThemeData blueTheme = ThemeData(
    primaryColor: const Color(0xFF1e40af),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF3b82f6),
      surface: const Color(0xFFf0f9ff),
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf0f9ff),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1e40af),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );

  // الثيم الأخضر
  static final ThemeData greenTheme = ThemeData(
    primaryColor: const Color(0xFF15803d),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF22c55e),
      surface: const Color(0xFFf0fdf4),
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf0fdf4),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF15803d),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );

  // الثيم البرتقالي
  static final ThemeData orangeTheme = ThemeData(
    primaryColor: const Color(0xFFea580c),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFFfb923c),
      surface: const Color(0xFFfff7ed),
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFfff7ed),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFea580c),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );

  Color get primaryColor => currentThemeData.primaryColor;
  Color get secondaryColor => currentThemeData.colorScheme.secondary;
  Color get backgroundColor => currentThemeData.scaffoldBackgroundColor;
  Color get cardColor => currentThemeData.cardColor;
  Color get textColor => currentThemeData.brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  Color get accentColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF14b8a6);
      case AppTheme.blue:
        return const Color(0xFF3b82f6);
      case AppTheme.green:
        return const Color(0xFF22c55e);
      case AppTheme.orange:
        return const Color(0xFFfb923c);
      case AppTheme.light:
      // ignore: unreachable_switch_default
      default:
        return const Color(0xFFf97316);
    }
  }
}
