// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ إضافة الخطوط
import 'dart:async';

import 'services_page.dart';
import 'universities_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';
import 'gallery_page.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'widgets.dart'; // تأكد أن WhatsAppButton موجود هنا أو استخدم الكود المباشر
import 'cost_calculator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _imageController = PageController();
  final PageController _testimonialsController =
      PageController(); // ✅ متحكم جديد للآراء
  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _imageController.dispose();
    _testimonialsController.dispose(); // ✅ تنظيف الذاكرة
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentImageIndex < 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0;
      }
      if (_imageController.hasClients) {
        _imageController.animateToPage(
          _currentImageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: themeProvider.primaryColor,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // الهيدر الثابت في الأعلى
          SliverToBoxAdapter(
            child: Container(
              height: 160,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/The_Vision_P1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      themeProvider.scaffoldBackgroundColor.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                crossAxisAlignment: languageProvider.isArabic
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  // 1. السلايدر
                  Container(
                    height: 240, // تقليل الارتفاع قليلاً ليكون أنيقاً
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.primaryColor.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView(
                            controller: _imageController,
                            onPageChanged: (index) {
                              setState(() => _currentImageIndex = index);
                            },
                            children: [
                              _buildImageCard('assets/images/The_Vision_P2.jpg',
                                  themeProvider),
                              _buildImageCard('assets/images/In_Rwanda_1.jpg',
                                  themeProvider),
                            ],
                          ),
                          Positioned(
                            bottom: 15,
                            child: SmoothPageIndicator(
                              controller: _imageController,
                              count: 2,
                              effect: const ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Colors.white,
                                dotColor: Colors.white38,
                                expansionFactor: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. حاسبة التكاليف
                  _buildCostCalculatorCard(context, languageProvider),

                  const SizedBox(height: 16),

                  // 3. كرت الترحيب
                  _buildWelcomeCard(context, themeProvider, languageProvider),

                  const SizedBox(height: 30),

                  // 4. الخدمات الرئيسية
                  _buildSectionTitle(
                      languageProvider.mainServices, themeProvider),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      reverse: !languageProvider.isArabic,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      children: [
                        ServicePreviewCard(
                          title: languageProvider.applyServices,
                          icon: Icons.description,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                        ServicePreviewCard(
                          title: languageProvider.afterAcceptance,
                          icon: Icons.home_work,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                        ServicePreviewCard(
                          title: languageProvider.studentSupport,
                          icon: Icons.school,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                        ServicePreviewCard(
                          title: languageProvider.academicConsultation,
                          icon: Icons.lightbulb,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 5. مميزات الدراسة
                  _buildSectionTitle(
                      languageProvider.studyFeatures, themeProvider),
                  const SizedBox(height: 12),
                  ..._buildFeatureItems(themeProvider, languageProvider),

                  const SizedBox(height: 30),

                  // 6. تكاليف المعيشة
                  _buildSectionTitle(
                      languageProvider.livingCosts, themeProvider),
                  const SizedBox(height: 12),
                  _buildCostsGrid(themeProvider, languageProvider),

                  const SizedBox(height: 30),

                  // 7. ✅ آراء الطلاب (التصميم الجديد المحسن)
                  _buildSectionTitle(
                      languageProvider.testimonials, themeProvider),
                  const SizedBox(height: 15),

                  // استخدام PageView بدلاً من القائمة العمودية
                  SizedBox(
                    height: 260, // ارتفاع مناسب للكرت الجديد
                    child: PageView(
                      controller: _testimonialsController,
                      children: [
                        _buildTestimonialCard(
                          languageProvider.studentName1,
                          languageProvider.studentJob1,
                          languageProvider.studentReview1,
                          themeProvider,
                        ),
                        _buildTestimonialCard(
                          languageProvider.studentName2,
                          languageProvider.studentJob2,
                          languageProvider.studentReview2,
                          themeProvider,
                        ),
                      ],
                    ),
                  ),
                  // مؤشر الصفحات للآراء
                  Center(
                    child: SmoothPageIndicator(
                      controller: _testimonialsController,
                      count: 2,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: themeProvider.primaryColor,
                        dotColor: Colors.grey.shade300,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 8. روابط سريعة
                  _buildFAQCard(context, themeProvider, languageProvider),
                  _buildUniversitiesCard(
                      context, themeProvider, languageProvider),
                  _buildGalleryCard(context, themeProvider, languageProvider),

                  const SizedBox(height: 30),

                  // 9. زر الواتساب
                  Center(
                    child: WhatsAppButton(
                      onPressed: () {
                        _launchWhatsAppChat(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImageCard(String imagePath, ThemeProvider themeProvider) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [themeProvider.primaryColor, themeProvider.secondaryColor],
          ),
        ),
        child: const Center(
            child:
                Icon(Icons.image_not_supported, color: Colors.white, size: 50)),
      ),
    );
  }

  Widget _buildCostCalculatorCard(
      BuildContext context, LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CostCalculatorPage()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFfbbf24)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calculate,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.costCalculator,
                        style: GoogleFonts.tajawal(
                          // ✅ استخدام خط تجوال
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        languageProvider.costCalculatorDesc,
                        style: GoogleFonts.tajawal(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeProvider.primaryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeProvider.primaryColor,
              themeProvider.secondaryColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                languageProvider.appTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  // ✅ خط تجوال
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                languageProvider.startJourney,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                    fontSize: 15, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ContactPage(initialInterest: '')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: themeProvider.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  languageProvider.contactNow,
                  style: GoogleFonts.tajawal(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: themeProvider.accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.tajawal(
              // ✅ خط تجوال
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureItems(
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    final features = [
      languageProvider.feature1,
      languageProvider.feature2,
      languageProvider.feature3,
      languageProvider.feature4,
      languageProvider.feature5,
    ];

    return features.map((feature) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: themeProvider.primaryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.check, color: themeProvider.accentColor, size: 20),
          ),
          title: Text(
            feature,
            style: GoogleFonts.tajawal(
                fontSize: 15,
                color: themeProvider.textColor,
                fontWeight: FontWeight.w500),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      );
    }).toList();
  }

  Widget _buildCostsGrid(
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    final costs = [
      {
        'title': languageProvider.singleRoom,
        'cost': '100 - 150',
        'icon': Icons.home
      },
      {
        'title': languageProvider.sharedRoom,
        'cost': '50 - 100',
        'icon': Icons.people
      },
      {
        'title': languageProvider.monthlyLiving,
        'cost': '100 - 150',
        'icon': Icons.restaurant
      },
      {
        'title': languageProvider.transportation,
        'cost': '20 - 40',
        'icon': Icons.directions_bus
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: costs.length,
      itemBuilder: (context, index) {
        final item = costs[index];
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeProvider.primaryColor.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'] as IconData,
                  size: 32, color: themeProvider.primaryColor),
              const SizedBox(height: 12),
              Text(
                item['title'] as String,
                style: GoogleFonts.tajawal(
                    // ✅ خط تجوال
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: item['cost'] as String,
                  style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.accentColor),
                  children: [
                    TextSpan(
                      text: ' \$',
                      style: GoogleFonts.tajawal(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: themeProvider.textColor.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ الويدجت الجديد المحسن لآراء الطلاب
  Widget _buildTestimonialCard(
      String name, String job, String text, ThemeProvider theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // النجوم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (index) => const Icon(Icons.star_rounded,
                    color: Color(0xFFF59E0B), size: 22)),
          ),
          const SizedBox(height: 15),
          // النص
          Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.tajawal(
              color: theme.textColor,
              height: 1.6,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          // فاصل
          Divider(
              color: Colors.grey.withOpacity(0.2), indent: 50, endIndent: 50),
          const SizedBox(height: 10),
          // الاسم والوظيفة
          Text(
            name,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              fontSize: 16,
            ),
          ),
          Text(
            job,
            style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return _buildNavigationCard(
      context,
      title: languageProvider.faq,
      icon: Icons.help_outline,
      colors: [themeProvider.primaryColor, themeProvider.secondaryColor],
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const FAQPage())),
      isArabic: languageProvider.isArabic,
    );
  }

  Widget _buildGalleryCard(BuildContext context, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return _buildNavigationCard(
      context,
      title: languageProvider.galleryRwanda,
      icon: Icons.photo_library,
      colors: [
        themeProvider.accentColor,
        Color.lerp(themeProvider.accentColor, Colors.orange, 0.5)!
      ],
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GalleryPage())),
      isArabic: languageProvider.isArabic,
    );
  }

  Widget _buildUniversitiesCard(BuildContext context,
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    return _buildNavigationCard(
      context,
      title: languageProvider.famousUniversities,
      icon: Icons.school,
      colors: const [Color(0xFF0ea5e9), Color(0xFF38bdf8)],
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UniversitiesPage())),
      isArabic: languageProvider.isArabic,
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
    required bool isArabic,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: GoogleFonts.tajawal(
                        // ✅ خط تجوال
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchWhatsAppChat(BuildContext context) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final message = languageProvider.whatsappMessage;

    final url =
        'https://wa.me/+250795050689?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }
}
