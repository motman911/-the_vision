import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'services_page.dart';
import 'universities_page.dart';
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

  final List<Widget> _screens = [
    const HomePage(),
    const ServicesPage(),
    const UniversitiesPage(),
    const AboutUsPage(),
    const ContactPage(),
    const FAQPage(),
    const GalleryPage(),
  ];

  List<String> _pageTitles(LanguageProvider languageProvider) {
    return [
      languageProvider.home,
      languageProvider.services,
      languageProvider.universities,
      languageProvider.aboutUs,
      languageProvider.contactUs,
      languageProvider.faq,
      languageProvider.gallery,
    ];
  }

  List<BottomNavigationBarItem> _navItems(LanguageProvider languageProvider) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: languageProvider.home,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.work_outlined),
        activeIcon: const Icon(Icons.work),
        label: languageProvider.services,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.school_outlined),
        activeIcon: const Icon(Icons.school),
        label: languageProvider.universities,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.group_outlined),
        activeIcon: const Icon(Icons.group),
        label: languageProvider.aboutUs,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.contact_page_outlined),
        activeIcon: const Icon(Icons.contact_page),
        label: languageProvider.contactUs,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.help_outline),
        activeIcon: const Icon(Icons.help),
        label: languageProvider.faq,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.photo_library_outlined),
        activeIcon: const Icon(Icons.photo_library),
        label: languageProvider.gallery,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? 0;
      if (newIndex != _currentIndex && mounted) {
        setState(() => _currentIndex = newIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showMoreMenu(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Directionality(
              textDirection: languageProvider.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      languageProvider.viewMore,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                  ),
                  ..._navItems(languageProvider)
                      .asMap()
                      .entries
                      .skip(3)
                      .map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return ListTile(
                      leading: Icon((item.icon as Icon).icon,
                          color: themeProvider.primaryColor),
                      title: Text(item.label!),
                      onTap: () {
                        Navigator.pop(context);
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles(languageProvider)[_currentIndex],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          if (mounted) {
            setState(() => _currentIndex = index);
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex < 3 ? _currentIndex : 3,
            onTap: (index) {
              if (index == 3) {
                _showMoreMenu(context);
              } else {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            selectedItemColor: themeProvider.accentColor,
            unselectedItemColor: themeProvider.primaryColor,
            backgroundColor: themeProvider.cardColor,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              _navItems(languageProvider)[0],
              _navItems(languageProvider)[1],
              _navItems(languageProvider)[2],
              BottomNavigationBarItem(
                icon: const Icon(Icons.more_horiz),
                activeIcon: const Icon(Icons.more_horiz),
                label: languageProvider.viewMore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
