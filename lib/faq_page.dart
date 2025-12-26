// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final faqs = _getFAQs(languageProvider);

        return Scaffold(
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          appBar: AppBar(
            // ✅ التعديل هنا: تثبيت اللون الأبيض للنص
            title: Text(
              languageProvider.faq,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: themeProvider.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                languageProvider.isArabic
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back_ios_new,
                color: Colors.white, // ✅ الأيقونة بيضاء
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              return _buildFAQCard(
                faqs[index]['question']!,
                faqs[index]['answer']!,
                themeProvider,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAQCard(String question, String answer, ThemeProvider theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // إزالة الخطوط الفاصلة الافتراضية
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: theme.primaryColor,
          collapsedIconColor: theme.primaryColor,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.question_answer_rounded,
                color: theme.primaryColor, size: 20),
          ),
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.textColor,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textColor.withOpacity(0.8),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ قائمة الأسئلة (بيانات)
  List<Map<String, String>> _getFAQs(LanguageProvider lang) {
    if (lang.isArabic) {
      return [
        {
          'question': 'ما هي مدة الدراسة في رواندا؟',
          'answer':
              'مدة الدراسة تختلف حسب المرحلة:\n• البكالوريوس: 3-4 سنوات\n• الماجستير: 1-2 سنة\n• الدكتوراه: 3-5 سنوات',
        },
        {
          'question': 'ما هي لغة الدراسة؟',
          'answer':
              'اللغة الإنجليزية هي اللغة الرسمية والأساسية في معظم الجامعات الرواندية، مع توفر بعض البرامج باللغة الفرنسية.',
        },
        {
          'question': 'هل أحتاج إلى فيزا مسبقة؟',
          'answer':
              'لا، الطلاب من معظم الدول يحصلون على تأشيرة الدخول عند الوصول إلى المطار (Visa on Arrival). بعد ذلك، نقوم بمساعدتك في تحويلها إلى إقامة طلابية سنوية.',
        },
        {
          'question': 'كم تكلفة الدراسة والمعيشة؟',
          'answer':
              '• الرسوم الدراسية: تتراوح غالباً بين 500 إلى 2000 دولار سنوياً.\n• المعيشة: متوسط مصروف الطالب (سكن + أكل) يتراوح بين 150 إلى 250 دولار شهرياً.',
        },
        {
          'question': 'هل يمكنني العمل أثناء الدراسة؟',
          'answer':
              'نعم، قانونياً يُسمح للطلاب الدوليين بالعمل بدوام جزئي (20 ساعة أسبوعياً) خلال فترة الدراسة.',
        },
        {
          'question': 'كم يستغرق الحصول على القبول؟',
          'answer':
              'عادة ما نستخرج القبول المبدئي (Offer Letter) خلال 2-6 أيام عمل بعد اكتمال المستندات ودفع رسوم التسجيل.',
        },
        {
          'question': 'هل شهادة اللغة (IELTS/TOEFL) مطلوبة؟',
          'answer':
              'في الغالب لا. معظم الجامعات تكتفي باختبار تحديد مستوى بسيط للغة الإنجليزية عند الوصول، أو مقابلة شخصية.',
        },
        {
          'question': 'هل الشهادات معترف بها؟',
          'answer':
              'نعم، الجامعات الرواندية معترف بها من قبل وزارة التعليم العالي الرواندية، وشهاداتها مقبولة عالمياً وفي معظم الدول العربية.',
        },
      ];
    } else {
      return [
        {
          'question': 'Duration of study in Rwanda?',
          'answer':
              'It varies by level:\n• Bachelor\'s: 3-4 years\n• Master\'s: 1-2 years\n• PhD: 3-5 years',
        },
        {
          'question': 'Language of instruction?',
          'answer':
              'English is the main official language in most universities, with some programs available in French.',
        },
        {
          'question': 'Do I need a visa beforehand?',
          'answer':
              'No, most students get a Visa on Arrival. We will assist you later in converting it to a Student Permit.',
        },
        {
          'question': 'How much does it cost?',
          'answer':
              '• Tuition: Ranges from \$500 to \$2000 per year.\n• Living: Average monthly cost (Housing + Food) is \$150 - \$250.',
        },
        {
          'question': 'Can I work while studying?',
          'answer':
              'Yes, international students are legally allowed to work part-time (20 hours/week) during their studies.',
        },
        {
          'question': 'How long for admission?',
          'answer':
              'We usually secure the preliminary admission offer within 2-6 business days after document submission.',
        },
        {
          'question': 'Is IELTS/TOEFL required?',
          'answer':
              'Mostly No. Universities usually conduct a simple placement test or interview upon arrival.',
        },
        {
          'question': 'Are degrees recognized?',
          'answer':
              'Yes, Rwandan universities are accredited by the Ministry of Education and recognized globally.',
        },
      ];
    }
  }
}
