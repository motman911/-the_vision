import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_vision/contact_page.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'widgets.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildServiceCard(
                  context,
                  languageProvider.applyServices,
                  languageProvider.isArabic
                      ? 'استشارة أكاديمية، اختيار التخصص والجامعة، تجهيز المستندات، متابعة القبول'
                      : 'Academic consultation, choosing major and university, document preparation, follow-up acceptance',
                  Icons.description,
                  themeProvider,
                  languageProvider,
                ),
                _buildServiceCard(
                  context,
                  languageProvider.afterAcceptance,
                  languageProvider.isArabic
                      ? 'استقبال من المطار، تأمين السكن، استخراج شريحة اتصال، المساعدة في الإقامة'
                      : 'Airport pickup, securing accommodation, obtaining SIM card, assistance with residency',
                  Icons.home_work,
                  themeProvider,
                  languageProvider,
                ),
                _buildServiceCard(
                  context,
                  languageProvider.studentSupport,
                  languageProvider.isArabic
                      ? 'متابعة الطالب خلال فترة الدراسة، حل المشاكل الأكاديمية والإدارية'
                      : 'Following up with the student during the study period, solving academic and administrative problems',
                  Icons.school,
                  themeProvider,
                  languageProvider,
                ),
                const SizedBox(height: 24),
                _buildProcessSteps(themeProvider, languageProvider),
                const SizedBox(height: 24),
                _buildLivingCosts(themeProvider, languageProvider),
                const SizedBox(height: 24),
                _buildRequiredDocuments(themeProvider, languageProvider),
                const SizedBox(height: 24),
                const Center(child: WhatsAppButton()),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    ThemeProvider themeProvider,
    LanguageProvider languageProvider,
  ) {
    final features = _getServiceFeatures(title, languageProvider);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: themeProvider.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              languageProvider.isArabic ? 'المميزات:' : 'Features:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: themeProvider.accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                languageProvider.contactNow,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getServiceFeatures(
      String serviceType, LanguageProvider languageProvider) {
    if (serviceType == languageProvider.applyServices) {
      return languageProvider.isArabic
          ? const [
              'استشارة أكاديمية متخصصة',
              'اختيار التخصص والجامعة المناسبة',
              'معادلة الشهادة بالتعليم العالي',
              'تجهيز الأوراق والمستندات المطلوبة',
              'التقديم للجامعات ومتابعة القبول',
            ]
          : const [
              'Specialized academic consultation',
              'Choosing the right major and university',
              'Certificate equivalency with higher education',
              'Preparing required papers and documents',
              'Applying to universities and follow-up acceptance',
            ];
    } else if (serviceType == languageProvider.afterAcceptance) {
      return languageProvider.isArabic
          ? const [
              'استقبال من المطار عند الوصول',
              'استخراج شريحة اتصال محلية',
              'استضافة لمدة يومين',
              'المساعدة في توفير السكن المناسب',
              'المساعدة في إجراءات الإقامة',
            ]
          : const [
              'Airport pickup upon arrival',
              'Obtaining local SIM card',
              'Two-day hosting',
              'Assistance in providing suitable accommodation',
              'Assistance with residency procedures',
            ];
    } else {
      return languageProvider.isArabic
          ? const [
              'متابعة الطالب خلال فترة الدراسة',
              'حل المشاكل الأكاديمية والإدارية',
              'توجيه للأنشطة الطلابية والثقافية',
              'دعم في إجراءات تجديد الإقامة',
              'دعم مستمر طوال فترة الدراسة',
            ]
          : const [
              'Following up with the student during the study period',
              'Solving academic and administrative problems',
              'Guidance for student and cultural activities',
              'Support in residency renewal procedures',
              'Continuous support throughout the study period',
            ];
    }
  }

  Widget _buildProcessSteps(
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    final steps = [
      {
        'number': 1,
        'title': languageProvider.isArabic
            ? 'الاستشارة الأولية'
            : 'Initial Consultation',
        'description': languageProvider.isArabic
            ? 'نبدأ باستشارة شاملة لفهم احتياجاتك الأكاديمية والمهنية ونساعدك في اختيار التخصص والجامعة المناسبة لمستقبلك'
            : 'We start with a comprehensive consultation to understand your academic and professional needs and help you choose the right major and university for your future',
      },
      {
        'number': 2,
        'title': languageProvider.isArabic
            ? 'تجهيز المستندات'
            : 'Document Preparation',
        'description': languageProvider.isArabic
            ? 'نساعدك في تجهيز جميع المستندات المطلوبة وتصديقها من الجهات المختصة لضمان قبول طلبك في الجامعة'
            : 'We help you prepare all required documents and certify them from the relevant authorities to ensure your application is accepted at the university',
      },
      {
        'number': 3,
        'title': languageProvider.isArabic
            ? 'التقديم والمتابعة'
            : 'Application and Follow-up',
        'description': languageProvider.isArabic
            ? 'نتولى عملية التقديم للجامعات والمتابعة المستمرة حتى حصولك على خطاب القبول الرسمي من الجامعة'
            : 'We handle the application process to universities and continuous follow-up until you receive the official acceptance letter from the university',
      },
      {
        'number': 4,
        'title': languageProvider.isArabic
            ? 'الاستعداد للسفر'
            : 'Travel Preparation',
        'description': languageProvider.isArabic
            ? 'نساعدك في استكمال إجراءات السفر والتأشيرة ونوفر لك دليلاً شاملاً للاستعداد للحياة الدراسية في رواندا'
            : 'We help you complete travel and visa procedures and provide you with a comprehensive guide to prepare for student life in Rwanda',
      },
      {
        'number': 5,
        'title':
            languageProvider.isArabic ? 'الدعم المستمر' : 'Continuous Support',
        'description': languageProvider.isArabic
            ? 'نبقى على تواصل معك خلال رحلتك الدراسية ونقدم الدعم اللازم لحل أي تحديات قد تواجهك خلال الدراسة'
            : 'We stay in touch with you during your study journey and provide the necessary support to solve any challenges you may face during your studies',
      },
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.isArabic ? 'خطوات التقديم' : 'Application Steps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.map((step) => _buildStep(step, themeProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(Map<String, dynamic> step, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step['description'] as String,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: themeProvider.primaryColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                step['number'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivingCosts(
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    final List<Map<String, dynamic>> costs = [
      {
        'title': languageProvider.singleRoom,
        'cost': '100 - 150',
        'icon': Icons.home,
      },
      {
        'title': languageProvider.sharedRoom,
        'cost': '50 - 80',
        'icon': Icons.people,
      },
      {
        'title': languageProvider.monthlyLiving,
        'cost': '70 - 90',
        'icon': Icons.restaurant,
      },
      {
        'title': languageProvider.transportation,
        'cost': '20 - 30',
        'icon': Icons.directions_bus,
      },
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.livingCosts,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              languageProvider.isArabic
                  ? 'نقدم لك معلومات شاملة عن تكاليف المعيشة في رواندا لمساعدتك في التخطيط لميزانيتك'
                  : 'We provide you with comprehensive information about living costs in Rwanda to help you plan your budget',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: costs.map((item) {
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 32,
                          color: themeProvider.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
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
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeProvider.primaryColor,
                    themeProvider.secondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      languageProvider.isArabic
                          ? 'الفيزا مجانية عند الوصول مع القبول الجامعي'
                          : 'Visa is free upon arrival with university acceptance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.info, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredDocuments(
      ThemeProvider themeProvider, LanguageProvider languageProvider) {
    final documents = [
      {
        'text': languageProvider.isArabic
            ? 'شهادة الثانوية العامة (مترجمة للإنجليزية)'
            : 'High school certificate (translated to English)',
        'icon': Icons.assignment,
      },
      {
        'text': languageProvider.isArabic
            ? 'صورة جواز السفر ساري المفعول'
            : 'Valid passport copy',
        'icon': Icons.credit_card,
      },
      {
        'text': languageProvider.isArabic
            ? 'صور شخصية حديثة'
            : 'Recent personal photos',
        'icon': Icons.photo,
      },
      {
        'text': languageProvider.isArabic
            ? 'كشف الدرجات (إن وجد)'
            : 'Transcript (if available)',
        'icon': Icons.description,
      },
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.isArabic
                  ? 'المستندات المطلوبة'
                  : 'Required Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...documents.map((doc) => _buildDocumentItem(
                  doc['text'] as String,
                  doc['icon'] as IconData,
                  themeProvider,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(
      String text, IconData icon, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 16),
          Icon(icon, color: themeProvider.primaryColor),
        ],
      ),
    );
  }
}
