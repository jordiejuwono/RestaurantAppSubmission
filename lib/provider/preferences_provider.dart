import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_submission_3/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;
  PreferencesProvider({required this.preferencesHelper}) {
    _getNotificationsPreferences();
  }

  bool _isNotificationsActive = false;
  bool get isNotificationsActive => _isNotificationsActive;

  void _getNotificationsPreferences() async {
    _isNotificationsActive = await preferencesHelper.isNotificationsActive;
    notifyListeners();
  }

  void enableNotifications(bool value) {
    preferencesHelper.setNotifications(value);
    _getNotificationsPreferences();
  }
}
