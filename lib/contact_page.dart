// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'email_service.dart';
import 'error_handler.dart';
import 'connectivity_service.dart';
import 'app_analytics.dart';

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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageProvider.isArabic ? 'اختر المصدر' : 'Select Source',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor),
            ),
            const SizedBox(height: 20),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: themeProvider.primaryColor),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: themeProvider.textColor)),
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
        setState(() {
          switch (type) {
            case 'passport':
              passportImage = File(pickedFile.path);
              break;
            case 'personal':
              personalPhoto = File(pickedFile.path);
              break;
            case 'certificateFront':
              certificateFront = File(pickedFile.path);
              break;
            case 'certificateBack':
              certificateBack = File(pickedFile.path);
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
      final fullNameWithNotes =
          "${_nameController.text} (${_notesController.text})";

      await sendEmail(
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
        title: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text(lp.isArabic ? 'تم الإرسال بنجاح' : 'Sent Successfully'),
          ],
        ),
        content: Text(
          lp.isArabic
              ? 'تم استلام طلبك، سنتواصل معك قريباً عبر الواتساب.'
              : 'Your request has been received, we will contact you shortly via WhatsApp.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lp.isArabic ? 'حسناً' : 'OK'),
          )
        ],
      ),
    );
  }

  // ---------------------- UI Building Blocks ----------------------

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    final List<Widget> formElements = [
      _buildHeader(themeProvider, languageProvider),
      if (widget.initialInterest != null)
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: themeProvider.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: themeProvider.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.isArabic
                          ? 'طلب تقديم على:'
                          : 'Applying for:',
                      style: TextStyle(
                          fontSize: 12, color: themeProvider.subTextColor),
                    ),
                    Text(
                      '${widget.initialInterest}',
                      style: TextStyle(
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
          Icons.person,
          themeProvider),
      _buildTextField(
        controller: _nameController,
        label: languageProvider.isArabic ? 'الاسم الكامل' : 'Full Name',
        icon: Icons.person_outline,
        isRequired: true,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
      ),
      _buildDropdown(themeProvider, languageProvider),
      _buildSectionTitle(
          languageProvider.isArabic ? 'معلومات الاتصال' : 'Contact Info',
          Icons.contact_phone,
          themeProvider),
      _buildTextField(
        controller: _whatsappController,
        label: languageProvider.isArabic ? 'رقم الواتساب' : 'WhatsApp Number',
        icon: Icons.chat_bubble_outline,
        isRequired: true,
        keyboardType: TextInputType.phone,
        languageProvider: languageProvider,
        themeProvider: themeProvider,
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
          Icons.folder_open,
          themeProvider),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
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
      const SizedBox(height: 12),
      _buildPDFButton(themeProvider, languageProvider),
      const SizedBox(height: 40),
      _buildSubmitButton(themeProvider, languageProvider),
      const SizedBox(height: 30),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.contactUs),
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(formElements.length, (index) {
              return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
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
              borderRadius: BorderRadius.circular(10),
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
                        style: const TextStyle(color: Colors.red))),
              ],
            ),
          ),
        Text(
          lang.isArabic ? 'ابدأ رحلتك الآن 🚀' : 'Start Your Journey 🚀',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lang.isArabic
              ? 'نحن هنا لمساعدتك في كل خطوة. املأ البيانات وسنتواصل معك.'
              : 'We are here to help. Fill in the details and we will contact you.',
          style: TextStyle(color: theme.subTextColor, fontSize: 15),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.primaryColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: themeProvider.textColor),
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon:
              Icon(icon, color: themeProvider.primaryColor.withOpacity(0.7)),
          filled: true,
          // ✅ لون الخلفية الجديد (رمادي فاتح جداً مثل F8FAFC)
          fillColor: themeProvider.currentTheme == AppTheme.dark
              ? themeProvider.cardColor
              : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: themeProvider.primaryColor, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.isArabic
                      ? 'هذا الحقل مطلوب'
                      : 'This field is required';
                }
                return null;
              }
            : null,
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
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedCountry,
        decoration: InputDecoration(
          labelText: lang.isArabic ? 'الجنسية' : 'Nationality',
          prefixIcon: Icon(Icons.flag_outlined,
              color: theme.primaryColor.withOpacity(0.7)),
          filled: true,
          fillColor: theme.currentTheme == AppTheme.dark
              ? theme.cardColor
              : Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
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
              hasFile ? theme.primaryColor.withOpacity(0.1) : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          // ✅ تصميم الحدود المتقطعة (Dashed) باستخدام Border.all كبديل بسيط
          border: Border.all(
            color: hasFile ? theme.primaryColor : Colors.grey.withOpacity(0.4),
            width: 1.5,
            style: hasFile ? BorderStyle.solid : BorderStyle.none, // بسيط
          ),
          boxShadow: hasFile
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                  child: Image.file(file,
                      width: double.infinity, fit: BoxFit.cover),
                ),
              )
            else
              Expanded(
                child: Icon(
                  Icons.cloud_upload_outlined, // أيقونة السحابة
                  size: 32,
                  color: theme.primaryColor.withOpacity(0.6),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              decoration: BoxDecoration(
                color: hasFile ? theme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                    bottom: const Radius.circular(14),
                    top: hasFile ? Radius.zero : const Radius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasFile)
                    const Icon(Icons.check_circle,
                        size: 14, color: Colors.white),
                  if (hasFile) const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      title + (isRequired ? '*' : ''),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            hasFile ? FontWeight.bold : FontWeight.normal,
                        color: hasFile
                            ? Colors.white
                            : theme.textColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf,
                color: hasFile ? Colors.red : Colors.grey),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                hasFile
                    ? pdfFile!.path.split('/').last
                    : (lang.isArabic
                        ? 'إرفاق ملفات إضافية PDF (اختياري)'
                        : 'Attach extra PDF (Optional)'),
                style: TextStyle(
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
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isSending ? null : () => _sendData(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, // لأننا استخدمنا ظل في الحاوية
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.send_rounded),
                ],
              ),
      ),
    );
  }
}
