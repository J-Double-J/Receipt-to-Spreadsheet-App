import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProxy extends ChangeNotifier {
  late SharedPreferences _prefs;
  static final SharedPreferencesProxy _proxy =
      SharedPreferencesProxy._internal();

  factory SharedPreferencesProxy() {
    return _proxy;
  }

  SharedPreferencesProxy._internal() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  dynamic get(String key) {
    return _prefs.get(key);
  }

  Future<bool> set(String key, dynamic value) async {
    bool success = false;
    if (value is String) {
      success = await _prefs.setString(key, value);
    } else if (value is int) {
      success = await _prefs.setInt(key, value);
    } else if (value is double) {
      success = await _prefs.setDouble(key, value);
    } else if (value is bool) {
      success = await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      success = await _prefs.setStringList(key, value);
    }
    if (success) {
      notifyListeners();
    }
    return success;
  }
}
