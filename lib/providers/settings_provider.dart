import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _option1 = false;
  bool _option2 = false;

  bool get option1 => _option1;
  bool get option2 => _option2;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _option1 = prefs.getBool('option1') ?? false;
    _option2 = prefs.getBool('option2') ?? false;
    notifyListeners();
  }

  void setOption1(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _option1 = value;
    prefs.setBool('option1', value);
    notifyListeners();
  }

  void setOption2(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _option2 = value;
    prefs.setBool('option2', value);
    notifyListeners();
  }
}