import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'theme_provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<String> galleryImages = [
    'assets/images/The_Vision_P2.jpg',
    'assets/images/In_Rwanda_1.jpg',
    'assets/images/In_Rwanda_2.jpg',
    'assets/images/In_Rwanda_3.jpg',
    'assets/images/In_Rwanda_4.jpg',
    'assets/images/In_Rwanda_5.jpg',
    'assets/images/ULK_P3.jpg',
    'assets/images/In_Rwanda_6.jpg',
    'assets/images/In_Rwanda_7.jpg',
    'assets/images/In_Rwanda_8.jpg',
    'assets/images/In_Rwanda_9.jpg',
    'assets/images/In_Rwanda_10.jpg',
  ];

  int _currentIndex = 0;
  bool _isFullScreen = false;

  void _openImage(BuildContext context, int index) {
    setState(() {
      _currentIndex = index;
      _isFullScreen = true;
    });
  }

  void _closeFullScreen() {
    setState(() {
      _isFullScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _closeFullScreen,
          ),
          title: Text(
            '${_currentIndex + 1} / ${galleryImages.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: PhotoViewGallery.builder(
          itemCount: galleryImages.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: AssetImage(galleryImages[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale:
                  PhotoViewComputedScale.covered * 3.0, // زيادة نسبة التكبير
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: galleryImages[index]),
              basePosition: Alignment.center,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: _currentIndex),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          //   decoration: BoxDecoration(
          //     color: themeProvider.primaryColor.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     'معرض الصور - رواندا',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //       color: themeProvider.primaryColor,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openImage(context, index),
                    child: Hero(
                      tag: galleryImages[index],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Stack(
                          children: [
                            Image.asset(
                              galleryImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              cacheWidth: 400, // تحسين الجودة بالتحكم في الدقة
                              cacheHeight: 300,
                              filterQuality: FilterQuality.high, // تحسين الجودة
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeProvider.primaryColor,
                                      themeProvider.secondaryColor,
                                    ],
                                  ),
                                ),
                                child: const Icon(Icons.photo,
                                    size: 40, color: Colors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
