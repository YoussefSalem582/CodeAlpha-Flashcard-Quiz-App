import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider with ChangeNotifier {
  int _correctAnswers = 0;
  int _totalQuestions = 0;

  int get correctAnswers => _correctAnswers;
  int get totalQuestions => _totalQuestions;

  ProgressProvider() {
    _loadProgress();
  }

  void _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _correctAnswers = prefs.getInt('correctAnswers') ?? 0;
    _totalQuestions = prefs.getInt('totalQuestions') ?? 0;
    notifyListeners();
  }

  void updateProgress(int correct, int total) async {
    final prefs = await SharedPreferences.getInstance();
    _correctAnswers += correct;
    _totalQuestions += total;
    prefs.setInt('correctAnswers', _correctAnswers);
    prefs.setInt('totalQuestions', _totalQuestions);
    notifyListeners();
  }

  void resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _correctAnswers = 0;
    _totalQuestions = 0;
    prefs.setInt('correctAnswers', _correctAnswers);
    prefs.setInt('totalQuestions', _totalQuestions);
    notifyListeners();
  }
}