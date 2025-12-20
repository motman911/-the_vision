import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'data/universities_data.dart';

class CostCalculatorPage extends StatefulWidget {
  const CostCalculatorPage({super.key});

  @override
  State<CostCalculatorPage> createState() => _CostCalculatorPageState();
}

class _CostCalculatorPageState extends State<CostCalculatorPage> {
  // المتغيرات المختارة
  UniversityModel? _selectedUniversity;
  String? _selectedSpecialtyKey;
  double _tuitionFees = 0;

  // خيارات المعيشة (قيم افتراضية)
  double _accommodationCost = 100; // قيمة أولية للسكن
  double _livingCost = 150; // قيمة أولية للمعيشة

  final double _visaAndInsurance = 150; // رسوم التأشيرة والتأمين

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final isArabic = lang.isArabic;

    // الحسابات النهائية
    double yearlyAccommodation = _accommodationCost * 12;
    double yearlyLiving = _livingCost * 12;
    double totalFirstYear =
        _tuitionFees + yearlyAccommodation + yearlyLiving + _visaAndInsurance;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isArabic ? 'حاسبة التكاليف التقديرية' : 'Cost Estimator'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم اختيار الجامعة
            _buildSectionHeader(
              title: isArabic ? 'الجامعة والتخصص' : 'University & Major',
              icon: Icons.school,
              theme: theme,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<UniversityModel>(
                  value: _selectedUniversity,
                  hint: Text(isArabic ? 'اختر الجامعة' : 'Select University'),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down_circle,
                      color: theme.primaryColor),
                  items: UniversitiesData.allUniversities.map((uni) {
                    return DropdownMenuItem(
                      value: uni,
                      child: Text(
                        uni.getName(isArabic),
                        style: TextStyle(color: theme.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedUniversity = val;
                      _selectedSpecialtyKey = null;
                      _tuitionFees = 0;
                    });
                  },
                  dropdownColor: theme.cardColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // عرض التخصصات كـ Chips (أزرار صغيرة) بدلاً من القائمة المنسدلة
            if (_selectedUniversity != null) ...[
              Text(
                isArabic ? 'اختر التخصص:' : 'Select Major:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: theme.textColor),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedUniversity!
                    .getSpecialties(isArabic)
                    .keys
                    .map((key) {
                  final isSelected = _selectedSpecialtyKey == key;
                  return ChoiceChip(
                    label: Text(key),
                    selected: isSelected,
                    selectedColor: theme.primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? theme.primaryColor : theme.textColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? theme.primaryColor
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedSpecialtyKey = key;
                        String priceText =
                            _selectedUniversity!.getSpecialties(isArabic)[key]!;
                        _tuitionFees = _parsePrice(priceText);
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 30),

            // 2. قسم السكن والمعيشة (Sliders)
            _buildSectionHeader(
              title: isArabic
                  ? 'خيارات المعيشة (شهرياً)'
                  : 'Living Options (Monthly)',
              icon: Icons.settings_accessibility,
              theme: theme,
            ),

            _buildSliderCard(
              label:
                  isArabic ? 'تكلفة السكن المتوقعة' : 'Expected Housing Cost',
              value: _accommodationCost,
              min: 50,
              max: 400,
              divisions: 7,
              icon: Icons.home,
              color: Colors.orange,
              theme: theme,
              onChanged: (val) => setState(() => _accommodationCost = val),
            ),

            const SizedBox(height: 16),

            _buildSliderCard(
              label: isArabic
                  ? 'مصروف المعيشة (أكل/مواصلات)'
                  : 'Living Expenses (Food/Transport)',
              value: _livingCost,
              min: 50,
              max: 500,
              divisions: 9,
              icon: Icons.shopping_cart,
              color: Colors.green,
              theme: theme,
              onChanged: (val) => setState(() => _livingCost = val),
            ),

            const SizedBox(height: 30),

            // 3. كرت النتيجة النهائية
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isArabic ? 'إجمالي السنة الأولى' : 'Total First Year',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16, letterSpacing: 1),
                  ),
                  const SizedBox(height: 5),
                  // عداد بسيط للرقم
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: totalFirstYear),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Text(
                        '\$${value.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.white24, height: 30),

                  // تفاصيل الفاتورة
                  _buildCostRow(isArabic ? 'الرسوم الدراسية' : 'Tuition Fees',
                      _tuitionFees, Colors.white),
                  _buildCostRow(isArabic ? 'السكن (12 شهر)' : 'Housing (12 Mo)',
                      yearlyAccommodation, Colors.white70),
                  _buildCostRow(
                      isArabic ? 'المعيشة (12 شهر)' : 'Living (12 Mo)',
                      yearlyLiving,
                      Colors.white70),
                  _buildCostRow(
                      isArabic ? 'رسوم التأشيرة والتأمين' : 'Visa & Insurance',
                      _visaAndInsurance,
                      Colors.white70),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ملاحظة في الأسفل
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'هذه الأرقام تقديرية وقد تختلف قليلاً حسب سعر الصرف.'
                        : 'Figures are estimates and may vary by exchange rates.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required ThemeProvider theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required Color color,
    required ThemeProvider theme,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: theme.textColor)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '\$${value.round()}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: '\$${value.round()}',
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 14)),
          Text('\$${amount.toStringAsFixed(0)}',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  double _parsePrice(String priceText) {
    try {
      final RegExp regex = RegExp(r'(\d+)');
      final match = regex.firstMatch(priceText);
      if (match != null) {
        return double.parse(match.group(0)!);
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
