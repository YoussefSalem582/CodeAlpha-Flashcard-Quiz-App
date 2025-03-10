import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flashcard.dart';

class TriviaService {
  static const List<String> difficulties = ['easy', 'medium', 'hard'];
  static const Map<String, String> _categoryUrls = {
    'CS Questions': 'https://opentdb.com/api.php?amount=10&category=18&type=multiple',
    'Flutter Questions': 'https://opentdb.com/api.php?amount=10&category=22&type=multiple',
    'ML Questions': 'https://opentdb.com/api.php?amount=10&category=23&type=multiple',
    'Math Questions': 'https://opentdb.com/api.php?amount=10&category=19&type=multiple',
    'English': 'https://opentdb.com/api.php?amount=10&category=25&type=multiple',
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