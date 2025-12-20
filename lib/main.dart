// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ مهم جداً لهذه الميزة
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_screen.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'app_config.dart';
// ignore: unused_import
import 'favorites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. ضبط ألوان شريط الحالة (الساعة والبطارية)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // شفاف عشان ياخد لون الـ AppBar
    statusBarIconBrightness: Brightness.dark, // أيقونات داكنة (للوضع الفاتح)
    systemNavigationBarColor: Colors.white, // شريط التنقل السفلي للأندرويد
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // ✅ 2. تثبيت التطبيق في الوضع الطولي فقط (منع التدوير)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await dotenv.load(fileName: ".env");
    print('🔐 تم تحميل ملف البيئة بنجاح');
  } catch (e) {
    print('❌ خطأ في تحميل ملف .env: $e');
  }

  print('🚀 بدء تشغيل تطبيق مكتب الرؤية...');
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
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: '${AppConfig.appName} - الدراسة في رواندا',

            // ✅ تعديل الثيم لاستخدام خط تجوال
            theme: themeProvider.currentThemeData.copyWith(
              textTheme: GoogleFonts.tajawalTextTheme(
                themeProvider.currentThemeData.textTheme,
              ),
              appBarTheme: themeProvider.currentThemeData.appBarTheme.copyWith(
                titleTextStyle: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.currentTheme == AppTheme.dark
                        ? Colors.white
                        : Colors.black, // تعديل حسب الثيم
                  ),
                ),
              ),
            ),

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
