import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/widgets/App_Bar.dart';

const kPrimaryColorRed = Color(0xFFEA4335);

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var languageManager = Provider.of<LanguageManager>(context);
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    bool isVietnameseMode = languageManager.isVietnamese();

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildLanguageSelector(
                context, languageManager, isDarkMode, isVietnameseMode),
            SizedBox(height: 20),
            _buildThemeSwitch(
                context, themeNotifier, isDarkMode, isVietnameseMode),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context,
      LanguageManager languageManager, bool isDarkMode, bool isVietnameseMode) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.language, color: kPrimaryColorRed),
        title: Text(
          languageManager.isEnglishDefault ? 'English' : 'Vietnamese',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          isVietnameseMode
              ? 'Chọn ngôn ngữ cho app'
              : 'Select default app language',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
            fontSize: 14,
          ),
        ),
        trailing: DropdownButton<bool>(
          value: languageManager.isEnglishDefault,
          icon: Icon(Icons.arrow_drop_down,
              color: isDarkMode ? Colors.white : Colors.black),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
          onChanged: (bool? isEnglish) {
            languageManager.setDefaultLanguage(isEnglish!);
          },
          items: [
            DropdownMenuItem<bool>(
              value: true,
              child: Text('English'),
            ),
            DropdownMenuItem<bool>(
              value: false,
              child: Text('Vietnamese'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context, ThemeNotifier themeNotifier,
      bool isDarkMode, bool isVietnameseMode) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.brightness_6, color: kPrimaryColorRed),
        title: Text(
          isVietnameseMode ? 'Giao diện' : 'Theme',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          isVietnameseMode ? 'Sáng/tối' : 'Toggle light/dark mode',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
            fontSize: 14,
          ),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
          activeColor: kPrimaryColorRed,
        ),
      ),
    );
  }
}
