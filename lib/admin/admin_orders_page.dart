// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_order_details.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _startDate;
  DateTime? _endDate;

  // الألوان
  final Color primaryColor = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // اختيار التاريخ
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate =
            picked.end.add(const Duration(hours: 23, minutes: 59, seconds: 59));
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("يرجى تسجيل الدخول")));
    }

    // 1️⃣ فحص الصلاحيات لحظياً
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // إعداد متغيرات التحقق
        String currentAuthEmail = user.email?.trim().toLowerCase() ?? '';
        String superAdminEmail = "motman911@gmail.com".trim().toLowerCase();
        bool isSuperAdmin = currentAuthEmail == superAdminEmail;
        bool hasEquivalencePerm = false;

        // جلب الصلاحيات من الداتابيز لو الملف موجود
        if (snapshot.hasData && snapshot.data!.exists) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          if (userData['permissions'] != null) {
            hasEquivalencePerm = userData['permissions']['equivalence'] == true;
          }
        }

        // ✅ الشرط: السوبر أدمن يدخل دائماً، أو الأدمن العادي بصلاحية المعادلات
        bool hasAccess = isSuperAdmin || hasEquivalencePerm;

        // 🛑 شاشة المنع
        if (!hasAccess) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_person, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    "عذراً، لا تملك صلاحية إدارة المعادلات",
                    style: GoogleFonts.tajawal(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ الشاشة الرئيسية (مسموح بالدخول)
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          appBar: AppBar(
            title: Text(
              'إدارة المعادلات',
              style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: _startDate != null
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _startDate != null
                        ? Icons.filter_alt_off
                        : Icons.calendar_month,
                    color: _startDate != null ? Colors.blue : Colors.grey[700],
                  ),
                  onPressed: () {
                    if (_startDate != null) {
                      _clearDateFilter();
                    } else {
                      _selectDateRange(context);
                    }
                  },
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: '   الكل   '),
                    Tab(text: '   انتظار   '),
                    Tab(text: '   جاري العمل   '),
                    Tab(text: '   مكتمل   '),
                    Tab(text: '   مرفوض   '),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              if (_startDate != null && _endDate != null)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.blue.withOpacity(0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.filter_list,
                          size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '${DateFormat('yyyy/MM/dd').format(_startDate!)}  ➔  ${DateFormat('yyyy/MM/dd').format(_endDate!)}',
                        style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _OrdersList(
                        statusFilter: null,
                        startDate: _startDate,
                        endDate: _endDate),
                    _OrdersList(
                        statusFilter: 1,
                        startDate: _startDate,
                        endDate: _endDate),
                    _OrdersList(
                        statusFilter: 2,
                        startDate: _startDate,
                        endDate: _endDate),
                    _OrdersList(
                        statusFilter: 3,
                        startDate: _startDate,
                        endDate: _endDate),
                    _OrdersList(
                        statusFilter: 0,
                        startDate: _startDate,
                        endDate: _endDate),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrdersList extends StatelessWidget {
  final int? statusFilter;
  final DateTime? startDate;
  final DateTime? endDate;

  const _OrdersList({
    this.statusFilter,
    this.startDate,
    this.endDate,
  });

  String _getSimpleDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) return 'اليوم';
    if (dateToCheck == yesterday) return 'أمس';
    return DateFormat('yyyy/MM/dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('equivalence_requests')
        .orderBy('createdAt', descending: true);

    if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter);
    }

    if (startDate != null && endDate != null) {
      query = query
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 50),
                const SizedBox(height: 10),
                Text("تأكد من إنشاء Index في Firebase",
                    style: GoogleFonts.tajawal()),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 15),
                Text(
                  'لا توجد طلبات',
                  style: GoogleFonts.tajawal(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var doc = docs[index];
            var data = doc.data() as Map<String, dynamic>;

            DateTime? currentDate;
            if (data['createdAt'] != null) {
              currentDate = (data['createdAt'] as Timestamp).toDate();
            }

            bool showHeader = false;
            if (index == 0) {
              showHeader = true;
            } else {
              var prevDoc = docs[index - 1];
              var prevData = prevDoc.data() as Map<String, dynamic>;
              DateTime? prevDate;
              if (prevData['createdAt'] != null) {
                prevDate = (prevData['createdAt'] as Timestamp).toDate();
              }

              if (currentDate != null && prevDate != null) {
                if (_getSimpleDateHeader(currentDate) !=
                    _getSimpleDateHeader(prevDate)) {
                  showHeader = true;
                }
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader && currentDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          _getSimpleDateHeader(currentDate),
                          style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                  ),
                _buildOrderCard(context, doc.id, data),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOrderCard(
      BuildContext context, String docId, Map<String, dynamic> data) {
    int status = data['status'] is int ? data['status'] : 1;

    Color statusColor;
    String statusText;

    switch (status) {
      case 1:
        statusColor = Colors.orange;
        statusText = "انتظار";
        break;
      case 2:
        statusColor = Colors.blue;
        statusText = "جاري العمل";
        break;
      case 3:
        statusColor = Colors.green;
        statusText = "مكتمل";
        break;
      case 0:
        statusColor = Colors.red;
        statusText = "مرفوض";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "غير معروف";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdminOrderDetails(requestId: docId, data: data),
              ),
            );
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                // الشريط الجانبي الملون
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // ✅ التعديل هنا: منع خروج الاسم من الكونتينر
                            Expanded(
                              child: Text(
                                data['studentName'] ?? 'مجهول',
                                style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                maxLines: 1, // حد أقصى سطر واحد
                                overflow: TextOverflow
                                    .ellipsis, // وضع نقاط (...) لو الكلام كتير
                              ),
                            ),
                            const SizedBox(width: 8),
                            // حالة الطلب
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: GoogleFonts.tajawal(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.payment,
                                size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            // منع خروج طريقة الدفع أيضاً
                            Expanded(
                              child: Text(
                                '${data['payment'] != null ? data['payment']['method'] : "غير محدد"}',
                                style: GoogleFonts.tajawal(
                                    fontSize: 12, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (data['createdAt'] != null)
                              Text(
                                DateFormat('hh:mm a').format(
                                    (data['createdAt'] as Timestamp).toDate()),
                                style: GoogleFonts.tajawal(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w500),
                              ),
                          ],
                        ),
                      ],
                    ),
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
