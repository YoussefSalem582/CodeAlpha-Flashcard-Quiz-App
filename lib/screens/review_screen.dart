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
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: incorrectFlashcards.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlashcardWidget(
                flashcard: incorrectFlashcards[index],
                onNext: (bool correct) {},
                showCorrectAnswer: true,
              ),
            ),
          );
        },
      ),
    );
  }
}