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

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'type': type.toString(),
      'options': options,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
      type: FlashcardType.values.firstWhere((e) => e.toString() == json['type']),
      options: json['options'] != null ? List<String>.from(json['options']) : null,
    );
  }
}