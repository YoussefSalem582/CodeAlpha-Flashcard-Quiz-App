import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flashcard.dart';

class TriviaService {
  static const String _baseUrl = 'https://opentdb.com/api.php';

  static const Map<String, int> _categoryIds = {
    'Computer Science': 18,
    'Science': 17,
    'Mathematics': 19,
    'Geography': 22,
    'History': 23,
    'English': 10,
    'General Knowledge': 9,
    'Entertainment': 14,
  };

  Future<List<Flashcard>> fetchQuestions({
    required String category,
    int amount = 10,
    String difficulty = 'medium',
  }) async {
    try {
      final categoryId = _categoryIds[category];
      if (categoryId == null) {
        throw Exception('Invalid category: $category');
      }

      final url = Uri.parse('$_baseUrl').replace(queryParameters: {
        'amount': amount.toString(),
        'category': categoryId.toString(),
        'type': 'multiple',
        'difficulty': difficulty.toLowerCase(),
        'encode': 'base64', // To handle special characters
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['response_code'] != 0) {
          throw Exception('API Error: ${_getErrorMessage(data['response_code'])}');
        }

        final List<Flashcard> flashcards = [];
        for (var item in data['results']) {
          final question = _decodeBase64(item['question']);
          final correctAnswer = _decodeBase64(item['correct_answer']);
          final incorrectAnswers = (item['incorrect_answers'] as List)
              .map((e) => _decodeBase64(e))
              .toList();

          final options = List<String>.from(incorrectAnswers);
          options.add(correctAnswer);
          options.shuffle();

          flashcards.add(Flashcard(
            question: question,
            answer: correctAnswer,
            type: FlashcardType.multipleChoice,
            options: options,
          ));
        }

        return flashcards;
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  String _decodeBase64(String encoded) {
    try {
      return utf8.decode(base64.decode(encoded));
    } catch (e) {
      return encoded; // Return original if not base64 encoded
    }
  }

  String _getErrorMessage(int responseCode) {
    switch (responseCode) {
      case 1:
        return 'No results found';
      case 2:
        return 'Invalid parameter';
      case 3:
        return 'Session token not found';
      case 4:
        return 'Session token has retrieved all questions';
      default:
        return 'Unknown error';
    }
  }

  static List<String> get categories => _categoryIds.keys.toList();

  static List<String> get difficulties => ['easy', 'medium', 'hard'];
}