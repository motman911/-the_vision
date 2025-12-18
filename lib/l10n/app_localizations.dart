import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

class AppLocalizations {
  final bool isArabic;

  AppLocalizations(this.isArabic);

  static AppLocalizations of(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return AppLocalizations(languageProvider.isArabic);
  }

  // ============== النصوص الأساسية للتطبيق ==============
  String get appTitle => isArabic
      ? 'مكتب الرؤية - الدراسة في رواندا'
      : 'Vision Office - Study in Rwanda';
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get services => isArabic ? 'خدماتنا' : 'Services';
  String get universities => isArabic ? 'الجامعات' : 'Universities';
  String get aboutUs => isArabic ? 'من نحن' : 'About Us';
  String get contactUs => isArabic ? 'اتصل بنا' : 'Contact Us';
  String get faq => isArabic ? 'الأسئلة الشائعة' : 'FAQ';
  String get gallery => isArabic ? 'المعرض' : 'Gallery'; // ← الاسم الأساسي
  String get viewMore => isArabic ? 'المزيد' : 'More';
  String get startJourney =>
      isArabic ? 'ابدأ رحلتك الآن' : 'Start Your Journey Now';
  String get applyNow => isArabic ? 'قدم الآن' : 'Apply Now';
  String get officialWebsite => isArabic ? 'الموقع الرسمي' : 'Official Website';

  // ============== الصفحة الرئيسية ==============
  String get mainServices =>
      isArabic ? 'خدماتنا الرئيسية' : 'Our Main Services';
  String get studyFeatures =>
      isArabic ? 'مميزات الدراسة في رواندا' : 'Study Features in Rwanda';
  String get livingCosts =>
      isArabic ? 'تكاليف المعيشة الشهرية' : 'Monthly Living Costs';
  String get testimonials => isArabic ? 'آراء طلابنا' : 'Student Testimonials';
  String get contactNow => isArabic ? 'اتصل بنا الآن' : 'Contact Us Now';
  String get famousUniversities =>
      isArabic ? 'الجامعات الشهيرة في رواندا' : 'Famous Universities in Rwanda';
  String get galleryRwanda =>
      isArabic ? 'معرض الصور - رواندا' : 'Photo Gallery - Rwanda';

  // ============== بطاقات الخدمات ==============
  String get applyServices =>
      isArabic ? 'خدمات التقديم' : 'Application Services';
  String get afterAcceptance => isArabic ? 'ما بعد القبول' : 'After Acceptance';
  String get studentSupport => isArabic ? 'دعم الطلاب' : 'Student Support';
  String get academicConsultation =>
      isArabic ? 'استشارات أكاديمية' : 'Academic Consultation';

  // ============== مميزات الدراسة ==============
  String get feature1 => isArabic
      ? 'تكاليف مناسبة ورسوم دراسية معقولة'
      : 'Affordable costs and reasonable tuition fees';
  String get feature2 => isArabic
      ? 'جودة تعليمية عالية ومعترف بها دولياً'
      : 'High educational quality internationally recognized';
  String get feature3 => isArabic
      ? 'بيئة آمنة وملائمة للطلاب الدوليين'
      : 'Safe and suitable environment for international students';
  String get feature4 => isArabic
      ? 'لغة الدراسة بالإنجليزية في معظم التخصصات'
      : 'English as the language of study in most majors';
  String get feature5 => isArabic
      ? 'فيزا مجانية عند الوصول مع القبول الجامعي'
      : 'Free visa on arrival with university acceptance';

  // ============== تكاليف المعيشة ==============
  String get singleRoom => isArabic ? 'السكن الفردي' : 'Single Room';
  String get sharedRoom => isArabic ? 'السكن المشترك' : 'Shared Room';
  String get monthlyLiving => isArabic ? 'الإعاشة الشهرية' : 'Monthly Living';
  String get transportation => isArabic ? 'المواصلات' : 'Transportation';
  String get dollarPerMonth => isArabic ? 'دولار/شهر' : 'Dollar/Month';

  // ============== آراء الطلاب ==============
  String get studentPosition1 => isArabic
      ? 'طالب برمجيات - جامعة كيغالي المستقلة'
      : 'Software Student - Kigali Independent University';
  String get studentPosition2 => isArabic
      ? 'طالب برمجيات - جامعة كيغالي'
      : 'Software Student - University of Kigali';

  String get testimonial1 => isArabic
      ? 'مكتب الرؤية غير مجرد مكتب استشارات، هم عائلة داعمة. من لحظة التواصل الأولى حتى وصولي إلى رواندا، شعروا بمسؤوليتي كأخ كبير. ما يميزهم هو المتابعة المستمرة بعد الوصول ومساعدتهم في حل أي مشكلة تواجهني.'
      : 'The Vision Office is not just a consultation office, they are a supportive family. From the first moment of contact until my arrival in Rwanda, they felt responsible for me like an older brother. What distinguishes them is the continuous follow-up after arrival and their help in solving any problem I face.';

  String get testimonial2 => isArabic
      ? 'تجربتي مع مكتب الرؤية كانت ممتازة بكل المقاييس. ساعدوني في اختيار التخصص المناسب، وجمع المستندات، وحتى بعد وصولي لم يتركوني وحيداً. ساعدوني في إيجاد سكن مناسب وقريب من الجامعة. أنصح أي طالب يريد الدراسة في رواندا بالتعامل معهم.'
      : 'My experience with the Vision Office was excellent in every way. They helped me choose the right major, collect documents, and even after my arrival they did not leave me alone. They helped me find suitable housing close to the university. I advise any student who wants to study in Rwanda to deal with them.';

  // ============== صفحة الخدمات ==============
  String get serviceApplyTitle =>
      isArabic ? 'خدمات التقديم' : 'Application Services';
  String get serviceApplyDesc => isArabic
      ? 'استشارة أكاديمية، اختيار التخصص والجامعة، تجهيز المستندات، متابعة القبول'
      : 'Academic consultation, major and university selection, document preparation, acceptance follow-up';

  String get serviceAfterTitle =>
      isArabic ? 'خدمات ما بعد القبول' : 'Post-Acceptance Services';
  String get serviceAfterDesc => isArabic
      ? 'استقبال من المطار، تأمين السكن، استخراج شريحة اتصال، المساعدة في الإقامة'
      : 'Airport pickup, accommodation arrangement, SIM card acquisition, residence assistance';

  String get serviceSupportTitle =>
      isArabic ? 'خدمات دعم الطلاب' : 'Student Support Services';
  String get serviceSupportDesc => isArabic
      ? 'متابعة الطالب خلال فترة الدراسة، حل المشاكل الأكاديمية والإدارية'
      : 'Student follow-up during study period, solving academic and administrative problems';

  String get serviceFeatures => isArabic ? 'المميزات:' : 'Features:';
  String get requestServiceNow =>
      isArabic ? 'اطلب الخدمة الآن' : 'Request Service Now';
  String get applicationSteps =>
      isArabic ? 'خطوات التقديم' : 'Application Steps';
  String get housingLivingDetails =>
      isArabic ? 'تفاصيل السكن والمعيشة' : 'Housing and Living Details';
  String get requiredDocuments =>
      isArabic ? 'المستندات المطلوبة' : 'Required Documents';
  String get visaInfo => isArabic
      ? 'الفيزا مجانية عند الوصول مع القبول الجامعي'
      : 'Free visa on arrival with university acceptance';

  // ============== خطوات التقديم ==============
  String get step1 => isArabic ? 'الاستشارة الأولية' : 'Initial Consultation';
  String get step1Desc => isArabic
      ? 'نبدأ باستشارة شاملة لفهم احتياجاتك الأكاديمية والمهنية'
      : 'We start with a comprehensive consultation to understand your academic and professional needs';

  String get step2 => isArabic ? 'تجهيز المستندات' : 'Document Preparation';
  String get step2Desc => isArabic
      ? 'نساعدك في تجهيز جميع المستندات المطلوبة وتصديقها'
      : 'We help you prepare and authenticate all required documents';

  String get step3 =>
      isArabic ? 'التقديم والمتابعة' : 'Application and Follow-up';
  String get step3Desc => isArabic
      ? 'نتولى عملية التقديم للجامعات والمتابعة المستمرة'
      : 'We handle the university application process and continuous follow-up';

  String get step4 => isArabic ? 'الاستعداد للسفر' : 'Travel Preparation';
  String get step4Desc => isArabic
      ? 'نساعدك في استكمال إجراءات السفر والتأشيرة'
      : 'We help you complete travel procedures and visa requirements';

  String get step5 => isArabic ? 'الدعم المستمر' : 'Continuous Support';
  String get step5Desc => isArabic
      ? 'نبقى على تواصل معك خلال رحلتك الدراسية'
      : 'We stay in touch with you throughout your study journey';

  // ============== المستندات المطلوبة ==============
  String get doc1 => isArabic
      ? 'شهادة الثانوية العامة (مترجمة للإنجليزية)'
      : 'High School Certificate (translated to English)';
  String get doc2 =>
      isArabic ? 'صورة جواز السفر ساري المفعول' : 'Valid Passport Copy';
  String get doc3 => isArabic ? 'صور شخصية حديثة' : 'Recent Personal Photos';
  String get doc4 =>
      isArabic ? 'كشف الدرجات (إن وجد)' : 'Transcript (if available)';

  // ============== صفحة الجامعات ==============
  String get specializationsFees =>
      isArabic ? 'التخصصات والرسوم:' : 'Specializations and Fees:';
  String get applyHere => isArabic ? 'التقديم الآن' : 'Apply Now';

  // ============== صفحة من نحن ==============
  String get ourVision => isArabic ? 'رؤيتنا' : 'Our Vision';
  String get ourMission => isArabic ? 'رسالتنا' : 'Our Mission';
  String get ourGoal => isArabic ? 'هدفنا' : 'Our Goal';
  String get ourValues => isArabic ? 'قيمنا الأساسية' : 'Our Core Values';
  String get ourTeam => isArabic ? 'فريق العمل' : 'Our Team';

  String get visionText => isArabic
      ? 'أن نكون الوكالة الرائدة في تمكين الطلاب العرب من تحقيق أحلامهم الأكاديمية في رواندا'
      : 'To be the leading agency in empowering Arab students to achieve their academic dreams in Rwanda';

  String get missionText => isArabic
      ? 'توفير تجربة دراسية سلسة وناجحة للطلاب من خلال تقديم الدعم الكامل'
      : 'Providing a smooth and successful study experience for students through full support';

  String get goalText => isArabic
      ? 'تقديم خدمات متميزة تركز على احتياجات الطلاب، مع الحفاظ على الشفافية والمصداقية'
      : 'Providing distinguished services focused on student needs, while maintaining transparency and credibility';

  String get value1 => isArabic ? 'الثقة' : 'Trust';
  String get value1Desc => isArabic
      ? 'نحن نحرص على بناء علاقات ثقة طويلة الأمد مع طلابنا'
      : 'We are keen to build long-term trust relationships with our students';

  String get value2 => isArabic ? 'الشفافية' : 'Transparency';
  String get value2Desc => isArabic
      ? 'جميع خطواتنا واضحة وشفافة دون أي تكاليف خفية'
      : 'All our steps are clear and transparent without any hidden costs';

  String get value3 => isArabic ? 'الالتزام' : 'Commitment';
  String get value3Desc => isArabic
      ? 'نلتزم بمواعيدنا ونحترم تعهداتنا تجاه الطلاب'
      : 'We are committed to our deadlines and respect our promises to students';

  String get value4 => isArabic ? 'الدعم' : 'Support';
  String get value4Desc => isArabic
      ? 'دعم مستمر للطالب طوال فترة دراسته في رواندا'
      : 'Continuous support for the student throughout their study period in Rwanda';

  // ============== صفحة الاتصال ==============
  String get sendYourInfo =>
      isArabic ? 'أرسل لنا بياناتك' : 'Send Your Information';
  String get name => isArabic ? 'الاسم' : 'Name';
  String get whatsapp => isArabic ? 'رقم الواتساب' : 'WhatsApp Number';
  String get optionalPhone =>
      isArabic ? 'رقم الهاتف (اختياري)' : 'Phone Number (Optional)';
  String get optionalEmail =>
      isArabic ? 'البريد الإلكتروني (اختياري)' : 'Email (Optional)';
  String get nationality => isArabic ? 'الجنسية' : 'Nationality';
  String get passport => isArabic ? 'جواز السفر' : 'Passport';
  String get personalPhoto => isArabic ? 'صورة شخصية' : 'Personal Photo';
  String get certificateFront => isArabic ? 'شهادة أمام' : 'Certificate Front';
  String get certificateBack =>
      isArabic ? 'شهادة خلف (اختياري)' : 'Certificate Back (Optional)';
  String get uploadPDF =>
      isArabic ? 'رفع PDF (اختياري)' : 'Upload PDF (Optional)';
  String get sendData => isArabic ? 'إرسال البيانات' : 'Send Data';
  String get dataReceived => isArabic
      ? 'تم استلال البيانات! سنتواصل معك'
      : 'Data received! We will contact you';

  // ============== صفحة الأسئلة الشائعة ==============
  String get faq1 => isArabic
      ? 'ما هي مدة الدراسة في رواندا؟'
      : 'What is the study duration in Rwanda?';
  String get faq1Answer => isArabic
      ? 'مدة الدراسة في رواندا تختلف حسب المرحلة الدراسية والتخصص، فمدة البكالوريوس تتراوح بين 3-4 سنوات، والماجستير من 1-2 سنوات، والدكتوراه من 3-5 سنوات.'
      : 'Study duration in Rwanda varies according to academic level and specialization. Bachelor\'s degrees range from 3-4 years, Master\'s from 1-2 years, and PhD from 3-5 years.';

  String get faq2 => isArabic
      ? 'ما هي لغة الدراسة في رواندا؟'
      : 'What is the language of study in Rwanda?';
  String get faq2Answer => isArabic
      ? 'اللغة الإنجليزية هي لغة الدراسة الرئيسية في معظم الجامعات الرواندية، مع وجود بعض البرامج باللغة الفرنسية في بعض الجامعات.'
      : 'English is the main language of study in most Rwandan universities, with some programs in French in some universities.';

  String get faq3 => isArabic
      ? 'هل تحتاج إلى فيزا للدراسة في رواندا؟'
      : 'Do you need a visa to study in Rwanda?';
  String get faq3Answer => isArabic
      ? 'نعم، يحتاج الطلاب الدوليون إلى الحصول على فيزا دراسة للدخول إلى رواندا، ويمكننا مساعدتك في استخراجها.'
      : 'Yes, international students need to obtain a study visa to enter Rwanda, and we can help you obtain it.';

  String get faq4 => isArabic
      ? 'ما هي تكاليف الدراسة في رواندا؟'
      : 'What are the study costs in Rwanda?';
  String get faq4Answer => isArabic
      ? 'تتراوح تكاليف الدراسة بين 500-2000 دولار أمريكي سنوياً حسب الجامعة والتخصص، وتعتبر مناسبة مقارنة بجودة التعليم المقدمة.'
      : 'Study costs range between 500-2000 US dollars annually depending on the university and specialization, and are considered reasonable compared to the quality of education provided.';

  String get faq5 => isArabic
      ? 'هل يمكن العمل أثناء الدراسة في رواندا؟'
      : 'Can you work while studying in Rwanda?';
  String get faq5Answer => isArabic
      ? 'نعم، يسمح للطلاب الدوليين بالعمل بدوام جزئي أثناء الدراسة، بحد أقصى 20 ساعة أسبوعياً.'
      : 'Yes, international students are allowed to work part-time while studying, with a maximum of 20 hours per week.';

  String get faq6 => isArabic
      ? 'ما هي مدة الحصول على القبول الجامعي؟'
      : 'How long does it take to get university acceptance?';
  String get faq6Answer => isArabic
      ? 'عادةً ما تستغرق عملية الحصول على القبول ما بين 2-6 أيام بعد اكتمال المستندات. نضمن لك الحصول على رد من الجامعات في أسرع وقت ممكن.'
      : 'The acceptance process usually takes between 2-6 days after completing the documents. We guarantee you get a response from universities as soon as possible.';

  String get faq7 => isArabic
      ? 'هل أحتاج لشهادة لغة للدراسة في رواندا؟'
      : 'Do I need a language certificate to study in Rwanda?';
  String get faq7Answer => isArabic
      ? 'معظم البرامج الدراسية في رواندا باللغة الإنجليزية. بعض الجامعات قد تتطلب شهادة لغة، لكن العديد منها يقبل الطلاب بدونها مع إجراء مقابلة تقييمية.'
      : 'Most study programs in Rwanda are in English. Some universities may require a language certificate, but many accept students without it after an evaluation interview.';

  // ============== نصوص الأزرار ==============
  String get chooseImageSource =>
      isArabic ? 'اختر مصدر الصورة' : 'Choose Image Source';
  String get camera => isArabic ? 'كاميرا' : 'Camera';
  String get photoGallery =>
      isArabic ? 'معرض الصور' : 'Photo Gallery'; // ← تم تغيير الاسم
  String get whatsappJourney => isArabic
      ? 'ابدأ رحلتك الآن عبر واتساب'
      : 'Start Your Journey Now via WhatsApp';

  // ============== نصوص الثيمات ==============
  String get chooseTheme => isArabic ? 'اختر المظهر' : 'Choose Theme';
  String get chooseLanguage => isArabic ? 'اختر اللغة' : 'Choose Language';
  String get lightTheme => isArabic ? 'فاتح' : 'Light';
  String get darkTheme => isArabic ? 'داكن' : 'Dark';
  String get blueTheme => isArabic ? 'أزرق' : 'Blue';
  String get greenTheme => isArabic ? 'أخضر' : 'Green';
  String get orangeTheme => isArabic ? 'برتقالي' : 'Orange';

  // ============== رسائل التحقق ==============
  String get enterName => isArabic ? 'يرجى إدخال الاسم' : 'Please enter name';
  String get enterWhatsApp =>
      isArabic ? 'يرجى إدخال رقم الواتساب' : 'Please enter WhatsApp number';
  String get validWhatsApp => isArabic
      ? 'يرجى إدخال رقم واتساب صحيح'
      : 'Please enter valid WhatsApp number';
  String get incompleteFields => isArabic
      ? 'الحقول الأساسية غير مكتملة!'
      : 'Required fields are incomplete!';
  String get dataError => isArabic
      ? 'حدث خطأ أثناء إرسال البيانات:'
      : 'Error occurred while sending data:';

  // ============== نصوص واجهة المستخدم ==============
  String get enterNameHint => isArabic ? 'ادخل اسمك' : 'Enter your name';
  String get enterWhatsAppHint =>
      isArabic ? 'ادخل رقم الواتساب' : 'Enter WhatsApp number';
  String get sudan => isArabic ? 'السودان' : 'Sudan';
  String get syria => isArabic ? 'سوريا' : 'Syria';
  String get yemen => isArabic ? 'اليمن' : 'Yemen';
  String get southSudan => isArabic ? 'جنوب السودان' : 'South Sudan';
  String get chad => isArabic ? 'تشاد' : 'Chad';

  // ============== نصوص المعرض ==============
  String get zoomIn => isArabic ? 'تكبير' : 'Zoom In';

  // ============== نصوص فريق العمل ==============
  String get teamMember1 => isArabic ? 'أسامة جمال' : 'Osama Jamal';
  String get teamMember1Position => isArabic
      ? 'مستشار أكاديمي ومسؤول متابعة الطلاب'
      : 'Academic Advisor and Student Follow-up Officer';
  String get teamMember1Desc => isArabic
      ? 'خبرة في مجال الاستشارات الأكاديمية والتوجيه للدراسة في رواندا، بالإضافة إلى متابعة الطلاب ودعمهم خلال رحلتهم الدراسية.'
      : 'Experience in academic consultations and guidance for studying in Rwanda, in addition to student follow-up and support during their study journey.';

  String get teamMember2 =>
      isArabic ? 'مؤتمن نور النبي' : 'Moamen Noor Al-Nabi';
  String get teamMember2Position => isArabic
      ? 'مسؤول استقبال الطلاب والدعم المستمر'
      : 'Student Reception and Continuous Support Officer';
  String get teamMember2Desc => isArabic
      ? 'يقوم باستقبال الطلاب في رواندا ومساعدتهم في خطواتهم الأولى، ويقدم الدعم المستمر للطلاب طوال فترة دراستهم.'
      : 'Receives students in Rwanda and helps them with their first steps, and provides continuous support to students throughout their study period.';

  String get teamMember3 => isArabic ? 'محمد عادل' : 'Mohamed Adel';
  String get teamMember3Position => isArabic
      ? 'مسؤول ارشاد الطلاب والدعم المستمر'
      : 'Student Guidance and Continuous Support Officer';
  String get teamMember3Desc => isArabic
      ? 'يعمل على تيسير عملية الانتقال والاستقرار للطلاب في رواندا'
      : 'Works to facilitate the transition and settlement process for students in Rwanda';
}
