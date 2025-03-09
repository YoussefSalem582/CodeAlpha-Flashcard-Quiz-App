import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../main.dart';

class AddFlashcardScreen extends StatelessWidget {
  const AddFlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            ElevatedButton(
              onPressed: () {
                final question = questionController.text;
                final answer = answerController.text;

                if (question.isNotEmpty && answer.isNotEmpty) {
                  final flashcard = Flashcard(question: question, answer: answer);
                  Provider.of<FlashcardProvider>(context, listen: false).addFlashcard(flashcard);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}