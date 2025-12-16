import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'splash_screen.dart';
// ignore: unused_import
import 'home_screen.dart';
import 'theme_provider.dart';

void main() {
  runApp(const TheVisionApp());
}

class TheVisionApp extends StatelessWidget {
  const TheVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'مكتب الرؤية - الدراسة في رواندا',
            theme: themeProvider.currentThemeData,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AE'),
              Locale('en', 'US'),
            ],
            locale: const Locale('ar', 'AE'),
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
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
