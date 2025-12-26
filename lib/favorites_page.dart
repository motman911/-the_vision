// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';
import 'data/universities_data.dart';
import 'universities_page.dart'; // لاستخدام UniversityCard
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<FavoritesProvider, ThemeProvider, LanguageProvider>(
      builder:
          (context, favoritesProvider, themeProvider, languageProvider, child) {
        // 1. جلب قائمة الجامعات الكاملة بناءً على الـ IDs المحفوظة في المفضلة
        final favoriteUniversities = UniversitiesData.allUniversities
            .where((uni) => favoritesProvider.isFavorite(uni.id))
            .toList();

        return Scaffold(
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          // ❌ تم إزالة AppBar من هنا لأنه موجود في HomeScreen

          body: favoriteUniversities.isEmpty
              ? _buildEmptyState(context, themeProvider, languageProvider)
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: favoriteUniversities.length,
                  itemBuilder: (context, index) {
                    final uni = favoriteUniversities[index];

                    // ✅ ميزة السحب للحذف (Dismissible)
                    return Dismissible(
                      key: Key(uni.id),
                      direction:
                          DismissDirection.endToStart, // السحب لليسار للحذف
                      background: _buildDismissBackground(),
                      onDismissed: (direction) {
                        // 1. الحذف من البروفايدر
                        favoritesProvider.toggleFavorite(uni.id);

                        // 2. إظهار رسالة مع زر تراجع
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              languageProvider.isArabic
                                  ? 'تم حذف ${uni.getName(true)}'
                                  : '${uni.getName(false)} removed',
                            ),
                            action: SnackBarAction(
                              label:
                                  languageProvider.isArabic ? 'تراجع' : 'Undo',
                              textColor: Colors.white,
                              onPressed: () {
                                // إعادة الإضافة في حال التراجع
                                favoritesProvider.toggleFavorite(uni.id);
                              },
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: UniversityCard(
                        uniModel: uni,
                        themeProvider: themeProvider,
                        languageProvider: languageProvider,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // خلفية حمراء تظهر عند السحب
  Widget _buildDismissBackground() {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 24), // نفس هامش الكرت ليكون متطابقاً
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
    );
  }

  // تصميم الشاشة الفارغة (عندما لا توجد مفضلة)
  Widget _buildEmptyState(
      BuildContext context, ThemeProvider theme, LanguageProvider lang) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border,
                  size: 70, color: theme.primaryColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              lang.isArabic ? 'لا توجد جامعات مفضلة' : 'No favorites yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              lang.isArabic
                  ? 'تصفح الجامعات واضغط على القلب ❤️ لحفظها هنا.'
                  : 'Browse universities and tap ❤️ to save them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.subTextColor, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            // لاحظ: زر التصفح هنا قد لا ينقلك للتبويب الآخر تلقائياً إلا باستخدام Controller
            // لذا يمكن جعله يظهر رسالة توجيهية أو محاولة الانتقال
            ElevatedButton.icon(
              onPressed: () {
                // بما أننا في Tab، الأفضل ترك المستخدم يضغط على تبويب "الجامعات" بالأسفل
                // أو يمكننا استخدام PushReplacement كحل مؤقت
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UniversitiesPage()),
                );
              },
              icon: const Icon(Icons.search),
              label:
                  Text(lang.isArabic ? 'تصفح الجامعات' : 'Browse Universities'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
