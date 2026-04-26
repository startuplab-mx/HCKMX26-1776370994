import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences for app-level flags.
///
/// All keys are centralised here so they are easy to audit.
class LocalPrefs {
  LocalPrefs._();

  static const _keyWelcomeSeen = 'welcome_seen';
  static const _keyDukiIntroSeen = 'duki_intro_seen';
  static const _keyNavigationTutorialSeen = 'navigation_tutorial_seen';
  static const _keyMandatoryLessonsCompleted = 'mandatory_lessons_completed';

  // ── welcome_seen ─────────────────────────────────────────────────────────

  static Future<bool> isWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyWelcomeSeen) ?? false;
  }

  static Future<void> setWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWelcomeSeen, true);
  }

  // ── duki_intro_seen ───────────────────────────────────────────────────────

  static Future<bool> isDukiIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDukiIntroSeen) ?? false;
  }

  static Future<void> setDukiIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDukiIntroSeen, true);
  }

  // ── navigation_tutorial_seen ──────────────────────────────────────────────

  static Future<bool> isNavigationTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNavigationTutorialSeen) ?? false;
  }

  static Future<void> setNavigationTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNavigationTutorialSeen, true);
  }

  // ── mandatory_lessons_completed ───────────────────────────────────────────

  static Future<bool> isMandatoryLessonsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyMandatoryLessonsCompleted) ?? false;
  }

  static Future<void> setMandatoryLessonsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMandatoryLessonsCompleted, true);
  }
}
