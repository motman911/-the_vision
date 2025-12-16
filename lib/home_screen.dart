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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const ServicesPage(),
    const UniversitiesPage(),
    const AboutUsPage(),
    const ContactPage(),
    const FAQPage(),
    const GalleryPage(),
  ];

  final List<String> _pageTitles = [
    'مكتب الرؤية - الدراسة في رواندا',
    'خدماتنا',
    'الجامعات',
    'من نحن',
    'اتصل بنا',
    'الأسئلة الشائعة',
    'معرض الصور',
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'الرئيسية',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.work_outlined),
      activeIcon: Icon(Icons.work),
      label: 'خدماتنا',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined),
      activeIcon: Icon(Icons.school),
      label: 'الجامعات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.group_outlined),
      activeIcon: Icon(Icons.group),
      label: 'من نحن',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.contact_page_outlined),
      activeIcon: Icon(Icons.contact_page),
      label: 'اتصل بنا',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.help_outline),
      activeIcon: Icon(Icons.help),
      label: 'الأسئلة',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.photo_library_outlined),
      activeIcon: Icon(Icons.photo_library),
      label: 'المعرض',
    ),
  ];

  void _showMoreMenu(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
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
                    'المزيد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryColor,
                    ),
                  ),
                ),
                ..._navItems.asMap().entries.skip(3).map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return ListTile(
                    leading: item.icon is Icon
                        ? Icon((item.icon as Icon).icon,
                            color: themeProvider.primaryColor)
                        : item.icon,
                    title: Text(item.label!),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: themeProvider.cardColor,
            title: Text(
              'اختر المظهر',
              style: TextStyle(
                color: themeProvider.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                    context, 'فاتح', AppTheme.light, Icons.light_mode),
                _buildThemeOption(
                    context, 'داكن', AppTheme.dark, Icons.dark_mode),
                _buildThemeOption(
                    context, 'أزرق', AppTheme.blue, Icons.water_drop),
                _buildThemeOption(
                    context, 'أخضر', AppTheme.green, Icons.nature),
                _buildThemeOption(
                    context, 'برتقالي', AppTheme.orange, Icons.brightness_auto),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
      BuildContext context, String title, AppTheme theme, IconData icon) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = themeProvider.currentTheme == theme;

    return ListTile(
      leading: Icon(icon,
          color: isSelected
              ? themeProvider.primaryColor
              : themeProvider.textColor),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: themeProvider.primaryColor)
          : null,
      onTap: () {
        themeProvider.setTheme(theme);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: themeProvider.primaryColor,
        centerTitle: true,
        elevation: 4,
        // ignore: deprecated_member_use
        shadowColor: Colors.black.withOpacity(0.3),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.white),
            onPressed: () => _showThemeDialog(context),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
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
                setState(() => _currentIndex = index);
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
              _navItems[0],
              _navItems[1],
              _navItems[2],
              const BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                activeIcon: Icon(Icons.more_horiz),
                label: 'المزيد',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
