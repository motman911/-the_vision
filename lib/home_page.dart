import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

import 'services_page.dart';
import 'universities_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';
import 'gallery_page.dart';
import 'theme_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: CustomScrollView(
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
                      // ignore: deprecated_member_use
                      Colors.black.withOpacity(0.3),
                      // ignore: deprecated_member_use
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: AnimatedSmoothIndicator(
                            activeIndex: _currentImageIndex,
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
                  _buildWelcomeCard(context, themeProvider),
                  const SizedBox(height: 24),
                  _buildSectionTitle('خدماتنا الرئيسية', themeProvider),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ServicePreviewCard(
                          title: 'خدمات التقديم',
                          icon: Icons.description,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                        ServicePreviewCard(
                          title: 'ما بعد القبول',
                          icon: Icons.home_work,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                        ServicePreviewCard(
                          title: 'دعم الطلاب',
                          icon: Icons.school,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                        ServicePreviewCard(
                          title: 'استشارات أكاديمية',
                          icon: Icons.lightbulb,
                          page: const ServicesPage(),
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildSectionTitle('مميزات الدراسة في رواندا', themeProvider),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                      'تكاليف مناسبة ورسوم دراسية معقولة', themeProvider),
                  _buildFeatureItem(
                      'جودة تعليمية عالية ومعترف بها دولياً', themeProvider),
                  _buildFeatureItem(
                      'بيئة آمنة وملائمة للطلاب الدوليين', themeProvider),
                  _buildFeatureItem('لغة الدراسة بالإنجليزية في معظم التخصصات',
                      themeProvider),
                  _buildFeatureItem('فيزا مجانية عند الوصول مع القبول الجامعي',
                      themeProvider),
                  const SizedBox(height: 28),
                  _buildSectionTitle('تكاليف المعيشة الشهرية', themeProvider),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.99,
                    crossAxisSpacing: 0.9,
                    mainAxisSpacing: 10,
                    children: [
                      _buildCostCard('السكن الفردي', '100 - 150', 'دولار/شهر',
                          Icons.home, themeProvider),
                      _buildCostCard('السكن المشترك', '50 - 100', 'دولار/شهر',
                          Icons.people, themeProvider),
                      _buildCostCard('الإعاشة الشهرية', '100 - 150',
                          'دولار/شهر', Icons.restaurant, themeProvider),
                      _buildCostCard('المواصلات', '20 - 40', 'دولار/شهر',
                          Icons.directions_bus, themeProvider),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _buildSectionTitle('آراء طلابنا', themeProvider),
                  const SizedBox(height: 12),
                  _buildTestimonial(
                    'محمد اشرف',
                    'طالب برمجيات - جامعة كيغالي المستقلة',
                    'مكتب الرؤية غير مجرد مكتب استشارات، هم عائلة داعمة. من لحظة التواصل الأولى حتى وصولي إلى رواندا، شعروا بمسؤوليتي كأخ كبير. ما يميزهم هو المتابعة المستمرة بعد الوصول ومساعدتهم في حل أي مشكلة تواجهني.',
                    themeProvider,
                  ),
                  _buildTestimonial(
                    'عثمان محمد',
                    'طالب برمجيات - جامعة كيغالي',
                    'تجربتي مع مكتب الرؤية كانت ممتازة بكل المقاييس. ساعدوني في اختيار التخصص المناسب، وجمع المستندات، وحتى بعد وصولي لم يتركوني وحيداً. ساعدوني في إيجاد سكن مناسب وقريب من الجامعة. أنصح أي طالب يريد الدراسة في رواندا بالتعامل معهم.',
                    themeProvider,
                  ),
                  const SizedBox(height: 28),
                  _buildFAQCard(context, themeProvider),
                  _buildUniversitiesCard(context, themeProvider),
                  _buildGalleryCard(context, themeProvider),
                  const SizedBox(height: 20),
                  Center(
                    child: WhatsAppButton(
                      onPressed: () {
                        _launchWhatsAppChat();
                      },
                    ),
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

  Widget _buildWelcomeCard(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'ابتعث إلى رواندا مع مكتب الرؤية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ابدأ رحلتك التعليمية في رواندا مع دعم متكامل من الخبراء',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
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
                  elevation: 6,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                ),
                child: const Text(
                  'اتصل بنا الآن',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildFeatureItem(String text, ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: themeProvider.accentColor),
        minLeadingWidth: 0,
        title: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCostCard(String title, String cost, String unit, IconData icon,
      ThemeProvider themeProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: themeProvider.primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                text: cost,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.accentColor,
                ),
                children: [
                  TextSpan(
                    text: ' $unit',
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
  }

  Widget _buildTestimonial(String name, String position, String content,
      ThemeProvider themeProvider) {
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
                      Text(
                        position,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, ThemeProvider themeProvider) {
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
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: Colors.white, size: 30),
                Expanded(
                  child: Text(
                    'الأسئلة الشائعة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Icon(Icons.help_outline, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, ThemeProvider themeProvider) {
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
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: Colors.white, size: 30),
                Expanded(
                  child: Text(
                    'معرض الصور - رواندا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Icon(Icons.photo_library, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUniversitiesCard(
      BuildContext context, ThemeProvider themeProvider) {
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
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: Colors.white, size: 30),
                Expanded(
                  child: Text(
                    'الجامعات الشهيرة في رواندا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Icon(Icons.school, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchWhatsAppChat() async {
    const url =
        'https://wa.me/+250795050689?text=مرحباً، أريد الاستفسار عن الدراسة في رواندا';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
