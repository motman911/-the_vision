import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Dialog(
      backgroundColor: themeProvider.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Directionality(
          textDirection:
              languageProvider.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageProvider.settings,
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // قسم اللغة
                _buildSectionTitle(
                  context,
                  languageProvider.languageText,
                  Icons.language,
                ),
                _buildLanguageOption(context, 'العربية', 'ar', Icons.language),
                _buildLanguageOption(context, 'English', 'en', Icons.translate),

                const SizedBox(height: 20),

                // قسم السمة
                _buildSectionTitle(
                  context,
                  languageProvider.themeText,
                  Icons.palette,
                ),
                _buildThemeOption(
                  context,
                  languageProvider.lightTheme,
                  AppTheme.light,
                  Icons.light_mode,
                ),
                _buildThemeOption(
                  context,
                  languageProvider.darkTheme,
                  AppTheme.dark,
                  Icons.dark_mode,
                ),
                _buildThemeOption(
                  context,
                  languageProvider.blueTheme,
                  AppTheme.blue,
                  Icons.water_drop,
                ),
                _buildThemeOption(
                  context,
                  languageProvider.greenTheme,
                  AppTheme.green,
                  Icons.nature,
                ),
                _buildThemeOption(
                  context,
                  languageProvider.orangeTheme,
                  AppTheme.orange,
                  Icons.brightness_auto,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageProvider.isArabic ? 'إغلاق' : 'Close',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeProvider.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String languageCode,
    IconData icon,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    bool isSelected = languageCode == 'ar'
        ? languageProvider.isArabic
        : !languageProvider.isArabic;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: themeProvider.textColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: themeProvider.textColor,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check, color: themeProvider.primaryColor)
            : null,
        onTap: () {
          languageProvider.setLanguage(languageCode);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: themeProvider.surfaceColor,
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    AppTheme theme,
    IconData icon,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = themeProvider.currentTheme == theme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isSelected ? themeProvider.primaryColor : themeProvider.textColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: isSelected
                ? themeProvider.primaryColor
                : themeProvider.textColor,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check, color: themeProvider.primaryColor)
            : null,
        onTap: () {
          themeProvider.setTheme(theme);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: themeProvider.surfaceColor,
      ),
    );
  }
}
