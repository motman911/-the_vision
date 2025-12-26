// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ إضافة الخطوط
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // ✅ إضافة أيقونات إضافية
import 'package:url_launcher/url_launcher.dart'; // ✅ للاتصال المباشر

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'email_service.dart';
import 'error_handler.dart';
import 'connectivity_service.dart';
import 'app_analytics.dart';
import 'form_validators.dart';
import 'app_config.dart'; // ✅ لاستخدام بيانات التواصل الثابتة

class ContactPage extends StatefulWidget {
  final String? initialInterest;

  const ContactPage({super.key, this.initialInterest});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  late final TextEditingController _notesController;

  String selectedCountry = 'SD';
  File? passportImage;
  File? personalPhoto;
  File? certificateFront;
  File? certificateBack;
  File? pdfFile;

  bool isSending = false;
  bool _isOnline = true;

  final ImagePicker _picker = ImagePicker();
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.forward();

    // ملء الملاحظات تلقائياً إذا جاء المستخدم من صفحة الخدمات
    _notesController = TextEditingController(
        text: widget.initialInterest != null
            ? 'أرغب في التقديم على: ${widget.initialInterest}'
            : '');

    _checkConnectivity();
    AppAnalytics.logScreenView('Contact Page');
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      _isOnline = await ConnectivityService.isConnected();
      if (mounted) setState(() {});
    } catch (e) {
      _isOnline = false;
      if (mounted) setState(() {});
    }
  }

  Future<File> _compressImage(File file) async {
    final lastIndex = file.path.lastIndexOf(RegExp(r'.jp'));
    if (lastIndex == -1) return file;
    final splitted = file.path.substring(0, (lastIndex));
    final outPath = "${splitted}_out${file.path.substring(lastIndex)}";

    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
      );
      return result != null ? File(result.path) : file;
    } catch (e) {
      return file;
    }
  }

  // ---------------------- Logic Section ----------------------

  void _showImageSourceDialog(BuildContext context, String type) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageProvider.isArabic ? 'اختر المصدر' : 'Select Source',
              style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceButton(
                  icon: Icons.camera_alt,
                  label: languageProvider.isArabic ? 'الكاميرا' : 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, type);
                  },
                  themeProvider: themeProvider,
                ),
                _buildSourceButton(
                  icon: Icons.photo_library,
                  label: languageProvider.isArabic ? 'المعرض' : 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, type);
                  },
                  themeProvider: themeProvider,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: themeProvider.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: themeProvider.primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: themeProvider.primaryColor),
            const SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.tajawal(
                    color: themeProvider.textColor,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        File originalFile = File(pickedFile.path);
        File compressedFile = await _compressImage(originalFile);

        setState(() {
          switch (type) {
            case 'passport':
              passportImage = compressedFile;
              break;
            case 'personal':
              personalPhoto = compressedFile;
              break;
            case 'certificateFront':
              certificateFront = compressedFile;
              break;
            case 'certificateBack':
              certificateBack = compressedFile;
              break;
          }
        });
        AppAnalytics.logButtonClick('Pick Image - $type');
      }
    } catch (e) {
      if (mounted) AppErrorHandler.handleError(context, e);
    }
  }

  Future<void> _pickPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          pdfFile = File(result.files.single.path!);
        });
        AppAnalytics.logButtonClick('Pick PDF');
      }
    } catch (e) {
      if (mounted) AppErrorHandler.handleError(context, e);
    }
  }

  Future<void> _sendData(BuildContext context) async {
    if (isSending) return;

    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    if (!_isOnline) {
      AppErrorHandler.showWarning(
          context,
          languageProvider.isArabic
              ? 'لا يوجد اتصال بالإنترنت'
              : 'No internet connection');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (passportImage == null ||
        personalPhoto == null ||
        certificateFront == null) {
      AppErrorHandler.showWarning(
          context,
          languageProvider.isArabic
              ? 'يرجى إرفاق المستندات المطلوبة (الجواز، الصورة الشخصية، الشهادة)'
              : 'Please attach required documents (Passport, Photo, Certificate)');
      return;
    }

    setState(() => isSending = true);

    try {
      await ConnectivityService.ensureConnection();

      final fullNameWithNotes =
          "${_nameController.text} (${_notesController.text})";

      await EmailService.sendEmail(
        name: fullNameWithNotes,
        pdfFile: pdfFile,
        passport: passportImage!,
        personalPhoto: personalPhoto!,
        certificateFront: certificateFront!,
        certificateBack: certificateBack,
        phone: _phoneController.text,
        whatsapp: _whatsappController.text,
        email: _emailController.text,
        country: selectedCountry,
      );

      AppAnalytics.logFormSubmission('Contact Form');

      if (!mounted) return;

      _showSuccessDialog(context, languageProvider);

      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _whatsappController.clear();
      _notesController.clear();

      setState(() {
        passportImage = null;
        personalPhoto = null;
        certificateFront = null;
        certificateBack = null;
        pdfFile = null;
        selectedCountry = 'SD';
      });
    } catch (e) {
      if (mounted) AppErrorHandler.handleError(context, e);
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  void _showSuccessDialog(BuildContext context, LanguageProvider lp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              lp.isArabic ? 'تم الإرسال بنجاح' : 'Sent Successfully',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          lp.isArabic
              ? 'تم استلام طلبك، سنتواصل معك قريباً عبر الواتساب.'
              : 'Your request has been received, we will contact you shortly via WhatsApp.',
          textAlign: TextAlign.center,
          style: GoogleFonts.tajawal(fontSize: 15),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(lp.isArabic ? 'حسناً' : 'OK',
                  style: GoogleFonts.tajawal()),
            ),
          )
        ],
      ),
    );
  }

  // --- دوال التواصل السريع ---
  void _launchWhatsApp() async {
    const url = 'https://wa.me/${AppConfig.whatsappNumber}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _makePhoneCall() async {
    const url = 'tel:${AppConfig.whatsappNumber}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // ---------------------- UI Building Blocks ----------------------

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    final List<Widget> formElements = [
      _buildHeader(themeProvider, languageProvider),

      // بطاقة تواصل سريع
      _buildQuickContactCard(themeProvider, languageProvider),
      const SizedBox(height: 24),

      if (widget.initialInterest != null && widget.initialInterest!.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: themeProvider.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: themeProvider.primaryColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.isArabic
                          ? 'طلب تقديم على:'
                          : 'Applying for:',
                      style: GoogleFonts.tajawal(
                          fontSize: 13, color: themeProvider.subTextColor),
                    ),
                    Text(
                      '${widget.initialInterest}',
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      _buildSectionTitle(
          languageProvider.isArabic ? 'البيانات الشخصية' : 'Personal Info',
          Icons.person_outline,
          themeProvider),
      _buildTextField(
        controller: _nameController,
        label: languageProvider.isArabic ? 'الاسم الكامل' : 'Full Name',
        icon: Icons.badge_outlined,
        isRequired: true,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
        validator: (v) =>
            FormValidators.validateName(v, languageProvider.isArabic),
      ),
      _buildDropdown(themeProvider, languageProvider),

      _buildSectionTitle(
          languageProvider.isArabic ? 'معلومات الاتصال' : 'Contact Info',
          Icons.contact_phone_outlined,
          themeProvider),
      _buildTextField(
        controller: _whatsappController,
        label: languageProvider.isArabic ? 'رقم الواتساب' : 'WhatsApp Number',
        icon: FontAwesomeIcons.whatsapp,
        isRequired: true,
        keyboardType: TextInputType.phone,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
        validator: (v) =>
            FormValidators.validatePhone(v, languageProvider.isArabic),
      ),
      _buildTextField(
        controller: _phoneController,
        label: languageProvider.isArabic
            ? 'رقم الهاتف (اختياري)'
            : 'Phone Number (Optional)',
        icon: Icons.phone_android_outlined,
        keyboardType: TextInputType.phone,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
      ),
      _buildTextField(
        controller: _emailController,
        label: languageProvider.isArabic ? 'البريد الإلكتروني' : 'Email',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
        validator: (v) => v != null && v.isNotEmpty
            ? FormValidators.validateEmail(v, languageProvider.isArabic)
            : null,
      ),
      _buildTextField(
        controller: _notesController,
        label: languageProvider.isArabic
            ? 'ملاحظات / استفسارات'
            : 'Notes / Inquiries',
        icon: Icons.edit_note,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
      ),

      _buildSectionTitle(
          languageProvider.isArabic ? 'المستندات المطلوبة' : 'Documents',
          Icons.folder_open_outlined,
          themeProvider),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
        children: [
          _buildUploadCard(
              'passport',
              languageProvider.isArabic ? 'جواز السفر' : 'Passport',
              passportImage,
              true,
              themeProvider,
              languageProvider),
          _buildUploadCard(
              'personal',
              languageProvider.isArabic ? 'صورة شخصية' : 'Personal Photo',
              personalPhoto,
              true,
              themeProvider,
              languageProvider),
          _buildUploadCard(
              'certificateFront',
              languageProvider.isArabic
                  ? 'الشهادة (أمام)'
                  : 'Certificate (Front)',
              certificateFront,
              true,
              themeProvider,
              languageProvider),
          _buildUploadCard(
              'certificateBack',
              languageProvider.isArabic
                  ? 'الشهادة (خلف)'
                  : 'Certificate (Back)',
              certificateBack,
              false,
              themeProvider,
              languageProvider),
        ],
      ),
      const SizedBox(height: 16),
      _buildPDFButton(themeProvider, languageProvider),
      const SizedBox(height: 40),
      _buildSubmitButton(themeProvider, languageProvider),
      const SizedBox(height: 30),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialInterest != null && widget.initialInterest!.isNotEmpty
              ? widget.initialInterest!
              : languageProvider.contactUs,
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: themeProvider.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            languageProvider.isArabic
                ? Icons.arrow_back_ios
                : Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(formElements.length, (index) {
              return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                        .animate(
                  CurvedAnimation(
                    parent: _animController,
                    curve: Interval(
                      index * 0.05,
                      1.0,
                      curve: Curves.easeOutQuart,
                    ),
                  ),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animController,
                      curve: Interval(index * 0.05, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: formElements[index],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ---------------------- Custom Widgets ----------------------

  Widget _buildHeader(ThemeProvider theme, LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isOnline)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        lang.isArabic
                            ? 'أنت غير متصل بالإنترنت'
                            : 'You are offline',
                        style: GoogleFonts.tajawal(
                            color: Colors.red, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        Text(
          lang.isArabic ? 'ابدأ رحلتك الآن 🚀' : 'Start Your Journey 🚀',
          style: GoogleFonts.tajawal(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lang.isArabic
              ? 'نحن هنا لمساعدتك في كل خطوة. املأ البيانات وسنتواصل معك.'
              : 'We are here to help. Fill in the details and we will contact you.',
          style: GoogleFonts.tajawal(color: theme.subTextColor, fontSize: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // بطاقة التواصل السريع
  Widget _buildQuickContactCard(ThemeProvider theme, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.isArabic ? 'تفضل التواصل المباشر؟' : 'Prefer direct contact?',
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _launchWhatsApp,
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                  label: Text(lang.isArabic ? 'واتساب' : 'WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _makePhoneCall,
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(lang.isArabic ? 'اتصال' : 'Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(color: theme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.primaryColor),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeProvider themeProvider,
    required LanguageProvider languageProvider,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.tajawal(color: themeProvider.textColor),
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          labelStyle: GoogleFonts.tajawal(color: Colors.grey[600]),
          prefixIcon: Icon(icon,
              size: 20, color: themeProvider.primaryColor.withOpacity(0.7)),
          filled: true,
          fillColor: themeProvider.currentTheme == AppTheme.dark
              ? themeProvider.cardColor
              : Colors.grey[50], // لون أفتح قليلاً
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: themeProvider.primaryColor, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator ??
            (isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return languageProvider.isArabic
                          ? 'هذا الحقل مطلوب'
                          : 'This field is required';
                    }
                    return null;
                  }
                : null),
      ),
    );
  }

  Widget _buildDropdown(ThemeProvider theme, LanguageProvider lang) {
    final Map<String, String> countries = {
      'SD': lang.isArabic ? '🇸🇩 السودان' : 'Sudan',
      'SY': lang.isArabic ? '🇸🇾 سوريا' : 'Syria',
      'YE': lang.isArabic ? '🇾🇪 اليمن' : 'Yemen',
      'SS': lang.isArabic ? '🇸🇸 جنوب السودان' : 'South Sudan',
      'TD': lang.isArabic ? '🇹🇩 تشاد' : 'Chad',
      'EG': lang.isArabic ? '🇪🇬 مصر' : 'Egypt',
      'SA': lang.isArabic ? '🇸🇦 السعودية' : 'Saudi Arabia',
      'AE': lang.isArabic ? '🇦🇪 الإمارات' : 'UAE',
      'OTHER': lang.isArabic ? '🌍 أخرى' : 'Other',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedCountry,
        style: GoogleFonts.tajawal(color: theme.textColor),
        decoration: InputDecoration(
          labelText: lang.isArabic ? 'الجنسية' : 'Nationality',
          labelStyle: GoogleFonts.tajawal(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.flag_outlined,
              size: 20, color: theme.primaryColor.withOpacity(0.7)),
          filled: true,
          fillColor: theme.currentTheme == AppTheme.dark
              ? theme.cardColor
              : Colors.grey[50],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          ),
        ),
        items: countries.entries.map((entry) {
          return DropdownMenuItem(value: entry.key, child: Text(entry.value));
        }).toList(),
        onChanged: (val) => setState(() => selectedCountry = val!),
      ),
    );
  }

  Widget _buildUploadCard(String type, String title, File? file,
      bool isRequired, ThemeProvider theme, LanguageProvider lang) {
    final bool hasFile = file != null;
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context, type),
      child: Container(
        decoration: BoxDecoration(
          color:
              hasFile ? theme.primaryColor.withOpacity(0.05) : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? theme.primaryColor : Colors.grey.withOpacity(0.3),
            width: hasFile ? 1.5 : 1,
            style:
                hasFile ? BorderStyle.solid : BorderStyle.none, // تحسين الحدود
          ),
          boxShadow: hasFile
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasFile)
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(file,
                          width: double.infinity, fit: BoxFit.cover),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check_circle,
                              color: theme.primaryColor, size: 16),
                        ),
                      )
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 28,
                        color: theme.primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: hasFile ? theme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                    bottom: const Radius.circular(14),
                    top: hasFile ? Radius.zero : const Radius.circular(14)),
              ),
              child: Text(
                title + (isRequired ? '*' : ''),
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 12,
                  fontWeight: hasFile ? FontWeight.bold : FontWeight.normal,
                  color:
                      hasFile ? Colors.white : theme.textColor.withOpacity(0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFButton(ThemeProvider theme, LanguageProvider lang) {
    final bool hasFile = pdfFile != null;
    return InkWell(
      onTap: _pickPDF,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: hasFile ? Colors.red.withOpacity(0.05) : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: hasFile ? Colors.red : Colors.grey.withOpacity(0.2)),
            boxShadow: hasFile
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf,
                color: hasFile ? Colors.red : Colors.grey[600]),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                hasFile
                    ? pdfFile!.path.split('/').last
                    : (lang.isArabic
                        ? 'إرفاق ملفات إضافية PDF (اختياري)'
                        : 'Attach extra PDF (Optional)'),
                style: GoogleFonts.tajawal(
                  color: hasFile ? Colors.red : Colors.grey[600],
                  fontWeight: hasFile ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasFile)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () => setState(() => pdfFile = null),
                  child: const Icon(Icons.close, color: Colors.red, size: 20),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeProvider theme, LanguageProvider lang) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isSending ? null : () => _sendData(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isSending
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lang.isArabic ? 'إرسال الطلب الآن' : 'Submit Application',
                    style: GoogleFonts.tajawal(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.send_rounded),
                ],
              ),
      ),
    );
  }
}
