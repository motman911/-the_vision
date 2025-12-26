// ignore_for_file: use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  bool _canManageEquivalence = false;
  bool _canManageExchange = false;

  // --- الألوان والثيم ---
  final Color primaryColor = const Color(0xFF2563EB); // أزرق عصري
  final Color backgroundColor = const Color(0xFFF3F4F6); // رمادي فاتح جداً

  // ✅ منطق الترقية
  Future<void> _promoteUser() async {
    String inputEmail = _emailController.text.trim().toLowerCase();

    if (inputEmail.isEmpty) {
      _showMsg('يرجى إدخال البريد الإلكتروني', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: inputEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showMsg('هذا البريد غير مسجل في النظام', Colors.redAccent);
      } else {
        await _updateUserRole(querySnapshot.docs.first.id);
      }
    } catch (e) {
      _showMsg('حدث خطأ: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserRole(String docId) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).update({
      'role': 'admin',
      'permissions': {
        'equivalence': _canManageEquivalence,
        'exchange': _canManageExchange,
      }
    });
    _showMsg('تمت ترقية العضو لمشرف بنجاح 🎉', Colors.green);
    _emailController.clear();
    setState(() {
      _canManageEquivalence = false;
      _canManageExchange = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
                child: Text(msg,
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
        elevation: 4,
      ),
    );
  }

  Future<void> _confirmRemoveAdmin(String docId, String email) async {
    bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 28),
                const SizedBox(width: 10),
                Text("سحب الصلاحيات",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
                "هل أنت متأكد من إزالة صلاحيات المشرف عن:\n$email؟\n\nسيعود المستخدم لرتبة عضو عادي.",
                style: GoogleFonts.tajawal(height: 1.5)),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text("إلغاء",
                      style: GoogleFonts.tajawal(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text("نعم، سحب الصلاحيات",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'role': 'user',
        'permissions': FieldValue.delete(),
      });
      _showMsg('تم سحب الصلاحيات بنجاح', Colors.black87);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("إدارة المشرفين",
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("إضافة مشرف جديد", Icons.person_add_alt),
            const SizedBox(height: 15),
            _buildAddAdminCard(),
            const SizedBox(height: 35),
            _buildHeader(
                "المشرفون الحاليون", Icons.admin_panel_settings_outlined),
            const SizedBox(height: 15),
            _buildAdminsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 22),
        const SizedBox(width: 8),
        Text(title,
            style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blueGrey[800])),
      ],
    );
  }

  Widget _buildAddAdminCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            style: GoogleFonts.tajawal(),
            decoration: InputDecoration(
              labelText: "البريد الإلكتروني للمستخدم",
              labelStyle: GoogleFonts.tajawal(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 1.5)),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildPermissionSwitch(
                    "إدارة المعادلات",
                    "السماح بقبول ورفض طلبات المعادلة",
                    _canManageEquivalence,
                    (v) => setState(() => _canManageEquivalence = v)),
                Divider(
                    height: 1,
                    color: Colors.grey[200],
                    indent: 20,
                    endIndent: 20),
                _buildPermissionSwitch(
                    "إدارة الصرافة",
                    "السماح بمعالجة طلبات التحويل المالي",
                    _canManageExchange,
                    (v) => setState(() => _canManageExchange = v)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _promoteUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                shadowColor: primaryColor.withOpacity(0.4),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text("ترقية إلى مشرف",
                      style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionSwitch(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title,
          style: GoogleFonts.tajawal(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87)),
      subtitle: Text(subtitle,
          style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey[600])),
      value: value,
      onChanged: onChanged,
      activeColor: primaryColor,
      activeTrackColor: primaryColor.withOpacity(0.2),
      inactiveThumbColor: Colors.grey[400],
      inactiveTrackColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildAdminsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var admins = snapshot.data?.docs
                .where((doc) => doc['email'] != "motman911@gmail.com")
                .toList() ??
            [];

        if (admins.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 15),
                Text("لا يوجد مشرفين إضافيين",
                    style: GoogleFonts.tajawal(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500)),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: admins.length,
          separatorBuilder: (c, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            var data = admins[index].data() as Map<String, dynamic>;
            var perms = data['permissions'] ?? {};

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[100]!),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  radius: 24,
                  child: Text(
                    (data['email'] as String)[0].toUpperCase(),
                    style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 18),
                  ),
                ),
                title: Text(data['email'],
                    style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (perms['equivalence'] == true)
                        _buildBadge("معادلات", Colors.purple),
                      if (perms['exchange'] == true)
                        _buildBadge("صرافة", Colors.orange),
                      if (perms['equivalence'] != true &&
                          perms['exchange'] != true)
                        _buildBadge("مراقبة فقط", Colors.grey),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.redAccent),
                  onPressed: () =>
                      _confirmRemoveAdmin(admins[index].id, data['email']),
                  tooltip: "سحب الصلاحية",
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(label,
          style: GoogleFonts.tajawal(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
