// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ استيراد الصفحات الأساسية
import 'home_page.dart';
import 'services_page.dart';
import 'universities_page.dart';
import 'favorites_page.dart';
import 'about_us_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';
import 'gallery_page.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'settings_dialog.dart';
import 'my_orders_page.dart';
import 'auth_screen.dart';
import 'admin/admin_dashboard.dart'; // ✅ تأكد أن هذا المسار صحيح والملف موجود
import 'currency_exchange_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  DateTime? currentBackPressTime;

  // إيميل السوبر أدمن الأساسي للتحقق المباشر
  final String superAdminEmail = "motman911@gmail.com";

  final List<Widget> _mainScreens = [
    const HomePage(),
    const ServicesPage(),
    const UniversitiesPage(),
    const FavoritesPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  // ✅ تحسين معالجة زر الرجوع للخروج من التطبيق
  void _handlePop(bool didPop) {
    if (didPop) return;

    // إذا لم يكن في الصفحة الرئيسية، يرجع إليها أولاً
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
      return;
    }

    // منطق الضغط مرتين للخروج
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      final lang = Provider.of<LanguageProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.isArabic ? 'اضغط مرة أخرى للخروج' : 'Press back again to exit',
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.black87,
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: _handlePop,
      child: Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        appBar: _currentIndex ==
                2 // إخفاء الـ AppBar في صفحة الجامعات للتصميم الخاص
            ? null
            : AppBar(
                title: Text(
                  _getPageTitle(_currentIndex, languageProvider),
                  style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                centerTitle: true,
                backgroundColor: themeProvider.primaryColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyOrdersPage()),
                      );
                    },
                    icon: const Icon(Icons.history_edu, color: Colors.white),
                    tooltip: languageProvider.isArabic ? 'طلباتي' : 'My Orders',
                  ),
                  const SizedBox(width: 8),
                ],
              ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _mainScreens,
          onPageChanged: (index) => setState(() => _currentIndex = index),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _launchWhatsApp(),
          backgroundColor: const Color(0xFF25D366),
          elevation: 4,
          shape: const CircleBorder(),
          child: const FaIcon(FontAwesomeIcons.whatsapp,
              color: Colors.white, size: 28),
        ),
        bottomNavigationBar: _buildBottomBar(themeProvider, languageProvider),
      ),
    );
  }

  Widget _buildBottomBar(ThemeProvider theme, LanguageProvider lang) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            _showMoreMenu(context);
          } else {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          }
        },
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: theme.cardColor,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.tajawal(),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: lang.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.design_services_outlined),
              activeIcon: const Icon(Icons.design_services),
              label: lang.services),
          BottomNavigationBarItem(
              icon: const Icon(Icons.school_outlined),
              activeIcon: const Icon(Icons.school),
              label: lang.universities),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              activeIcon: const Icon(Icons.favorite, color: Colors.red),
              label: lang.isArabic ? 'المفضلة' : 'Favorites'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view),
              label: lang.isArabic ? 'المزيد' : 'More'),
        ],
      ),
    );
  }

  String _getPageTitle(int index, LanguageProvider lang) {
    switch (index) {
      case 0:
        return lang.home;
      case 1:
        return lang.services;
      case 2:
        return lang.universities;
      case 3:
        return lang.isArabic ? 'المفضلة' : 'Favorites';
      default:
        return lang.appTitle;
    }
  }

  void _showMoreMenu(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user?.isAnonymous ?? (user == null);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
            _buildUserCard(isGuest, user, lang, theme, context),
            const SizedBox(height: 10),

            // ✅ نظام التحقق المطور لظهور لوحة التحكم للمشرفين فقط
            if (!isGuest)
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  bool isAdmin = false;
                  if (user?.email == superAdminEmail) {
                    isAdmin = true;
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    if (data['role'] == 'admin') isAdmin = true;
                  }

                  if (isAdmin) {
                    return Column(
                      children: [
                        _buildMenuItem(
                            context,
                            Icons.admin_panel_settings_rounded,
                            lang.isArabic
                                ? "لوحة تحكم المشرفين"
                                : "Admin Dashboard",
                            // 👇 التعديل هنا: حذف const
                            AdminDashboard(),
                            theme,
                            isSpecial: true),
                        const Divider(indent: 25, endIndent: 25, height: 1),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),

            _buildMenuItem(
                context,
                Icons.currency_exchange_rounded,
                lang.isArabic ? "تحويل عملات" : "Currency Exchange",
                const CurrencyExchangePage(),
                theme),
            _buildMenuItem(context, Icons.info_outline, lang.aboutUs,
                const AboutUsPage(), theme),
            _buildMenuItem(context, Icons.contact_mail_outlined, lang.contactUs,
                const ContactPage(), theme),
            _buildMenuItem(context, Icons.question_answer_outlined, lang.faq,
                const FAQPage(), theme),
            _buildMenuItem(context, Icons.photo_library_outlined, lang.gallery,
                const GalleryPage(), theme),

            const Divider(indent: 25, endIndent: 25),

            _buildMenuItem(context, Icons.settings, lang.settings, null, theme,
                isSettings: true),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(bool isGuest, User? user, LanguageProvider lang,
      ThemeProvider theme, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isGuest
            ? Colors.orange.withOpacity(0.05)
            : theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isGuest
                ? Colors.orange.withOpacity(0.2)
                : theme.primaryColor.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isGuest ? Colors.orange : theme.primaryColor,
          child: Icon(isGuest ? Icons.person_outline : Icons.person,
              color: Colors.white),
        ),
        title: Text(
            isGuest
                ? (lang.isArabic ? 'أهلاً بك، زائر' : 'Welcome, Guest')
                : (user?.displayName ?? (lang.isArabic ? 'مستخدم' : 'User')),
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: theme.textColor)),
        subtitle: Text(
            isGuest
                ? (lang.isArabic ? 'اضغط لتسجيل الدخول' : 'Tap to login')
                : (user?.email ?? ''),
            style:
                GoogleFonts.tajawal(fontSize: 11, color: theme.subTextColor)),
        onTap: () {
          if (isGuest) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false);
          }
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      Widget? page, ThemeProvider theme,
      {bool isSpecial = false, bool isSettings = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
      leading: Icon(icon,
          color:
              isSpecial ? Colors.blueAccent : theme.textColor.withOpacity(0.7),
          size: 22),
      title: Text(title,
          style: GoogleFonts.tajawal(
              fontSize: 14,
              fontWeight: isSpecial ? FontWeight.bold : FontWeight.w500,
              color: isSpecial ? Colors.blueAccent : theme.textColor)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        if (isSettings) {
          _showSettingsDialog(context);
        } else if (page != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }

  Future<void> _launchWhatsApp() async {
    const url = 'https://wa.me/+250798977374';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
