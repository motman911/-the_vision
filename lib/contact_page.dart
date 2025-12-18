import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'email_service.dart';

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
    }
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      if (mounted) {
        setState(() {
          pdfFile = File(result.files.single.path!);
        });
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

  void _sendData(BuildContext context) {
    if (isSending || !mounted) return;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passportImage == null ||
        personalPhoto == null ||
        certificateFront == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(languageProvider.isArabic
              ? 'الحقول الأساسية غير مكتملة!'
              : 'Required fields are incomplete!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isSending = true);

    Future.microtask(() async {
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

        if (!mounted) return;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(languageProvider.isArabic
                ? 'تم استلام البيانات! سنتواصل معك'
                : 'Data received! We will contact you'),
            backgroundColor: themeProvider.primaryColor,
          ),
        );

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
          });
        }
      } catch (e) {
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(languageProvider.isArabic
                  ? 'حدث خطأ أثناء إرسال البيانات: $e'
                  : 'An error occurred while sending data: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isSending = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              languageProvider.contactUs,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: themeProvider.primaryColor,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 4,
          ),
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
                    const SizedBox(height: 16),

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
                            ? 'ادخل اسمك'
                            : 'Enter your name',
                        contentPadding: const EdgeInsets.all(16),
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
                      child: Text(
                        pdfFile != null
                            ? (languageProvider.isArabic
                                ? 'PDF محدد: ${pdfFile!.path.split('/').last}'
                                : 'PDF Selected: ${pdfFile!.path.split('/').last}')
                            : (languageProvider.isArabic
                                ? 'رفع PDF (اختياري)'
                                : 'Upload PDF (Optional)'),
                        style: const TextStyle(fontSize: 16),
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
                        child: Text(
                          isSending
                              ? (languageProvider.isArabic
                                  ? 'جاري الإرسال...'
                                  : 'Sending...')
                              : (languageProvider.isArabic
                                  ? 'إرسال البيانات'
                                  : 'Send Data'),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
