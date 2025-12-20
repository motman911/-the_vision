// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Dialog(
      backgroundColor: themeProvider.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Directionality(
          textDirection:
              languageProvider.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: themeProvider.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.settings,
                          color: themeProvider.primaryColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      languageProvider.settings,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 1️⃣ قسم اللغة
                _buildSectionTitle(
                  languageProvider.languageText,
                  Icons.language,
                  themeProvider,
                ),
                const SizedBox(height: 8),
                _buildLanguageOption(
                    context, 'العربية', const Locale('ar'), Icons.language),
                _buildLanguageOption(
                    context, 'English', const Locale('en'), Icons.translate),

                const Divider(height: 30),

                // 2️⃣ قسم السمة (الألوان)
                _buildSectionTitle(
                  languageProvider.themeText,
                  Icons.palette,
                  themeProvider,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildColorCircle(
                        context, AppTheme.light, const Color(0xFF0f766e)),
                    _buildColorCircle(
                        context, AppTheme.blue, const Color(0xFF1e40af)),
                    _buildColorCircle(
                        context, AppTheme.green, const Color(0xFF15803d)),
                    _buildColorCircle(
                        context, AppTheme.orange, const Color(0xFFea580c)),
                    _buildColorCircle(
                        context, AppTheme.dark, const Color(0xFF1a1a1a),
                        isDark: true),
                  ],
                ),

                const Divider(height: 30),

                // 3️⃣ أدوات إضافية
                _buildActionTile(
                  context,
                  title: languageProvider.isArabic
                      ? 'مشاركة التطبيق'
                      : 'Share App',
                  icon: Icons.share,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    Share.share(languageProvider.isArabic
                        ? 'حمل تطبيق مكتب الرؤية للدراسة في رواندا الآن! 🇷🇼🎓\nhttps://your-app-link.com'
                        : 'Download The Vision app for studying in Rwanda now! 🇷🇼🎓\nhttps://your-app-link.com');
                  },
                  themeProvider: themeProvider,
                ),
                _buildActionTile(
                  context,
                  title: languageProvider.isArabic
                      ? 'سياسة الخصوصية'
                      : 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  color: Colors.grey,
                  onTap: () async {
                    const url = 'https://google.com'; // ضع رابطك هنا
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  themeProvider: themeProvider,
                ),

                const SizedBox(height: 24),

                // زر الإغلاق
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      languageProvider.isArabic ? 'إغلاق' : 'Close',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildSectionTitle(String title, IconData icon, ThemeProvider theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.subTextColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.subTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String title, Locale locale, IconData icon) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final isSelected = lang.locale.languageCode == locale.languageCode;

    return InkWell(
      onTap: () => lang.changeLanguage(locale),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: theme.primaryColor.withOpacity(0.5))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? theme.primaryColor : theme.textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.primaryColor : theme.textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.primaryColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(
      BuildContext context, AppTheme themeEnum, Color color,
      {bool isDark = false}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = themeProvider.currentTheme == themeEnum;

    return GestureDetector(
      onTap: () => themeProvider.setTheme(themeEnum),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: themeProvider.textColor, width: 3) // إطار للاختيار
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }

  Widget _buildActionTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
      required ThemeProvider themeProvider}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(color: themeProvider.textColor, fontSize: 15),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 14, color: themeProvider.subTextColor),
      onTap: onTap,
    );
  }
}
