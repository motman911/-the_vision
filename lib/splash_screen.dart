// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'language_selection_screen.dart'; // ✅ التوجيه لصفحة اللغة أولاً
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNextScreen();
  }

  Future<void> _checkNextScreen() async {
    try {
      // انتظار جمالي للأنيميشن
      await Future.delayed(const Duration(milliseconds: 2000));

      if (!mounted) return;

      // ✅ التحقق من حالة الترحيب
      final prefs = await SharedPreferences.getInstance();
      // ملاحظة: تأكد أن المفتاح هنا يطابق المفتاح الذي تحفظه في OnboardingScreen
      final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

      if (!mounted) return;

      if (seenOnboarding) {
        // 1. إذا كان مستخدماً قديماً -> اذهب للرئيسية فوراً
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // 2. إذا كان مستخدماً جديداً -> اذهب لاختيار اللغة أولاً
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen()),
        );
      }
    } catch (e) {
      // في حالة الخطأ، نذهب للرئيسية كاحتياط
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school,
                  size: 60,
                  color: Color(0xFF0f766e),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                languageProvider.isArabic ? 'مكتب الرؤية' : 'Vision Office',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                languageProvider.isArabic
                    ? 'الدراسة في رواندا'
                    : 'Study in Rwanda',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
