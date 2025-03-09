import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flashcard.dart';

class TriviaService {
  static const Map<String, String> _categoryUrls = {
    'CS Questions': 'https://api.example.com/cs_questions',
    'Flutter Questions': 'https://api.example.com/flutter_questions',
    'ML Questions': 'https://api.example.com/ml_questions',
    'Math Questions': 'https://api.example.com/math_questions',
    'English': 'https://api.example.com/english_questions',
  };

  Future<List<Flashcard>> fetchQuestions({required String category}) async {
    final url = _categoryUrls[category];
    if (url == null) {
      throw Exception('Invalid category');
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Flashcard> flashcards = [];

      for (var item in data['results']) {
        final options = List<String>.from(item['incorrect_answers']);
        options.add(item['correct_answer']);
        options.shuffle();

        flashcards.add(Flashcard(
          question: item['question'],
          answer: item['correct_answer'],
          type: FlashcardType.multipleChoice,
          options: options,
        ));
      }

      return flashcards;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}