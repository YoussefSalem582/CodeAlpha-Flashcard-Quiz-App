import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

class SettingsProvider with ChangeNotifier {
  bool _option1 = false;
  bool _option2 = false;
  Category _category = Category.csQuestions;
  String _difficulty = 'easy';

  bool get option1 => _option1;
  bool get option2 => _option2;
  Category get category => _category;
  String get difficulty => _difficulty;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _option1 = prefs.getBool('option1') ?? false;
    _option2 = prefs.getBool('option2') ?? false;
    _category = Category.values[prefs.getInt('category') ?? 0];
    _difficulty = prefs.getString('difficulty') ?? 'easy';
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

  void setCategory(Category value) async {
    final prefs = await SharedPreferences.getInstance();
    _category = value;
    prefs.setInt('category', value.index);
    notifyListeners();
  }

  void setDifficulty(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _difficulty = value;
    prefs.setString('difficulty', value);
    notifyListeners();
  }
}