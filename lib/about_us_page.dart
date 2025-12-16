import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            //   decoration: BoxDecoration(
            //     color: themeProvider.primaryColor.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Text(
            //     'من نحن',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //       color: themeProvider.primaryColor,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24),

            // الرؤية والرسالة
            Text(
              'رؤيتنا ورسالتنا',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildValueCard(
              'رؤيتنا',
              'أن نكون الوكالة الرائدة في تمكين الطلاب العرب من تحقيق أحلامهم الأكاديمية في رواندا',
              Icons.visibility,
              themeProvider,
            ),
            _buildValueCard(
              'رسالتنا',
              'توفير تجربة دراسية سلسة وناجحة للطلاب من خلال تقديم الدعم الكامل في جميع مراحل رحلتهم الأكاديمية',
              Icons.flag,
              themeProvider,
            ),
            _buildValueCard(
              'هدفنا',
              'تقديم خدمات متميزة تركز على احتياجات الطلاب، مع الحفاظ على الشفافية والمصداقية',
              Icons.star,
              themeProvider,
            ),
            const SizedBox(height: 24),

            // القيم الأساسية
            Text(
              'قيمنا الأساسية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildValueItem(
              'الثقة',
              'نحن نحرص على بناء علاقات ثقة طويلة الأمد مع طلابنا، حيث نضع مصلحتهم في المقام الأول',
              Icons.handshake,
              themeProvider,
            ),
            _buildValueItem(
              'الشفافية',
              'جميع خطواتنا واضحة وشفافة دون أي تكاليف خفية، مع تقديم تقارير دورية عن سير الإجراءات',
              Icons.visibility,
              themeProvider,
            ),
            _buildValueItem(
              'الالتزام',
              'نلتزم بمواعيدنا ونحترم تعهداتنا تجاه الطلاب، مع تقديم حلول سريعة لأي تحديات تواجههم',
              Icons.event_available,
              themeProvider,
            ),
            _buildValueItem(
              'الدعم',
              'دعم مستمر للطالب طوال فترة دراسته في رواندا، مع فريق متكامل لمساعدته في جميع احتياجاته',
              Icons.support,
              themeProvider,
            ),
            const SizedBox(height: 24),

            // فريق العمل
            Text(
              'فريق العمل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              'أسامة جمال',
              'مستشار أكاديمي ومسؤول متابعة الطلاب',
              'خبرة في مجال الاستشارات الأكاديمية والتوجيه للدراسة في رواندا، بالإضافة إلى متابعة الطلاب ودعمهم خلال رحلتهم الدراسية.',
              themeProvider,
            ),
            _buildTeamMember(
              'مؤتمن نور النبي',
              'مسؤول استقبال الطلاب والدعم المستمر',
              'يقوم باستقبال الطلاب في رواندا ومساعدتهم في خطواتهم الأولى، ويقدم الدعم المستمر للطلاب طوال فترة دراستهم.',
              themeProvider,
            ),
            _buildTeamMember(
              'محمد عادل',
              'مسؤول ارشاد الطلاب والدعم المستمر',
              'يعمل على تيسير عملية الانتقال والاستقرار للطلاب في رواندا',
              themeProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(String title, String description, IconData icon,
      ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: themeProvider.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 30, color: themeProvider.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(String title, String description, IconData icon,
      ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(icon, color: themeProvider.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildTeamMember(String name, String position, String description,
      ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.primaryColor,
                        ),
                      ),
                      Text(position, style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
