import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
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
      const String username = 'skstechnologies.eld@gmail.com';
      const String password = 'okbezijhpyyylgth'; // App password

      final smtpServer = gmail(username, password);

      // تاريخ ووقت الإرسال
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // إنشاء الرسالة
      final message = Message()
        ..from = Address(username, 'مكتب الرؤية - The Vision Office')
        ..recipients.add(username)
        ..subject = '📋 طلب جديد - $name'
        ..html = _createHtmlMessage(
          name: name,
          phone: phone,
          whatsapp: whatsapp,
          email: email,
          country: country,
          dateTime: formattedDate,
          hasCertificateBack: certificateBack != null,
          hasPdfFile: pdfFile != null,
        );

      // إضافة المرفقات مع أسماء منظمة
      _addAttachment(message, passport, '${name}_جواز_السفر.jpg');
      _addAttachment(message, personalPhoto, '${name}_صورة_شخصية.jpg');
      _addAttachment(message, certificateFront, '${name}_شهادة_أمام.jpg');

      if (certificateBack != null) {
        _addAttachment(message, certificateBack, '${name}_شهادة_خلف.jpg');
      }

      if (pdfFile != null) {
        _addAttachment(message, pdfFile, '${name}_مستندات.pdf');
      }

      // إرسال الرسالة
      final sendReport = await send(message, smtpServer);

      if (kDebugMode) {
        print('✅ تم إرسال البريد بنجاح إلى $username');
        print('📋 تقرير الإرسال: ${sendReport.toString()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في إرسال البريد: $e');
      }
      rethrow;
    }
  }

  // دالة مساعدة لإضافة مرفق
  static void _addAttachment(Message message, File file, String fileName) {
    message.attachments.add(
      FileAttachment(file)
        ..location = Location.attachment
        ..fileName = _sanitizeFileName(fileName),
    );
  }

  // تنظيف اسم الملف من الأحرف غير المسموح بها
  static String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  // إنشاء رسالة HTML مرتبة وجميلة
  static String _createHtmlMessage({
    required String name,
    required String? phone,
    required String whatsapp,
    required String? email,
    required String? country,
    required String dateTime,
    required bool hasCertificateBack,
    required bool hasPdfFile,
  }) {
    final countryNames = {
      'SD': '🇸🇩 السودان',
      'SY': '🇸🇾 سوريا',
      'YE': '🇾🇪 اليمن',
      'SS': '🇸🇸 جنوب السودان',
      'TD': '🇹🇩 تشاد',
    };

    final countryName = countryNames[country] ?? country ?? 'غير محدد';

    // بناء HTML الديناميكي
    final phoneHtml = phone != null
        ? '''
    <div class="info-item">
        <div class="info-label">📱 رقم الهاتف</div>
        <div class="info-value">$phone</div>
    </div>
    '''
        : '';

    final emailHtml = email != null
        ? '''
    <div class="info-item">
        <div class="info-label">📧 البريد الإلكتروني</div>
        <div class="info-value">$email</div>
    </div>
    '''
        : '';

    final certificateBackHtml = hasCertificateBack
        ? '''
    <li class="attachment-item">
        <span class="attachment-icon">📄</span>
        <span>${name}_شهادة_خلف.jpg <span class="badge">اختياري</span></span>
    </li>
    '''
        : '';

    final pdfFileHtml = hasPdfFile
        ? '''
    <li class="attachment-item">
        <span class="attachment-icon">📄</span>
        <span>${name}_مستندات.pdf <span class="badge">اختياري</span></span>
    </li>
    '''
        : '';

    return '''
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>طلب جديد - $name</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.8;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #0f766e 0%, #14b8a6 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 32px;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .header .subtitle {
            font-size: 18px;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .header .timestamp {
            font-size: 14px;
            opacity: 0.8;
            background: rgba(255, 255, 255, 0.1);
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            margin-top: 15px;
        }
        
        .content {
            padding: 40px;
        }
        
        .section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .section-title {
            color: #0f766e;
            font-size: 22px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #14b8a6;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            font-size: 24px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .info-item {
            background: #f8fafc;
            padding: 20px;
            border-radius: 12px;
            border-right: 5px solid #14b8a6;
            transition: transform 0.3s ease;
        }
        
        .info-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .info-label {
            font-weight: 600;
            color: #64748b;
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-value {
            font-size: 18px;
            color: #1e293b;
            font-weight: 500;
        }
        
        .attachments {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            padding: 30px;
            border-radius: 15px;
            margin-top: 20px;
        }
        
        .attachment-list {
            list-style: none;
            margin-top: 15px;
        }
        
        .attachment-item {
            background: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 10px;
            border-left: 4px solid #0f766e;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .attachment-icon {
            color: #0f766e;
            font-size: 20px;
        }
        
        .footer {
            background: #f1f5f9;
            padding: 30px;
            text-align: center;
            border-top: 2px solid #e2e8f0;
            color: #64748b;
            font-size: 14px;
        }
        
        .footer a {
            color: #0f766e;
            text-decoration: none;
            font-weight: 600;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 15px;
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            color: white;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .badge-optional {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }
        
        @media (max-width: 600px) {
            .content {
                padding: 20px;
            }
            
            .header {
                padding: 30px 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 طلب جديد للدراسة في رواندا</h1>
            <div class="subtitle">مكتب الرؤية - The Vision Office</div>
            <div class="timestamp">🕒 $dateTime</div>
        </div>
        
        <div class="content">
            <div class="section">
                <h2 class="section-title">
                    <span>👤 معلومات الطالب</span>
                </h2>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">📝 الاسم الكامل</div>
                        <div class="info-value">$name</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">🌍 الجنسية</div>
                        <div class="info-value">$countryName</div>
                    </div>
                </div>
            </div>
            
            <div class="section">
                <h2 class="section-title">
                    <span>📞 معلومات التواصل</span>
                </h2>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">💬 واتساب</div>
                        <div class="info-value">$whatsapp <span class="badge">أساسي</span></div>
                    </div>
                    $phoneHtml
                    $emailHtml
                </div>
            </div>
            
            <div class="attachments">
                <h2 class="section-title">
                    <span>📎 المرفقات</span>
                </h2>
                <ul class="attachment-list">
                    <li class="attachment-item">
                        <span class="attachment-icon">📄</span>
                        <span>${name}_جواز_السفر.jpg <span class="badge">مطلوب</span></span>
                    </li>
                    <li class="attachment-item">
                        <span class="attachment-icon">📷</span>
                        <span>${name}_صورة_شخصية.jpg <span class="badge">مطلوب</span></span>
                    </li>
                    <li class="attachment-item">
                        <span class="attachment-icon">📄</span>
                        <span>${name}_شهادة_أمام.jpg <span class="badge">مطلوب</span></span>
                    </li>
                    $certificateBackHtml
                    $pdfFileHtml
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <p>تم إرسال هذا الطلب تلقائياً من تطبيق <strong>مكتب الرؤية</strong></p>
            <p>🕒 وقت الإرسال: $dateTime</p>
            <p>📧 للإستفسار: <a href="mailto:skstechnologies.eld@gmail.com">skstechnologies.eld@gmail.com</a></p>
            <p style="margin-top: 20px; font-size: 12px; opacity: 0.7;">
                ⚠️ هذه رسالة آلية، يرجى عدم الرد عليها مباشرةً
            </p>
        </div>
    </div>
</body>
</html>
''';
  }
}

// الدالة القديمة للحفاظ على التوافق
Future<void> sendEmail(
  String name,
  File? pdfFile,
  File passport,
  File personalPhoto,
  File certificateFront,
  File? certificateBack, {
  String? phone,
  String? whatsapp,
  String? email,
  String? country,
}) async {
  if (whatsapp == null || whatsapp.isEmpty) {
    throw Exception('WhatsApp number is required');
  }

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
