import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';
import '../services/trivia_service.dart';

class FlashcardProvider with ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  final TriviaService _triviaService = TriviaService();

  List<Flashcard> get flashcards => _flashcards;

  FlashcardProvider() {
    _loadFlashcards();
  }

  void addFlashcard(Flashcard flashcard) {
    _flashcards.add(flashcard);
    _saveFlashcards();
    notifyListeners();
  }

  Future<void> fetchFlashcards({required String category}) async {
    final flashcards = await _triviaService.fetchQuestions(category: category);
    _flashcards.addAll(flashcards);
    _saveFlashcards();
    notifyListeners();
  }

  Future<void> _saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final flashcardsJson = jsonEncode(_flashcards.map((f) => f.toJson()).toList());
    prefs.setString('flashcards', flashcardsJson);
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getString('flashcards');
    if (flashcardsJson != null) {
      final List<dynamic> flashcardsList = jsonDecode(flashcardsJson);
      _flashcards.clear();
      _flashcards.addAll(flashcardsList.map((json) => Flashcard.fromJson(json)).toList());
      notifyListeners();
    }
  }
}