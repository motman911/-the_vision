// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrderDetails extends StatefulWidget {
  final String requestId;
  final Map<String, dynamic> data;

  const AdminOrderDetails({
    super.key,
    required this.requestId,
    required this.data,
  });

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  bool _isLoading = false;

  // الألوان الأساسية للتصميم
  final Color primaryColor = const Color(0xFF1E293B); // Slate 800
  final Color cardColor = Colors.white;
  final Color bgColor = const Color(0xFFF1F5F9); // Slate 100

  // 🔔 التحقق من التوكن (لغرض اللوج)
  Future<void> _checkNotificationToken(String statusTitle) async {
    try {
      final String? userId = widget.data['userId'];
      if (userId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final String? fcmToken = userDoc.data()?['fcmToken'];

      if (fcmToken != null) {
        print("🔔 (Client Log) جاهز للإشعار: $statusTitle");
      }
    } catch (e) {
      print("⚠️ خطأ في التحقق من التوكن: $e");
    }
  }

  // --- 1. دالة الرفض ---
  Future<void> _rejectOrder() async {
    final reasonController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 10),
            Text('رفض الطلب',
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('يرجى ذكر سبب الرفض بوضوح:', style: GoogleFonts.tajawal()),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: 'مثال: الصورة غير واضحة، الاسم غير مطابق...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يجب كتابة سبب الرفض!')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: Text('تأكيد الرفض',
                style: GoogleFonts.tajawal(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _updateStatus(0, rejectionReason: reasonController.text.trim());
    }
  }

  // --- 2. دالة القبول (ورفع الملف) ---
  Future<void> _completeOrder() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
              Text('تأكيد الإكمال',
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'سيتم رفع ملف المعادلة (PDF) وإرسال إشعار فوري للطالب بأن طلبه قد اكتمل.',
            style: GoogleFonts.tajawal(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('إلغاء', style: GoogleFonts.tajawal()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () => Navigator.pop(context, true),
              child: Text('رفع وإكمال',
                  style: GoogleFonts.tajawal(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() => _isLoading = true);
        try {
          String fileName = 'equivalence_${widget.requestId}.pdf';
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('completed_equivalences/$fileName');

          UploadTask uploadTask = ref.putFile(file);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          await _updateStatus(3, finalFileUrl: downloadUrl);
        } catch (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('فشل الرفع: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // --- دالة التحديث العامة ---
  Future<void> _updateStatus(int newStatus,
      {String? rejectionReason, String? finalFileUrl}) async {
    setState(() => _isLoading = true);
    try {
      Map<String, dynamic> updates = {
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      String notifyTitle = "";

      if (newStatus == 0) {
        updates['rejectionReason'] = rejectionReason;
        notifyTitle = "تنبيه: تم رفض طلبك ⚠️";
      } else if (newStatus == 2) {
        notifyTitle = "جاري المعالجة ⚙️";
      } else if (newStatus == 3) {
        updates['finalEquivalenceUrl'] = finalFileUrl;
        notifyTitle = "مبارك! اكتمل طلبك ✅";
      }

      await FirebaseFirestore.instance
          .collection('equivalence_requests')
          .doc(widget.requestId)
          .update(updates);

      _checkNotificationToken(notifyTitle);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الحالة وإشعار الطالب بنجاح ✅'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // فتح الواتساب
  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final url = 'https://wa.me/$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  // فتح عارض الصور الداخلي
  void _openImageViewer(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var d = widget.data;
    var docs = d['documents'] ?? {};
    var pay = d['payment'] ?? {};

    // تحديد حالة الطلب الحالية للعرض
    int currentStatus = d['status'] ?? 1;
    String statusText = "";
    Color statusColor = Colors.grey;
    if (currentStatus == 1) {
      statusText = "قيد الانتظار";
      statusColor = Colors.orange;
    } else if (currentStatus == 2) {
      statusText = "قيد المراجعة";
      statusColor = Colors.blue;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'تفاصيل الطلب',
          style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شريط الحالة
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: statusColor),
                        const SizedBox(width: 10),
                        Text(
                          "حالة الطلب الحالية: $statusText",
                          style: GoogleFonts.tajawal(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 1. بطاقة الطالب
                  _buildCard(
                    title: 'معلومات الطالب',
                    icon: Icons.person,
                    children: [
                      _buildInfoRow(
                          Icons.person_outline, 'اسم الطالب', d['studentName']),
                      _buildInfoRow(
                          Icons.family_restroom, 'اسم الأم', d['motherName']),
                      _buildInfoRow(Icons.email_outlined, 'البريد', d['email']),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.phone_android,
                            color: Colors.green),
                        title: Text(
                          d['whatsapp'] ?? "غير متوفر",
                          style:
                              GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          icon: const Icon(Icons.chat,
                              size: 18, color: Colors.white),
                          label: Text("واتساب",
                              style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () => _openWhatsApp(d['whatsapp']),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 2. بطاقة الدفع
                  _buildCard(
                    title: 'بيانات الدفع',
                    icon: Icons.payments_outlined,
                    children: [
                      _buildInfoRow(
                          Icons.credit_card, 'الطريقة', pay['method']),
                      _buildInfoRow(Icons.receipt_long, 'معرف المعاملة',
                          pay['transactionInfo']),
                      const SizedBox(height: 10),
                      Text("صورة الإيصال:",
                          style: GoogleFonts.tajawal(
                              fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 5),
                      _buildImageThumbnail(pay['receiptUrl']),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 3. بطاقة المستندات
                  _buildCard(
                    title: 'المستندات المرفقة',
                    icon: Icons.folder_open,
                    children: [
                      Text("جواز السفر:",
                          style: GoogleFonts.tajawal(
                              fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 5),
                      _buildImageThumbnail(docs['passportUrl']),
                      const SizedBox(height: 15),
                      if (docs['certificateFrontUrl'] != null) ...[
                        Text("الشهادة:",
                            style: GoogleFonts.tajawal(
                                fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 5),
                        _buildImageThumbnail(docs['certificateFrontUrl']),
                      ],
                    ],
                  ),

                  const SizedBox(height: 30),

                  // منطقة الإجراءات
                  Text(
                    'الإجراءات الإدارية:',
                    style: GoogleFonts.tajawal(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: 'قيد المراجعة',
                          icon: Icons.plumbing, // أيقونة معبرة عن العمل
                          color: Colors.blue,
                          onPressed: () => _updateStatus(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionButton(
                          label: 'إكمال ورفع',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                          onPressed: _completeOrder,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: _buildActionButton(
                      label: 'رفض الطلب',
                      icon: Icons.cancel_outlined,
                      color: Colors.red,
                      onPressed: _rejectOrder,
                      isOutlined: true, // تصميم مختلف للرفض
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  // --- Widgets مساعدة ---

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[400]),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(label,
                style:
                    GoogleFonts.tajawal(color: Colors.grey[600], fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value ?? '---',
              style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(String? url) {
    if (url == null) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Center(
            child:
                Text('لا توجد صورة', style: GoogleFonts.tajawal(fontSize: 12))),
      );
    }

    return GestureDetector(
      onTap: () => _openImageViewer(url),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.zoom_in, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.white : color,
        foregroundColor: isOutlined ? color : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: isOutlined ? BorderSide(color: color) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isOutlined ? 0 : 4,
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    );
  }
}
