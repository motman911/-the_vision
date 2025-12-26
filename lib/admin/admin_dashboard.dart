// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد صفحات التبويبات (تأكد أن هذه الملفات موجودة)
import 'admin_orders_page.dart'; // صفحة الطلبات
import 'admin_exchange_page.dart'; // صفحة الصرافة
import 'admin_management_page.dart'; // صفحة الإدارة

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // قائمة الصفحات التي يتنقل بينها الأدمن
  final List<Widget> _adminPages = [
    const AdminOrdersPage(),
    const AdminExchangePage(),
    const AdminManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _getPageTitle(_selectedIndex),
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _adminPages[_selectedIndex], // عرض الصفحة المختارة
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.tajawal(),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'الطلبات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              activeIcon: Icon(Icons.currency_exchange),
              label: 'الصرافة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security_outlined),
              activeIcon: Icon(Icons.security),
              label: 'الإدارة',
            ),
          ],
        ),
      ),
    );
  }

  // دالة لتغيير عنوان الصفحة حسب التبويب
  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'إدارة طلبات المعادلة';
      case 1:
        return 'طلبات التحويل المالي';
      case 2:
        return 'إدارة المشرفين';
      default:
        return 'لوحة التحكم';
    }
  }
}
