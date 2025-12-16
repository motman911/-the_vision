import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'theme_provider.dart';
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

  void _showImageSourceDialog(String type) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('اختر مصدر الصورة'),
        actions: [
          TextButton(
            child: const Text('كاميرا'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera, type);
            },
          ),
          TextButton(
            child: const Text('معرض'),
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

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        pdfFile = File(result.files.single.path!);
      });
    }
  }

  String? _validateWhatsApp(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال رقم الواتساب';
    final regex = RegExp(r'^[0-9]{10,15}$');
    if (!regex.hasMatch(value)) return 'يرجى إدخال رقم واتساب صحيح';
    return null;
  }

  Widget _imagePreview(String label, File? file) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        file != null
            ? Image.file(file, height: 100, width: 100, fit: BoxFit.cover)
            : Container(
                height: 100,
                width: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اتصل بنا'),
        backgroundColor: themeProvider.primaryColor,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أرسل لنا بياناتك',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                // الاسم (اجباري)
                Row(
                  children: const [
                    Text('*', style: TextStyle(color: Colors.red)),
                    SizedBox(width: 4),
                    Text('الاسم',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'ادخل اسمك',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال الاسم'
                      : null,
                ),
                const SizedBox(height: 12),
                // رقم الواتساب (اجباري)
                Row(
                  children: const [
                    Text('*', style: TextStyle(color: Colors.red)),
                    SizedBox(width: 4),
                    Text('رقم الواتساب',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _whatsappController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'ادخل رقم الواتساب',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validateWhatsApp,
                ),
                const SizedBox(height: 12),
                // رقم الهاتف
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف (اختياري)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                // البريد الالكتروني
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني (اختياري)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                // الجنسية
                DropdownButtonFormField<String>(
                  initialValue: selectedCountry,
                  items: const [
                    DropdownMenuItem(value: 'SD', child: Text('السودان')),
                    DropdownMenuItem(value: 'SY', child: Text('سوريا')),
                    DropdownMenuItem(value: 'YE', child: Text('اليمن')),
                    DropdownMenuItem(value: 'SS', child: Text('جنوب السودان')),
                    DropdownMenuItem(value: 'TD', child: Text('تشاد')),
                  ],
                  onChanged: (value) =>
                      setState(() => selectedCountry = value!),
                  decoration: InputDecoration(
                    labelText: 'الجنسية',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    GestureDetector(
                      onTap: () => _showImageSourceDialog('passport'),
                      child: _imagePreview('جواز السفر', passportImage),
                    ),
                    GestureDetector(
                      onTap: () => _showImageSourceDialog('personal'),
                      child: _imagePreview('صورة شخصية', personalPhoto),
                    ),
                    GestureDetector(
                      onTap: () => _showImageSourceDialog('certificateFront'),
                      child: _imagePreview('شهادة أمام', certificateFront),
                    ),
                    GestureDetector(
                      onTap: () => _showImageSourceDialog('certificateBack'),
                      child:
                          _imagePreview('شهادة خلف (اختياري)', certificateBack),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _pickPDF,
                  child: Text(pdfFile != null
                      ? 'PDF محدد: ${pdfFile!.path.split('/').last}'
                      : 'رفع PDF (اختياري)'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (passportImage == null ||
                                  personalPhoto == null ||
                                  certificateFront == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('الحقول الأساسية غير مكتملة!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

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

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'تم استلام البيانات! سنتواصل معك'),
                                    backgroundColor: themeProvider.primaryColor,
                                  ),
                                );

                                _nameController.clear();
                                _emailController.clear();
                                _phoneController.clear();
                                _whatsappController.clear();
                                setState(() {
                                  passportImage = null;
                                  personalPhoto = null;
                                  certificateFront = null;
                                  certificateBack = null;
                                  pdfFile = null;
                                });
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'حدث خطأ أثناء إرسال البيانات: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() => isSending = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: isSending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3),
                          )
                        : const Text('إرسال البيانات'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
