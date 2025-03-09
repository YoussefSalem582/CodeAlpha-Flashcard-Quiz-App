import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/flashcard.dart';
import 'screens/home_screen.dart';

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

  List<Flashcard> get flashcards => _flashcards;

  void addFlashcard(Flashcard flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }
}