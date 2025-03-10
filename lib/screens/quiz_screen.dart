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

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late Future<List<Flashcard>> _flashcardsFuture;
  final List<Flashcard> _incorrectFlashcards = [];
  int _currentIndex = 0;
  int _score = 0;
  List<Flashcard> _flashcards = [];
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _loadQuestions();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<List<Flashcard>> _loadQuestions() async {
    try {
      final questions = await TriviaService().fetchQuestions(
        category: widget.category,
      );
      setState(() => _flashcards = questions);
      return questions;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  void _handleAnswer(bool correct) {
    if (correct) {
      setState(() => _score++);
    } else {
      _incorrectFlashcards.add(_flashcards[_currentIndex]);
    }

    if (_currentIndex < _flashcards.length - 1) {
      _slideController.forward().then((_) {
        setState(() {
          _currentIndex++;
          _slideController.reset();
        });
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScoreWidget(
              score: _score,
              total: _flashcards.length,
            ),
            const SizedBox(height: 16),
            if (_incorrectFlashcards.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        incorrectFlashcards: _incorrectFlashcards,
                      ),
                    ),
                  );
                },
                child: const Text('Review Incorrect Answers'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(
              context,
                  (route) => route.isFirst,
            ),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _flashcardsFuture = _loadQuestions();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _flashcards.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Question ${_currentIndex + 1}/${_flashcards.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-1.0, 0.0),
                  ).animate(_slideController),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FlashcardWidget(
                      flashcard: _flashcards[_currentIndex],
                      onNext: _handleAnswer,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}