import 'package:flutter/material.dart';

class LanguageManager {
  static bool isEnglishDefault = true; // Default language is English

  static Future<void> init() async {
    // Initialize session if needed
  }

  static void setDefaultLanguage(bool isEnglish) {
    isEnglishDefault = isEnglish;
    // You can save isEnglishDefault to persistent storage here if needed
  }

  static bool getDefaultLanguage() {
    return isEnglishDefault;
  }

  static String getLanguage() {
    return isEnglishDefault ? 'English' : 'Vietnamese';
  }

  // Add a method to check if current language is Vietnamese
  static bool isVietnamese() {
    return !isEnglishDefault;
  }
}
