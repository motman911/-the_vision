import 'package:flutter_dotenv/flutter_dotenv.dart';

// lib/app_config.dart - الإعدادات الثابتة المضمونة
class AppConfig {
  // إعدادات التطبيق الأساسية
  static const String appName = 'مكتب الرؤية';
  static const String appVersion = '1.2.0';
  static const String appBuildNumber = '3';

  // إعدادات البريد الإلكتروني (الآن آمنة 🔒)
  static String get emailUsername => dotenv.env['EMAIL_USERNAME'] ?? '';
  static String get emailPassword => dotenv.env['EMAIL_PASSWORD'] ?? '';
  static const String emailSenderName = 'مكتب الرؤية - The Vision Office';

  // إعدادات WhatsApp
  static const String whatsappNumber = '+250795050689';
  static const String whatsappDefaultMessage =
      'مرحباً، أريد الاستفسار عن الدراسة في رواندا';

  // التحقق من الإعدادات
  static bool get isEmailConfigured =>
      emailUsername.isNotEmpty && emailPassword.isNotEmpty;

  // دالة لطباعة المعلومات
  static void printConfig() {
    print('''
🎯 إعدادات تطبيق مكتب الرؤية:
   📱 اسم التطبيق: $appName
   🔢 الإصدار: $appVersion (بناء: $appBuildNumber)
   📧 البريد: ${isEmailConfigured ? "✅ مضبوط (آمن)" : "❌ غير مضبوط"}
   💬 واتساب: $whatsappNumber
    ''');
  }

  // دالة للحصول على القيم كـ Map
  static Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'appVersion': appVersion,
      'emailUsername': emailUsername.isNotEmpty ? '***' : '',
      'whatsappNumber': whatsappNumber,
      'isEmailConfigured': isEmailConfigured,
    };
  }
}
