import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../main.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/score_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;

  void _nextFlashcard(bool correct) {
    if (correct) {
      _score++;
    }
    setState(() {
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = Provider.of<FlashcardProvider>(context).flashcards;

    if (_currentIndex >= flashcards.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Finished'),
        ),
        body: Center(
          child: ScoreWidget(score: _score, total: flashcards.length),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: FlashcardWidget(
          flashcard: flashcards[_currentIndex],
          onNext: _nextFlashcard,
        ),
      ),
    );
  }
}