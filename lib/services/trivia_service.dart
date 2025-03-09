import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flashcard.dart';

class TriviaService {
  static const String _baseUrl = 'https://opentdb.com/api.php?amount=10&type=multiple';

  Future<List<Flashcard>> fetchQuestions() async {
    final response = await http.get(Uri.parse(_baseUrl));

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