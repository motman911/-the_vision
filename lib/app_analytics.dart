import 'package:flutter/foundation.dart';

/// كلاس مسؤول عن تتبع أحداث التطبيق وتحليل الأخطاء
/// حالياً يقوم بالطباعة في الـ Console فقط
/// يمكن تطويره لاحقاً لربطه بـ Firebase Analytics
class AppAnalytics {
  /// تسجيل فتح شاشة جديدة
  static Future<void> logScreenView(String screenName) async {
    if (kDebugMode) {
      print('📊 [Analytics] Screen View: $screenName');
    }
    // TODO: Add Firebase implementation here
    // await FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }

  /// تسجيل الضغط على زر
  static Future<void> logButtonClick(String buttonName) async {
    if (kDebugMode) {
      print('👆 [Analytics] Button Click: $buttonName');
    }
    // TODO: Add Firebase implementation here
    // await FirebaseAnalytics.instance.logEvent(
    //   name: 'button_click',
    //   parameters: {'button_name': buttonName},
    // );
  }

  /// تسجيل إرسال نموذج بنجاح
  static Future<void> logFormSubmission(String formName) async {
    if (kDebugMode) {
      print('📝 [Analytics] Form Submitted: $formName');
    }
  }

  /// تسجيل إرسال بريد إلكتروني
  static Future<void> logEmailSent(String type) async {
    if (kDebugMode) {
      print('📧 [Analytics] Email Sent: $type');
    }
  }

  /// تسجيل الأخطاء التي تحدث في التطبيق
  static Future<void> logError(String source, dynamic error,
      [dynamic stackTrace]) async {
    if (kDebugMode) {
      print('❌ [Analytics] Error in $source: $error');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
    // TODO: Add Crashlytics implementation here
    // await FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: source);
  }

  /// تسجيل حدث مخصص عام
  static Future<void> logEvent(String eventName,
      {Map<String, dynamic>? parameters}) async {
    if (kDebugMode) {
      print('✨ [Analytics] Custom Event: $eventName, Params: $parameters');
    }
  }
}
