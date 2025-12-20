import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/language_provider.dart';
import 'onboarding_screen.dart';
import 'theme_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Image.asset(
                  'assets/images/icon.png', // تأكد أن الشعار موجود هنا
                  width: 80,
                  height: 80,
                  errorBuilder: (c, o, s) =>
                      Icon(Icons.school, size: 60, color: theme.primaryColor),
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'Choose your language\nاختر لغتك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // زر العربية
              _buildLanguageButton(
                context,
                title: 'العربية',
                flag: '🇸🇦',
                onTap: () {
                  lang.changeLanguage(const Locale('ar'));
                  _goToOnboarding(context);
                },
                theme: theme,
              ),

              const SizedBox(height: 16),

              // زر الإنجليزية
              _buildLanguageButton(
                context,
                title: 'English',
                flag: '🇺🇸',
                onTap: () {
                  lang.changeLanguage(const Locale('en'));
                  _goToOnboarding(context);
                },
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String title,
    required String flag,
    required VoidCallback onTap,
    required ThemeProvider theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
