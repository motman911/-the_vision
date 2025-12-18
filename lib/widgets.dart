import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class WhatsAppButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const WhatsAppButton({super.key, this.onPressed});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final languageProvider = context.read<LanguageProvider>();
    final message = languageProvider.isArabic
        ? 'مرحباً، أريد الاستفسار عن الدراسة في رواندا'
        : 'Hello, I want to inquire about studying in Rwanda';
    final url =
        'https://wa.me/+250795050689?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // محاولة البديل إذا فشلت canLaunchUrl
        final alternativeUrl =
            'whatsapp://send?phone=+250795050689&text=${Uri.encodeComponent(message)}';
        if (await canLaunchUrl(Uri.parse(alternativeUrl))) {
          await launchUrl(Uri.parse(alternativeUrl));
        } else {
          _showErrorDialog(context, languageProvider);
        }
      }
    } catch (e) {
      _showErrorDialog(context, languageProvider);
    }
  }

  void _showErrorDialog(
      BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.isArabic ? 'خطأ' : 'Error'),
        content: Text(languageProvider.isArabic
            ? 'تعذر فتح تطبيق واتساب. الرجاء التأكد من تثبيت التطبيق.'
            : 'Could not open WhatsApp. Please make sure the app is installed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.isArabic ? 'موافق' : 'OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    // ignore: unused_local_variable
    final themeProvider = context.read<ThemeProvider>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed ?? () => _launchWhatsApp(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.whatsapp, size: 20),
            const SizedBox(width: 8),
            Text(languageProvider.startJourney),
          ],
        ),
      ),
    );
  }
}

class ServicePreviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;
  final ThemeProvider themeProvider;

  const ServicePreviewCard({
    super.key,
    required this.title,
    required this.icon,
    required this.page,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: 120, // حجم ثابت
        margin: EdgeInsets.only(
          left: languageProvider.isArabic ? 12 : 0,
          right: languageProvider.isArabic ? 0 : 12,
        ),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0), // padding ثابت
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32, // حجم ثابت
                  color: themeProvider.primaryColor,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
