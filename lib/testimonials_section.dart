import 'package:flutter/material.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class TestimonialsSection extends StatelessWidget {
  final ThemeProvider theme;
  final LanguageProvider lang;

  const TestimonialsSection({
    super.key,
    required this.theme,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية (استبدلها بصور وكلام طلاب حقيقيين لاحقاً)
    final List<Map<String, String>> testimonials = [
      {
        'name': lang.isArabic ? 'أحمد محمد' : 'Ahmed Mohamed',
        'uni': lang.isArabic ? 'جامعة رواندا' : 'University of Rwanda',
        'quote': lang.isArabic
            ? 'تجربة رائعة، ساعدوني في كل خطوة من التقديم حتى السكن. أنصح بهم بشدة!'
            : 'Amazing experience, they helped me every step of the way. Highly recommended!',
        'image': 'assets/images/student1.png', // ضع صور حقيقية لاحقاً
      },
      {
        'name': lang.isArabic ? 'سارة علي' : 'Sara Ali',
        'uni': lang.isArabic ? 'جامعة كيجالي' : 'University of Kigali',
        'quote': lang.isArabic
            ? 'لم أكن أتوقع أن تكون الإجراءات بهذه السهولة. شكراً لمكتب الرؤية على المصداقية.'
            : 'I didn\'t expect the process to be this easy. Thanks to The Vision for credibility.',
        'image': 'assets/images/student2.png',
      },
      {
        'name': lang.isArabic ? 'عمر خالد' : 'Omar Khalid',
        'uni': lang.isArabic ? 'جامعة ULK' : 'ULK University',
        'quote': lang.isArabic
            ? 'رواندا بلد جميل والدراسة قوية. المكتب وفر عليّ عناء البحث والتقديم.'
            : 'Rwanda is beautiful and education is strong. The office saved me the trouble of searching.',
        'image': 'assets/images/student3.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            lang.isArabic ? 'طلابنا المتفوقون 🎓' : 'Our Top Students 🎓',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180, // ارتفاع الكرت
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              final item = testimonials[index];
              return Container(
                width: 280, // عرض الكرت
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border:
                      Border.all(color: theme.primaryColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الرأس: الصورة والاسم
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Icon(Icons.person,
                              color: theme.primaryColor), // أيقونة مؤقتة
                          // backgroundImage: AssetImage(item['image']!), // فعل هذا السطر لما تضيف صور
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item['uni']!,
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.format_quote,
                            color: Colors.grey.withOpacity(0.3), size: 30),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // النص
                    Expanded(
                      child: Text(
                        '"${item['quote']}"',
                        style: TextStyle(
                          color: theme.textColor.withOpacity(0.8),
                          fontSize: 12,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // النجوم
                    Row(
                      children: List.generate(
                          5,
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 14)),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
