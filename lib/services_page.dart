import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_vision/contact_page.dart';

import 'theme_provider.dart';
import 'widgets.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            //   decoration: BoxDecoration(
            //     // ignore: deprecated_member_use
            //     color: themeProvider.primaryColor.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Text(
            //     'خدماتنا',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //       color: themeProvider.primaryColor,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24),
            ServiceCard(
              title: 'خدمات التقديم',
              description:
                  'استشارة أكاديمية، اختيار التخصص والجامعة، تجهيز المستندات، متابعة القبول',
              icon: Icons.description,
              features: const [
                'استشارة أكاديمية متخصصة',
                'اختيار التخصص والجامعة المناسبة',
                'معادلة الشهادة بالتعليم العالي',
                'تجهيز الأوراق والمستندات المطلوبة',
                'التقديم للجامعات ومتابعة القبول',
              ],
              themeProvider: themeProvider,
            ),
            ServiceCard(
              title: 'خدمات ما بعد القبول',
              description:
                  'استقبال من المطار، تأمين السكن، استخراج شريحة اتصال، المساعدة في الإقامة',
              icon: Icons.home_work,
              features: const [
                'استقبال من المطار عند الوصول',
                'استخراج شريحة اتصال محلية',
                'استضافة لمدة يومين',
                'المساعدة في توفير السكن المناسب',
                'المساعدة в إجراءات الإقامة',
              ],
              themeProvider: themeProvider,
            ),
            ServiceCard(
              title: 'خدمات دعم الطلاب',
              description:
                  'متابعة الطالب خلال فترة الدراسة، حل المشاكل الأكاديمية والإدارية',
              icon: Icons.school,
              features: const [
                'متابعة الطالب خلال فترة الدراسة',
                'حل المشاكل الأكاديمية والإدارية',
                'توجيه للأنشطة الطلابية والثقافية',
                'دعم في إجراءات تجديد الإقامة',
                'دعم مستمر طوال فترة الدراسة',
              ],
              themeProvider: themeProvider,
            ),
            const SizedBox(height: 24),
            ProcessSteps(themeProvider: themeProvider),
            const SizedBox(height: 24),
            LivingCosts(themeProvider: themeProvider),
            const SizedBox(height: 24),
            RequiredDocuments(themeProvider: themeProvider),
            const SizedBox(height: 24),
            const Center(child: WhatsAppButton()),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;
  final ThemeProvider themeProvider;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                      fontSize: 20,
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
                    // ignore: deprecated_member_use
                    color: themeProvider.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(icon, size: 30, color: themeProvider.primaryColor),
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
              'المميزات:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: themeProvider.accentColor,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 4,
                // ignore: deprecated_member_use
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: const Text('اطلب الخدمة الآن'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessSteps extends StatelessWidget {
  final ThemeProvider themeProvider;

  const ProcessSteps({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خطوات التقديم',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildStep(
                1,
                'الاستشارة الأولية',
                'نبدأ باستشارة شاملة لفهم احتياجاتك الأكاديمية والمهنية ونساعدك في اختيار التخصص والجامعة المناسبة لمستقبلك',
                themeProvider),
            _buildStep(
                2,
                'تجهيز المستندات',
                'نساعدك في تجهيز جميع المستندات المطلوبة وتصديقها من الجهات المختصة لضمان قبول طلبك في الجامعة',
                themeProvider),
            _buildStep(
                3,
                'التقديم والمتابعة',
                'نتولى عملية التقديم للجامعات والمتابعة المستمرة حتى حصولك على خطاب القبول الرسمي من الجامعة',
                themeProvider),
            _buildStep(
                4,
                'الاستعداد للسفر',
                'نساعدك في استكمال إجراءات السفر والتأشيرة ونوفر لك دليلاً شاملاً للاستعداد للحياة الدراسية في رواندا',
                themeProvider),
            _buildStep(
                5,
                'الدعم المستمر',
                'نبقى على تواصل معك خلال رحلتك الدراسية ونقدم الدعم اللازم لحل أي تحديات قد تواجهك خلال الدراسة',
                themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String title, String description,
      ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
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
                number.toString(),
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
}

class LivingCosts extends StatelessWidget {
  final ThemeProvider themeProvider;

  const LivingCosts({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل السكن والمعيشة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'نقدم لك معلومات شاملة عن تكاليف المعيشة في رواندا لمساعدتك في التخطيط لميزانيتك',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              children: [
                _buildCostCard('السكن الفردي', '100 - 150', 'دولار/شهر',
                    Icons.home, themeProvider),
                _buildCostCard('السكن المشترك', '50 - 80', 'دولار/شهر',
                    Icons.people, themeProvider),
                _buildCostCard('الإعاشة الشهرية', '70 - 90', 'دولار/شهر',
                    Icons.restaurant, themeProvider),
                _buildCostCard('المواصلات', '20 - 30', 'دولار/شهر',
                    Icons.directions_bus, themeProvider),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeProvider.primaryColor,
                    themeProvider.secondaryColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'الفيزا مجانية عند الوصول مع القبول الجامعي',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.info, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostCard(String title, String cost, String unit, IconData icon,
      ThemeProvider themeProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: themeProvider.primaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: cost,
                style: TextStyle(
                  fontSize: 18,
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
}

class RequiredDocuments extends StatelessWidget {
  final ThemeProvider themeProvider;

  const RequiredDocuments({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المستندات المطلوبة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildDocumentItem('شهادة الثانوية العامة (مترجمة للإنجليزية)',
                Icons.assignment, themeProvider),
            _buildDocumentItem('صورة جواز السفر ساري المفعول',
                Icons.credit_card, themeProvider),
            _buildDocumentItem('صور شخصية حديثة', Icons.photo, themeProvider),
            _buildDocumentItem(
                'كشف الدرجات (إن وجد)', Icons.description, themeProvider),
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
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          const SizedBox(width: 16),
          Icon(icon, color: themeProvider.primaryColor),
        ],
      ),
    );
  }
}
