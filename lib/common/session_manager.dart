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

  static String get accountId => _preferences?.getString('accountId') ?? '';

  static Future<void> saveAccountId(String accountId) async {
    await _preferences?.setString('accountId', accountId);
  }

  static Future<void> clearSession() async {
    await _preferences?.remove('sessionId');
    await _preferences?.remove('accountId');
  }

//lịch sử xem phim
  static Future<void> addToWatchHistory(int movieId) async {
    List<String> watchHistory =
        _preferences?.getStringList('watchHistory_$accountId') ?? [];
    if (!watchHistory.contains(movieId.toString())) {
      watchHistory.add(movieId.toString());
      await _preferences?.setStringList(
          'watchHistory_$accountId', watchHistory);
    }
  }

  static List<int> getWatchHistory() {
    List<String> watchHistory =
        _preferences?.getStringList('watchHistory_$accountId') ?? [];
    return watchHistory.map((id) => int.parse(id)).toList();
  }
}
