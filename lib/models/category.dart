// lib/models/category.dart
enum Category {
  csQuestions,
  flutterQuestions,
  mlQuestions,
  mathQuestions,
  english,
  customFlashcards,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.csQuestions:
        return 'CS Questions';
      case Category.flutterQuestions:
        return 'Flutter Questions';
      case Category.mlQuestions:
        return 'ML Questions';
      case Category.mathQuestions:
        return 'Math Questions';
      case Category.english:
        return 'English';
      case Category.customFlashcards:
        return 'Custom Flashcards';
      default:
        return '';
    }
  }
}