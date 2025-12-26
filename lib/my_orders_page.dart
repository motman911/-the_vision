// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ ضروري لفتح الإشعارات والملفات

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'auth_screen.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    // 1. واجهة الزائر (إذا لم يسجل الدخول)
    bool isGuest = user == null || user.isAnonymous;
    if (isGuest) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            lang.isArabic ? 'متابعة طلباتي' : 'Track My Requests',
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: theme.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(lang.isArabic
                ? Icons.arrow_back_ios
                : Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildGuestView(context, theme, lang),
      );
    }

    // 2. واجهة المستخدم المسجل
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            lang.isArabic ? 'متابعة طلباتي' : 'Track My Requests',
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: theme.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(lang.isArabic
                ? Icons.arrow_back_ios
                : Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle:
                GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: lang.isArabic ? "المعادلات" : "Equivalences"),
              Tab(text: lang.isArabic ? "العملات" : "Exchange"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrdersList(
                collection: 'equivalence_requests',
                userId: user.uid,
                isExchange: false,
                theme: theme,
                lang: lang),
            _OrdersList(
                collection: 'exchange_requests',
                userId: user.uid,
                isExchange: true,
                theme: theme,
                lang: lang),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(
      BuildContext context, ThemeProvider theme, LanguageProvider lang) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_person_outlined,
                size: 80, color: theme.primaryColor.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text(
                lang.isArabic ? 'أنت تتصفح كزائر' : 'You are browsing as Guest',
                style: GoogleFonts.tajawal(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
                lang.isArabic
                    ? 'يرجى تسجيل الدخول لمتابعة طلباتك.'
                    : 'Please login to track requests.',
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(color: theme.subTextColor)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false),
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text(lang.isArabic ? 'تسجيل الدخول الآن' : 'Login Now',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final String collection;
  final String userId;
  final bool isExchange;
  final ThemeProvider theme;
  final LanguageProvider lang;

  const _OrdersList(
      {required this.collection,
      required this.userId,
      required this.isExchange,
      required this.theme,
      required this.lang});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(lang.isArabic
                  ? 'خطأ في جلب البيانات'
                  : 'Error fetching data'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(theme, lang);
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            var data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return _buildOrderCard(context, data, theme, lang);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> data,
      ThemeProvider theme, LanguageProvider lang) {
    int statusCode = 1;
    String statusText = "";
    Color statusColor = Colors.orange;
    String title = "";
    String subtitle = "";

    // معالجة البيانات بناءً على النوع (عملات أو معادلات)
    if (isExchange) {
      String statusStr = data['status'] ?? 'pending';
      if (statusStr == 'approved') {
        statusCode = 3;
        statusText = lang.isArabic ? "مكتمل" : "Approved";
        statusColor = Colors.green;
      } else if (statusStr == 'rejected') {
        statusCode = 0;
        statusText = lang.isArabic ? "مرفوض" : "Rejected";
        statusColor = Colors.red;
      } else {
        statusCode = 1;
        statusText = lang.isArabic ? "قيد المراجعة" : "Pending";
        statusColor = Colors.orange;
      }

      title = data['type'] == 'SDG_TO_RWF'
          ? "🇸🇩 SDG ➔ RWF 🇷🇼"
          : "🇷🇼 RWF ➔ SDG 🇸🇩";
      subtitle = "${data['inputAmount'] ?? 0} ➔ ${data['outputAmount'] ?? 0}";
    } else {
      statusCode = (data['status'] is int)
          ? data['status']
          : int.tryParse(data['status'].toString()) ?? 1;
      if (statusCode == 3) {
        statusText = lang.isArabic ? "مكتمل" : "Completed";
        statusColor = Colors.green;
      } else if (statusCode == 0) {
        statusText = lang.isArabic ? "مرفوض" : "Rejected";
        statusColor = Colors.red;
      } else if (statusCode == 2) {
        statusText = lang.isArabic ? "جاري العمل" : "Processing";
        statusColor = Colors.blue;
      } else {
        statusText = lang.isArabic ? "انتظار" : "Pending";
        statusColor = Colors.orange;
      }

      title = lang.isArabic ? "طلب معادلة شهادة" : "Equivalence Request";
      subtitle = data['studentName'] ?? "";
    }

    String dateStr = '';
    if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
      dateStr = DateFormat('dd MMM, hh:mm a', lang.isArabic ? 'ar' : 'en')
          .format(data['createdAt'].toDate());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontSize: 13)),
              _statusBadge(statusText, statusColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle,
              style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor)),
          const Divider(height: 25),

          // ✅ الجزء الجديد: عرض الملف المرفوع من الأدمن عند الاكتمال
          if (statusCode == 3) _buildDownloadSection(data, lang),

          if (statusCode == 0 && data['rejectionReason'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                  "${lang.isArabic ? 'السبب' : 'Reason'}: ${data['rejectionReason']}",
                  style: GoogleFonts.tajawal(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(dateStr,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ ويدجت عرض روابط التحميل (إشعار الأدمن)
  Widget _buildDownloadSection(
      Map<String, dynamic> data, LanguageProvider lang) {
    // تحديد الرابط بناءً على نوع الطلب
    String? url =
        isExchange ? data['adminReceiptUrl'] : data['finalEquivalenceUrl'];

    if (url == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.2))),
      child: Column(
        children: [
          Text(
              lang.isArabic
                  ? "تم إكمال طلبك بنجاح! يمكنك تحميل النتيجة من هنا:"
                  : "Request completed! Download your result:",
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800])),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: Icon(isExchange ? Icons.image : Icons.picture_as_pdf,
                color: Colors.white),
            label: Text(
                lang.isArabic ? "عرض / تحميل الإشعار" : "View / Download",
                style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState(ThemeProvider theme, LanguageProvider lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(lang.isArabic ? "لا توجد طلبات حالياً" : "No requests found",
              style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}
