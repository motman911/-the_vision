import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favoriteIds = []; // ✅ نحفظ المعرفات (IDs) فقط
  static const String _prefsKey = 'favorite_universities_ids';

  FavoritesProvider() {
    _loadFavorites();
  }

  // الحصول على قائمة المعرفات المفضلة
  List<String> get favoriteIds => _favoriteIds;

  // ✅ تحميل القائمة عند فتح التطبيق
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList(_prefsKey) ?? [];
    notifyListeners();
  }

  // ✅ إضافة أو إزالة (Toggle)
  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id); // حذف إذا موجود
    } else {
      _favoriteIds.add(id); // إضافة إذا غير موجود
    }

    // حفظ التغييرات
    await _saveFavorites();
    notifyListeners();
  }

  // ✅ التحقق هل الجامعة مفضلة أم لا
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  // دالة الحفظ الداخلية
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favoriteIds);
  }
}
