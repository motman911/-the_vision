// ignore_for_file: unreachable_switch_default

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
  late final SharedPreferences _prefs;

  AppTheme get currentTheme => _currentTheme;

  ThemeProvider() {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final themeIndex = _prefs.getInt(_themeKey) ?? 0;
      _currentTheme = AppTheme.values[themeIndex];
    } catch (e) {
      _currentTheme = AppTheme.light;
    }
    notifyListeners();
  }

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    try {
      await _prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // ignore: avoid_print
      print('Error saving theme: $e');
    }
    notifyListeners();
  }

  ThemeData get currentThemeData {
    return _getThemeData(_currentTheme);
  }

  ThemeData _getThemeData(AppTheme theme) {
    switch (theme) {
      case AppTheme.dark:
        return darkTheme;
      case AppTheme.blue:
        return blueTheme;
      case AppTheme.green:
        return greenTheme;
      case AppTheme.orange:
        return orangeTheme;
      case AppTheme.light:
      default:
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
  );

  // الألوان المحددة من الثيمات
  Color get primaryColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF14b8a6);
      case AppTheme.blue:
        return const Color(0xFF1e40af);
      case AppTheme.green:
        return const Color(0xFF15803d);
      case AppTheme.orange:
        return const Color(0xFFea580c);
      case AppTheme.light:
      default:
        return const Color(0xFF0f766e);
    }
  }

  Color get secondaryColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF0f766e);
      case AppTheme.blue:
        return const Color(0xFF3b82f6);
      case AppTheme.green:
        return const Color(0xFF22c55e);
      case AppTheme.orange:
        return const Color(0xFFfb923c);
      case AppTheme.light:
      default:
        return const Color(0xFF14b8a6);
    }
  }

  Color get accentColor => secondaryColor;

  Color get cardColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF1a1a1a);
      default:
        return Colors.white;
    }
  }

  Color get textColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return Colors.white;
      default:
        return Colors.black87;
    }
  }

  Color get backgroundColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF121212);
      case AppTheme.blue:
        return const Color(0xFFf0f9ff);
      case AppTheme.green:
        return const Color(0xFFf0fdf4);
      case AppTheme.orange:
        return const Color(0xFFfff7ed);
      case AppTheme.light:
      default:
        return const Color(0xFFf8fafc);
    }
  }

  Color get surfaceColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF1a1a1a);
      case AppTheme.blue:
        return const Color(0xFFf0f9ff);
      case AppTheme.green:
        return const Color(0xFFf0fdf4);
      case AppTheme.orange:
        return const Color(0xFFfff7ed);
      case AppTheme.light:
      default:
        return const Color(0xFFf8fafc);
    }
  }

  // ألوان إضافية
  Color get primaryColorLight => _colorWithOpacity(primaryColor, 0.1);
  Color get primaryColorMedium => _colorWithOpacity(primaryColor, 0.3);
  Color get secondaryColorLight => _colorWithOpacity(secondaryColor, 0.1);

  Color get onPrimaryColor => Colors.white;
  Color get onSecondaryColor => Colors.white;
  Color get errorColor => const Color(0xFFef4444);
  Color get successColor => const Color(0xFF22c55e);
  Color get warningColor => const Color(0xFFf59e0b);
  Color get infoColor => const Color(0xFF0ea5e9);

  // دالة مساعدة للـ opacity
  Color _colorWithOpacity(Color color, double opacity) {
    final clampedOpacity = opacity.clamp(0.0, 1.0);
    return color.withOpacity(clampedOpacity);
  }
}
