// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'error_handler.dart';

class CurrencyExchangePage extends StatefulWidget {
  const CurrencyExchangePage({super.key});

  @override
  State<CurrencyExchangePage> createState() => _CurrencyExchangePageState();
}

class _CurrencyExchangePageState extends State<CurrencyExchangePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _targetNameController = TextEditingController();
  final TextEditingController _targetNumberController = TextEditingController();
  final TextEditingController _senderNameController = TextEditingController();

  bool isSdgToRwf = true;
  File? receiptImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  double _calculatedAmount = 0.0;

  double rateSdgToRwf = 0.39;
  double rateRwfToSdg = 0.41;

  // الألوان المستخدمة
  final Color primaryColor = const Color(0xFF0F766E); // Teal 700
  final Color accentColor = const Color(0xFFF59E0B); // Amber 500

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  void _fetchRates() {
    FirebaseFirestore.instance
        .collection('app_settings')
        .doc('currency_rates')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        setState(() {
          rateSdgToRwf = (snapshot.data()?['sdg_to_rwf'] ?? 0.39).toDouble();
          rateRwfToSdg = (snapshot.data()?['rwf_to_sdg'] ?? 0.41).toDouble();
          _calculateResult();
        });
      }
    });
  }

  // --- دالة الحساب ---
  void _calculateResult() {
    double input = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _calculatedAmount =
          isSdgToRwf ? input * rateSdgToRwf : input / rateRwfToSdg;
    });
  }

  // --- اختيار الصورة ---
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image =
        await _picker.pickImage(source: source, imageQuality: 70);
    if (image != null) setState(() => receiptImage = File(image.path));
  }

  // --- إرسال الطلب ---
  Future<void> _submitRequest() async {
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    if (!_formKey.currentState!.validate() || receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(lang.isArabic
            ? "يرجى إرفاق صورة الإيصال وملء جميع الحقول"
            : "Please attach receipt and fill all fields"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      String fileName = 'exchange_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('exchange_receipts')
          .child(fileName);
      await ref.putFile(receiptImage!);
      String imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('exchange_requests').add({
        'userId': user.uid,
        'userEmail': user.email,
        'type': isSdgToRwf ? 'SDG_TO_RWF' : 'RWF_TO_SDG',
        'inputAmount': double.parse(_amountController.text),
        'outputAmount': _calculatedAmount,
        'rateUsed': isSdgToRwf ? rateSdgToRwf : rateRwfToSdg,
        'targetAccountName': _targetNameController.text,
        'targetAccountNumber': _targetNumberController.text,
        'senderName': isSdgToRwf ? '' : _senderNameController.text,
        'receiptUrl': imageUrl,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _amountController.clear();
      _targetNameController.clear();
      _targetNumberController.clear();
      _senderNameController.clear();
      setState(() {
        receiptImage = null;
        _calculatedAmount = 0.0;
        _isLoading = false;
      });

      _showSuccessDialog(lang);
    } catch (e) {
      setState(() => _isLoading = false);
      AppErrorHandler.handleError(context, e.toString());
    }
  }

  void _showSuccessDialog(LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(
              lang.isArabic ? "تم إرسال الطلب بنجاح!" : "Request Sent!",
              style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              lang.isArabic
                  ? "سيتم مراجعة طلبك وإرسال المبلغ في أقرب وقت."
                  : "Your request is under review.",
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child:
                    const Text("حسناً", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- تحديث الأسعار (للأدمن) ---
  Future<void> _updateRatesDialog(LanguageProvider lang) async {
    final TextEditingController sdgController =
        TextEditingController(text: rateSdgToRwf.toString());
    final TextEditingController rwfController =
        TextEditingController(text: rateRwfToSdg.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("تحديث الأسعار", style: GoogleFonts.tajawal()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: sdgController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "SDG -> RWF")),
            TextField(
                controller: rwfController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "RWF -> SDG")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('app_settings')
                  .doc('currency_rates')
                  .set({
                'sdg_to_rwf':
                    double.tryParse(sdgController.text) ?? rateSdgToRwf,
                'rwf_to_sdg':
                    double.tryParse(rwfController.text) ?? rateRwfToSdg,
              });
              Navigator.pop(ctx);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    // التحقق من الأدمن (يمكن تعديله حسب الحاجة)
    bool isSuperAdmin = user?.email == "motman911@gmail.com";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(lang.isArabic ? "تحويل العملات" : "Currency Exchange",
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          if (isSuperAdmin)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => _updateRatesDialog(lang),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Rates
            _buildRatesTicker(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Calculator Card
                    _buildCalculatorCard(lang),
                    const SizedBox(height: 25),

                    // Transfer Info
                    _buildInstructionCard(lang),
                    const SizedBox(height: 25),

                    // Input Fields
                    _buildInputFields(lang),
                    const SizedBox(height: 25),

                    // Upload Receipt
                    _buildUploadSection(lang),
                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                lang.isArabic
                                    ? "تأكيد وإرسال الطلب"
                                    : "Confirm & Send",
                                style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatesTicker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _rateBadge("SDG ➔ RWF", rateSdgToRwf.toStringAsFixed(2)),
          Container(height: 30, width: 1, color: Colors.white30),
          _rateBadge("RWF ➔ SDG", rateRwfToSdg.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _rateBadge(String title, String rate) {
    return Column(
      children: [
        Text(title,
            style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(rate,
            style: GoogleFonts.tajawal(
                color: accentColor, fontWeight: FontWeight.bold, fontSize: 22)),
      ],
    );
  }

  Widget _buildCalculatorCard(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          // Direction Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _toggleButton("SDG ➔ RWF", isSdgToRwf, () {
                  setState(() {
                    isSdgToRwf = true;
                    _calculateResult();
                  });
                }),
                _toggleButton("RWF ➔ SDG", !isSdgToRwf, () {
                  setState(() {
                    isSdgToRwf = false;
                    _calculateResult();
                  });
                }),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Amount Input
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            onChanged: (val) => _calculateResult(),
            textAlign: TextAlign.center,
            style:
                GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: "0.0",
              suffixText: isSdgToRwf ? "SDG" : "RWF",
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2)),
            ),
          ),
          const SizedBox(height: 10),
          Text(lang.isArabic ? "المبلغ المراد تحويله" : "Amount to send",
              style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12)),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Icon(Icons.arrow_downward, color: Colors.grey),
          ),

          // Result
          Text(
            "${_calculatedAmount.toStringAsFixed(1)} ${isSdgToRwf ? 'RWF' : 'SDG'}",
            style: GoogleFonts.tajawal(
                fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          Text(lang.isArabic ? "المبلغ المستلم" : "You receive",
              style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard(LanguageProvider lang) {
    String number = isSdgToRwf ? "4604638" : "0795590995";
    String name =
        isSdgToRwf ? "عبد الرحمن ضياء الدين" : "ABDELRAHMAN DIAAELDIN";
    String bank = isSdgToRwf ? "بنك الخرطوم (بنكك)" : "MTN MoMo Rwanda";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark Slate
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white70),
              const SizedBox(width: 10),
              Text(
                lang.isArabic ? "حول المبلغ إلى:" : "Transfer to:",
                style: GoogleFonts.tajawal(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 25),
          _infoRow(bank, Icons.account_balance),
          const SizedBox(height: 8),
          _infoRow(name, Icons.person),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  number,
                  style: GoogleFonts.sourceCodePro(
                      color: accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: number));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("تم نسخ الرقم"),
                        duration: Duration(seconds: 1)));
                  },
                  child: const Icon(Icons.copy, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 10),
        Text(text,
            style: GoogleFonts.tajawal(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildInputFields(LanguageProvider lang) {
    return Column(
      children: [
        _customTextField(
          controller: _targetNameController,
          label: isSdgToRwf
              ? "اسم حساب المستلم (MoMo)"
              : "اسم حساب المستلم (بنكك)",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 15),
        _customTextField(
          controller: _targetNumberController,
          label: isSdgToRwf ? "رقم هاتف المستلم" : "رقم حساب المستلم",
          icon: Icons.phone_android,
          keyboardType: TextInputType.number,
        ),
        if (!isSdgToRwf) ...[
          const SizedBox(height: 15),
          _customTextField(
            controller: _senderNameController,
            label: "اسم حسابك المرسل (MoMo)",
            icon: Icons.send_outlined,
          ),
        ],
      ],
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? "هذا الحقل مطلوب" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }

  Widget _buildUploadSection(LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.isArabic ? "إيصال التحويل:" : "Receipt:",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                builder: (_) => SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text("المعرض"),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              }),
                          ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("الكاميرا"),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              }),
                        ],
                      ),
                    ));
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color:
                      receiptImage != null ? Colors.green : Colors.grey[300]!,
                  width: 2,
                  style: BorderStyle.solid),
            ),
            child: receiptImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(receiptImage!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          size: 40, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        lang.isArabic
                            ? "اضغط لرفع صورة الإيصال"
                            : "Tap to upload receipt",
                        style: GoogleFonts.tajawal(color: Colors.grey),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
