import 'dart:io';

class FormValidators {
  static String? validateName(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال الاسم' : 'Please enter your name';
    }
    if (value.length < 2) {
      return isArabic ? 'الاسم قصير جداً' : 'Name is too short';
    }
    if (value.length > 100) {
      return isArabic ? 'الاسم طويل جداً' : 'Name is too long';
    }

    // التحقق من أن الاسم يحتوي على حروف فقط
    final nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return isArabic ? 'يرجى إدخال اسم صحيح' : 'Please enter a valid name';
    }

    return null;
  }

  static String? validateEmail(String? value, bool isArabic) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return isArabic ? 'بريد إلكتروني غير صحيح' : 'Invalid email';
      }
    }
    return null;
  }

  static String? validatePhone(String? value, bool isArabic) {
    if (value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9]{10,15}$');
      if (!phoneRegex.hasMatch(value)) {
        return isArabic ? 'رقم هاتف غير صحيح' : 'Invalid phone number';
      }
    }
    return null;
  }

  static String? validateWhatsApp(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic
          ? 'يرجى إدخال رقم الواتساب'
          : 'Please enter WhatsApp number';
    }
    final regex = RegExp(r'^[0-9]{10,15}$');
    if (!regex.hasMatch(value)) {
      return isArabic
          ? 'يرجى إدخال رقم واتساب صحيح'
          : 'Please enter a valid WhatsApp number';
    }
    return null;
  }

  static String? validateRequired(
      String? value, String fieldName, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال $fieldName' : 'Please enter $fieldName';
    }
    return null;
  }

  static String? validatePassword(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter password';
    }
    if (value.length < 6) {
      return isArabic
          ? 'كلمة المرور قصيرة (6 أحرف على الأقل)'
          : 'Password too short (minimum 6 characters)';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? value, String password, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى تأكيد كلمة المرور' : 'Please confirm password';
    }
    if (value != password) {
      return isArabic ? 'كلمات المرور غير متطابقة' : 'Passwords do not match';
    }
    return null;
  }

  // جديد: التحقق من الجنسية
  static String? validateCountry(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى اختيار الجنسية' : 'Please select nationality';
    }
    return null;
  }

  // جديد: التحقق من الملفات
  static String? validateFile(File? file, String fieldName, bool isArabic) {
    if (file == null) {
      return isArabic ? 'يرجى إرفاق $fieldName' : 'Please attach $fieldName';
    }

    // التحقق من حجم الملف (حد أقصى 10 ميجابايت)
    final fileSize = file.lengthSync();
    const maxSize = 10 * 1024 * 1024; // 10 MB
    if (fileSize > maxSize) {
      return isArabic
          ? 'حجم الملف كبير جداً (الحد الأقصى 10 ميجابايت)'
          : 'File size too large (maximum 10 MB)';
    }

    return null;
  }

  // جديد: التحقق من البريد الإلكتروني أو رقم الهاتف
  static String? validateEmailOrPhone(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic
          ? 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف'
          : 'Please enter email or phone';
    }

    // التحقق إذا كان بريد إلكتروني
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(value)) return null;

    // التحقق إذا كان رقم هاتف
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (phoneRegex.hasMatch(value)) return null;

    return isArabic
        ? 'يرجى إدخال بريد إلكتروني صحيح أو رقم هاتف'
        : 'Please enter a valid email or phone number';
  }

  // جديد: التحقق من نص طويل
  static String? validateLongText(
      String? value, String fieldName, bool isArabic,
      {int minLength = 10, int maxLength = 1000}) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال $fieldName' : 'Please enter $fieldName';
    }
    if (value.length < minLength) {
      return isArabic
          ? '$fieldName قصير جداً ($minLength أحرف على الأقل)'
          : '$fieldName is too short (minimum $minLength characters)';
    }
    if (value.length > maxLength) {
      return isArabic
          ? '$fieldName طويل جداً ($maxLength أحرف كحد أقصى)'
          : '$fieldName is too long (maximum $maxLength characters)';
    }
    return null;
  }

  // جديد: التحقق من تاريخ الميلاد
  static String? validateBirthDate(DateTime? date, bool isArabic) {
    if (date == null) {
      return isArabic
          ? 'يرجى اختيار تاريخ الميلاد'
          : 'Please select birth date';
    }

    final now = DateTime.now();
    final minDate = DateTime(now.year - 80, now.month, now.day);
    final maxDate = DateTime(now.year - 16, now.month, now.day);

    if (date.isBefore(minDate)) {
      return isArabic ? 'العمر غير صحيح' : 'Invalid age';
    }
    if (date.isAfter(maxDate)) {
      return isArabic
          ? 'يجب أن يكون عمرك 16 سنة على الأقل'
          : 'You must be at least 16 years old';
    }

    return null;
  }
}
