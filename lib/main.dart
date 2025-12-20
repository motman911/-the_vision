// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'splash_screen.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
// ✅ استبدل env_config بـ app_config
import 'app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 بدء تشغيل تطبيق مكتب الرؤية...');
  print('📁 المسار الحالي: ${Directory.current.path}');

  // ✅ استخدام AppConfig مباشرة
  AppConfig.printConfig();

  runApp(const TheVisionApp());
}

class TheVisionApp extends StatelessWidget {
  const TheVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: '${AppConfig.appName} - الدراسة في رواندا',
            theme: themeProvider.currentThemeData,
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AE'),
              Locale('en', 'US'),
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: languageProvider.isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
