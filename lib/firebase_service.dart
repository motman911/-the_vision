import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. دالة لرفع ملف واحد والحصول على الرابط
  Future<String?> uploadFile(File file, String folderName) async {
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      Reference ref = _storage.ref().child('$folderName/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('❌ Error uploading file: $e');
      return null;
    }
  }

  // 2. دالة إرسال الطلب كاملاً
  Future<void> submitEquivalenceRequest({
    required String studentName,
    required String motherName,
    required String whatsapp,
    required String paymentMethod,
    required String transactionInfo,
    required File passport,
    required File paymentScreenshot,
    File? certificatePdf,
    File? certificateFront,
    File? certificateBack,
  }) async {
    // الحصول على معرف المستخدم الحالي (أو زائر)
    User? user = _auth.currentUser;
    String userId = user?.uid ?? 'guest_user';

    // أ. رفع الملفات أولاً
    String? passportUrl = await uploadFile(passport, 'passports');
    String? paymentUrl = await uploadFile(paymentScreenshot, 'payments');

    String? certPdfUrl;
    if (certificatePdf != null) {
      certPdfUrl = await uploadFile(certificatePdf, 'certificates_pdf');
    }

    String? certFrontUrl;
    if (certificateFront != null) {
      certFrontUrl = await uploadFile(certificateFront, 'certificates_img');
    }

    String? certBackUrl;
    if (certificateBack != null) {
      certBackUrl = await uploadFile(certificateBack, 'certificates_img');
    }

    // ب. تجهيز البيانات
    Map<String, dynamic> requestData = {
      'userId': userId,
      'userEmail': user?.email ?? 'Guest',
      'studentName': studentName,
      'motherName': motherName,
      'whatsapp': whatsapp,
      'status': 1, // 1: جاري التحقق من الدفع
      'createdAt': FieldValue.serverTimestamp(),
      'payment': {
        'method': paymentMethod,
        'transactionInfo': transactionInfo,
        'receiptUrl': paymentUrl,
      },
      'documents': {
        'passportUrl': passportUrl,
        'certificatePdfUrl': certPdfUrl,
        'certificateFrontUrl': certFrontUrl,
        'certificateBackUrl': certBackUrl,
      },
    };

    // ج. الحفظ في قاعدة البيانات
    await _firestore.collection('equivalence_requests').add(requestData);
  }
}
