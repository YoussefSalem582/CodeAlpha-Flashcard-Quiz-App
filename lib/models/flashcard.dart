enum FlashcardType {
  trueFalse,
  multipleChoice,
  matching,
  shortAnswer
}

class Flashcard {
  final String question;
  final String answer;
  final FlashcardType type;
  final List<String>? options;
  final String? hint;
  final String? explanation;
  final String? category;
  final int difficulty;
  final DateTime createdAt;
  final DateTime? lastReviewed;
  final int timesReviewed;
  final double successRate;

  Flashcard({
    required this.question,
    required this.answer,
    required this.type,
    this.options,
    this.hint,
    this.explanation,
    this.category,
    this.difficulty = 1,
    DateTime? createdAt,
    this.lastReviewed,
    this.timesReviewed = 0,
    this.successRate = 0.0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'type': type.name,
      'options': options,
      'hint': hint,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
      'lastReviewed': lastReviewed?.toIso8601String(),
      'timesReviewed': timesReviewed,
      'successRate': successRate,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'] as String,
      answer: json['answer'] as String,
      type: FlashcardType.values.byName(json['type'] as String),
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
      category: json['category'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastReviewed: json['lastReviewed'] != null
          ? DateTime.parse(json['lastReviewed'] as String)
          : null,
      timesReviewed: json['timesReviewed'] as int? ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Flashcard &&
              runtimeType == other.runtimeType &&
              question == other.question &&
              answer == other.answer &&
              type == other.type;

  @override
  int get hashCode => Object.hash(question, answer, type);

  @override
  String toString() => 'Flashcard(question: $question, type: $type)';
}