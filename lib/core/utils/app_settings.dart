import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String keyTheme = 'app_theme';
  static const String keyBiometrics = 'app_biometrics';
  static const String keyNotifications = 'app_notifications';
  static const String keyUserName = 'user_name';

  static Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyTheme, theme);
  }

  static Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyTheme) ?? 'system';
  }

  static Future<void> setBiometrics(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyBiometrics, enabled);
  }

  static Future<bool> getBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyBiometrics) ?? false;
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserName, name);
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserName) ?? 'Student';
  }
}
