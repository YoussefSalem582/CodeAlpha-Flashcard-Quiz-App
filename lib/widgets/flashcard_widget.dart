import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final Function(bool) onNext;

  const FlashcardWidget({required this.flashcard, required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(flashcard.question, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => onNext(true),
          child: const Text('Correct'),
        ),
        ElevatedButton(
          onPressed: () => onNext(false),
          child: const Text('Incorrect'),
        ),
      ],
    );
  }
}