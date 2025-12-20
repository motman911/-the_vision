import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // الرؤية والرسالة
                Text(
                  languageProvider.isArabic
                      ? 'رؤيتنا ورسالتنا'
                      : 'Our Vision and Mission',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildValueCard(
                  languageProvider.isArabic ? 'رؤيتنا' : 'Our Vision',
                  languageProvider.isArabic
                      ? 'أن نكون الوكالة الرائدة في تمكين الطلاب العرب من تحقيق أحلامهم الأكاديمية في رواندا'
                      : 'To be the leading agency in enabling Arab students to achieve their academic dreams in Rwanda',
                  Icons.visibility,
                  themeProvider,
                ),
                _buildValueCard(
                  languageProvider.isArabic ? 'رسالتنا' : 'Our Mission',
                  languageProvider.isArabic
                      ? 'توفير تجربة دراسية سلسة وناجحة للطلاب من خلال تقديم الدعم الكامل في جميع مراحل رحلتهم الأكاديمية'
                      : 'Providing a smooth and successful study experience for students by offering full support at all stages of their academic journey',
                  Icons.flag,
                  themeProvider,
                ),
                _buildValueCard(
                  languageProvider.isArabic ? 'هدفنا' : 'Our Goal',
                  languageProvider.isArabic
                      ? 'تقديم خدمات متميزة تركز على احتياجات الطلاب، مع الحفاظ على الشفافية والمصداقية'
                      : 'Providing distinguished services focused on student needs, while maintaining transparency and credibility',
                  Icons.star,
                  themeProvider,
                ),
                const SizedBox(height: 24),

                // القيم الأساسية
                Text(
                  languageProvider.isArabic
                      ? 'قيمنا الأساسية'
                      : 'Our Core Values',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildValueItem(
                  languageProvider.isArabic ? 'الثقة' : 'Trust',
                  languageProvider.isArabic
                      ? 'نحن نحرص على بناء علاقات ثقة طويلة الأمد مع طلابنا، حيث نضع مصلحتهم في المقام الأول'
                      : 'We are keen on building long-term trust relationships with our students, where we prioritize their interests',
                  Icons.handshake,
                  themeProvider,
                ),
                _buildValueItem(
                  languageProvider.isArabic ? 'الشفافية' : 'Transparency',
                  languageProvider.isArabic
                      ? 'جميع خطواتنا واضحة وشفافة دون أي تكاليف خفية، مع تقديم تقارير دورية عن سير الإجراءات'
                      : 'All our steps are clear and transparent without any hidden costs, with periodic reports on the progress of procedures',
                  Icons.visibility,
                  themeProvider,
                ),
                _buildValueItem(
                  languageProvider.isArabic ? 'الالتزام' : 'Commitment',
                  languageProvider.isArabic
                      ? 'نلتزم بمواعيدنا ونحترم تعهداتنا تجاه الطلاب، مع تقديم حلول سريعة لأي تحديات تواجههم'
                      : 'We adhere to our schedules and respect our commitments to students, providing quick solutions to any challenges they face',
                  Icons.event_available,
                  themeProvider,
                ),
                _buildValueItem(
                  languageProvider.isArabic ? 'الدعم' : 'Support',
                  languageProvider.isArabic
                      ? 'دعم مستمر للطالب طوال فترة دراسته في رواندا، مع فريق متكامل لمساعدته في جميع احتياجاته'
                      : 'Continuous support for the student throughout their study period in Rwanda, with an integrated team to assist them in all their needs',
                  Icons.support,
                  themeProvider,
                ),
                const SizedBox(height: 24),

                // فريق العمل
                Text(
                  languageProvider.isArabic ? 'فريق العمل' : 'Our Team',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTeamMember(
                  languageProvider.isArabic ? 'أسامة جمال' : 'Osama Jamal',
                  languageProvider.isArabic
                      ? 'مستشار أكاديمي ومسؤول متابعة الطلاب'
                      : 'Academic Advisor and Student Follow-up Officer',
                  languageProvider.isArabic
                      ? 'خبرة في مجال الاستشارات الأكاديمية والتوجيه للدراسة في رواندا، بالإضافة إلى متابعة الطلاب ودعمهم خلال رحلتهم الدراسية.'
                      : 'Experience in the field of academic consultations and guidance for studying in Rwanda, in addition to following up with students and supporting them during their study journey.',
                  themeProvider,
                ),
                _buildTeamMember(
                  languageProvider.isArabic
                      ? 'مؤتمن نور النبي'
                      : 'Mu\'taman Noor Al-Nabi',
                  languageProvider.isArabic
                      ? 'مسؤول استقبال الطلاب والدعم المستمر'
                      : 'Student Reception Officer and Continuous Support',
                  languageProvider.isArabic
                      ? 'يقوم باستقبال الطلاب في رواندا ومساعدتهم في خطواتهم الأولى، ويقدم الدعم مستمر للطلاب طوال فترة دراستهم.'
                      : 'Receives students in Rwanda and assists them in their first steps, and provides continuous support to students throughout their studies.',
                  themeProvider,
                ),
                _buildTeamMember(
                  languageProvider.isArabic ? 'محمد عادل' : 'Mohamed Adel',
                  languageProvider.isArabic
                      ? 'مسؤول ارشاد الطلاب والدعم المستمر'
                      : 'Student Guidance Officer and Continuous Support',
                  languageProvider.isArabic
                      ? 'يعمل على تيسير عملية الانتقال والاستقرار للطلاب في رواندا'
                      : 'Works to facilitate the transition and stability process for students in Rwanda',
                  themeProvider,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValueCard(
    String title,
    String description,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
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

  Widget _buildValueItem(
    String title,
    String description,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          size: 24,
          color: themeProvider.primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    String name,
    String position,
    String description,
    ThemeProvider themeProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.primaryColor,
                        ),
                      ),
                      Text(
                        position,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
