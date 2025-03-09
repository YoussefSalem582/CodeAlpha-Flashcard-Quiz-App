enum FlashcardType { trueFalse, multipleChoice }

class Flashcard {
  final String question;
  final String answer;
  final FlashcardType type;
  final List<String>? options;

  Flashcard({
    required this.question,
    required this.answer,
    required this.type,
    this.options,
  });
}