// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'app_config.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    // الألوان
    // ignore: unused_local_variable
    final primaryColor = theme.primaryColor;
    final bgColor = const Color(0xFFF8FAFC); // رمادي فاتح جداً للخلفية

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true, // لجعل الهيدر يمتد للأعلى
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        padding: EdgeInsets.zero, // إزالة الحواف لأننا نستخدم هيدر مخصص
        child: Column(
          children: [
            // 1. الهيدر المخصص مع الشعار
            _buildCustomHeader(theme, lang),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // مقدمة مختصرة
                  Text(
                    lang.isArabic
                        ? 'نحن هنا لنرسم مستقبلك الأكاديمي'
                        : 'We are here to shape your academic future',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lang.isArabic
                        ? 'مكتب الرؤية هو شريكك الموثوق للدراسة في رواندا، نقدم لك الدعم الشامل من الفكرة وحتى التخرج.'
                        : 'The Vision Office is your trusted partner for studying in Rwanda, offering comprehensive support from concept to graduation.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 2. الرؤية والرسالة (تصميم الشبكة)
                  _buildSectionTitle(lang.isArabic ? 'هويتنا' : 'Our Identity',
                      Icons.fingerprint, theme),
                  const SizedBox(height: 10),
                  _buildMissionVisionGrid(theme, lang),

                  const SizedBox(height: 30),

                  // 3. القيم الأساسية
                  _buildSectionTitle(lang.isArabic ? 'قيمنا' : 'Our Values',
                      Icons.star, theme),
                  _buildValuesList(theme, lang),

                  const SizedBox(height: 30),

                  // 4. فريق العمل
                  _buildSectionTitle(lang.isArabic ? 'فريقنا' : 'Our Team',
                      Icons.people_alt, theme),
                  _buildTeamList(theme, lang),

                  const SizedBox(height: 40),

                  // 5. المطور والتواصل
                  _buildDeveloperSection(theme, lang),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- الهيدر المنحني ---
  Widget _buildCustomHeader(ThemeProvider theme, LanguageProvider lang) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // الخلفية الملونة
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        // دائرة زخرفية
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // المحتوى (اللوجو والاسم)
        Positioned(
          bottom: 40,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage('assets/images/icon.png'),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                AppConfig.appName,
                style: GoogleFonts.tajawal(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- شبكة الرؤية والرسالة ---
  Widget _buildMissionVisionGrid(ThemeProvider theme, LanguageProvider lang) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModernCard(
                title: lang.isArabic ? 'رؤيتنا' : 'Vision',
                content: lang.isArabic
                    ? 'الريادة في الخدمات التعليمية.'
                    : 'Leading in educational services.',
                icon: Icons.visibility_outlined,
                color: Colors.blue,
                theme: theme,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildModernCard(
                title: lang.isArabic ? 'رسالتنا' : 'Mission',
                content: lang.isArabic
                    ? 'تذليل الصعاب أمام الطلاب.'
                    : 'Overcoming obstacles for students.',
                icon: Icons.rocket_launch_outlined,
                color: Colors.orange,
                theme: theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildModernCard(
          title: lang.isArabic ? 'هدفنا' : 'Goal',
          content: lang.isArabic
              ? 'بناء جيل متعلم وواعي قادر على بناء المستقبل.'
              : 'Building an educated generation capable of building the future.',
          icon: Icons.flag_outlined,
          color: Colors.green,
          theme: theme,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildModernCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required ThemeProvider theme,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: isFullWidth ? null : 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.tajawal(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- قائمة القيم ---
  Widget _buildValuesList(ThemeProvider theme, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          _buildValueTile(lang.isArabic ? 'المصداقية' : 'Credibility',
              Icons.verified_user_outlined, Colors.teal),
          Divider(indent: 20, endIndent: 20, color: Colors.grey[100]),
          _buildValueTile(lang.isArabic ? 'الاحترافية' : 'Professionalism',
              Icons.work_outline, Colors.purple),
          Divider(indent: 20, endIndent: 20, color: Colors.grey[100]),
          _buildValueTile(lang.isArabic ? 'الالتزام' : 'Commitment',
              Icons.handshake_outlined, Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildValueTile(String title, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  // --- قائمة الفريق ---
  Widget _buildTeamList(ThemeProvider theme, LanguageProvider lang) {
    return Column(
      children: [
        _buildTeamMemberCard(
          name: lang.isArabic ? 'أسامة جمال' : 'Osama Jamal',
          role: lang.isArabic ? 'مستشار أكاديمي' : 'Academic Advisor',
          color: Colors.blue,
          theme: theme,
        ),
        _buildTeamMemberCard(
          name: lang.isArabic ? 'مؤتمن نور النبي' : 'Mu\'taman Noor',
          role: lang.isArabic ? 'مسؤول الاستقبال' : 'Reception Officer',
          color: Colors.orange,
          theme: theme,
        ),
        _buildTeamMemberCard(
          name: lang.isArabic ? 'محمد عادل' : 'Mohamed Adel',
          role: lang.isArabic ? 'مسؤول الإرشاد' : 'Guidance Officer',
          color: Colors.green,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildTeamMemberCard({
    required String name,
    required String role,
    required Color color,
    required ThemeProvider theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Text(
              name[0],
              style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold, color: color, fontSize: 18),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Text(role,
                  style: GoogleFonts.tajawal(
                      color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // --- قسم المطور ---
  Widget _buildDeveloperSection(ThemeProvider theme, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E293B), const Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            lang.isArabic ? "تم التطوير بكل ❤️ بواسطة" : "Developed with ❤️ by",
            style: GoogleFonts.tajawal(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            "S_K_S Technology",
            style: GoogleFonts.audiowide(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Mr. Skimo",
            style: GoogleFonts.tajawal(color: Colors.blueAccent, fontSize: 14),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialButton(Icons.phone, () => _launchURL("tel:+250798977374")),
              const SizedBox(width: 15),
              _socialButton(FontAwesomeIcons.whatsapp,
                  () => _launchURL("https://wa.me/249906824173")),
              const SizedBox(width: 15),
              _socialButton(Icons.email,
                  () => _launchURL("mailto:skstechnologies.eld@gmail.com")),
              const SizedBox(width: 15),
              _socialButton(
                  FontAwesomeIcons.linkedinIn,
                  () => _launchURL(
                      "https://www.linkedin.com/in/motman-nor-alnbe-ahmed-16b4552ba")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeProvider theme) {
    return Row(
      children: [
        Icon(icon, color: theme.primaryColor, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
