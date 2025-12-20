import 'package:flutter/material.dart';

class AppErrorHandler {
  static void handleError(BuildContext context, dynamic error,
      {String? customMessage}) {
    // Log error
    debugPrint('App Error: $error');

    // Show user-friendly message
    final message = customMessage ?? _getErrorMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _getErrorMessage(dynamic error) {
    if (error is String) return error;

    if (error.toString().contains('SocketException') ||
        error.toString().contains('Network')) {
      return 'فشل الاتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';
    }

    if (error.toString().contains('Timeout')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
    }

    if (error.toString().contains('email') ||
        error.toString().contains('Email')) {
      return 'خطأ في إرسال البريد الإلكتروني. يرجى المحاولة مرة أخرى أو الاتصال بالدعم.';
    }

    return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'نعم',
    String cancelText = 'إلغاء',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
