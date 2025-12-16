import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          //   decoration: BoxDecoration(
          //     color: themeProvider.primaryColor.withValues(alpha: 0.1),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     'الأسئلة الشائعة',
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
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                FAQItem(
                  question: 'ما هي مدة الدراسة في رواندا؟',
                  answer:
                      'مدة الدراسة في رواندا تختلف حسب المرحلة الدراسية والتخصص، فمدة البكالوريوس تتراوح بين 3-4 سنوات، والماجستير من 1-2 سنوات، والدكتوراه من 3-5 سنوات.',
                  themeProvider: themeProvider,
                ),
                FAQItem(
                  question: 'ما هي لغة الدراسة في رواندا؟',
                  answer:
                      'اللغة الإنجليزية هي لغة الدراسة الرئيسية في معظم الجامعات الرواندية، مع وجود بعض البرامج باللغة الفرنسية في بعض الجامعات.',
                  themeProvider: themeProvider,
                ),
                FAQItem(
                  question: 'هل تحتاج إلى فيزا للدراسة في رواندا؟',
                  answer:
                      'نعم، يحتاج الطلاب الدوليون إلى الحصول على فيزا دراسة للدخول إلى رواندا، ويمكننا مساعدتك في استخراجها.',
                  themeProvider: themeProvider,
                ),
                FAQItem(
                  question: 'ما هي تكاليف الدراسة في رواندا؟',
                  answer:
                      'تتراوح تكاليف الدراسة بين 500-2000 دولار أمريكي سنوياً حسب الجامعة والتخصص، وتعتبر مناسبة مقارنة بجودة التعليم المقدمة.',
                  themeProvider: themeProvider,
                ),
                FAQItem(
                  question: 'هل يمكن العمل أثناء الدراسة في رواندا؟',
                  answer:
                      'نعم، يسمح للطلاب الدوليين بالعمل بدوام جزئي أثناء الدراسة، بحد أقصى 20 ساعة أسبوعياً.',
                  themeProvider: themeProvider,
                ),
                FAQItem(
                  question: 'ما هي مدة الحصول على القبول الجامعي؟',
                  answer:
                      'عادةً ما تستغرق عملية الحصول على القبول ما بين 2-6 أيام بعد اكتمال المستندات. نضمن لك الحصول على رد من الجامعات في أسرع وقت ممكن.',
                  themeProvider: themeProvider,
                ),
                FAQItem(
                  question: 'هل أحتاج لشهادة لغة للدراسة في رواندا؟',
                  answer:
                      'معظم البرامج الدراسية في رواندا باللغة الإنجليزية. بعض الجامعات قد تتطلب شهادة لغة (مثل IELTS أو TOEFL)، لكن العديد منها يقبل الطلاب بدونها مع إجراء مقابلة تقييمية.',
                  themeProvider: themeProvider,
                ),
              ],
            ),
          ),
        ],
      ),
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
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
