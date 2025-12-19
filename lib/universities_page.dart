import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'widgets.dart';
import 'contact_page.dart';

class UniversitiesPage extends StatelessWidget {
  const UniversitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
         
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
            //     Container(
            //       width: double.infinity,
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            //       decoration: BoxDecoration(
            //         color: themeProvider.primaryColor.withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Text(
            //         languageProvider.famousUniversities,
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 22,
            //           fontWeight: FontWeight.bold,
            //           color: themeProvider.primaryColor,
            //         ),
            //       ),
            //     ),
            //     const SizedBox(height: 24),
                UniversityCard(
                  name: 'Kigali Independent University (ULK)',
                  description: languageProvider.isArabic
                      ? 'في عام 1996 تأسست جامعة كيغالي المستقلة وهي واحدة من أقدم الجامعات الخاصة في رواندا، تقدم الجامعة برامج دراسية متنوعة في مجالات الحقوق، الإدارة، التكنولوجيا والعلوم الاجتماعية.'
                      : 'In 1996, Kigali Independent University was established and is one of the oldest private universities in Rwanda. The university offers diverse study programs in the fields of law, management, technology, and social sciences.',
                  images: const [
                    'assets/images/ULK_P3.jpg',
                    'assets/images/ULK_P1.webp',
                    'assets/images/ULK_P5.jpg',
                    'assets/images/ULK_P6.jpg',
                  ],
                  specialties: _getULKSpecialties(languageProvider),
                  website: 'https://www.ulk.ac.rw',
                  themeProvider: themeProvider,
                  languageProvider: languageProvider,
                ),
                UniversityCard(
                  name: 'University of Kigali (UoK)',
                  description: languageProvider.isArabic
                      ? 'جامعة كيغالي تقدم برامج دراسية متنوعة في مجالات الإدارة، القانون، والتكنولوجيا.'
                      : 'University of Kigali offers diverse study programs in the fields of management, law, and technology.',
                  images: const [
                    'assets/images/UoK_P1.jpg',
                    'assets/images/UoK_P2.jpg',
                    'assets/images/UoK_P3.jpg',
                    'assets/images/UoK_P4.jpg',
                    'assets/images/UoK_P5.jpg',
                  ],
                  specialties: _getUoKSpecialties(languageProvider),
                  website: 'https://www.universityofkigali.ac.rw',
                  themeProvider: themeProvider,
                  languageProvider: languageProvider,
                ),
                UniversityCard(
                  name: 'INES Ruhengeri',
                  description: languageProvider.isArabic
                      ? 'معهد INES Ruhengeri هو مؤسسة تعليمية خاصة تركز على مجالات العلوم والتكنولوجيا والهندسة والرياضيات. يتميز ببرامجه التطبيقية التي تربط بين النظرية والتطبيق العملي.'
                      : 'INES Ruhengeri Institute is a private educational institution focusing on science, technology, engineering, and mathematics fields. It is distinguished by its applied programs that link theory with practical application.',
                  images: const [
                    'assets/images/INES_P1.jpeg',
                    'assets/images/INES_P2.jpeg',
                    'assets/images/INES_P3.jpg',
                  ],
                  specialties: _getINESSpecialties(languageProvider),
                  website: 'https://www.ines.ac.rw',
                  themeProvider: themeProvider,
                  languageProvider: languageProvider,
                ),
                UniversityCard(
                  name: 'UNILAK University',
                  description: languageProvider.isArabic
                      ? 'جامعة UNILAK تقدم برامج دراسية متنوعة في مجالات الحقوق والاقتصاد والعلوم البيئية والحوسبة.'
                      : 'UNILAK University offers diverse study programs in the fields of law, economics, environmental sciences, and computing.',
                  images: const [
                    'assets/images/UNLAK_P1.jpg',
                    'assets/images/UNLAK_P2.jpg',
                    'assets/images/UNLAK_P3.jpg',
                  ],
                  specialties: _getUNILAKSpecialties(languageProvider),
                  website: 'https://www.unilak.ac.rw',
                  themeProvider: themeProvider,
                  languageProvider: languageProvider,
                ),
                UniversityCard(
                  name: 'University of Rwanda (UR)',
                  description: languageProvider.isArabic
                      ? 'جامعة رواندا هي الجامعة الحكومية الرئيسية في البلاد، نتجت عن دمج عدة مؤسسات تعليم عالي. تقدم الجامعة برامج دراسية في مختلف التخصصات العلمية والأدبية.'
                      : 'University of Rwanda is the main public university in the country, resulting from the merger of several higher education institutions. The university offers study programs in various scientific and literary disciplines.',
                  images: const [
                    'assets/images/UR_P1.jpeg',
                    'assets/images/UR_P2.jpeg',
                    'assets/images/UR_P4.jpg',
                    'assets/images/UR_P5.jpg',
                    'assets/images/UR_P6.jpg',
                  ],
                  specialties: _getURSpecialties(languageProvider),
                  website: 'https://www.ur.ac.rw',
                  themeProvider: themeProvider,
                  languageProvider: languageProvider,
                ),
                const SizedBox(height: 24),
                const Center(child: WhatsAppButton()),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, String> _getULKSpecialties(LanguageProvider languageProvider) {
    if (languageProvider.isArabic) {
      return {
        'كلية الاقتصاد والدراسات الإدارية (3 سنوات) - الاقتصاد، المالية، المحاسبة، التنمية الريفية':
            '500 دولار/سنوياً',
        'كلية العلوم الاجتماعية (3 سنوات) - العلاقات الدولية، دراسات التنمية، علم الاجتماع، الدراسات الإدارية السكانية':
            '500 دولار/سنوياً',
        'كلية الحقوق (3 سنوات) - القانون العام، القانون الخاص':
            '500 دولار/سنوياً',
        'كلية العلوم والتكنولوجيا (4 سنوات) - الشبكات، هندسة البرمجيات، علم البيانات':
            '570 دولار/سنوياً',
        'قسم الكهرباء والالكترونيات (3 سنوات) - التكنولوجيا الكهربائية، الالكترونيات والاتصالات':
            '690 دولار/سنوياً',
        'قسم الهندسة المدنية (3 سنوات) - تكنولوجيا البناء، هندسة مسح الاراضي':
            '690 دولار/سنوياً',
      };
    } else {
      return {
        'Faculty of Economics and Administrative Studies (3 years) - Economics, Finance, Accounting, Rural Development':
            '500 USD/year',
        'Faculty of Social Sciences (3 years) - International Relations, Development Studies, Sociology, Population Administrative Studies':
            '500 USD/year',
        'Faculty of Law (3 years) - Public Law, Private Law': '500 USD/year',
        'Faculty of Science and Technology (4 years) - Networks, Software Engineering, Data Science':
            '570 USD/year',
        'Department of Electricity and Electronics (3 years) - Electrical Technology, Electronics and Communications':
            '690 USD/year',
        'Department of Civil Engineering (3 years) - Construction Technology, Land Surveying Engineering':
            '690 USD/year',
      };
    }
  }

  Map<String, String> _getUoKSpecialties(LanguageProvider languageProvider) {
    if (languageProvider.isArabic) {
      return {
        'المحاسبة (3 سنوات)': '520 دولار/سنوياً',
        'التمويل (3 سنوات)': '520 دولار/سنوياً',
        'الاقتصاد (3 سنوات)': '520 دولار/سنوياً',
        'التسويق (3 سنوات)': '520 دولار/سنوياً',
        'المشروعات (3 سنوات)': '520 دولار/سنوياً',
        'الإدارة العامة (3 سنوات)': '520 دولار/سنوياً',
        'القانون (3 سنوات)': '520 دولار/سنوياً',
        'تقنية المعلومات (3 سنوات)': '560 دولار/سنوياً',
        'علوم الكمبيوتر (3 سنوات)': '561 دولار/سنوياً',
        'تكنولوجيا معلومات الأعمال (3 سنوات)': '561 دولار/سنوياً',
        'التعليم مع مرتبة الشرف في تنمية الطفولة المبكرة (3 سنوات)':
            '520 دولار/سنوياً',
      };
    } else {
      return {
        'Accounting (3 years)': '520 USD/year',
        'Finance (3 years)': '520 USD/year',
        'Economics (3 years)': '520 USD/year',
        'Marketing (3 years)': '520 USD/year',
        'Projects (3 years)': '520 USD/year',
        'Public Administration (3 years)': '520 USD/year',
        'Law (3 years)': '520 USD/year',
        'Information Technology (3 years)': '560 USD/year',
        'Computer Science (3 years)': '561 USD/year',
        'Business Information Technology (3 years)': '561 USD/year',
        'Education with Honors in Early Childhood Development (3 years)':
            '520 USD/year',
      };
    }
  }

  Map<String, String> _getINESSpecialties(LanguageProvider languageProvider) {
    if (languageProvider.isArabic) {
      return {
        'علوم المعلومات والمكتبة الإدارة (4 سنوات)': '610 دولار/سنوياً',
        'الاقتصاد المالي (3 سنوات)': '760 دولار/سنوياً',
        'اقتصاديات التنمية الريفية (3 سنوات)': '760 دولار/سنوياً',
        'الاقتصاد الدولي (3 سنوات)': '760 دولار/سنوياً',
        'المحاسبة (3 سنوات)': '760 دولار/سنوياً',
        'تطوير ريادة الأعمال والإدارة (3 سنوات)': '760 دولار/سنوياً',
        'الإدارة العامة والحوكمة (4 سنوات)': '560 دولار/سنوياً',
        'الإنجليزية - الفرنسية مع التعليم (3 سنوات)': '545 دولار/سنوياً',
        'الهندسة المعمارية (5 سنوات)': '1560 دولار/سنوياً',
        'الهندسة المدنية (4 سنوات)': '1200 دولار/سنوياً',
        'هندسة المياه (4 سنوات)': '1200 دولار/سنوياً',
        'علوم المختبرات الطبية الحيوية (4 سنوات)': '1200 دولار/سنوياً',
      };
    } else {
      return {
        'Information Sciences and Library Management (4 years)': '610 USD/year',
        'Financial Economics (3 years)': '760 USD/year',
        'Rural Development Economics (3 years)': '760 USD/year',
        'International Economics (3 years)': '760 USD/year',
        'Accounting (3 years)': '760 USD/year',
        'Entrepreneurship and Management Development (3 years)': '760 USD/year',
        'Public Administration and Governance (4 years)': '560 USD/year',
        'English - French with Education (3 years)': '545 USD/year',
        'Architecture Engineering (5 years)': '1560 USD/year',
        'Civil Engineering (4 years)': '1200 USD/year',
        'Water Engineering (4 years)': '1200 USD/year',
        'Biomedical Laboratory Sciences (4 years)': '1200 USD/year',
      };
    }
  }

  Map<String, String> _getUNILAKSpecialties(LanguageProvider languageProvider) {
    if (languageProvider.isArabic) {
      return {
        'كلية الحقوق': '500 دولار/سنوياً',
        'الاقتصاد والعلوم الإدارية (3 سنوات) - الإدارة التعاونية الاقتصاد، المالية، المحاسبة والتسويق وإدارة الموارد البشرية':
            '500 دولار/سنوياً',
        'كلية الدراسات البيئية (3 سنوات) - التنمية الريفية، الطوارئ والكوارث، الإدارة البيئية والحفاظ عليها':
            '520 دولار/سنوياً',
        'كلية الحوسبة وعلوم المعلومات (3 سنوات) - هندسة البرمجيات، نظم المعلومات':
            '520 دولار/سنوياً',
        'التكنولوجيا (تكنولوجيا المعلومات)': '520 دولار/سنوياً',
      };
    } else {
      return {
        'Faculty of Law': '500 USD/year',
        'Economics and Administrative Sciences (3 years) - Cooperative Management, Economics, Finance, Accounting, Marketing and Human Resources Management':
            '500 USD/year',
        'Faculty of Environmental Studies (3 years) - Rural Development, Emergencies and Disasters, Environmental Management and Conservation':
            '520 USD/year',
        'Faculty of Computing and Information Sciences (3 years) - Software Engineering, Information Systems':
            '520 USD/year',
        'Technology (Information Technology)': '520 USD/year',
      };
    }
  }

  Map<String, String> _getURSpecialties(LanguageProvider languageProvider) {
    if (languageProvider.isArabic) {
      return {
        'الطب': '2000 دولار/سنوياً',
        'الهندسة': '1500 دولار/سنوياً',
        'العلوم الطبيعية': '1000 دولار/سنوياً',
        'الآداب والعلوم الإنسانية': '800 دولار/سنوياً',
      };
    } else {
      return {
        'Medicine': '2000 USD/year',
        'Engineering': '1500 USD/year',
        'Natural Sciences': '1000 USD/year',
        'Arts and Humanities': '800 USD/year',
      };
    }
  }
}

class UniversityCard extends StatefulWidget {
  final String name;
  final String description;
  final List<String> images;
  final Map<String, String> specialties;
  final String website;
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;

  const UniversityCard({
    super.key,
    required this.name,
    required this.description,
    required this.images,
    required this.specialties,
    required this.website,
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
        if (_currentPage < widget.images.length - 1) {
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: widget.themeProvider.cardColor,
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        widget.images[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.themeProvider.primaryColor,
                                widget.themeProvider.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.school,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (widget.images.length > 1)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentPage + 1}/${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.themeProvider.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.languageProvider.isArabic
                      ? 'التخصصات والرسوم:'
                      : 'Specialties and Fees:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.themeProvider.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.specialties.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 18,
                          color: widget.themeProvider.accentColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: widget.themeProvider.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(widget.website));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeProvider.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        widget.languageProvider.isArabic
                            ? 'الموقع الرسمي'
                            : 'Official Website',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeProvider.secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        widget.languageProvider.isArabic
                            ? 'التقديم الآن'
                            : 'Apply Now',
                        style: const TextStyle(fontSize: 14),
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
