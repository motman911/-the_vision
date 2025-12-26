import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('ar', 'AE');
  static const String _languageKey = 'app_language';

  LanguageProvider() {
    _loadLanguage();
  }

  Locale get locale => _currentLocale;
  Locale get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        final countryCode = languageCode == 'ar' ? 'AE' : 'US';
        _currentLocale = Locale(languageCode, countryCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  Future<void> setLanguage(String languageCode) async {
    final countryCode = languageCode == 'ar' ? 'AE' : 'US';
    await changeLanguage(Locale(languageCode, countryCode));
  }

  // --- النصوص العامة (General) ---
  String get currentLanguageName => isArabic ? 'العربية' : 'English';
  String get appTitle => isArabic
      ? 'مكتب الرؤية - الدراسة في رواندا'
      : 'Vision Office - Study in Rwanda';
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get services => isArabic ? 'الخدمات' : 'Services';
  String get universities => isArabic ? 'الجامعات' : 'Universities';
  String get favorites => isArabic ? 'المفضلة' : 'Favorites';
  String get more => isArabic ? 'المزيد' : 'More';
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

  // --- الصفحة الرئيسية (Home Page) ---
  String get startJourney =>
      isArabic ? 'ابدأ رحلتك الآن' : 'Start Your Journey';
  String get contactNow => isArabic ? 'تواصل معنا الآن' : 'Contact Us Now';
  String get costCalculator =>
      isArabic ? 'حاسبة التكاليف الذكية' : 'Smart Cost Calculator';
  String get costCalculatorDesc => isArabic
      ? 'خطط ميزانيتك الدراسية والمعيشية بدقة'
      : 'Plan your tuition & living budget accurately';

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

  String get galleryRwanda => isArabic ? 'معرض رواندا' : 'Rwanda Gallery';
  String get famousUniversities =>
      isArabic ? 'أشهر الجامعات' : 'Famous Universities';

  // --- آراء الطلاب (Testimonials) ---
  String get testimonials => isArabic ? 'آراء طلابنا' : 'Student Testimonials';

  // الطالب 1: أحمد محمد
  String get studentName1 => isArabic ? 'محمد أشرف' : 'Mohammed Ashraf';
  String get studentJob1 => isArabic
      ? 'طالب برمجيات - جامعة كيغالي المستقلة'
      : 'Software Student - ULK University';
  String get studentReview1 => isArabic
      ? 'مكتب الرؤية غير مجرد مكتب استشارات، هم عائلة داعمة. من لحظة التواصل الأولى حتى وصولي إلى رواندا، شعروا بمسؤوليتي كأخ كبير. ما يميزهم هو المتابعة المستمرة بعد الوصول ومساعدتهم في حل أي مشكلة تواجهني.'
      : 'Vision Office is not just a consultancy, they are a supportive family. From the first contact until I arrived in Rwanda, they acted like big brothers. Their continuous follow-up after arrival is what sets them apart.';

  // الطالب 2: عمر خالد
  String get studentName2 => isArabic ? 'عثمان محمد' : 'Othman Mohammed';
  String get studentJob2 => isArabic
      ? 'طالب برمجيات - جامعة كيغالي'
      : 'Software Student - University of Kigali';
  String get studentReview2 => isArabic
      ? 'تجربتي مع مكتب الرؤية كانت ممتازة بكل المقاييس. ساعدوني في اختيار التخصص المناسب، وجمع المستندات، وحتى بعد وصولي لم يتركوني وحيداً. ساعدوني وأسرتي في إيجاد سكن مناسب وقريب من الجامعة. أنصح أي طالب يريد الدراسة في رواندا بالتعامل معهم.'
      : 'My experience with Vision Office was excellent. They helped me choose my major, gather documents, and didn\'t leave me alone after arrival. They helped me and my family find housing near the university. I highly recommend them.';

  // --- واتساب (WhatsApp) ---
  String get whatsappMessage => isArabic
      ? 'مرحباً، أريد الاستفسار عن الدراسة في رواندا'
      : 'Hello, I would like to inquire about studying in Rwanda';

  // --- الخروج (Exit) ---
  String get pressBackAgain =>
      isArabic ? 'اضغط مرة أخرى للخروج' : 'Press back again to exit';

  // --- نصوص صفحة المعادلة ---
  String get equivalenceRequest =>
      isArabic ? 'طلب معادلة الشهادة' : 'Certificate Equivalence';
  String get reqDocs => isArabic ? 'المستندات المطلوبة' : 'Required Documents';
  String get reqDocsHint => isArabic
      ? 'يرجى رفع الشهادة الثانوية (PDF أو صور واضحة) + صورة الجواز'
      : 'Please upload High School Certificate (PDF or Clear Photos) + Passport Copy';
  String get certPdf => isArabic ? 'PDF الشهادة' : 'Certificate PDF';
  String get certFront => isArabic ? 'صورة (أمام)' : 'Photo (Front)';
  String get certBack =>
      isArabic ? 'صورة (خلف - اختياري)' : 'Photo (Back - Optional)';
  String get passportPhoto =>
      isArabic ? 'صورة الجواز (مطلوب)' : 'Passport Photo (Required)';
  String get personalInfo =>
      isArabic ? 'البيانات الشخصية' : 'Personal Information';
  String get motherName => isArabic
      ? 'اسم الأم الكامل (كما في الجواز)'
      : 'Mother\'s Full Name (As in Passport)';
  String get whatsappNum =>
      isArabic ? 'رقم الواتساب للتواصل' : 'WhatsApp Number';
  String get paymentMethod =>
      isArabic ? 'اختر طريقة الدفع' : 'Choose Payment Method';
  String get momoRwanda => isArabic ? 'MoMo رواندا' : 'MoMo Rwanda';
  String get binance => isArabic ? 'باينانس (Binance)' : 'Binance';
  String get bankak =>
      isArabic ? 'بنك الخرطوم (بنكك)' : 'Bank of Khartoum (Bankak)';
  String get transferDetails =>
      isArabic ? 'بيانات التحويل المطلوبة' : 'Transfer Details';
  String get requiredAmount =>
      isArabic ? 'المبلغ المطلوب:' : 'Required Amount:';
  String get accountNum =>
      isArabic ? 'رقم الحساب / المعرف:' : 'Account Number / ID:';
  String get beneficiaryName =>
      isArabic ? 'اسم المستفيد:' : 'Beneficiary Name:';
  String get uploadReceipt => isArabic
      ? 'إرفاق صورة الإيصال (تصوير أو معرض)'
      : 'Upload Receipt (Photo or Gallery)';
  String get senderName => isArabic
      ? 'اسم الحساب المرسل منه (اجباري)'
      : 'Sender Account Name (Mandatory)';
  String get transactionRef => isArabic
      ? 'رقم العملية المرجعي (اجباري)'
      : 'Transaction Reference No. (Mandatory)';
  String get submitRequest =>
      isArabic ? 'إرسال طلب المعادلة' : 'Submit Equivalence Request';
  String get fieldRequired =>
      isArabic ? 'هذا الحقل مطلوب' : 'This field is required';
  String get fillAllFields => isArabic
      ? 'يرجى تعبئة كافة البيانات والمرفقات واختيار طريقة الدفع'
      : 'Please fill all data, attachments and select payment method';
  String get studentName =>
      isArabic ? 'اسم الطالب الكامل' : 'Student Full Name';
  String get confirmOrder => isArabic ? 'تأكيد الطلب ⚠️' : 'Confirm Order ⚠️';
  String get confirmOrderMsg => isArabic
      ? 'هل تأكدت من تحويل المبلغ الصحيح وإرفاق الإيصال؟\nسيتم مراجعة الطلب بدقة.'
      : 'Did you ensure the correct amount was transferred and receipt attached?\nThe order will be reviewed carefully.';
  String get review => isArabic ? 'مراجعة' : 'Review';
  String get confirmAndSend => isArabic ? 'تأكيد وإرسال' : 'Confirm & Send';
  String get orderReceived => isArabic ? 'تم استلام الطلب' : 'Order Received';
  String get orderReceivedMsg => isArabic
      ? 'تم إرسال بياناتك بنجاح.\nسنقوم بمراجعة الدفع واستخراج المعادلة، وسنرسلها لك عبر الواتساب فور صدورها.'
      : 'Your data has been sent successfully.\nWe will review the payment and process the equivalence, then send it to your WhatsApp once issued.';
  String get ok => isArabic ? 'حسناً' : 'OK';
  String get copied =>
      isArabic ? 'تم نسخ الرقم بنجاح ✅' : 'Number copied successfully ✅';
  String get pickSource =>
      isArabic ? 'اختر مصدر الصورة' : 'Select Image Source';
  String get camera => isArabic ? 'الكاميرا' : 'Camera';
  String get gallerySource => isArabic ? 'المعرض' : 'Gallery';

  // --- نصوص شاشات الترحيب (Onboarding) ---
  String get skip => isArabic ? 'تخطي' : 'Skip';
  String get next => isArabic ? 'التالي' : 'Next';
  String get onbTitle1 =>
      isArabic ? 'مرحباً بك في مكتب الرؤية' : 'Welcome to The Vision';
  String get onbDesc1 => isArabic
      ? 'بوابتك الموثوقة للدراسة في رواندا. نحقق حلمك الأكاديمي بخطوات مدروسة.'
      : 'Your trusted gateway to study in Rwanda. We realize your academic dream with planned steps.';
  String get onbTitle2 =>
      isArabic ? 'خدمات شاملة ومتكاملة' : 'Comprehensive Services';
  String get onbDesc2 => isArabic
      ? 'من القبول الجامعي، وتأمين السكن، وحتى استقبالك في المطار وإنهاء إجراءات الإقامة.'
      : 'From university admission, housing, to airport pickup and residency procedures.';
  String get onbTitle3 =>
      isArabic ? 'معادلة الشهادات بسهولة' : 'Easy Certificate Equivalence';
  String get onbDesc3 => isArabic
      ? 'ادفع وقدم طلب معادلة شهادتك عبر التطبيق مباشرة، وسنقوم نحن بالباقي.'
      : 'Pay and apply for your certificate equivalence directly through the app, and we will do the rest.';

  // 🔥 --- المصادقة وتسجيل الدخول (Auth) --- 🔥
  String get login => isArabic ? 'تسجيل الدخول' : 'Login';
  String get createAccount => isArabic ? 'إنشاء حساب جديد' : 'Create Account';
  String get signUp => isArabic ? 'إنشاء حساب' : 'Sign Up';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full Name';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email Address';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get confirmPassword =>
      isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get forgotPassword =>
      isArabic ? 'هل نسيت كلمة المرور؟' : 'Forgot Password?';
  String get forgotPasswordTitle =>
      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get enterEmailReset => isArabic
      ? 'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين.'
      : 'Enter your email to receive a reset link.';
  String get send => isArabic ? 'إرسال' : 'Send';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get resetLinkSent => isArabic
      ? 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني'
      : 'Password reset link sent to your email';
  String get signInGoogle =>
      isArabic ? 'دخول باستخدام Google' : 'Sign in with Google';
  String get dontHaveAccount =>
      isArabic ? 'ليس لديك حساب؟ أنشئ حساباً' : 'Create new account';
  String get alreadyHaveAccount =>
      isArabic ? 'لديك حساب بالفعل؟ سجل دخول' : 'I already have an account';
  String get skipGuest =>
      isArabic ? 'تخطي والدخول كزائر' : 'Skip & Login as Guest';

  // رسائل التحقق (Validation)
  String get invalidName => isArabic ? 'يرجى إدخال اسم صحيح' : 'Invalid name';
  String get invalidEmail =>
      isArabic ? 'بريد إلكتروني غير صالح' : 'Invalid email';
  String get shortPassword =>
      isArabic ? 'كلمة المرور قصيرة' : 'Password too short';
  String get passwordMismatch =>
      isArabic ? 'كلمات المرور غير متطابقة' : 'Passwords do not match';

  // رسائل أخطاء فايربيس (Firebase Errors)
  String get weakPasswordError =>
      isArabic ? 'كلمة المرور ضعيفة جداً.' : 'Password is too weak.';
  String get emailInUseError => isArabic
      ? 'البريد الإلكتروني مستخدم بالفعل.'
      : 'Email is already in use.';
  String get userNotFoundError => isArabic
      ? 'لا يوجد مستخدم بهذا البريد.'
      : 'No user found with this email.';
  String get wrongPasswordError =>
      isArabic ? 'كلمة المرور غير صحيحة.' : 'Incorrect password.';
  String get invalidEmailFormatError =>
      isArabic ? 'تنسيق البريد الإلكتروني غير صحيح.' : 'Invalid email format.';
  String get operationNotAllowedError =>
      isArabic ? 'تسجيل الدخول معطل حالياً.' : 'Operation not allowed.';
  String get networkError => isArabic
      ? 'خطأ في الشبكة، تحقق من الاتصال.'
      : 'Network error, check your connection.';
  String get unknownError => isArabic ? 'حدث خطأ ما:' : 'An error occurred:';
  String get googleSignInError => isArabic
      ? 'فشل الدخول بجوجل. يرجى المحاولة مرة أخرى.'
      : 'Google Sign-In failed. Please try again.';
  String get guestLoginError =>
      isArabic ? 'فشل الدخول كزائر:' : 'Guest login failed:';
}
