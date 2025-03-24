import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';
import '../services/trivia_service.dart';

class FlashcardProvider with ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  final TriviaService _triviaService = TriviaService();
  bool _isLoading = false;
  String? _error;
  static const _storageKey = 'flashcards';

  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);
  bool get isLoading => _isLoading;
  String? get error => _error;

  FlashcardProvider() {
    _initializeFlashcards();
  }

  Future<void> _initializeFlashcards() async {
    try {
      await _loadFlashcards();
    } catch (e) {
      _setError('Failed to load flashcards: $e');
    }
  }

  void addFlashcard(Flashcard flashcard) {
    try {
      _flashcards.add(flashcard);
      _saveFlashcards();
      notifyListeners();
    } catch (e) {
      _setError('Failed to add flashcard: $e');
    }
  }

  void removeFlashcard(Flashcard flashcard) {
    try {
      _flashcards.remove(flashcard);
      _saveFlashcards();
      notifyListeners();
    } catch (e) {
      _setError('Failed to remove flashcard: $e');
    }
  }

  void updateFlashcard(Flashcard oldCard, Flashcard newCard) {
    try {
      final index = _flashcards.indexOf(oldCard);
      if (index != -1) {
        _flashcards[index] = newCard;
        _saveFlashcards();
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update flashcard: $e');
    }
  }

  Future<void> fetchFlashcards({required String category}) async {
    try {
      _setLoading(true);
      _clearError();

      final flashcards = await _triviaService.fetchQuestions(category: category);
      _flashcards.addAll(flashcards);
      await _saveFlashcards();

      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch flashcards: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearFlashcards() async {
    try {
      _flashcards.clear();
      await _saveFlashcards();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear flashcards: $e');
    }
  }

  List<Flashcard> getFlashcardsByCategory(String category) {
    return _flashcards
        .where((flashcard) => flashcard.category == category)
        .toList();
  }

  Future<void> _saveFlashcards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final flashcardsJson = jsonEncode(
        _flashcards.map((f) => f.toJson()).toList(),
      );
      await prefs.setString(_storageKey, flashcardsJson);
    } catch (e) {
      _setError('Failed to save flashcards: $e');
      rethrow;
    }
  }

  Future<void> _loadFlashcards() async {
    try {
      _setLoading(true);
      _clearError();

      final prefs = await SharedPreferences.getInstance();
      final flashcardsJson = prefs.getString(_storageKey);

      if (flashcardsJson != null) {
        final List<dynamic> flashcardsList = jsonDecode(flashcardsJson);
        _flashcards.clear();
        _flashcards.addAll(
          flashcardsList
              .map((json) => Flashcard.fromJson(json as Map<String, dynamic>))
              .toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load flashcards: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _saveFlashcards(); // Save data before disposing
    super.dispose();
  }
}

