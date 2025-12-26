// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'auth_screen.dart';
// ignore: unused_import
import 'admin/admin_dashboard.dart'; // ✅ تأكد أن هذا الملف موجود

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  // ✅ فتح رابط سياسة الخصوصية الخارجي
  Future<void> _launchPrivacyUrl() async {
    final Uri url = Uri.parse(
        'https://doc-hosting.flycricket.io/sysh-khswsyh-ttbyq-the-visiov/c7bbb6f6-d00c-49f7-baac-77d35a022d14/privacy');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  // ✅ دالة الخروج وتنظيف الجلسة
  Future<void> _signOut(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      if (context.mounted) {
        Navigator.pop(context); // إغلاق التحميل
        Navigator.pop(context); // إغلاق الإعدادات

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user?.isAnonymous ?? true;

    return Dialog(
      backgroundColor: themeProvider.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 15,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Directionality(
          textDirection:
              languageProvider.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الهيدر
                _buildHeader(themeProvider, languageProvider),
                const SizedBox(height: 20),

                // 🔥 قسم الإدارة (للسوبر أدمن والمشرفين)
                if (!isGuest && user != null)
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      bool showAdmin = false;
                      if (user.email == "motman911@gmail.com") showAdmin = true;
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        if (data['role'] == 'admin') showAdmin = true;
                      }

                      if (showAdmin) {
                        return Column(
                          children: [
                            _buildActionTile(
                              context,
                              title: languageProvider.isArabic
                                  ? 'لوحة تحكم المكتب'
                                  : 'Office Admin Panel',
                              icon: Icons.admin_panel_settings,
                              color: Colors.blueAccent,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            // 👇 التعديل هنا: إزالة const
                                            AdminDashboard()));
                              },
                              themeProvider: themeProvider,
                            ),
                            const Divider(height: 25, thickness: 0.5),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                // قسم المظهر واللغة
                _buildSectionTitle(
                    languageProvider.isArabic
                        ? "المظهر واللغة"
                        : "Appearance & Language",
                    Icons.style,
                    themeProvider),
                const SizedBox(height: 10),
                _buildLanguageToggle(context, themeProvider, languageProvider),
                const SizedBox(height: 15),
                _buildThemeSelector(context, themeProvider),

                const Divider(height: 30),

                // قسم الدعم والتطوير
                _buildSectionTitle(
                    languageProvider.isArabic
                        ? "الدعم والقانون"
                        : "Support & Legal",
                    Icons.info_outline,
                    themeProvider),
                _buildActionTile(
                  context,
                  title: languageProvider.isArabic
                      ? 'مشاركة التطبيق'
                      : 'Share App',
                  icon: Icons.share_rounded,
                  color: Colors.green,
                  onTap: () {
                    Share.share(languageProvider.isArabic
                        ? 'حمل تطبيق مكتب الرؤية للدراسة في رواندا! 🇷🇼🎓\nhttps://your-app-link.com'
                        : 'Download The Vision app for studying in Rwanda! 🇷🇼🎓\nhttps://your-app-link.com');
                  },
                  themeProvider: themeProvider,
                ),
                _buildActionTile(
                  context,
                  title: languageProvider.isArabic
                      ? 'سياسة الخصوصية'
                      : 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  color: Colors.orange,
                  onTap: _launchPrivacyUrl, // ✅ استدعاء الرابط الخارجي
                  themeProvider: themeProvider,
                ),

                const Divider(height: 30),

                // منطقة تسجيل الخروج
                if (isGuest)
                  _buildLoginButton(context, themeProvider, languageProvider)
                else
                  _buildSignOutSection(
                      context, themeProvider, languageProvider),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة الفرعية ---

  Widget _buildHeader(ThemeProvider theme, LanguageProvider lang) {
    return Row(
      children: [
        Icon(Icons.settings_suggest_rounded,
            color: theme.primaryColor, size: 28),
        const SizedBox(width: 12),
        Text(lang.settings,
            style: GoogleFonts.tajawal(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.textColor)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.subTextColor),
          const SizedBox(width: 8),
          Text(title,
              style: GoogleFonts.tajawal(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.subTextColor)),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle(
      BuildContext context, ThemeProvider theme, LanguageProvider lang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _langChip(context, 'العربية', const Locale('ar'), lang),
        _langChip(context, 'English', const Locale('en'), lang),
      ],
    );
  }

  Widget _langChip(
      BuildContext context, String label, Locale loc, LanguageProvider lang) {
    bool selected = lang.locale.languageCode == loc.languageCode;
    return ChoiceChip(
      label: Text(label,
          style: GoogleFonts.tajawal(
              fontSize: 12, color: selected ? Colors.white : Colors.grey)),
      selected: selected,
      onSelected: (_) => lang.changeLanguage(loc),
      selectedColor: Provider.of<ThemeProvider>(context).primaryColor,
    );
  }

  Widget _buildThemeSelector(
      BuildContext context, ThemeProvider themeProvider) {
    return Wrap(
      spacing: 15,
      children: [
        _buildColorCircle(context, AppTheme.light, const Color(0xFF0f766e)),
        _buildColorCircle(context, AppTheme.blue, const Color(0xFF1e40af)),
        _buildColorCircle(context, AppTheme.green, const Color(0xFF15803d)),
        _buildColorCircle(context, AppTheme.dark, const Color(0xFF1a1a1a)),
      ],
    );
  }

  Widget _buildLoginButton(
      BuildContext context, ThemeProvider theme, LanguageProvider lang) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.login_rounded),
        label: Text(lang.isArabic ? "تسجيل الدخول" : "Login"),
        onPressed: () => _signOut(context),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, foregroundColor: Colors.white),
      ),
    );
  }

  Widget _buildSignOutSection(
      BuildContext context, ThemeProvider theme, LanguageProvider lang) {
    return Column(
      children: [
        _buildActionTile(
          context,
          title: lang.isArabic ? 'تسجيل الخروج' : 'Sign Out',
          icon: Icons.logout_rounded,
          color: Colors.redAccent,
          onTap: () => _signOut(context),
          themeProvider: theme,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildColorCircle(
      BuildContext context, AppTheme themeEnum, Color color) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = themeProvider.currentTheme == themeEnum;
    return GestureDetector(
      onTap: () => themeProvider.setTheme(themeEnum),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: color,
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  Widget _buildActionTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
      required ThemeProvider themeProvider,
      bool isDestructive = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.tajawal(
              color: isDestructive ? Colors.red : themeProvider.textColor,
              fontSize: 14,
              fontWeight: isDestructive ? FontWeight.bold : FontWeight.w500)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: onTap,
    );
  }
}
