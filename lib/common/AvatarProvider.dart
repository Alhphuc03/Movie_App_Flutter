import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xemphim/common/AvatarManager.dart';

class AvatarProvider extends ChangeNotifier {
  String _avatarUrl = '';

  String get avatarUrl => _avatarUrl;

  void updateAvatarUrl(String newAvatarUrl) {
    _avatarUrl = newAvatarUrl;
    notifyListeners();
  }
}