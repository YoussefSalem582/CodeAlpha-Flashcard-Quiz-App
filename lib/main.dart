import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/flashcard.dart';
import 'screens/home_screen.dart';
import 'services/trivia_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FlashcardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flashcard Quiz App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class FlashcardProvider with ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  final TriviaService _triviaService = TriviaService();

  List<Flashcard> get flashcards => _flashcards;

  void addFlashcard(Flashcard flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }

  Future<void> fetchFlashcards() async {
    final flashcards = await _triviaService.fetchQuestions();
    _flashcards.addAll(flashcards);
    notifyListeners();
  }
}