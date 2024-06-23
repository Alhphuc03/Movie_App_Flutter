import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/widgets/App_Bar.dart';

const kBackgroundColor = Color.fromARGB(255, 0, 0, 0);
const kPrimaryColorRed = Color(0xFFEA4335);

const Color kDarkModeBackgroundColor = Colors.black;
const Color kLightModeBackgroundColor = Color.fromARGB(255, 255, 255, 255);

const Color kDarkModeCardColor = Color(0xFF3C4043);
const Color kLightModeCardColor = Color(0xDADADA);

const Color kVietnameseModeBackgroundColor = Color(0xFFECEFF1);
const Color kVietnameseModeCardColor = Color(0xFFC5CAE9);

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isEnglishDefault = LanguageManager.getDefaultLanguage();
  final List<String> _languages = [
    'English',
    'Vietnamese',
  ];

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor:
          isDarkMode ? kDarkModeBackgroundColor : kLightModeBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildListTile(
              icon: Icons.language,
              title: 'Default Language', // Tiêu đề cho DropdownButton
              subtitle:
                  'Select default app language', // Mô tả cho DropdownButton
              child: DropdownButton<bool>(
                value: _isEnglishDefault,
                icon: Icon(Icons.arrow_downward,
                    color: _isEnglishDefault
                        ? (isDarkMode
                            ? Colors.white
                            : Colors
                                .black) // Màu sắc chữ khi tiếng Anh được chọn
                        : (isDarkMode
                            ? Colors.white
                            : Colors
                                .black)), // Màu sắc chữ khi tiếng Việt được chọn
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: _isEnglishDefault
                        ? (isDarkMode
                            ? Colors.white
                            : Colors
                                .black) // Màu sắc chữ khi tiếng Anh được chọn
                        : (isDarkMode
                            ? Colors.white
                            : Colors
                                .black)), // Màu sắc chữ khi tiếng Việt được chọn
                underline: Container(
                    height: 2,
                    color: _isEnglishDefault
                        ? (isDarkMode
                            ? Colors.white
                            : Colors
                                .black) // Màu sắc chữ khi tiếng Anh được chọn
                        : (isDarkMode
                            ? Colors.white
                            : Colors
                                .black)), // Màu sắc chữ khi tiếng Việt được chọn
                onChanged: (bool? isEnglish) {
                  setState(() {
                    _isEnglishDefault = isEnglish!;
                    LanguageManager.setDefaultLanguage(isEnglish);
                  });
                },
                items: _languages.map<DropdownMenuItem<bool>>((String value) {
                  return DropdownMenuItem<bool>(
                    value: value == 'English',
                    child: Text(value),
                  );
                }).toList(),
              ),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 20),
            _buildListTile(
              icon: Icons.brightness_6,
              title: 'Theme', // Tiêu đề cho Switch
              subtitle: 'Toggle light/dark mode', // Mô tả cho Switch
              child: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeNotifier.toggleTheme();
                },
                activeColor: kPrimaryColorRed,
              ),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
    required bool isDarkMode,
  }) {
    bool isVietnameseMode = !_isEnglishDefault;

    return Card(
      color: isDarkMode ? kDarkModeCardColor : kLightModeCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColorRed),
        title: Text(
          isVietnameseMode
              ? 'Ngôn ngữ mặc định'
              : title, // Hiển thị tiêu đề dựa trên ngôn ngữ
          style: TextStyle(
            color: isVietnameseMode
                ? (isDarkMode
                    ? Colors.white
                    : Colors.black) // Màu sắc chữ khi tiếng Anh được chọn
                : (isDarkMode
                    ? Colors.white
                    : Colors.black), // Màu sắc chữ khi tiếng Việt được chọn
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          isVietnameseMode
              ? 'Chọn ngôn ngữ ứng dụng'
              : subtitle, // Hiển thị mô tả dựa trên ngôn ngữ
          style: TextStyle(
            color: isVietnameseMode
                ? (isDarkMode
                    ? Colors.white
                    : Colors.black) // Màu sắc chữ khi tiếng Anh được chọn
                : (isDarkMode
                    ? Colors.white
                    : Colors.black), // Màu sắc chữ khi tiếng Việt được chọn
          ),
        ),
        trailing: child,
      ),
    );
  }
}
