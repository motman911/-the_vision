import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  String _orderStatus =
      ''; // القيم: '' (لا يوجد), 'pending', 'verified', 'completed'
  String _orderDate = '';

  OrderProvider() {
    _loadOrder();
  }

  String get orderStatus => _orderStatus;
  String get orderDate => _orderDate;
  bool get hasActiveOrder => _orderStatus.isNotEmpty;

  // تحميل البيانات عند فتح التطبيق
  Future<void> _loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    _orderStatus = prefs.getString('order_status') ?? '';
    _orderDate = prefs.getString('order_date') ?? '';
    notifyListeners();
  }

  // حفظ طلب جديد
  Future<void> saveOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final date = DateTime.now().toString().split(' ')[0]; // التاريخ YYYY-MM-DD

    _orderStatus = 'pending';
    _orderDate = date;

    await prefs.setString('order_status', 'pending');
    await prefs.setString('order_date', date);

    notifyListeners();
  }

  // تحديث الحالة (يمكن استخدامه لاحقاً من لوحة التحكم)
  Future<void> updateStatus(String newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    _orderStatus = newStatus;
    await prefs.setString('order_status', newStatus);
    notifyListeners();
  }

  // حذف الطلب
  Future<void> clearOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('order_status');
    await prefs.remove('order_date');
    _orderStatus = '';
    _orderDate = '';
    notifyListeners();
  }
}
