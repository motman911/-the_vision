class UniversityModel {
  final String id;
  final String website;
  final List<String> images;

  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final Map<String, String> specialtiesAr;
  final Map<String, String> specialtiesEn;

  const UniversityModel({
    required this.id,
    required this.website,
    required this.images,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.specialtiesAr,
    required this.specialtiesEn,
  });

  // دالة لجلب الاسم حسب اللغة
  String getName(bool isArabic) {
    return isArabic ? nameAr : nameEn;
  }

  // دالة لجلب الوصف حسب اللغة
  String getDescription(bool isArabic) {
    return isArabic ? descriptionAr : descriptionEn;
  }

  // دالة لجلب التخصصات حسب اللغة
  Map<String, String> getSpecialties(bool isArabic) {
    return isArabic ? specialtiesAr : specialtiesEn;
  }
}

class UniversitiesData {
  static final List<UniversityModel> allUniversities = [
    // 1. جامعة كيغالي المستقلة (ULK)
    const UniversityModel(
      id: 'ulk',
      website: 'https://www.ulk.ac.rw',
      images: [
        'assets/images/ULK_P3.jpg',
        'assets/images/ULK_P1.webp',
        'assets/images/ULK_P5.jpg',
        'assets/images/ULK_P6.jpg',
      ],
      nameAr: 'جامعة كيغالي المستقلة (ULK)',
      nameEn: 'Kigali Independent University (ULK)',
      descriptionAr:
          'في عام 1996 تأسست جامعة كيغالي المستقلة وهي واحدة من أقدم الجامعات الخاصة في رواندا، تقدم الجامعة برامج دراسية متنوعة في مجالات الحقوق، الإدارة، التكنولوجيا والعلوم الاجتماعية.',
      descriptionEn:
          'In 1996, Kigali Independent University was established and is one of the oldest private universities in Rwanda. The university offers diverse study programs in the fields of law, management, technology, and social sciences.',
      specialtiesAr: {
        'كلية الاقتصاد والدراسات الإدارية (3 سنوات)': '500 دولار/سنوياً',
        'كلية العلوم الاجتماعية (3 سنوات)': '500 دولار/سنوياً',
        'كلية الحقوق (3 سنوات)': '500 دولار/سنوياً',
        'كلية العلوم والتكنولوجيا (4 سنوات)': '570 دولار/سنوياً',
        'قسم الكهرباء والالكترونيات (3 سنوات)': '690 دولار/سنوياً',
        'قسم الهندسة المدنية (3 سنوات)': '690 دولار/سنوياً',
      },
      specialtiesEn: {
        'Faculty of Economics and Administrative Studies (3 years)':
            '500 USD/year',
        'Faculty of Social Sciences (3 years)': '500 USD/year',
        'Faculty of Law (3 years)': '500 USD/year',
        'Faculty of Science and Technology (4 years)': '570 USD/year',
        'Department of Electricity and Electronics (3 years)': '690 USD/year',
        'Department of Civil Engineering (3 years)': '690 USD/year',
      },
    ),

    // 2. جامعة كيغالي (UoK)
    const UniversityModel(
      id: 'uok',
      website: 'https://www.universityofkigali.ac.rw',
      images: [
        'assets/images/UoK_P1.jpg',
        'assets/images/UoK_P2.jpg',
        'assets/images/UoK_P3.jpg',
        'assets/images/UoK_P4.jpg',
        'assets/images/UoK_P5.jpg',
      ],
      nameAr: 'جامعة كيغالي (UoK)',
      nameEn: 'University of Kigali (UoK)',
      descriptionAr:
          'جامعة حديثة وسريعة النمو تقع في قلب العاصمة، تقدم برامج دراسية متنوعة في مجالات الإدارة، القانون، والتكنولوجيا.',
      descriptionEn:
          'A modern, fast-growing university in the heart of the capital, offering diverse study programs in management, law, and technology.',
      specialtiesAr: {
        'المحاسبة (3 سنوات)': '520 دولار/سنوياً',
        'التمويل (3 سنوات)': '520 دولار/سنوياً',
        'الاقتصاد (3 سنوات)': '520 دولار/سنوياً',
        'التسويق (3 سنوات)': '520 دولار/سنوياً',
        'المشروعات (3 سنوات)': '520 دولار/سنوياً',
        'الإدارة العامة (3 سنوات)': '520 دولار/سنوياً',
        'القانون (3 سنوات)': '520 دولار/سنوياً',
        'تقنية المعلومات (3 سنوات)': '560 دولار/سنوياً',
        'علوم الكمبيوتر (3 سنوات)': '561 دولار/سنوياً',
        'تكنولوجيا معلومات الأعمال': '561 دولار/سنوياً',
        'التعليم (تنمية الطفولة المبكرة)': '520 دولار/سنوياً',
      },
      specialtiesEn: {
        'Accounting (3 years)': '520 USD/year',
        'Finance (3 years)': '520 USD/year',
        'Economics (3 years)': '520 USD/year',
        'Marketing (3 years)': '520 USD/year',
        'Projects (3 years)': '520 USD/year',
        'Public Administration (3 years)': '520 USD/year',
        'Law (3 years)': '520 USD/year',
        'Information Technology (3 years)': '560 USD/year',
        'Computer Science (3 years)': '561 USD/year',
        'Business Information Technology': '561 USD/year',
        'Education (Early Childhood)': '520 USD/year',
      },
    ),

    // 3. معهد INES Ruhengeri
    const UniversityModel(
      id: 'ines',
      website: 'https://www.ines.ac.rw',
      images: [
        'assets/images/INES_P1.jpeg',
        'assets/images/INES_P2.jpeg',
        'assets/images/INES_P3.jpg',
      ],
      nameAr: 'معهد INES Ruhengeri',
      nameEn: 'INES Ruhengeri',
      descriptionAr:
          'مؤسسة تعليمية خاصة تركز على العلوم التطبيقية، التكنولوجيا، الهندسة والرياضيات. تتميز ببرامج تربط بين النظرية والتطبيق العملي.',
      descriptionEn:
          'A private institution focusing on Applied Sciences, Technology, Engineering, and Math. Distinguished by programs linking theory with practice.',
      specialtiesAr: {
        'علوم المعلومات والمكتبات (4 سنوات)': '610 دولار/سنوياً',
        'الاقتصاد المالي (3 سنوات)': '760 دولار/سنوياً',
        'اقتصاديات التنمية الريفية': '760 دولار/سنوياً',
        'الاقتصاد الدولي': '760 دولار/سنوياً',
        'المحاسبة': '760 دولار/سنوياً',
        'ريادة الأعمال والإدارة': '760 دولار/سنوياً',
        'الإدارة العامة والحوكمة (4 سنوات)': '560 دولار/سنوياً',
        'الإنجليزية - الفرنسية والتعليم': '545 دولار/سنوياً',
        'الهندسة المعمارية (5 سنوات)': '1560 دولار/سنوياً',
        'الهندسة المدنية (4 سنوات)': '1200 دولار/سنوياً',
        'هندسة المياه (4 سنوات)': '1200 دولار/سنوياً',
        'علوم المختبرات الطبية (4 سنوات)': '1200 دولار/سنوياً',
      },
      specialtiesEn: {
        'Info Sciences & Library (4 years)': '610 USD/year',
        'Financial Economics (3 years)': '760 USD/year',
        'Rural Development Economics': '760 USD/year',
        'International Economics': '760 USD/year',
        'Accounting': '760 USD/year',
        'Entrepreneurship & Management': '760 USD/year',
        'Public Admin & Governance (4 years)': '560 USD/year',
        'English - French & Education': '545 USD/year',
        'Architecture (5 years)': '1560 USD/year',
        'Civil Engineering (4 years)': '1200 USD/year',
        'Water Engineering (4 years)': '1200 USD/year',
        'Biomedical Lab Sciences (4 years)': '1200 USD/year',
      },
    ),

    // 4. جامعة UNILAK
    const UniversityModel(
      id: 'unilak',
      website: 'https://www.unilak.ac.rw',
      images: [
        'assets/images/UNLAK_P1.jpg',
        'assets/images/UNLAK_P2.jpg',
        'assets/images/UNLAK_P3.jpg',
      ],
      nameAr: 'جامعة UNILAK',
      nameEn: 'UNILAK University',
      descriptionAr:
          'جامعة UNILAK تقدم برامج دراسية متنوعة في مجالات الحقوق والاقتصاد والعلوم البيئية والحوسبة.',
      descriptionEn:
          'UNILAK University offers diverse study programs in law, economics, environmental sciences, and computing.',
      specialtiesAr: {
        'كلية الحقوق': '500 دولار/سنوياً',
        'الاقتصاد والعلوم الإدارية': '500 دولار/سنوياً',
        'كلية الدراسات البيئية': '520 دولار/سنوياً',
        'كلية الحوسبة وعلوم المعلومات': '520 دولار/سنوياً',
        'تكنولوجيا المعلومات': '520 دولار/سنوياً',
      },
      specialtiesEn: {
        'Faculty of Law': '500 USD/year',
        'Economics & Admin Sciences': '500 USD/year',
        'Faculty of Environmental Studies': '520 USD/year',
        'Computing & Info Sciences': '520 USD/year',
        'Information Technology': '520 USD/year',
      },
    ),

    // 5. جامعة رواندا (UR)
    const UniversityModel(
      id: 'ur',
      website: 'https://www.ur.ac.rw',
      images: [
        'assets/images/UR_P1.jpeg',
        'assets/images/UR_P2.jpeg',
        'assets/images/UR_P4.jpg',
        'assets/images/UR_P5.jpg',
        'assets/images/UR_P6.jpg',
      ],
      nameAr: 'جامعة رواندا (UR)',
      nameEn: 'University of Rwanda (UR)',
      descriptionAr:
          'الجامعة الحكومية الأكبر في رواندا، تضم كليات الطب والهندسة والعلوم والآداب.',
      descriptionEn:
          'The largest public university in Rwanda, featuring colleges of Medicine, Engineering, Science, and Arts.',
      specialtiesAr: {
        'الطب البشري': '2000 دولار/سنوياً',
        'الهندسة': '1500 دولار/سنوياً',
        'العلوم الطبيعية': '1000 دولار/سنوياً',
        'الآداب والعلوم الإنسانية': '800 دولار/سنوياً',
      },
      specialtiesEn: {
        'Medicine': '2000 USD/year',
        'Engineering': '1500 USD/year',
        'Natural Sciences': '1000 USD/year',
        'Arts and Humanities': '800 USD/year',
      },
    ),
  ];
}
