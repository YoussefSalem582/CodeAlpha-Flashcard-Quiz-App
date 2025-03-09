import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_flashcard_screen.dart';
import 'quiz_screen.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFlashcardScreen()),
                );
              },
              child: const Text('Add Flashcard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
              child: const Text('Start Quiz'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<FlashcardProvider>(context, listen: false).fetchFlashcards();
              },
              child: const Text('Fetch Questions from Internet'),
            ),
          ],
        ),
      ),
    );
  }
}