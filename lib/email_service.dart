import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'app_config.dart';

class EmailService {
  // 📧 1. دالة إرسال "تواصل معنا" (للاستفسارات العامة)
  static Future<void> sendEmail({
    required String name,
    required File passport,
    required File personalPhoto,
    required File certificateFront,
    File? certificateBack,
    File? pdfFile,
    String? phone,
    required String whatsapp,
    String? email,
    String? country,
  }) async {
    try {
      final smtpServer = _getSmtpServer();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      final message = Message()
        ..from = Address(AppConfig.emailUsername, AppConfig.emailSenderName)
        ..recipients.add(AppConfig.emailUsername)
        ..subject = '🔵 استفسار جديد - $name'
        ..html = _createContactHtml(
          name: name,
          phone: phone,
          whatsapp: whatsapp,
          email: email,
          country: country,
          dateTime: formattedDate,
        );

      // المرفقات مع تطهير الأسماء
      _addAttachment(message, passport, '${name}_جواز.jpg');
      _addAttachment(message, personalPhoto, '${name}_صورة.jpg');
      _addAttachment(message, certificateFront, '${name}_شهادة_أمام.jpg');

      if (certificateBack != null) {
        _addAttachment(message, certificateBack, '${name}_شهادة_خلف.jpg');
      }
      if (pdfFile != null) {
        _addAttachment(message, pdfFile, '${name}_مستندات.pdf');
      }

      await send(message, smtpServer);
      if (kDebugMode) print('✅ تم إرسال طلب التواصل بنجاح');
    } catch (e) {
      if (kDebugMode) print('❌ خطأ في الإرسال: $e');
      rethrow;
    }
  }

  // 🎓 2. دالة إرسال "طلب المعادلة" (المحسنة)
  static Future<void> sendEquivalenceRequest({
    required String studentName,
    required String motherName,
    required String whatsapp,
    required String paymentMethod, // momo, binance, bankak
    required String transactionInfo,
    required File passport,
    required File paymentScreenshot,
    File? certificatePdf,
    File? certificateFront,
    File? certificateBack,
  }) async {
    try {
      final smtpServer = _getSmtpServer();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      final message = Message()
        ..from = Address(AppConfig.emailUsername, AppConfig.emailSenderName)
        ..recipients.add(AppConfig.emailUsername)
        ..subject = '🟢 طلب معادلة جديد - $studentName'
        ..html = _createEquivalenceHtml(
          studentName: studentName,
          motherName: motherName,
          whatsapp: whatsapp,
          paymentMethod: paymentMethod,
          transactionInfo: transactionInfo,
          dateTime: formattedDate,
        );

      // المرفقات الأساسية لطلب المعادلة
      _addAttachment(message, passport, '1_جواز_السفر.jpg');
      _addAttachment(message, paymentScreenshot, '2_إيصال_الدفع.jpg');

      // مرفقات الشهادة (PDF أو صور)
      if (certificatePdf != null) {
        _addAttachment(message, certificatePdf, '3_الشهادة_الدراسية.pdf');
      } else {
        if (certificateFront != null) {
          _addAttachment(message, certificateFront, '3_الشهادة_أمام.jpg');
        }
        if (certificateBack != null) {
          _addAttachment(message, certificateBack, '4_الشهادة_خلف.jpg');
        }
      }

      await send(message, smtpServer);
      if (kDebugMode) print('✅ تم إرسال طلب المعادلة بنجاح');
    } catch (e) {
      if (kDebugMode) print('❌ خطأ في إرسال المعادلة: $e');
      rethrow;
    }
  }

  // 🛠️ دوال مساعدة (Helpers)

  static SmtpServer _getSmtpServer() {
    final String username = AppConfig.emailUsername;
    final String password = AppConfig.emailPassword;
    return gmail(username, password);
  }

  static void _addAttachment(Message message, File file, String fileName) {
    message.attachments.add(
      FileAttachment(file)
        ..location = Location.attachment
        ..fileName = _sanitizeFileName(fileName),
    );
  }

  static String _sanitizeFileName(String fileName) {
    // إزالة الرموز غير المسموحة في أسماء الملفات لضمان وصولها
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  // 📄 HTML Template: تواصل معنا
  static String _createContactHtml({
    required String name,
    required String? phone,
    required String whatsapp,
    required String? email,
    required String? country,
    required String dateTime,
  }) {
    return '''
<div dir="rtl" style="font-family: Arial, sans-serif; max-width: 600px; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;">
    <div style="background-color: #3b82f6; color: white; padding: 20px; text-align: center;">
        <h2 style="margin: 0;">📋 استفسار جديد من التطبيق</h2>
        <p style="font-size: 14px; margin-top: 5px; opacity: 0.9;">التوقيت: $dateTime</p>
    </div>
    <div style="padding: 20px; line-height: 1.6; color: #333;">
        <p><b>👤 الاسم:</b> $name</p>
        <p><b>🌍 الدولة:</b> ${country ?? 'غير محدد'}</p>
        <p><b>✅ واتساب:</b> <a href="https://wa.me/${whatsapp.replaceAll('+', '')}" style="color: #25D366; text-decoration: none;">$whatsapp</a></p>
        <p><b>📞 الهاتف:</b> ${phone ?? '-'}</p>
        <p><b>📧 البريد الإلكتروني:</b> ${email ?? '-'}</p>
    </div>
    <div style="background-color: #f8f9fa; padding: 10px; text-align: center; font-size: 12px; color: #777;">
        تم الإرسال عبر نظام البريد التلقائي لـ ${AppConfig.appName}
    </div>
</div>
''';
  }

  // 📄 HTML Template: المعادلة
  static String _createEquivalenceHtml({
    required String studentName,
    required String motherName,
    required String whatsapp,
    required String paymentMethod,
    required String transactionInfo,
    required String dateTime,
  }) {
    String methodTitle = paymentMethod;
    if (paymentMethod == 'momo') methodTitle = 'MoMo Pay (Rwanda)';
    if (paymentMethod == 'binance') methodTitle = 'Binance (Crypto)';
    if (paymentMethod == 'bankak') methodTitle = 'بنك الخرطوم (Bankak)';

    return '''
<div dir="rtl" style="font-family: Arial, sans-serif; max-width: 600px; border: 1px solid #2ecc71; border-radius: 10px; overflow: hidden;">
    <div style="background-color: #2ecc71; color: white; padding: 20px; text-align: center;">
        <h2 style="margin: 0;">🎓 طلب معادلة شهادة جديد</h2>
        <p style="font-size: 14px; margin-top: 5px; opacity: 0.9;">$dateTime</p>
    </div>
    <div style="padding: 20px; color: #2c3e50;">
        <h3 style="border-bottom: 2px solid #2ecc71; padding-bottom: 5px;">👤 بيانات الطالب</h3>
        <p><b>اسم الطالب:</b> $studentName</p>
        <p><b>اسم الأم:</b> $motherName</p>
        <p><b>واتساب:</b> $whatsapp</p>
        
        <h3 style="border-bottom: 2px solid #f39c12; padding-bottom: 5px; margin-top: 20px;">💰 تفاصيل الدفع</h3>
        <p><b>طريقة الدفع:</b> $methodTitle</p>
        <p><b>معلومات المعاملة:</b> $transactionInfo</p>
    </div>
    <div style="background-color: #fff3cd; color: #856404; padding: 15px; text-align: center; font-size: 13px; border-top: 1px solid #ffeeba;">
        ⚠️ <b>تنبيه:</b> يرجى مراجعة إيصال الدفع المرفق قبل البدء في الإجراءات.
    </div>
</div>
''';
  }
}

// دالة Wrapper للتوافق مع الأكواد القديمة في المشروع
Future<void> sendEmail({
  required String name,
  File? pdfFile,
  required File passport,
  required File personalPhoto,
  required File certificateFront,
  File? certificateBack,
  String? phone,
  required String whatsapp,
  String? email,
  String? country,
}) async {
  await EmailService.sendEmail(
    name: name,
    passport: passport,
    personalPhoto: personalPhoto,
    certificateFront: certificateFront,
    certificateBack: certificateBack,
    pdfFile: pdfFile,
    phone: phone,
    whatsapp: whatsapp,
    email: email,
    country: country,
  );
}
