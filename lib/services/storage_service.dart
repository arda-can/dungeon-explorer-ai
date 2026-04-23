import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLevelProgress(int levelId, int stars) async {
    await _prefs.setInt('level_${levelId}_stars', stars);
    await _prefs.setBool('level_${levelId}_completed', true);
  }

  static int getLevelStars(int levelId) {
    return _prefs.getInt('level_${levelId}_stars') ?? 0;
  }

  static bool isLevelCompleted(int levelId) {
    return _prefs.getBool('level_${levelId}_completed') ?? false;
  }

  static bool isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;
    return isLevelCompleted(levelId - 1);
  }

  static Future<void> clearAllProgress() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
