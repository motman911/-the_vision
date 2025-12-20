// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'app_config.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(lang.aboutUs),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            lang.isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. الشعار مع تصميم حديث
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(4), // حدود دقيقة
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.2), // ظل ملون متوهج
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                    color: theme.primaryColor.withOpacity(0.1), width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      color: theme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.school_rounded,
                          size: 60, color: theme.primaryColor),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              AppConfig.appName,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lang.isArabic
                  ? 'بوابتك الأولى للدراسة في رواندا'
                  : 'Your Gateway to Study in Rwanda',
              style: TextStyle(color: theme.subTextColor, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // 2. الرؤية والرسالة (تصميم أنيق)
            _buildSectionTitle(
                lang.isArabic ? 'رؤيتنا ورسالتنا' : 'Our Vision and Mission',
                Icons.lightbulb_outline,
                theme),

            _buildInfoCard(
              title: lang.isArabic ? 'رؤيتنا' : 'Our Vision',
              content: lang.isArabic
                  ? 'أن نكون الوكالة الرائدة في تمكين الطلاب العرب من تحقيق أحلامهم الأكاديمية في رواندا.'
                  : 'To be the leading agency in enabling Arab students to achieve their academic dreams in Rwanda.',
              icon: Icons.visibility,
              color: Colors.blueAccent,
              theme: theme,
            ),
            _buildInfoCard(
              title: lang.isArabic ? 'رسالتنا' : 'Our Mission',
              content: lang.isArabic
                  ? 'توفير تجربة دراسية سلسة وناجحة للطلاب من خلال تقديم الدعم الكامل في جميع مراحل رحلتهم الأكاديمية.'
                  : 'Providing a smooth and successful study experience for students by offering full support at all stages.',
              icon: Icons.flag,
              color: Colors.orangeAccent,
              theme: theme,
            ),
            _buildInfoCard(
              title: lang.isArabic ? 'هدفنا' : 'Our Goal',
              content: lang.isArabic
                  ? 'تقديم خدمات متميزة تركز على احتياجات الطلاب، مع الحفاظ على الشفافية والمصداقية.'
                  : 'Providing distinguished services focused on student needs, while maintaining transparency and credibility.',
              icon: Icons.track_changes,
              color: Colors.green,
              theme: theme,
            ),

            const SizedBox(height: 30),

            // 3. القيم الأساسية
            _buildSectionTitle(
                lang.isArabic ? 'قيمنا الأساسية' : 'Our Core Values',
                Icons.diamond_outlined,
                theme),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildValueItem(
                    lang.isArabic ? 'الثقة' : 'Trust',
                    lang.isArabic
                        ? 'بناء علاقات طويلة الأمد.'
                        : 'Building long-term relationships.',
                    Icons.handshake,
                    theme,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.1)),
                  _buildValueItem(
                    lang.isArabic ? 'الشفافية' : 'Transparency',
                    lang.isArabic
                        ? 'وضوح تام دون تكاليف خفية.'
                        : 'Total clarity, no hidden costs.',
                    Icons.visibility_off_outlined,
                    theme,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.1)),
                  _buildValueItem(
                    lang.isArabic ? 'الدعم' : 'Support',
                    lang.isArabic
                        ? 'دعم مستمر طوال الدراسة.'
                        : 'Continuous support throughout study.',
                    Icons.support_agent,
                    theme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. فريق العمل
            _buildSectionTitle(
                lang.isArabic ? 'فريق العمل' : 'Our Team', Icons.groups, theme),

            _buildTeamMember(
              lang.isArabic ? 'أسامة جمال' : 'Osama Jamal',
              lang.isArabic ? 'مستشار أكاديمي' : 'Academic Advisor',
              lang.isArabic
                  ? 'خبرة واسعة في التوجيه الأكاديمي للطلاب العرب.'
                  : 'Extensive experience in academic guidance.',
              theme,
            ),
            _buildTeamMember(
              lang.isArabic ? 'مؤتمن نور النبي' : 'Mu\'taman Noor',
              lang.isArabic ? 'مسؤول الاستقبال' : 'Reception Officer',
              lang.isArabic
                  ? 'متخصص في تسهيل إجراءات الوصول والاستقرار.'
                  : 'Specialist in arrival and settling-in procedures.',
              theme,
            ),
            _buildTeamMember(
              lang.isArabic ? 'محمد عادل' : 'Mohamed Adel',
              lang.isArabic ? 'مسؤول الإرشاد' : 'Guidance Officer',
              lang.isArabic
                  ? 'مرافق دائم للطلاب لضمان راحتهم واندماجهم.'
                  : 'Permanent companion for students ensuring comfort.',
              theme,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title, IconData icon, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required ThemeProvider theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          right: BorderSide(color: color, width: 4), // خط ملون جانبي
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: theme.textColor.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(
    String title,
    String description,
    IconData icon,
    ThemeProvider theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: theme.subTextColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    String name,
    String position,
    String description,
    ThemeProvider theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                name.substring(0, 1),
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.secondaryColor,
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
    );
  }
}
