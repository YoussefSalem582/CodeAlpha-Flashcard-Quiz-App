import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../models/flashcard.dart';
import '../services/trivia_service.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/score_widget.dart';
import 'review_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({required this.category, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Flashcard>> _flashcardsFuture;
  final List<Flashcard> _incorrectFlashcards = [];
  List<Flashcard> _flashcards = [];
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _loadQuestions();
  }

  Future<List<Flashcard>> _loadQuestions() async {
    try {
      setState(() => _isLoading = true);
      final questions = await TriviaService().fetchQuestions(category: widget.category);
      setState(() {
        _flashcards = questions;
        _isLoading = false;
      });
      return questions;
    } catch (e) {
      setState(() => _isLoading = false);
      throw Exception('Failed to load questions: $e');
    }
  }

  void _handleAnswer(int index, bool correct) {
    setState(() {
      if (correct) {
        _score++;
      } else {
        _incorrectFlashcards.add(_flashcards[index]);
      }
      _flashcards[index] = _flashcards[index].copyWith(attempted: true);
    });
    _showFeedback(index, correct);
  }

  void _showFeedback(int index, bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Answer: ${_flashcards[index].answer}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Score: $_score/${_flashcards.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _flashcards.length,
            itemBuilder: (context, index) => _buildQuizCard(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showResults,
        label: const Text('Finish Quiz'),
        icon: const Icon(Icons.done),
      ),
    );
  }

  Widget _buildQuizCard(int index) {
    final flashcard = _flashcards[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: flashcard.attempted ? null : () => _showAnswerDialog(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: flashcard.attempted
                  ? [Colors.grey.shade200, Colors.grey.shade300]
                  : [Colors.blue.shade100, Colors.purple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${index + 1}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Text(
                    flashcard.question,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              if (flashcard.attempted)
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnswerDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Question ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_flashcards[index].question),
            const SizedBox(height: 16),
            if (_flashcards[index].hint != null) ...[
              Text(
                'Hint: ${_flashcards[index].hint}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleAnswer(index, false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Incorrect'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleAnswer(index, true);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Correct'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResults() {
    if (_flashcards.any((f) => !f.attempted)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Quiz'),
          content: const Text('Please answer all questions before finishing.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final percentage = (_score / _flashcards.length) * 100;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $_score/${_flashcards.length}'),
            Text('Percentage: ${percentage.toStringAsFixed(1)}%'),
            if (_incorrectFlashcards.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReviewScreen(incorrectFlashcards: _incorrectFlashcards),
                    ),
                  );
                },
                child: const Text('Review Incorrect Answers'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}

