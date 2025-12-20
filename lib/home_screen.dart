// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _mainScreens = [
    const HomePage(), // 0
    const ServicesPage(), // 1
    const UniversitiesPage(), // 2
    const FavoritesPage(), // 3
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

  // ✅ دالة فتح الواتساب
  Future<void> _launchWhatsApp() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    const String phoneNumber = '+250795050689';

    // نص الرسالة داخل الواتساب
    final String message = lang.isArabic
        ? 'السلام عليكم، تواصلت معكم عبر تطبيق مكتب الرؤية. أرغب في الاستفسار عن الدراسة في رواندا.'
        : 'Hello, I contacted you via Vision Office app. I would like to inquire about studying in Rwanda.';

    final Uri whatsappAppUrl = Uri.parse(
        "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
    final Uri whatsappWebUrl = Uri.parse(
        "https://wa.me/${phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}");

    try {
      if (await canLaunchUrl(whatsappAppUrl)) {
        await launchUrl(whatsappAppUrl);
      } else {
        await launchUrl(whatsappWebUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(whatsappWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _showMoreMenu(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Align(
                  alignment: lang.isArabic
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    lang.viewMore,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildMenuItem(context, Icons.info_outline, lang.aboutUs,
                    const AboutUsPage(), theme),
                _buildMenuItem(context, Icons.contact_mail_outlined,
                    lang.contactUs, const ContactPage(), theme),
                _buildMenuItem(context, Icons.question_answer_outlined,
                    lang.faq, const FAQPage(), theme),
                _buildMenuItem(context, Icons.photo_library_outlined,
                    lang.gallery, const GalleryPage(), theme),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Colors.grey[300]),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.settings, color: theme.primaryColor),
                  ),
                  title: Text(
                    lang.settings,
                    style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: theme.textColor),
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsDialog(context);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      Widget page, ThemeProvider theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.grey[600], size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: theme.textColor, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
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
        return lang.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getPageTitle(_currentIndex, languageProvider),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: themeProvider.primaryColor,
        elevation: 0,
      ),

      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _mainScreens,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
      ),

      // ✅ التعديل هنا: تحويل الزر الدائري إلى زر ممتد (نص + أيقونة)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchWhatsApp,
        backgroundColor: const Color(0xFF25D366),
        elevation: 6,
        // الأيقونة
        icon: const FaIcon(FontAwesomeIcons.whatsapp,
            color: Colors.white, size: 24),
        // النص (يتبدل حسب اللغة)
        label: Text(
          languageProvider.startJourney, // سيجلب "تواصل معنا" أو "Contact Us"
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
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
          selectedItemColor: themeProvider.primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: themeProvider.cardColor,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: languageProvider.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.design_services_outlined),
              activeIcon: const Icon(Icons.design_services),
              label: languageProvider.services,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.school_outlined),
              activeIcon: const Icon(Icons.school),
              label: languageProvider.universities,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              activeIcon: const Icon(Icons.favorite, color: Colors.red),
              label: languageProvider.isArabic ? 'المفضلة' : 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view),
              label: languageProvider.isArabic ? 'المزيد' : 'More',
            ),
          ],
        ),
      ),
    );
  }
}
