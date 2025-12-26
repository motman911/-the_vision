// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'favorites_provider.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'contact_page.dart';
import 'data/universities_data.dart';

class UniversitiesPage extends StatefulWidget {
  const UniversitiesPage({super.key});

  @override
  State<UniversitiesPage> createState() => _UniversitiesPageState();
}

class _UniversitiesPageState extends State<UniversitiesPage> {
  List<UniversityModel> _filteredUniversities = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredUniversities = UniversitiesData.allUniversities;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword, bool isArabic) {
    List<UniversityModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = UniversitiesData.allUniversities;
    } else {
      results = UniversitiesData.allUniversities.where((uni) {
        final name = uni.getName(isArabic).toLowerCase();
        final description = uni.getDescription(isArabic).toLowerCase();
        final specialties =
            uni.getSpecialties(isArabic).keys.join(' ').toLowerCase();
        final query = enteredKeyword.toLowerCase();

        return name.contains(query) ||
            description.contains(query) ||
            specialties.contains(query);
      }).toList();
    }

    setState(() {
      _filteredUniversities = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          // ❌ لا يوجد AppBar، نستخدم Custom Header
          body: Column(
            children: [
              // ✅ تصميم الهيدر الجديد مع شريط البحث المدمج
              Stack(
                children: [
                  // الخلفية الملونة للهيدر
                  Container(
                    height: 160, // زيادة الارتفاع قليلاً لاستيعاب العناصر
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),

                  // محتوى الهيدر
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          // العنوان الرئيسي
                          Text(
                            languageProvider.universities,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // شريط البحث
                          Container(
                            decoration: BoxDecoration(
                              color: themeProvider.cardColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) =>
                                  _runFilter(value, languageProvider.isArabic),
                              style: TextStyle(color: themeProvider.textColor),
                              decoration: InputDecoration(
                                hintText: languageProvider.isArabic
                                    ? 'ابحث عن جامعة، تخصص...'
                                    : 'Search university, major...',
                                hintStyle: TextStyle(
                                    color: themeProvider.subTextColor),
                                prefixIcon: Icon(Icons.search,
                                    color: themeProvider.primaryColor),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Colors.grey),
                                        onPressed: () {
                                          _searchController.clear();
                                          _runFilter(
                                              '', languageProvider.isArabic);
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // قائمة الجامعات
              Expanded(
                child: _filteredUniversities.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 10, left: 16, right: 16, bottom: 80),
                        itemCount: _filteredUniversities.length,
                        itemBuilder: (context, index) {
                          return UniversityCard(
                            uniModel: _filteredUniversities[index],
                            themeProvider: themeProvider,
                            languageProvider: languageProvider,
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 80,
                                color: themeProvider.primaryColor
                                    .withOpacity(0.2)),
                            const SizedBox(height: 10),
                            Text(
                              languageProvider.isArabic
                                  ? 'لا توجد نتائج مطابقة'
                                  : 'No results found',
                              style: TextStyle(
                                  color: themeProvider.subTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UniversityCard extends StatefulWidget {
  final UniversityModel uniModel;
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;

  const UniversityCard({
    super.key,
    required this.uniModel,
    required this.themeProvider,
    required this.languageProvider,
  });

  @override
  State<UniversityCard> createState() => _UniversityCardState();
}

class _UniversityCardState extends State<UniversityCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < widget.uniModel.images.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.uniModel.getName(widget.languageProvider.isArabic);
    final description =
        widget.uniModel.getDescription(widget.languageProvider.isArabic);
    final specialties =
        widget.uniModel.getSpecialties(widget.languageProvider.isArabic);

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.uniModel.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: widget.themeProvider.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.themeProvider.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slider and Fav Button
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.uniModel.images.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.uniModel.images[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: widget.languageProvider.isArabic ? null : 12,
                left: widget.languageProvider.isArabic ? 12 : null,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      favoritesProvider.toggleFavorite(widget.uniModel.id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav
                                ? (widget.languageProvider.isArabic
                                    ? 'تم الحذف من المفضلة 💔'
                                    : 'Removed from favorites')
                                : (widget.languageProvider.isArabic
                                    ? 'تمت الإضافة للمفضلة ❤️'
                                    : 'Added to favorites'),
                          ),
                          backgroundColor: widget.themeProvider.primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white.withOpacity(0.5)),
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.uniModel.images.length > 1)
                Positioned(
                  bottom: 12,
                  right: widget.languageProvider.isArabic ? 12 : null,
                  left: widget.languageProvider.isArabic ? null : 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1}/${widget.uniModel.images.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.themeProvider.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 14,
                      color: widget.themeProvider.textColor.withOpacity(0.7),
                      height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          widget.themeProvider.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      iconColor: widget.themeProvider.primaryColor,
                      collapsedIconColor: widget.themeProvider.primaryColor,
                      title: Text(
                        widget.languageProvider.isArabic
                            ? 'عرض التخصصات والرسوم'
                            : 'Show Specialties & Fees',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: widget.themeProvider.primaryColor),
                      ),
                      children: specialties.entries
                          .map((entry) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_circle,
                                        size: 16,
                                        color:
                                            widget.themeProvider.accentColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          text: '${entry.key}: ',
                                          style: TextStyle(
                                              color: widget
                                                  .themeProvider.textColor,
                                              fontSize: 13),
                                          children: [
                                            TextSpan(
                                              text: entry.value,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: widget.themeProvider
                                                      .primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(widget.uniModel.website));
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: widget.themeProvider.textColor,
                          side: BorderSide(
                              color: widget.themeProvider.textColor
                                  .withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(widget.languageProvider.isArabic
                            ? 'الموقع الرسمي'
                            : 'Website'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.themeProvider.primaryColor,
                              widget.themeProvider.secondaryColor
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: widget.themeProvider.primaryColor
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactPage(
                                  initialInterest: '',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.languageProvider.isArabic
                                    ? 'تقديم طلب الآن'
                                    : 'Apply Now',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
