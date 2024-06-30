import 'package:flutter/material.dart';

class LanguageManager with ChangeNotifier {
  bool _isEnglishDefault = true; // Default language is English

  bool get isEnglishDefault => _isEnglishDefault;

  void setDefaultLanguage(bool isEnglish) {
    _isEnglishDefault = isEnglish;
    notifyListeners(); // Notify listeners that the language has changed
  }

  bool isVietnamese() {
    return !isEnglishDefault;
  }

  String getLanguageCode() {
    return _isEnglishDefault ? 'en' : 'vi';
  }
}
