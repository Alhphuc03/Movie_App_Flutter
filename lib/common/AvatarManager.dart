// lib/common/global_manager.dart

import 'package:flutter/material.dart';

class AvtManager {
  static final ValueNotifier<String> avatarUrlNotifier = ValueNotifier<String>('');

  static String get avatarUrl => avatarUrlNotifier.value;

  static set avatarUrl(String url) {
    avatarUrlNotifier.value = url;
  }

  static void clearAvatarUrl() {
    avatarUrlNotifier.value = '';
  }
}
