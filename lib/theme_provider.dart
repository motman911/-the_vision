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
      debugPrint('Error saving theme: $e');
    }
    notifyListeners();
  }

  void toggleTheme() {
    if (_currentTheme == AppTheme.dark) {
      setTheme(AppTheme.light);
    } else {
      setTheme(AppTheme.dark);
    }
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

  // --- تعريفات الثيمات (تم تحديث الألوان هنا) ---

  // ✅ الثيم الفاتح (تم تحسين الخلفية لتبدو Premium)
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF0f766e), // Teal
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF0f766e),
      secondary: const Color(0xFF14b8a6),
      surface: const Color(0xFFF1F5F9), // Slate 100 (بدلاً من الأبيض الصريح)
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Slate 100
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0f766e),
      foregroundColor: Colors.white,
      elevation: 0, // إلغاء الظل القديم للـ AppBar ليكون مسطحاً وعصرياً
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF0f766e),
      unselectedItemColor: Color(0xFF94A3B8), // Slate 400
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF14b8a6),
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF14b8a6),
      secondary: const Color(0xFF0f766e),
      surface: const Color(0xFF1e293b), // Slate 800
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        const Color(0xFF0F172A), // Slate 900 (فخم جداً للداكن)
    cardColor: const Color(0xFF1e293b), // Slate 800
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1e293b),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1e293b),
      selectedItemColor: Color(0xFF14b8a6),
      unselectedItemColor: Colors.grey,
    ),
  );

  // بقية الثيمات (أزرق، أخضر، برتقالي) مع تحسين الخلفيات أيضاً
  static final ThemeData blueTheme = ThemeData(
    primaryColor: const Color(0xFF1e40af),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF1e40af),
      secondary: const Color(0xFF3b82f6),
      surface: const Color(0xFFF0F9FF), // Sky 50
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F9FF),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1e40af),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: const Color(0xFF15803d),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF15803d),
      secondary: const Color(0xFF22c55e),
      surface: const Color(0xFFF0FDF4), // Green 50
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0FDF4),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF15803d),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static final ThemeData orangeTheme = ThemeData(
    primaryColor: const Color(0xFFea580c),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFFea580c),
      secondary: const Color(0xFFfb923c),
      surface: const Color(0xFFFFF7ED), // Orange 50
    ),
    fontFamily: 'Cairo',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF7ED),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFea580c),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  // --- Getters للألوان لتسهيل الاستخدام ---

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
      default:
        return const Color(0xFF14b8a6);
    }
  }

  Color get accentColor => secondaryColor;

  Color get cardColor {
    return _currentTheme == AppTheme.dark
        ? const Color(0xFF1e293b)
        : Colors.white;
  }

  // ✅ لون النص الجديد (Slate 800) بدلاً من الأسود
  Color get textColor {
    return _currentTheme == AppTheme.dark
        ? const Color(0xFFF8FAFC) // Slate 50
        : const Color(0xFF1E293B); // Slate 800
  }

  // ✅ لون النص الفرعي الجديد (رمادي متوسط)
  Color get subTextColor {
    return _currentTheme == AppTheme.dark
        ? const Color(0xFF94A3B8) // Slate 400
        : const Color(0xFF64748B); // Slate 500
  }

  // ✅ لون الظل الجديد (ملون وليس أسود)
  Color get shadowColor {
    return _currentTheme == AppTheme.dark
        ? const Color(0xFF0F172A).withOpacity(0.5)
        : primaryColor.withOpacity(0.15);
  }

  Color get surfaceColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF1e293b);
      case AppTheme.blue:
        return const Color(0xFFF0F9FF);
      case AppTheme.green:
        return const Color(0xFFF0FDF4);
      case AppTheme.orange:
        return const Color(0xFFFFF7ED);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color get scaffoldBackgroundColor {
    switch (_currentTheme) {
      case AppTheme.dark:
        return const Color(0xFF0F172A);
      case AppTheme.blue:
        return const Color(0xFFF0F9FF);
      case AppTheme.green:
        return const Color(0xFFF0FDF4);
      case AppTheme.orange:
        return const Color(0xFFFFF7ED);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  // ألوان إضافية مساعدة
  Color get primaryColorLight => _colorWithOpacity(primaryColor, 0.1);
  Color get primaryColorMedium => _colorWithOpacity(primaryColor, 0.3);
  Color get secondaryColorLight => _colorWithOpacity(secondaryColor, 0.1);

  Color get onPrimaryColor => Colors.white;
  Color get onSecondaryColor => Colors.white;
  Color get errorColor => const Color(0xFFef4444);
  Color get successColor => const Color(0xFF22c55e);
  Color get warningColor => const Color(0xFFf59e0b);
  Color get infoColor => const Color(0xFF0ea5e9);

  Color _colorWithOpacity(Color color, double opacity) {
    final clampedOpacity = opacity.clamp(0.0, 1.0);
    return color.withOpacity(clampedOpacity);
  }
}
