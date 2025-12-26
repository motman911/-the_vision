// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // تأكد من استيراد هذا الباكيج
import 'home_screen.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // قائمة محتوى الصفحات (بالنصوص التي طلبتها)
  List<Map<String, dynamic>> _getPages(LanguageProvider lang) {
    return [
      {
        'image': 'assets/images/In_Rwanda_15.jpg', // تأكد من وجود الصورة
        'title': lang.isArabic
            ? 'مرحباً بك في مكتب الرؤية'
            : 'Welcome to The Vision',
        'desc': lang.isArabic
            ? 'بوابتك الأولى للدراسة في أفضل جامعات رواندا، نحقق حلمك الأكاديمي بخطوات بسيطة.'
            : 'Your gateway to study in Rwanda\'s top universities. We make your academic dream come true.',
        'icon': Icons.school_outlined,
      },
      {
        'image': 'assets/images/UNLAK_P2.jpg',
        'title': lang.isArabic ? 'خدمات متكاملة' : 'Full Services',
        'desc': lang.isArabic
            ? 'من الاستشارة الأكاديمية، القبول الجامعي، وحتى الاستقبال في المطار وتأمين السكن.'
            : 'From academic consultation and admission to airport pickup and accommodation.',
        'icon': Icons.volunteer_activism_outlined,
      },
      {
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final pages = _getPages(lang);
    bool isLastPage = _currentIndex == pages.length - 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. عارض الصفحات
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _buildPageContent(pages[index], theme);
            },
          ),

          // 2. زر التخطي (في الأعلى)
          Positioned(
            top: 50,
            right: lang.isArabic ? null : 20,
            left: lang.isArabic ? 20 : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isLastPage ? 0.0 : 1.0, // إخفاء في آخر صفحة
              child: TextButton(
                onPressed: _finishOnboarding,
                style: TextButton.styleFrom(
                  backgroundColor:
                      Colors.black.withOpacity(0.1), // خلفية خفيفة للوضوح
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: Text(
                  lang.isArabic ? 'تخطي' : 'Skip',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // 3. المنطقة السفلية (المؤشر والأزرار)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // المؤشر (Indicator)
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: ExpandingDotsEffect(
                    spacing: 8,
                    radius: 4,
                    dotWidth: 10,
                    dotHeight: 8,
                    dotColor: Colors.white.withOpacity(0.5),
                    activeDotColor: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 30),

                // الزر الرئيسي
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        _finishOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 20,
                      shadowColor: theme.primaryColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isLastPage
                          ? (lang.isArabic ? 'ابدأ الآن' : 'Get Started')
                          : (lang.isArabic ? 'التالي' : 'Next'),
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

  Widget _buildPageContent(Map<String, dynamic> data, ThemeProvider theme) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // الخلفية (صورة كاملة)
        // الخلفية (صورة كاملة)
        Image.asset(
          data['image'],
          fit: BoxFit.cover, // يفضل تركه cover عشان الصورة تغطي الشاشة

          alignment: const Alignment(0.5, 0.0),

          errorBuilder: (context, error, stackTrace) {
            return Container(color: Colors.grey.shade300);
          },
        ),

        // تدرج لوني (Gradient) ليجعل النص مقروءاً
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1), // خفيف جداً في الأعلى
                Colors.black.withOpacity(0.5), // متوسط
                theme.scaffoldBackgroundColor
                    .withOpacity(1.0), // غامق في الأسفل
                theme.scaffoldBackgroundColor, // صلب في النهاية
              ],
              stops: const [0.0, 0.4, 0.8, 1.0],
            ),
          ),
        ),

        // المحتوى (أيقونة ونصوص)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // الأيقونة داخل دائرة متوهجة
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                  border: Border.all(
                    color: theme.primaryColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Icon(
                  data['icon'],
                  size: 40,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 30),

              // العنوان
              Text(
                data['title'],
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // الوصف
              Text(
                data['desc'],
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: theme.subTextColor.withOpacity(0.9),
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 140), // مساحة فارغة للأزرار السفلية
            ],
          ),
        ),
      ],
    );
  }
}
