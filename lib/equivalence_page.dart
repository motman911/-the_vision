// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';

// مكتبات الفايربيس
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'error_handler.dart';

// مخزن البيانات المؤقت (لضمان عدم ضياع البيانات عند التنقل بين الصفحات)
class TempDataManager {
  static String? studentName;
  static String? motherName;
  static String? whatsapp;
  static String? paymentMethod;
  static String? senderName;
  static String? transactionRef;

  static File? passportFile;
  static File? certFrontFile;
  static File? certBackFile;
  static File? certPdfFile;
  static File? paymentScreenshot;

  static void clear() {
    studentName = null;
    motherName = null;
    whatsapp = null;
    paymentMethod = null;
    senderName = null;
    transactionRef = null;
    passportFile = null;
    certFrontFile = null;
    certBackFile = null;
    certPdfFile = null;
    paymentScreenshot = null;
  }
}

class EquivalencePage extends StatefulWidget {
  const EquivalencePage({super.key});

  @override
  State<EquivalencePage> createState() => _EquivalencePageState();
}

class _EquivalencePageState extends State<EquivalencePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _transactionRefController =
      TextEditingController();
  final TextEditingController _senderNameController = TextEditingController();

  String? selectedPaymentMethod;

  File? passportFile;
  File? certFrontFile;
  File? certBackFile;
  File? certPdfFile;
  File? paymentScreenshot;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    if (TempDataManager.studentName != null) {
      _studentNameController.text = TempDataManager.studentName!;
    }
    if (TempDataManager.motherName != null) {
      _motherNameController.text = TempDataManager.motherName!;
    }
    if (TempDataManager.whatsapp != null) {
      _whatsappController.text = TempDataManager.whatsapp!;
    }
    if (TempDataManager.senderName != null) {
      _senderNameController.text = TempDataManager.senderName!;
    }
    if (TempDataManager.transactionRef != null) {
      _transactionRefController.text = TempDataManager.transactionRef!;
    }

    setState(() {
      selectedPaymentMethod = TempDataManager.paymentMethod;
      passportFile = TempDataManager.passportFile;
      certFrontFile = TempDataManager.certFrontFile;
      certBackFile = TempDataManager.certBackFile;
      certPdfFile = TempDataManager.certPdfFile;
      paymentScreenshot = TempDataManager.paymentScreenshot;
    });
  }

  // ضغط الصور لتقليل استهلاك مساحة Storage وسرعة الرفع
  Future<File> _compressImage(File file) async {
    try {
      final lastIndex = file.path.lastIndexOf(RegExp(r'.jp'));
      if (lastIndex == -1) return file;
      final splitted = file.path.substring(0, (lastIndex));
      final outPath = "${splitted}_out${file.path.substring(lastIndex)}";

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

  Future<void> _pickFile(String type,
      {bool isPdf = false, ImageSource source = ImageSource.gallery}) async {
    if (isPdf) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result != null) {
        setState(() {
          certPdfFile = File(result.files.single.path!);
          TempDataManager.certPdfFile = certPdfFile;
        });
      }
    } else {
      final XFile? image =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (image != null) {
        File compressedFile = await _compressImage(File(image.path));
        setState(() {
          if (type == 'passport') {
            passportFile = compressedFile;
            TempDataManager.passportFile = compressedFile;
          }
          if (type == 'front') {
            certFrontFile = compressedFile;
            TempDataManager.certFrontFile = compressedFile;
          }
          if (type == 'back') {
            certBackFile = compressedFile;
            TempDataManager.certBackFile = compressedFile;
          }
          if (type == 'pay') {
            paymentScreenshot = compressedFile;
            TempDataManager.paymentScreenshot = compressedFile;
          }
        });
      }
    }
  }

  void _showImageSourceDialog(String type) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("اختر المصدر",
                style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                    icon: Icons.camera_alt,
                    label: "الكاميرا",
                    theme: theme,
                    onTap: () {
                      Navigator.pop(context);
                      _pickFile(type, source: ImageSource.camera);
                    }),
                _buildSourceOption(
                    icon: Icons.photo_library,
                    label: "المعرض",
                    theme: theme,
                    onTap: () {
                      Navigator.pop(context);
                      _pickFile(type, source: ImageSource.gallery);
                    }),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required ThemeProvider theme}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle),
            child: Icon(icon, size: 30, color: theme.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.tajawal(color: theme.textColor)),
        ],
      ),
    );
  }

  void _submitOrder() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    if (!_formKey.currentState!.validate() ||
        passportFile == null ||
        (certFrontFile == null && certPdfFile == null) ||
        paymentScreenshot == null ||
        selectedPaymentMethod == null) {
      AppErrorHandler.showWarning(context, lang.fillAllFields);
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
      return;
    }
    _showConfirmDialog();
  }

  void _showConfirmDialog() {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(lang.confirmOrder,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        content: Text(lang.confirmOrderMsg,
            textAlign: TextAlign.center, style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(lang.review,
                  style: GoogleFonts.tajawal(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(ctx);
              _processOrder();
            },
            child: Text(lang.confirmAndSend,
                style: GoogleFonts.tajawal(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder() async {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          Center(child: CircularProgressIndicator(color: theme.primaryColor)),
    );

    try {
      // رفع الملفات بالتوازي لتحسين السرعة
      String passportUrl = await _uploadFile(passportFile!, 'passports');
      String paymentUrl = await _uploadFile(paymentScreenshot!, 'receipts');
      String? certFrontUrl = certFrontFile != null
          ? await _uploadFile(certFrontFile!, 'certificates')
          : null;
      String? certBackUrl = certBackFile != null
          ? await _uploadFile(certBackFile!, 'certificates')
          : null;
      String? certPdfUrl = certPdfFile != null
          ? await _uploadFile(certPdfFile!, 'certificates_pdf', isImage: false)
          : null;

      String transactionInfo = selectedPaymentMethod == 'momo'
          ? _senderNameController.text
          : _transactionRefController.text;

      await FirebaseFirestore.instance.collection('equivalence_requests').add({
        'studentName': _studentNameController.text.trim(),
        'motherName': _motherNameController.text.trim(),
        'whatsapp': _whatsappController.text.trim(),
        'payment': {
          'method': selectedPaymentMethod,
          'transactionInfo': transactionInfo,
          'receiptUrl': paymentUrl,
        },
        'documents': {
          'passportUrl': passportUrl,
          'certificateFrontUrl': certFrontUrl,
          'certificateBackUrl': certBackUrl,
          'certificatePdfUrl': certPdfUrl,
        },
        'status': 1,
        'userId': user.uid,
        'userEmail': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      TempDataManager.clear();
      if (!mounted) return;
      Navigator.of(context).pop(); // إغلاق مؤشر التحميل

      _showSuccessDialog();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        AppErrorHandler.showWarning(
            context, "فشل الإرسال: تأكد من جودة الإنترنت وحاول ثانية.");
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        title: Text("تم الإرسال بنجاح",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        content: Text("سيتم مراجعة طلبك والتواصل معك عبر الواتساب قريباً.",
            textAlign: TextAlign.center, style: GoogleFonts.tajawal()),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text("حسناً",
                  style: GoogleFonts.tajawal(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _uploadFile(File file, String folder,
      {bool isImage = true}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final extension = isImage ? '.jpg' : '.pdf';
    final ref = FirebaseStorage.instance.ref().child(folder).child(
        '${DateTime.now().millisecondsSinceEpoch}_${user.uid}$extension');
    final uploadTask =
        await ref.putFile(file).timeout(const Duration(seconds: 120));
    return await uploadTask.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(lang.equivalenceRequest,
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
              lang.isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(lang.reqDocs, Icons.folder_shared, theme),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: _uploadCard(
                          lang.certPdf,
                          certPdfFile != null,
                          () => _pickFile('pdf', isPdf: true),
                          theme,
                          Icons.picture_as_pdf)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _uploadCard(
                          lang.certFront,
                          certFrontFile != null,
                          () => _showImageSourceDialog('front'),
                          theme,
                          Icons.image)),
                ],
              ),
              const SizedBox(height: 10),
              _uploadCard(lang.certBack, certBackFile != null,
                  () => _showImageSourceDialog('back'), theme, Icons.flip),
              const SizedBox(height: 10),
              _uploadCard(
                  lang.passportPhoto,
                  passportFile != null,
                  () => _showImageSourceDialog('passport'),
                  theme,
                  Icons.person_pin_circle,
                  isRequired: true),
              const SizedBox(height: 30),
              _buildSectionHeader(lang.personalInfo, Icons.person, theme),
              _buildTextField(
                  controller: _studentNameController,
                  label: lang.studentName,
                  icon: Icons.person_outline,
                  theme: theme,
                  lang: lang,
                  onChanged: (val) => TempDataManager.studentName = val),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: _motherNameController,
                  label: lang.motherName,
                  icon: Icons.family_restroom,
                  theme: theme,
                  lang: lang,
                  onChanged: (val) => TempDataManager.motherName = val),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: _whatsappController,
                  label: lang.whatsappNum,
                  icon: Icons.chat,
                  theme: theme,
                  lang: lang,
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => TempDataManager.whatsapp = val),
              const SizedBox(height: 30),
              _buildSectionHeader(lang.paymentMethod, Icons.payment, theme),
              _buildPaymentSelector(theme, lang),
              if (selectedPaymentMethod != null)
                _buildPaymentDetailsCard(theme, lang),
              const SizedBox(height: 40),
              _buildSubmitButton(theme, lang),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeProvider theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: theme.primaryColor, size: 24),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor)),
      ],
    );
  }

  Widget _uploadCard(String label, bool isDone, VoidCallback onTap,
      ThemeProvider theme, IconData icon,
      {bool isRequired = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.withOpacity(0.05) : theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isDone ? Colors.green : Colors.grey.withOpacity(0.3),
              width: 1.5),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Icon(isDone ? Icons.check_circle : icon,
                color: isDone ? Colors.green : theme.primaryColor, size: 32),
            const SizedBox(height: 10),
            Text(label + (isRequired && !isDone ? ' *' : ''),
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDone ? Colors.green : theme.textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      required ThemeProvider theme,
      required LanguageProvider lang,
      TextInputType keyboardType = TextInputType.text,
      Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.tajawal(color: theme.textColor),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.tajawal(color: Colors.grey),
        prefixIcon: Icon(icon, color: theme.primaryColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      validator: (v) => v!.isEmpty ? lang.fieldRequired : null,
    );
  }

  Widget _buildPaymentSelector(ThemeProvider theme, LanguageProvider lang) {
    return Column(
      children: [
        _buildPaymentOptionCard(theme,
            title: lang.momoRwanda,
            price: '10,000 RWF',
            value: 'momo',
            icon: Icons.mobile_friendly),
        const SizedBox(height: 10),
        _buildPaymentOptionCard(theme,
            title: lang.binance,
            price: '7 USDT',
            value: 'binance',
            icon: Icons.currency_bitcoin),
        const SizedBox(height: 10),
        _buildPaymentOptionCard(theme,
            title: lang.bankak,
            price: '30,000 SDG',
            value: 'bankak',
            icon: Icons.account_balance),
      ],
    );
  }

  Widget _buildPaymentOptionCard(ThemeProvider theme,
      {required String title,
      required String price,
      required String value,
      required IconData icon}) {
    final isSelected = selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() => selectedPaymentMethod = value);
        TempDataManager.paymentMethod = value;
      },
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected ? theme.primaryColor : Colors.transparent,
              width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? theme.primaryColor : Colors.grey),
            const SizedBox(width: 15),
            Expanded(
                child: Text(title,
                    style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textColor))),
            Text(price,
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? theme.primaryColor : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsCard(ThemeProvider theme, LanguageProvider lang) {
    String number = "", name = "", amount = "";
    if (selectedPaymentMethod == 'momo') {
      number = "0798977374";
      name = "MOTMAN NOUR ALNABI";
      amount = "10,000 RWF";
    } else if (selectedPaymentMethod == 'binance') {
      number = "868252112";
      name = "Motman-Nour";
      amount = "7 USDT";
    } else if (selectedPaymentMethod == 'bankak') {
      number = "4604638";
      name = "عبد الرحمن ضياء";
      amount = "30,000 SDG";
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.primaryColor.withOpacity(0.3))),
      child: Column(
        children: [
          _detailRow(lang.requiredAmount, amount, theme, isBold: true),
          const Divider(),
          Row(children: [
            Expanded(
                child:
                    _detailRow(lang.accountNum, number, theme, isBold: true)),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: number));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(lang.copied),
                      duration: const Duration(seconds: 1)));
                },
                icon: const Icon(Icons.copy, size: 20))
          ]),
          const SizedBox(height: 10),
          _detailRow(lang.beneficiaryName, name, theme),
          const SizedBox(height: 20),
          _uploadCard(lang.uploadReceipt, paymentScreenshot != null,
              () => _showImageSourceDialog('pay'), theme, Icons.receipt_long,
              isRequired: true),
          const SizedBox(height: 15),
          if (selectedPaymentMethod == 'momo')
            _buildTextField(
                controller: _senderNameController,
                label: lang.senderName,
                icon: Icons.person,
                theme: theme,
                lang: lang,
                onChanged: (val) => TempDataManager.senderName = val),
          if (selectedPaymentMethod != 'momo')
            _buildTextField(
                controller: _transactionRefController,
                label: lang.transactionRef,
                icon: Icons.confirmation_number,
                theme: theme,
                lang: lang,
                onChanged: (val) => TempDataManager.transactionRef = val),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, ThemeProvider theme,
      {bool isBold = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12)),
      Text(value,
          style: GoogleFonts.tajawal(
              color: theme.textColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16))
    ]);
  }

  Widget _buildSubmitButton(ThemeProvider theme, LanguageProvider lang) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5),
        onPressed: _submitOrder,
        child: Text(lang.submitRequest,
            style: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
