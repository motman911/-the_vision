// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contact_page.dart';
import 'equivalence_page.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'widgets.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      // ❌ لا يوجد AppBar هنا لأنه موجود في HomeScreen
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ✅ كرت خدمة المعادلة (الأكثر أهمية)
            _buildEquivalenceCard(context, themeProvider, languageProvider),
            const SizedBox(height: 20),

            // 1. خدمات التقديم
            _buildServiceCard(
              context,
              languageProvider.applyServices,
              languageProvider.isArabic
                  ? 'استشارة أكاديمية، اختيار التخصص والجامعة، تجهيز المستندات، متابعة القبول'
                  : 'Academic consultation, major & university selection, document preparation',
              Icons.school,
              Colors.blue,
              themeProvider,
              languageProvider,
            ),

            // 2. ما بعد القبول
            _buildServiceCard(
              context,
              languageProvider.afterAcceptance,
              languageProvider.isArabic
                  ? 'استقبال من المطار، تأمين السكن، استخراج شريحة اتصال، المساعدة في الإقامة'
                  : 'Airport pickup, accommodation, SIM card, residency assistance',
              Icons.flight_land,
              const Color(0xFFF59E0B), // Orange
              themeProvider,
              languageProvider,
            ),

            // 3. دعم الطلاب
            _buildServiceCard(
              context,
              languageProvider.studentSupport,
              languageProvider.isArabic
                  ? 'متابعة الطالب خلال فترة الدراسة، حل المشاكل الأكاديمية والإدارية'
                  : 'Ongoing student support, solving academic & administrative issues',
              Icons.groups,
              const Color(0xFF10B981), // Green
              themeProvider,
              languageProvider,
            ),

            const SizedBox(height: 24),

            // خطوات التقديم
            _buildProcessSteps(themeProvider, languageProvider),

            const SizedBox(height: 24),

            // تكاليف المعيشة
            _buildLivingCosts(themeProvider, languageProvider),

            const SizedBox(height: 24),

            // المستندات المطلوبة
            _buildRequiredDocuments(themeProvider, languageProvider),

            const SizedBox(height: 30),

            // زر الواتساب
            const Center(child: WhatsAppButton()),

            const SizedBox(height: 80), // مساحة سفلية
          ],
        ),
      ),
    );
  }

  // --- المكونات (Widgets) ---

  Widget _buildEquivalenceCard(
      BuildContext context, ThemeProvider theme, LanguageProvider lang) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EquivalencePage()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.equivalenceRequest,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        lang.isArabic
                            ? 'ابدأ إجراءات معادلة شهادتك الآن'
                            : 'Start your certificate equivalence now',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    ThemeProvider theme,
    LanguageProvider lang,
  ) {
    final features = _getServiceFeatures(title, lang);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // نمرر اسم الخدمة كاهتمام أولي لصفحة التواصل
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactPage(initialInterest: title),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, size: 32, color: color),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textColor.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.1)),
                const SizedBox(height: 8),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang.isArabic ? 'اطلب الخدمة الآن' : 'Request Service',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        lang.isArabic ? Icons.arrow_back : Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getServiceFeatures(String serviceType, LanguageProvider lang) {
    if (serviceType == lang.applyServices) {
      return lang.isArabic
          ? const [
              'استشارة أكاديمية متخصصة',
              'اختيار التخصص والجامعة المناسبة',
              'تجهيز الأوراق والمستندات',
              'ضمان القبول الجامعي 100%',
            ]
          : const [
              'Specialized academic consultation',
              'Choosing major & university',
              'Preparing documents',
              '100% Admission Guarantee',
            ];
    } else if (serviceType == lang.afterAcceptance) {
      return lang.isArabic
          ? const [
              'استقبال VIP من المطار',
              'شريحة اتصال وإنترنت فورية',
              'توفير سكن قريب من الجامعة',
              'إنهاء إجراءات الإقامة',
            ]
          : const [
              'VIP Airport Pickup',
              'Instant SIM & Internet',
              'Accommodation near campus',
              'Residency permit processing',
            ];
    } else {
      return lang.isArabic
          ? const [
              'متابعة دورية للطالب',
              'حل المشاكل الأكاديمية',
              'دعم الطوارئ 24/7',
              'تجديد الإقامة سنوياً',
            ]
          : const [
              'Regular student follow-up',
              'Solving academic issues',
              '24/7 Emergency Support',
              'Annual visa renewal',
            ];
    }
  }

  Widget _buildProcessSteps(ThemeProvider theme, LanguageProvider lang) {
    final steps = [
      {'num': '1', 'title': lang.isArabic ? 'الاستشارة' : 'Consult'},
      {'num': '2', 'title': lang.isArabic ? 'التجهيز' : 'Prepare'},
      {'num': '3', 'title': lang.isArabic ? 'التقديم' : 'Apply'},
      {'num': '4', 'title': lang.isArabic ? 'القبول' : 'Accept'},
      {'num': '5', 'title': lang.isArabic ? 'السفر' : 'Travel'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.isArabic ? 'رحلة التقديم ✈️' : 'Your Journey ✈️',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: steps.map((step) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: theme.primaryColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          step['num']!,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step['title']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivingCosts(ThemeProvider theme, LanguageProvider lang) {
    final costs = [
      {'icon': Icons.home, 'title': lang.singleRoom, 'price': '\$100-150'},
      {'icon': Icons.people, 'title': lang.sharedRoom, 'price': '\$50-80'},
      {
        'icon': Icons.restaurant,
        'title': lang.monthlyLiving,
        'price': '\$70-90'
      },
      {
        'icon': Icons.directions_bus,
        'title': lang.transportation,
        'price': '\$20-30'
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.green[600]),
              const SizedBox(width: 8),
              Text(
                lang.livingCosts,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: costs.map((item) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData,
                        size: 24, color: theme.primaryColor),
                    const SizedBox(height: 4),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                          fontSize: 11,
                          color: theme.textColor.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      item['price'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocuments(ThemeProvider theme, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_special, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Text(
                lang.reqDocs,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _docItem(
              lang.isArabic
                  ? 'شهادة الثانوية (مترجمة)'
                  : 'High school certificate',
              theme),
          _docItem(lang.isArabic ? 'صورة جواز السفر' : 'Passport copy', theme),
          _docItem(lang.isArabic ? 'صور شخصية' : 'Personal photos', theme),
        ],
      ),
    );
  }

  Widget _docItem(String text, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: theme.textColor, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
