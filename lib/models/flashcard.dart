enum FlashcardType {
  trueFalse,
  multipleChoice,
  matching,
  shortAnswer;

  bool get requiresOptions => this == multipleChoice || this == matching;
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
  final int? selectedChoiceIndex;
  final int? correctChoiceIndex;
  final bool attempted;
  final bool? isCorrect;

  const Flashcard._({
    required this.question,
    required this.answer,
    required this.type,
    this.options,
    this.hint,
    this.explanation,
    this.category,
    required this.difficulty,
    required this.createdAt,
    this.lastReviewed,
    required this.timesReviewed,
    required this.successRate,
    this.selectedChoiceIndex,
    this.correctChoiceIndex,
    required this.attempted,
    this.isCorrect,
  });

  factory Flashcard({
    required String question,
    required String answer,
    required FlashcardType type,
    List<String>? options,
    String? hint,
    String? explanation,
    String? category,
    int difficulty = 1,
    DateTime? createdAt,
    DateTime? lastReviewed,
    int timesReviewed = 0,
    double successRate = 0.0,
    int? selectedChoiceIndex,
    int? correctChoiceIndex,
    bool attempted = false,
    bool? isCorrect,
  }) {
    // Validate inputs
    if (question.trim().isEmpty) {
      throw ArgumentError('Question cannot be empty');
    }
    if (answer.trim().isEmpty) {
      throw ArgumentError('Answer cannot be empty');
    }
    if (type.requiresOptions && (options == null || options.isEmpty)) {
      throw ArgumentError('Options are required for ${type.name} questions');
    }
    if (difficulty < 1 || difficulty > 5) {
      throw ArgumentError('Difficulty must be between 1 and 5');
    }
    if (successRate < 0.0 || successRate > 1.0) {
      throw ArgumentError('Success rate must be between 0.0 and 1.0');
    }

    return Flashcard._(
      question: question.trim(),
      answer: answer.trim(),
      type: type,
      options: options?.map((e) => e.trim()).toList(),
      hint: hint?.trim(),
      explanation: explanation?.trim(),
      category: category?.trim(),
      difficulty: difficulty,
      createdAt: createdAt ?? DateTime.now(),
      lastReviewed: lastReviewed,
      timesReviewed: timesReviewed,
      successRate: successRate,
      selectedChoiceIndex: selectedChoiceIndex,
      correctChoiceIndex: correctChoiceIndex,
      attempted: attempted,
      isCorrect: isCorrect,
    );
  }

  List<String> get choices => options ?? [];

  bool get hasOptions => options != null && options!.isNotEmpty;

  bool get isAnswered => attempted && isCorrect != null;

  double get difficultyPercentage => difficulty / 5.0;

  Flashcard copyWith({
    String? question,
    String? answer,
    FlashcardType? type,
    List<String>? options,
    String? hint,
    String? explanation,
    String? category,
    int? difficulty,
    DateTime? createdAt,
    DateTime? lastReviewed,
    int? timesReviewed,
    double? successRate,
    int? selectedChoiceIndex,
    int? correctChoiceIndex,
    bool? attempted,
    bool? isCorrect,
  }) {
    return Flashcard(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      type: type ?? this.type,
      options: options ?? this.options,
      hint: hint ?? this.hint,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      successRate: successRate ?? this.successRate,
      selectedChoiceIndex: selectedChoiceIndex ?? this.selectedChoiceIndex,
      correctChoiceIndex: correctChoiceIndex ?? this.correctChoiceIndex,
      attempted: attempted ?? this.attempted,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() => {
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
    'selectedChoiceIndex': selectedChoiceIndex,
    'correctChoiceIndex': correctChoiceIndex,
    'attempted': attempted,
    'isCorrect': isCorrect,
  };

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    try {
      return Flashcard(
        question: json['question'] as String,
        answer: json['answer'] as String,
        type: FlashcardType.values.byName(json['type'] as String),
        options: (json['options'] as List<dynamic>?)?.cast<String>(),
        hint: json['hint'] as String?,
        explanation: json['explanation'] as String?,
        category: json['category'] as String?,
        difficulty: (json['difficulty'] as int?)?.clamp(1, 5) ?? 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastReviewed: json['lastReviewed'] != null
            ? DateTime.parse(json['lastReviewed'] as String)
            : null,
        timesReviewed: json['timesReviewed'] as int? ?? 0,
        successRate: ((json['successRate'] as num?)?.toDouble() ?? 0.0).clamp(0.0, 1.0),
        selectedChoiceIndex: json['selectedChoiceIndex'] as int?,
        correctChoiceIndex: json['correctChoiceIndex'] as int?,
        attempted: json['attempted'] as bool? ?? false,
        isCorrect: json['isCorrect'] as bool?,
      );
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }
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
  String toString() => 'Flashcard(question: $question, type: $type, attempted: $attempted)';
}