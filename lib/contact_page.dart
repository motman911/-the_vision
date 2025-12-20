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
  const ContactPage({super.key});

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
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_animController);
    _animController.forward();

    // التحقق من الاتصال
    _checkConnectivity();

    // تسجيل مشاهدة الصفحة
    AppAnalytics.logScreenView('Contact Page');
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      _isOnline = await ConnectivityService.isConnected();
      setState(() {});
    } catch (e) {
      _isOnline = false;
      setState(() {});
    }
  }

  void _showImageSourceDialog(BuildContext context, String type) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(languageProvider.isArabic
            ? 'اختر مصدر الصورة'
            : 'Choose Image Source'),
        actions: [
          TextButton(
            child: Text(languageProvider.isArabic ? 'كاميرا' : 'Camera'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera, type);
            },
          ),
          TextButton(
            child: Text(languageProvider.isArabic ? 'معرض' : 'Gallery'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery, type);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        if (mounted) {
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
        }
        AppAnalytics.logButtonClick('Pick Image - $type');
      }
    } catch (e) {
      AppAnalytics.logError('Image Picker', e);
      if (mounted) {
        AppErrorHandler.handleError(context, e);
      }
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
        if (mounted) {
          setState(() {
            pdfFile = File(result.files.single.path!);
          });
        }
        AppAnalytics.logButtonClick('Pick PDF');
      }
    } catch (e) {
      AppAnalytics.logError('File Picker', e);
      if (mounted) {
        AppErrorHandler.handleError(context, e);
      }
    }
  }

  String? _validateWhatsApp(String? value, BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    if (value == null || value.isEmpty) {
      return languageProvider.isArabic
          ? 'يرجى إدخال رقم الواتساب'
          : 'Please enter WhatsApp number';
    }
    final regex = RegExp(r'^[0-9]{10,15}$');
    if (!regex.hasMatch(value)) {
      return languageProvider.isArabic
          ? 'يرجى إدخال رقم واتساب صحيح'
          : 'Please enter a valid WhatsApp number';
    }
    return null;
  }

  Widget _imagePreview(String label, File? file) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(file, fit: BoxFit.cover),
                )
              : Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _sendData(BuildContext context) async {
    if (isSending || !mounted) return;

    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    // التحقق من الاتصال
    if (!_isOnline) {
      AppErrorHandler.handleError(
        context,
        'لا يوجد اتصال بالإنترنت',
        customMessage: 'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passportImage == null ||
        personalPhoto == null ||
        certificateFront == null) {
      AppErrorHandler.showWarning(
        context,
        languageProvider.isArabic
            ? 'الحقول الأساسية غير مكتملة!'
            : 'Required fields are incomplete!',
      );
      return;
    }

    // عرض تأكيد الإرسال
    final shouldSend = await AppErrorHandler.showConfirmDialog(
      context,
      title: languageProvider.isArabic ? 'تأكيد الإرسال' : 'Confirm Send',
      message: languageProvider.isArabic
          ? 'هل أنت متأكد من إرسال البيانات؟'
          : 'Are you sure you want to send the data?',
      confirmText: languageProvider.isArabic ? 'إرسال' : 'Send',
      cancelText: languageProvider.isArabic ? 'إلغاء' : 'Cancel',
    );

    if (!shouldSend) return;

    setState(() => isSending = true);

    try {
      await sendEmail(
        _nameController.text,
        pdfFile,
        passportImage!,
        personalPhoto!,
        certificateFront!,
        certificateBack,
        phone: _phoneController.text,
        whatsapp: _whatsappController.text,
        email: _emailController.text,
        country: selectedCountry,
      );

      AppAnalytics.logFormSubmission('Contact Form');
      AppAnalytics.logEmailSent('Vision Office');

      if (!mounted) return;

      AppErrorHandler.showSuccess(
        context,
        languageProvider.isArabic
            ? 'تم استلام البيانات بنجاح! سنتواصل معك قريباً'
            : 'Data received successfully! We will contact you soon',
      );

      // إعادة تعيين النموذج
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _whatsappController.clear();

      if (mounted) {
        setState(() {
          passportImage = null;
          personalPhoto = null;
          certificateFront = null;
          certificateBack = null;
          pdfFile = null;
          selectedCountry = 'SD';
        });
      }
    } catch (e) {
      AppAnalytics.logError('Email Service', e);
      if (mounted) {
        AppErrorHandler.handleError(
          context,
          e,
          customMessage: languageProvider.isArabic
              ? 'حدث خطأ أثناء إرسال البيانات. يرجى المحاولة مرة أخرى'
              : 'An error occurred while sending data. Please try again',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  Widget _buildConnectionStatus() {
    if (_isOnline) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'أنت غير متصل بالإنترنت. بعض الميزات قد لا تعمل.',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
          body: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.isArabic
                          ? 'أرسل لنا بياناتك'
                          : 'Send us your information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      languageProvider.isArabic
                          ? 'املأ النموذج التالي وسنتواصل معك في أقرب وقت'
                          : 'Fill the form below and we will contact you soon',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // حالة الاتصال
                    _buildConnectionStatus(),

                    // الاسم (اجباري)
                    Row(
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: 4),
                        Text(
                          languageProvider.isArabic ? 'الاسم' : 'Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: languageProvider.isArabic
                            ? 'ادخل اسمك الكامل'
                            : 'Enter your full name',
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? (languageProvider.isArabic
                              ? 'يرجى إدخال الاسم'
                              : 'Please enter your name')
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // رقم الواتساب (اجباري)
                    Row(
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: 4),
                        Text(
                          languageProvider.isArabic
                              ? 'رقم الواتساب'
                              : 'WhatsApp Number',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _whatsappController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: languageProvider.isArabic
                            ? 'ادخل رقم الواتساب'
                            : 'Enter WhatsApp number',
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => _validateWhatsApp(value, context),
                    ),
                    const SizedBox(height: 12),

                    // رقم الهاتف
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: languageProvider.isArabic
                            ? 'رقم الهاتف (اختياري)'
                            : 'Phone Number (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: const Icon(Icons.phone_android),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),

                    // البريد الالكتروني
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: languageProvider.isArabic
                            ? 'البريد الإلكتروني (اختياري)'
                            : 'Email (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // الجنسية
                    DropdownButtonFormField<String>(
                      initialValue: selectedCountry,
                      items: [
                        DropdownMenuItem(
                          value: 'SD',
                          child: Text(
                              languageProvider.isArabic ? 'السودان' : 'Sudan'),
                        ),
                        DropdownMenuItem(
                          value: 'SY',
                          child: Text(
                              languageProvider.isArabic ? 'سوريا' : 'Syria'),
                        ),
                        DropdownMenuItem(
                          value: 'YE',
                          child: Text(
                              languageProvider.isArabic ? 'اليمن' : 'Yemen'),
                        ),
                        DropdownMenuItem(
                          value: 'SS',
                          child: Text(languageProvider.isArabic
                              ? 'جنوب السودان'
                              : 'South Sudan'),
                        ),
                        DropdownMenuItem(
                          value: 'TD',
                          child:
                              Text(languageProvider.isArabic ? 'تشاد' : 'Chad'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCountry = value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: languageProvider.isArabic
                            ? 'الجنسية'
                            : 'Nationality',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: const Icon(Icons.flag),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      languageProvider.isArabic
                          ? 'المستندات المطلوبة'
                          : 'Required Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _showImageSourceDialog(context, 'passport'),
                          child: _imagePreview(
                            languageProvider.isArabic
                                ? 'جواز السفر'
                                : 'Passport',
                            passportImage,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _showImageSourceDialog(context, 'personal'),
                          child: _imagePreview(
                            languageProvider.isArabic
                                ? 'صورة شخصية'
                                : 'Personal Photo',
                            personalPhoto,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showImageSourceDialog(
                              context, 'certificateFront'),
                          child: _imagePreview(
                            languageProvider.isArabic
                                ? 'شهادة أمام'
                                : 'Certificate Front',
                            certificateFront,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showImageSourceDialog(
                              context, 'certificateBack'),
                          child: _imagePreview(
                            languageProvider.isArabic
                                ? 'شهادة خلف (اختياري)'
                                : 'Certificate Back (Optional)',
                            certificateBack,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () => _pickPDF(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.surfaceColor,
                        foregroundColor: themeProvider.textColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.picture_as_pdf),
                          const SizedBox(width: 8),
                          Text(
                            pdfFile != null
                                ? (languageProvider.isArabic
                                    ? 'PDF محدد: ${pdfFile!.path.split('/').last}'
                                    : 'PDF Selected: ${pdfFile!.path.split('/').last}')
                                : (languageProvider.isArabic
                                    ? 'رفع PDF (اختياري)'
                                    : 'Upload PDF (Optional)'),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: isSending
                            ? null
                            : () {
                                _sendData(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.secondaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(250, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isSending
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    languageProvider.isArabic
                                        ? 'جاري الإرسال...'
                                        : 'Sending...',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            : Text(
                                languageProvider.isArabic
                                    ? 'إرسال البيانات'
                                    : 'Send Data',
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // معلومات إضافية
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeProvider.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: themeProvider.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              languageProvider.isArabic
                                  ? 'سنقوم بالتواصل معك عبر الواتساب خلال 24 ساعة'
                                  : 'We will contact you via WhatsApp within 24 hours',
                              style: TextStyle(
                                fontSize: 12,
                                color: themeProvider.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
