import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final Function(bool) onNext;
  final bool showCorrectAnswer;

  const FlashcardWidget({
    required this.flashcard,
    required this.onNext,
    this.showCorrectAnswer = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                flashcard.question,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (flashcard.type == FlashcardType.trueFalse) ...[
            ElevatedButton(
              onPressed: () => onNext(flashcard.answer == 'True'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: showCorrectAnswer && flashcard.answer == 'True' ? Colors.green : null,
              ),
              child: const Text('True', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onNext(flashcard.answer == 'False'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: showCorrectAnswer && flashcard.answer == 'False' ? Colors.green : null,
              ),
              child: const Text('False', style: TextStyle(fontSize: 18)),
            ),
          ] else if (flashcard.type == FlashcardType.multipleChoice) ...[
            ...flashcard.options!.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => onNext(flashcard.answer == option),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: showCorrectAnswer && flashcard.answer == option ? Colors.green : null,
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}