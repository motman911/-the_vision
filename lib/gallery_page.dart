// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  // الفلتر المختار حالياً
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    // 1. تعريف الفئات
    final List<String> categories = lang.isArabic
        ? ['الكل', 'الجامعات', 'الطبيعة', 'السكن', 'الحياة العامة']
        : ['All', 'Universities', 'Nature', 'Housing', 'Lifestyle'];

    // 2. تعريف الصور مع تصنيفاتها (بيانات تجريبية)
    final List<Map<String, dynamic>> allImages = [
      {'path': 'assets/images/ULK_P3.jpg', 'cat': 1}, // الجامعات
      {'path': 'assets/images/In_Rwanda_1.jpg', 'cat': 2}, // الطبيعة
      {'path': 'assets/images/In_Rwanda_2.jpg', 'cat': 4}, // الحياة العامة
      {'path': 'assets/images/UR_P1.jpg', 'cat': 1}, // الجامعات
      {'path': 'assets/images/In_Rwanda_3.jpg', 'cat': 3}, // السكن
      {'path': 'assets/images/In_Rwanda_4.jpg', 'cat': 2}, // الطبيعة
      {'path': 'assets/images/MKU_P4.jpg', 'cat': 1}, // الجامعات
      {'path': 'assets/images/In_Rwanda_5.jpg', 'cat': 4}, // الحياة العامة
      {'path': 'assets/images/In_Rwanda_6.jpg', 'cat': 2}, // الطبيعة
      {'path': 'assets/images/UoK_P1.jpg', 'cat': 1}, // الجامعات
    ];

    // 3. تصفية الصور حسب الفئة المختارة
    final displayImages = _selectedIndex == 0
        ? allImages
        : allImages.where((img) => img['cat'] == _selectedIndex).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(lang.gallery),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            lang.isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // شريط الفئات (Filters)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primaryColor : theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? theme.primaryColor
                            : Colors.grey.withOpacity(0.2),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : theme.textColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // شبكة الصور
          Expanded(
            child: displayImages.isEmpty
                ? Center(
                    child: Text(
                      lang.isArabic
                          ? 'لا توجد صور في هذا القسم'
                          : 'No images found',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85, // جعل الصور أطول قليلاً
                    ),
                    itemCount: displayImages.length,
                    itemBuilder: (context, index) {
                      final imagePath = displayImages[index]['path'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenGallery(
                                images: displayImages
                                    .map((e) => e['path'] as String)
                                    .toList(),
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: imagePath, // استخدام المسار كـ Tag لضمان التميز
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor
                                      .withOpacity(0.15), // ظل ملون
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // تدرج لوني خفيف في الأسفل
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                  stops: const [0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// عارض الصور بملء الشاشة (محسن)
class FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.images[index]),
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: widget.initialIndex),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),

          // زر الإغلاق في الأعلى
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // مؤشر الرقم في الأسفل
          Positioned(
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${currentIndex + 1} / ${widget.images.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
