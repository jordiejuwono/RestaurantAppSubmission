import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const RESTAURANT_NOTIFICATIONS = "RESTAURANT_NOTIFICATIONS";

  Future<bool> get isNotificationsActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(RESTAURANT_NOTIFICATIONS) ?? false;
  }

  void setNotifications(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(RESTAURANT_NOTIFICATIONS, value);
  }
}
