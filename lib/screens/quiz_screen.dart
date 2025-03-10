import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/trivia_service.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/score_widget.dart';
import 'package:animations/animations.dart';
import 'package:confetti/confetti.dart';

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
  bool _isLoading = true;
  List<Flashcard> _flashcards = [];
  late AnimationController _controller;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _loadQuestions(); // Store the Future
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  Future<List<Flashcard>> _loadQuestions() async {
    try {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _flashcards.length,
              ),
              Expanded(
                child: OpenContainer(
                  openBuilder: (context, openContainer) {
                    return _QuizResults(
                      score: _score,
                      total: _flashcards.length,
                      onReview: () {
                        openContainer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                              incorrectFlashcards: _incorrectFlashcards,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  closedBuilder: (context, openContainer) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Question ${_currentIndex + 1}/${_flashcards.length}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Expanded(
                          child: FlashcardWidget(
                            flashcard: _flashcards[_currentIndex],
                            onNext: (bool isCorrect) {
                              setState(() {
                                if (isCorrect) {
                                  _score += 1;
                                  _confettiController.play();
                                } else {
                                  _incorrectFlashcards.add(_flashcards[_currentIndex]);
                                }
                                _currentIndex += 1;
                                if (_currentIndex == _flashcards.length) {
                                  openContainer();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
class _QuizResults extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onReview;

  const _QuizResults({
    required this.score,
    required this.total,
    required this.onReview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz Results',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ScoreWidget(
          score: score,
          total: total,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onReview,
          child: const Text('Review Incorrect Answers'),
        ),
      ],
    );
  }
}