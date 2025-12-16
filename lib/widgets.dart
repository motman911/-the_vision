import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme_provider.dart';

class WhatsAppButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const WhatsAppButton({super.key, this.onPressed});

  Future<void> _launchWhatsApp() async {
    const url =
        'https://wa.me/+250795050689?text=مرحباً، أريد الاستفسار عن الدراسة في رواندا';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? _launchWhatsApp,
      icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
      label: const Text('ابدأ رحلتك الآن عبر واتساب'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
        // ignore: deprecated_member_use
        shadowColor: Colors.black.withOpacity(0.3),
      ),
    );
  }
}

class ServicePreviewCard extends StatelessWidget {
  const ServicePreviewCard({
    super.key,
    required this.title,
    required this.icon,
    required this.page,
    required this.themeProvider,
  });

  final String title;
  final IconData icon;
  final Widget page;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(left: 12),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: themeProvider.primaryColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
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
