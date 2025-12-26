// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class AdminExchangePage extends StatefulWidget {
  const AdminExchangePage({super.key});

  @override
  State<AdminExchangePage> createState() => _AdminExchangePageState();
}

class _AdminExchangePageState extends State<AdminExchangePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  String _selectedFilter = 'all';

  // الألوان الأساسية
  final Color primaryColor = const Color(0xFF10B981); // Emerald Green
  final Color bgColor = const Color(0xFFF8FAFC); // Slate 50

  // --- منطق المعالجة (نفس المنطق السابق مع تحسينات بسيطة) ---

  Future<void> _approveWithReceipt(String docId) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: Text("اختيار من المعرض", style: GoogleFonts.tajawal()),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.purple),
              title: Text("تصوير بالكاميرا", style: GoogleFonts.tajawal()),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? pickedFile =
        await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile == null) return;

    setState(() => _isProcessing = true);

    try {
      File file = File(pickedFile.path);
      String fileName =
          'payout_${docId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('admin_payout_receipts/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('exchange_requests')
          .doc(docId)
          .update({
        'status': 'approved',
        'adminReceiptUrl': downloadUrl,
        'processedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("تم تأكيد التحويل وإرسال الإيصال ✅"),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("حدث خطأ: $e"), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _updateStatus(String docId, String newStatus,
      {String? reason}) async {
    Map<String, dynamic> data = {'status': newStatus};
    if (reason != null) data['rejectionReason'] = reason;
    await FirebaseFirestore.instance
        .collection('exchange_requests')
        .doc(docId)
        .update(data);
  }

  void _showRejectDialog(String docId) {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("سبب الرفض",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: "مثال: الإيصال غير واضح، المبلغ ناقص...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("إلغاء", style: GoogleFonts.tajawal())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                _updateStatus(docId, 'rejected', reason: reasonController.text);
                Navigator.pop(ctx);
              }
            },
            child: Text("تأكيد الرفض",
                style: GoogleFonts.tajawal(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openImage(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.black,
                      leading: const BackButton(color: Colors.white)),
                  backgroundColor: Colors.black,
                  body: Center(
                      child: InteractiveViewer(
                          child: CachedNetworkImage(
                              imageUrl: url,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator()))),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("طلبات الصرافة",
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Stack(
              children: [
                _buildRequestsStream(),
                if (_isProcessing)
                  Container(
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildFilterTab("الكل", 'all'),
          const SizedBox(width: 10),
          _buildFilterTab("قيد الانتظار", 'pending'),
          const SizedBox(width: 10),
          _buildFilterTab("المكتملة", 'approved'),
          const SizedBox(width: 10),
          _buildFilterTab("المرفوضة", 'rejected'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    bool isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.tajawal(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsStream() {
    Query query = FirebaseFirestore.instance
        .collection('exchange_requests')
        .orderBy('createdAt', descending: true);

    if (_selectedFilter != 'all') {
      query = query.where('status', isEqualTo: _selectedFilter);
    }

    return StreamBuilder<QuerySnapshot>(
      key: ValueKey(_selectedFilter),
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.currency_exchange,
                    size: 80, color: Colors.grey[300]),
                const SizedBox(height: 15),
                Text("لا توجد طلبات هنا",
                    style: GoogleFonts.tajawal(
                        fontSize: 18, color: Colors.grey[500])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildRequestCard(doc.id, data);
          },
        );
      },
    );
  }

  Widget _buildRequestCard(String docId, Map<String, dynamic> data) {
    final String status = data['status'] ?? 'pending';
    final bool isSdgToRwf = data['type'] == 'SDG_TO_RWF';

    // تحديد الألوان حسب الحالة
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        statusText = "مكتمل";
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = "مرفوض";
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusText = "قيد المراجعة";
        statusIcon = Icons.hourglass_top;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date & Status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['createdAt'] != null
                      ? DateFormat('dd MMM yyyy, hh:mm a')
                          .format((data['createdAt'] as Timestamp).toDate())
                      : '...',
                  style: GoogleFonts.tajawal(
                      color: Colors.grey[500], fontSize: 12),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 5),
                      Text(statusText,
                          style: GoogleFonts.tajawal(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main Content: Amount & Direction
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSdgToRwf
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSdgToRwf ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isSdgToRwf ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSdgToRwf
                            ? "تحويل من السودان 🇸🇩 إلى رواندا 🇷🇼"
                            : "تحويل من رواندا 🇷🇼 إلى السودان 🇸🇩",
                        style: GoogleFonts.tajawal(
                            color: Colors.grey[700], fontSize: 13),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.tajawal(color: Colors.black87),
                          children: [
                            TextSpan(
                                text: "${data['inputAmount']} ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: "➔ "),
                            TextSpan(
                                text:
                                    "${data['outputAmount'].toStringAsFixed(1)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: primaryColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Client Info Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.person_outline, "المستلم",
                      data['targetAccountName']),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider()),
                  _infoRow(Icons.account_balance_wallet_outlined, "رقم الحساب",
                      data['targetAccountNumber'],
                      isCopyable: true),
                  if (data['senderName'] != null) ...[
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider()),
                    _infoRow(
                        Icons.send_outlined, "اسم المرسل", data['senderName']),
                  ]
                ],
              ),
            ),
          ),

          // Receipt & Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("إيصال العميل:",
                    style: GoogleFonts.tajawal(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildReceiptThumbnail(data['receiptUrl']),

                // أزرار التحكم (تظهر فقط إذا كان قيد الانتظار)
                if (status == 'pending') ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _approveWithReceipt(docId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: Text("قبول وإرسال إيصال",
                              style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _showRejectDialog(docId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],

                // عرض إيصال الأدمن (للمكتمل)
                if (status == 'approved' &&
                    data['adminReceiptUrl'] != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text("تم إرسال إيصال التحويل للعميل",
                                style: GoogleFonts.tajawal(
                                    color: Colors.green[800], fontSize: 12))),
                        GestureDetector(
                          onTap: () => _openImage(data['adminReceiptUrl']),
                          child: const Icon(Icons.visibility,
                              color: Colors.green, size: 20),
                        )
                      ],
                    ),
                  )
                ],

                // سبب الرفض
                if (status == 'rejected' &&
                    data['rejectionReason'] != null) ...[
                  const SizedBox(height: 20),
                  Text("سبب الرفض: ${data['rejectionReason']}",
                      style: GoogleFonts.tajawal(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {bool isCopyable = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(width: 10),
        Text(label,
            style: GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 13)),
        const Spacer(),
        isCopyable
            ? SelectableText(
                value,
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 14),
              )
            : Text(
                value,
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 14),
              ),
        if (isCopyable) ...[
          const SizedBox(width: 5),
          Icon(Icons.copy, size: 14, color: primaryColor.withOpacity(0.5)),
        ]
      ],
    );
  }

  Widget _buildReceiptThumbnail(String? url) {
    if (url == null)
      return Text("لا يوجد صورة",
          style: GoogleFonts.tajawal(color: Colors.grey));

    return GestureDetector(
      onTap: () => _openImage(url),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          image: DecorationImage(
            image: CachedNetworkImageProvider(url),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.zoom_in, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
