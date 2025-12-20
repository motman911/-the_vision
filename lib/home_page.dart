import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

import 'services_page.dart';
import 'universities_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';
import 'gallery_page.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _imageController = PageController();
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
          SliverToBoxAdapter(
            child: Container(
              height: 146,
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
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: languageProvider.isArabic
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 225,
                          child: PageView(
                            controller: _imageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            children: [
                              _buildImageCard('assets/images/The_Vision_P2.jpg',
                                  themeProvider),
                              _buildImageCard('assets/images/In_Rwanda_1.jpg',
                                  themeProvider),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: SmoothPageIndicator(
                            controller: _imageController,
                            count: 2,
                            effect: WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: themeProvider.accentColor,
                              dotColor: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildWelcomeCard(context, themeProvider, languageProvider),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                      languageProvider.mainServices, themeProvider),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      reverse: !languageProvider.isArabic,
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
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                      languageProvider.studyFeatures, themeProvider),
                  const SizedBox(height: 12),
                  ..._buildFeatureItems(themeProvider, languageProvider),
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                      languageProvider.livingCosts, themeProvider),
                  const SizedBox(height: 12),
                  _buildCostsGrid(themeProvider, languageProvider),
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                      languageProvider.testimonials, themeProvider),
                  const SizedBox(height: 12),
                  ..._buildTestimonials(themeProvider, languageProvider),
                  const SizedBox(height: 28),
                  _buildFAQCard(context, themeProvider, languageProvider),
                  _buildUniversitiesCard(
                      context, themeProvider, languageProvider),
                  _buildGalleryCard(context, themeProvider, languageProvider),
                  const SizedBox(height: 20),
                  Center(
                    child: WhatsAppButton(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath, ThemeProvider themeProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeProvider.primaryColor,
                themeProvider.secondaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeProvider.primaryColor,
              themeProvider.secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                languageProvider.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                languageProvider.startJourney,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.accentColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                child: Text(
                  languageProvider.contactNow,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: themeProvider.primaryColor,
        ),
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
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: themeProvider.accentColor),
            minLeadingWidth: 0,
            title: Text(
              feature,
              style: const TextStyle(fontSize: 14),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
        'icon': Icons.home,
      },
      {
        'title': languageProvider.sharedRoom,
        'cost': '50 - 100',
        'icon': Icons.people,
      },
      {
        'title': languageProvider.monthlyLiving,
        'cost': '100 - 150',
        'icon': Icons.restaurant,
      },
      {
        'title': languageProvider.transportation,
        'cost': '20 - 40',
        'icon': Icons.directions_bus,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.99,
      crossAxisSpacing: 0.9,
      mainAxisSpacing: 10,
      children: costs.map((item) {
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData,
                    size: 28, color: themeProvider.primaryColor),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    text: item['cost'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.accentColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${languageProvider.dollarPerMonth}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTestimonial(
      String name, String content, ThemeProvider themeProvider,
      {int rating = 5}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 18,
                      color: index < rating ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTestimonials(
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    return [
      _buildTestimonial(
        languageProvider.isArabic ? 'محمد اشرف' : 'Mohamed Ashraf',
        languageProvider.isArabic
            ? 'مكتب الرؤية غير مجرد مكتب استشارات، هم عائلة داعمة. من لحظة التواصل الأولى حتى وصولي إلى رواندا، شعروا بمسؤوليتي كأخ كبير. ما يميزهم هو المتابعة المستمرة بعد الوصول ومساعدتهم في حل أي مشكلة تواجهني.'
            : 'The Vision Office is more than just a consultancy, they are a supportive family. From the first contact until my arrival in Rwanda, they made me feel like an older brother. What sets them apart is the continuous follow-up after arrival and their help in solving any problem I face.',
        themeProvider,
        rating: 5,
      ),
      _buildTestimonial(
        languageProvider.isArabic ? 'سارة علي' : 'Sara Ali',
        languageProvider.isArabic
            ? 'الدعم المستمر بعد الوصول كان ممتازاً، فريق محترف جداً'
            : 'Continuous support after arrival was excellent, very professional team',
        themeProvider,
        rating: 4,
      ),
      _buildTestimonial(
        languageProvider.isArabic ? 'عثمان محمد' : 'Othman Mohamed',
        languageProvider.isArabic
            ? 'تجربتي مع مكتب الرؤية كانت ممتازة بكل المقاييس. ساعدوني في اختيار التخصص المناسب، وجمع المستندات، وحتى بعد وصولي لم يتركوني وحيداً. ساعدوني وأسرتي في إيجاد سكن مناسب وقريب من الجامعة. أنصح أي طالب يريد الدراسة في رواندا بالتعامل معهم.'
            : 'My experience with The Vision Office was excellent in every way. They helped me choose the right major, gather documents, and even after my arrival, they did not leave me alone. They helped me find suitable accommodation close to the university. I recommend anyone who wants to study in Rwanda to deal with them.',
        themeProvider,
        rating: 5,
      ),
    ];
  }

  Widget _buildFAQCard(BuildContext context, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const FAQPage()));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeProvider.primaryColor,
                themeProvider.secondaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                if (languageProvider.isArabic)
                  Icon(Icons.arrow_right, color: Colors.white, size: 30),
                Expanded(
                  child: Text(
                    languageProvider.faq,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (!languageProvider.isArabic)
                  Icon(Icons.help_outline, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, ThemeProvider themeProvider,
      LanguageProvider languageProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GalleryPage()));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(top: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeProvider.accentColor,
                Color.lerp(themeProvider.accentColor, Colors.orange, 0.5)!,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                if (languageProvider.isArabic)
                  Icon(Icons.arrow_right, color: Colors.white, size: 30),
                Expanded(
                  child: Text(
                    languageProvider.galleryRwanda,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (!languageProvider.isArabic)
                  Icon(Icons.photo_library, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUniversitiesCard(BuildContext context,
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UniversitiesPage()));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(top: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0ea5e9), Color(0xFF38bdf8)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                if (languageProvider.isArabic)
                  Icon(Icons.arrow_right, color: Colors.white, size: 30),
                Expanded(
                  child: Text(
                    languageProvider.famousUniversities,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (!languageProvider.isArabic)
                  Icon(Icons.school, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
