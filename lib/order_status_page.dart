import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // ✅ تم إضافة مكتبة الأيقونات
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class OrderStatusPage extends StatelessWidget {
  final String status; // 'pending', 'verified', 'completed'
  final String date;

  const OrderStatusPage({super.key, required this.status, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          lang.isArabic ? 'حالة المعادلة' : 'Order Status',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusIcon(status),
              const SizedBox(height: 30),
              Text(
                _getStatusText(status, lang.isArabic),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                '${lang.isArabic ? "تاريخ الرفع" : "Date"}: $date',
                style: TextStyle(color: theme.subTextColor),
              ),
              const SizedBox(height: 40),

              // ✅ التعديل هنا: استخدام FaIcon بدلاً من Icon
              if (status == 'pending')
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.withOpacity(0.3))),
                  child: Column(
                    children: [
                      // ✅ تم التصحيح هنا
                      const FaIcon(FontAwesomeIcons.whatsapp,
                          color: Colors.green, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        lang.isArabic
                            ? 'تم استلام طلبك بنجاح! \nسيقوم فريقنا بمراجعة الدفع واستخراج المعادلة، وسنرسل لك الشهادة (PDF) عبر الواتساب فور صدورها.'
                            : 'Order received! \nWe will process your request and send the Equivalence Certificate (PDF) to your WhatsApp once issued.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // حالة الانتهاء
              if (status == 'completed')
                Column(
                  children: [
                    Text(
                      lang.isArabic
                          ? 'مبروك! تم إرسال المعادلة إلى رقم الواتساب الخاص بك.'
                          : 'Congratulations! The certificate has been sent to your WhatsApp.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green[700], fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: Text(lang.isArabic ? 'حسناً' : 'OK'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'verified':
        icon = Icons.payment;
        color = Colors.blue;
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'pending':
      default:
        icon = Icons.hourglass_top;
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 80, color: color),
    );
  }

  String _getStatusText(String status, bool isArabic) {
    switch (status) {
      case 'verified':
        return isArabic ? 'تم التحقق من الدفع' : 'Payment Verified';
      case 'completed':
        return isArabic ? 'تم صدور المعادلة ✅' : 'Equivalence Issued ✅';
      case 'pending':
        return isArabic ? 'قيد المراجعة' : 'Under Review';
      default:
        return isArabic ? 'حالة غير معروفة' : 'Unknown Status';
    }
  }
}
