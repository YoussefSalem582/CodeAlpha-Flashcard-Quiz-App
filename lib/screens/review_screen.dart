import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../widgets/flashcard_widget.dart';

class ReviewScreen extends StatelessWidget {
  final List<Flashcard> incorrectFlashcards;

  const ReviewScreen({required this.incorrectFlashcards, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Incorrect Answers'),
      ),
      body: ListView.builder(
        itemCount: incorrectFlashcards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlashcardWidget(
              flashcard: incorrectFlashcards[index],
              onNext: (bool correct) {},
            ),
          );
        },
      ),
    );
  }
}