import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String get sessionId => _preferences?.getString('sessionId') ?? '';

  static Future<void> saveSessionId(String sessionId) async {
    await _preferences?.setString('sessionId', sessionId);
  }

  static Future<void> clearSession() async {
    await _preferences?.remove('sessionId');
  }
}
