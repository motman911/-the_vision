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
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: faqItems(languageProvider).length,
                  itemBuilder: (context, index) {
                    return FAQItem(
                      question: faqItems(languageProvider)[index]['question']!,
                      answer: faqItems(languageProvider)[index]['answer']!,
                      themeProvider: themeProvider,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final ThemeProvider themeProvider;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, String>> faqItems(LanguageProvider languageProvider) {
  if (languageProvider.isArabic) {
    return [
      {
        'question': 'ما هي مدة الدراسة في رواندا؟',
        'answer':
            'مدة الدراسة في رواندا تختلف حسب المرحلة الدراسية والتخصص، فمدة البكالوريوس تتراوح بين 3-4 سنوات، والماجستير من 1-2 سنوات، والدكتوراه من 3-5 سنوات.',
      },
      {
        'question': 'ما هي لغة الدراسة في رواندا؟',
        'answer':
            'اللغة الإنجليزية هي لغة الدراسة الرئيسية في معظم الجامعات الرواندية، مع وجود بعض البرامج باللغة الفرنسية في بعض الجامعات.',
      },
      {
        'question': 'هل تحتاج إلى فيزا للدراسة في رواندا؟',
        'answer':
            'نعم، يحتاج الطلاب الدوليون إلى الحصول على فيزا دراسة للدخول إلى رواندا، ويمكننا مساعدتك في استخراجها.',
      },
      {
        'question': 'ما هي تكاليف الدراسة في رواندا؟',
        'answer':
            'تتراوح تكاليف الدراسة بين 500-2000 دولار أمريكي سنوياً حسب الجامعة والتخصص، وتعتبر مناسبة مقارنة بجودة التعليم المقدمة.',
      },
      {
        'question': 'هل يمكن العمل أثناء الدراسة في رواندا؟',
        'answer':
            'نعم، يسمح للطلاب الدوليين بالعمل بدوام جزئي أثناء الدراسة، بحد أقصى 20 ساعة أسبوعياً.',
      },
      {
        'question': 'ما هي مدة الحصول على القبول الجامعي؟',
        'answer':
            'عادةً ما تستغرق عملية الحصول على القبول ما بين 2-6 أيام بعد اكتمال المستندات. نضمن لك الحصول على رد من الجامعات في أسرع وقت ممكن.',
      },
      {
        'question': 'هل أحتاج لشهادة لغة للدراسة في رواندا؟',
        'answer':
            'معظم البرامج الدراسية في رواندا باللغة الإنجليزية. بعض الجامعات قد تتطلب شهادة لغة (مثل IELTS أو TOEFL)، لكن العديد منها يقبل الطلاب بدونها مع إجراء مقابلة تقييمية.',
      },
    ];
  } else {
    return [
      {
        'question': 'What is the duration of study in Rwanda?',
        'answer':
            'The duration of study in Rwanda varies according to the study level and specialization. Bachelor\'s degree ranges from 3-4 years, Master\'s from 1-2 years, and PhD from 3-5 years.',
      },
      {
        'question': 'What is the language of study in Rwanda?',
        'answer':
            'English is the main language of study in most Rwandan universities, with some programs in French in some universities.',
      },
      {
        'question': 'Do you need a visa to study in Rwanda?',
        'answer':
            'Yes, international students need to obtain a study visa to enter Rwanda, and we can help you obtain it.',
      },
      {
        'question': 'What are the study costs in Rwanda?',
        'answer':
            'Study costs range between 500-2000 US dollars annually depending on the university and specialization, and are considered reasonable compared to the quality of education provided.',
      },
      {
        'question': 'Can I work while studying in Rwanda?',
        'answer':
            'Yes, international students are allowed to work part-time while studying, with a maximum of 20 hours per week.',
      },
      {
        'question': 'How long does it take to get university acceptance?',
        'answer':
            'The acceptance process usually takes between 2-6 days after completing the documents. We guarantee you a response from universities as soon as possible.',
      },
      {
        'question': 'Do I need a language certificate to study in Rwanda?',
        'answer':
            'Most study programs in Rwanda are in English. Some universities may require a language certificate (such as IELTS or TOEFL), but many accept students without it with an assessment interview.',
      },
    ];
  }
}
