// test/models/flashcard_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard_quiz_app/models/flashcard.dart';

void main() {
  test('Flashcard model test', () {
    final flashcard = Flashcard(
      question: 'What is Flutter?',
      answer: 'A UI toolkit',
      type: FlashcardType.multipleChoice,
      options: ['A UI toolkit', 'A programming language', 'A database', 'A framework'],
    );

    expect(flashcard.question, 'What is Flutter?');
    expect(flashcard.answer, 'A UI toolkit');
  });
}