import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  // ✅ 1. قيمة افتراضية فورية (تمنع الخطأ عند بدء التشغيل)
  Locale _currentLocale = const Locale('ar', 'AE');
  static const String _languageKey = 'app_language';

  LanguageProvider() {
    _loadLanguage();
  }

  // ✅ 2. إصلاح الـ Getter (كان يرجع null سابقاً ويسبب المشكلة)
  Locale get locale => _currentLocale;
  // للحفاظ على التوافق مع الأكواد القديمة التي قد تستخدم currentLocale
  Locale get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // تحميل اللغة المحفوظة
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      // إذا وجدت لغة محفوظة، قم بتحديثها
      if (languageCode != null) {
        final countryCode = languageCode == 'ar' ? 'AE' : 'US';
        _currentLocale = Locale(languageCode, countryCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  // ✅ 3. دالة تغيير اللغة (محدثة لتقبل Locale)
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;
    notifyListeners(); // تحديث الواجهة فوراً

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  // دالة مساعدة لضبط اللغة عبر النص (String)
  Future<void> setLanguage(String languageCode) async {
    final countryCode = languageCode == 'ar' ? 'AE' : 'US';
    await changeLanguage(Locale(languageCode, countryCode));
  }

  // ==========================================
  // 🗣️ نصوص الترجمة (Dictionary)
  // ==========================================

  String get currentLanguageName => isArabic ? 'العربية' : 'English';

  String get appTitle => isArabic
      ? 'مكتب الرؤية - الدراسة في رواندا'
      : 'Vision Office - Study in Rwanda';

  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get services => isArabic ? 'الخدمات' : 'Services';
  String get universities => isArabic ? 'الجامعات' : 'Universities';
  String get aboutUs => isArabic ? 'من نحن' : 'About Us';
  String get contactUs => isArabic ? 'اتصل بنا' : 'Contact Us';
  String get faq => isArabic ? 'الأسئلة الشائعة' : 'FAQ';
  String get gallery => isArabic ? 'المعرض' : 'Gallery';
  String get viewMore => isArabic ? 'عرض المزيد' : 'View More';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';

  String get languageText => isArabic ? 'اللغة' : 'Language';
  String get themeText => isArabic ? 'السمة' : 'Theme';
  String get chooseTheme => isArabic ? 'اختر السمة' : 'Choose Theme';

  String get lightTheme => isArabic ? 'فاتح' : 'Light';
  String get darkTheme => isArabic ? 'غامق' : 'Dark';
  String get blueTheme => isArabic ? 'أزرق' : 'Blue';
  String get greenTheme => isArabic ? 'أخضر' : 'Green';
  String get orangeTheme => isArabic ? 'برتقالي' : 'Orange';

  String get mainServices => isArabic ? 'الخدمات الرئيسية' : 'Main Services';
  String get applyServices =>
      isArabic ? 'خدمات التقديم' : 'Application Services';
  String get afterAcceptance => isArabic ? 'ما بعد القبول' : 'After Acceptance';
  String get studentSupport => isArabic ? 'دعم الطلاب' : 'Student Support';
  String get academicConsultation =>
      isArabic ? 'استشارات أكاديمية' : 'Academic Consultation';

  String get studyFeatures =>
      isArabic ? 'مميزات الدراسة في رواندا' : 'Study Features in Rwanda';
  String get feature1 => isArabic ? 'تكاليف معيشة منخفضة' : 'Low living costs';
  String get feature2 =>
      isArabic ? 'بيئة آمنة ومستقرة' : 'Safe and stable environment';
  String get feature3 => isArabic
      ? 'شهادات معترف بها عالمياً'
      : 'Globally recognized certificates';
  String get feature4 => isArabic ? 'تعدد الثقافات' : 'Cultural diversity';
  String get feature5 => isArabic
      ? 'طبيعة خلابة ومناخ معتدل'
      : 'Stunning nature and moderate climate';

  String get livingCosts =>
      isArabic ? 'تكاليف المعيشة الشهرية' : 'Monthly Living Costs';
  String get singleRoom => isArabic ? 'غرفة فردية' : 'Single Room';
  String get sharedRoom => isArabic ? 'غرفة مشتركة' : 'Shared Room';
  String get monthlyLiving => isArabic ? 'مصاريف المعيشة' : 'Monthly Expenses';
  String get transportation => isArabic ? 'المواصلات' : 'Transportation';
  String get dollarPerMonth => isArabic ? 'دولار/شهر' : 'USD/Month';

  String get testimonials => isArabic ? 'آراء الطلاب' : 'Student Testimonials';
  String get studentPosition1 => isArabic
      ? 'طالب هندسة - جامعة رواندا'
      : 'Engineering Student - University of Rwanda';
  String get studentPosition2 => isArabic
      ? 'طالب طب - جامعة كيغالي'
      : 'Medical Student - University of Kigali';
  String get testimonial1 => isArabic
      ? 'رواندا بلد رائع للدراسة، الشعب ودود والتكاليف معقولة جداً مقارنة بالدول الأخرى.'
      : 'Rwanda is a great country for studying, the people are friendly and costs are very reasonable compared to other countries.';
  String get testimonial2 => isArabic
      ? 'تجربتي في رواندا كانت استثنائية، البيئة آمنة والتعليم ذات جودة عالية.'
      : 'My experience in Rwanda was exceptional, the environment is safe and education is of high quality.';

  String get galleryRwanda => isArabic ? 'معرض رواندا' : 'Rwanda Gallery';
  String get famousUniversities =>
      isArabic ? 'أشهر الجامعات' : 'Famous Universities';
  String get startJourney =>
      isArabic ? 'تواصل معنا عبر واتساب' : 'Contact Us in WhatsApp';
  String get contactNow => isArabic ? 'تواصل معنا الآن' : 'Contact Us Now';
}
