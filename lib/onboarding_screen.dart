// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // قائمة محتوى الصفحات
  List<Map<String, dynamic>> _getPages(LanguageProvider lang) {
    return [
      {
        'image': 'assets/images/The_Vision_P2.jpg', // صورة ملهمة
        'title': lang.isArabic
            ? 'مرحباً بك في مكتب الرؤية'
            : 'Welcome to The Vision',
        'desc': lang.isArabic
            ? 'بوابتك الأولى للدراسة في أفضل جامعات رواندا، نحقق حلمك الأكاديمي بخطوات بسيطة.'
            : 'Your gateway to study in Rwanda\'s top universities. We make your academic dream come true.',
        'icon': Icons.school_outlined,
      },
      {
        'image': 'assets/images/In_Rwanda_1.jpg', // صورة لطبيعة رواندا
        'title': lang.isArabic ? 'خدمات متكاملة' : 'Full Services',
        'desc': lang.isArabic
            ? 'من الاستشارة الأكاديمية، القبول الجامعي، وحتى الاستقبال في المطار وتأمين السكن.'
            : 'From academic consultation and admission to airport pickup and accommodation.',
        'icon': Icons.volunteer_activism_outlined,
      },
      {
        // تأكد من وجود هذه الصورة أو استبدلها بصورة أخرى متاحة مثل In_Rwanda_2.jpg
        'image': 'assets/images/In_Rwanda_2.jpg',
        'title': lang.isArabic ? 'ابدأ رحلتك الآن' : 'Start Your Journey',
        'desc': lang.isArabic
            ? 'استخدم حاسبة التكاليف، تصفح التخصصات، وقدم طلبك بضغطة زر واحدة.'
            : 'Use the cost calculator, browse majors, and apply with just one click.',
        'icon': Icons.rocket_launch_outlined,
      },
    ];
  }

  Future<void> _finishOnboarding() async {
    // حفظ أن المستخدم شاهد الشاشة
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true); // ✅ نفس المفتاح في Splash

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final pages = _getPages(lang);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // خلفية PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _buildPage(pages[index], theme);
            },
          ),

          // زر التخطي (في الأعلى مع SafeArea)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: lang.isArabic
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _finishOnboarding,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black12, // خلفية خفيفة للوضوح
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        lang.isArabic ? 'تخطي' : 'Skip',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // المؤشرات والأزرار (في الأسفل)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // نقاط المؤشر
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? theme.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // زر التالي / ابدأ
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentIndex == pages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      _currentIndex == pages.length - 1
                          ? (lang.isArabic ? 'ابدأ الآن' : 'Get Started')
                          : (lang.isArabic ? 'التالي' : 'Next'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> data, ThemeProvider theme) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. الصورة الخلفية
        Image.asset(
          data['image'],
          fit: BoxFit.cover,
          errorBuilder: (c, o, s) =>
              Container(color: Colors.grey), // لون احتياطي
        ),

        // 2. طبقة تظليل (Gradient) عشان النص يظهر بوضوح
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1), // شفاف فوق
                Colors.black.withOpacity(0.6), // وسط
                theme
                    .scaffoldBackgroundColor, // لون الخلفية تحت (عشان يندمج مع النصوص)
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // 3. المحتوى النصي
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // النصوص تحت
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: theme.primaryColor.withOpacity(0.3)),
                ),
                child: Icon(data['icon'], size: 40, color: theme.primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                data['title'],
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                data['desc'],
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textColor.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 120), // مساحة للأزرار السفلية
            ],
          ),
        ),
      ],
    );
  }
}
