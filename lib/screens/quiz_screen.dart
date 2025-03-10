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
  bool _isLoading = true;
  bool _showHint = false;
  int _timeLeft = 30; // Time per question in seconds
  late AnimationController _slideController;
  late AnimationController _timeController;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _loadQuestions();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(() {
      setState(() {
        _timeLeft = (30 * (1 - _timeController.value)).ceil();
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleAnswer(false);
      }
    });
  }

  Future<List<Flashcard>> _loadQuestions() async {
    try {
      setState(() => _isLoading = true);
      final questions = await TriviaService().fetchQuestions(
        category: widget.category,
      );
      setState(() {
        _flashcards = questions;
        _isLoading = false;
      });
      _startTimer();
      return questions;
    } catch (e) {
      setState(() => _isLoading = false);
      throw Exception('Failed to load questions: $e');
    }
  }

  void _startTimer() {
    _timeController.reset();
    _timeController.forward();
  }

  void _handleAnswer(bool correct) {
    _timeController.stop();

    if (correct) {
      setState(() => _score++);
      _showFeedback(true);
    } else {
      _incorrectFlashcards.add(_flashcards[_currentIndex]);
      _showFeedback(false);
    }
  }

  void _showFeedback(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isCorrect ? Colors.green[100] : Colors.red[100],
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(isCorrect ? 'Correct!' : 'Incorrect'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Answer: ${_flashcards[_currentIndex].answer}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 8),
              const Text('Explanation:'),
              Text(_flashcards[_currentIndex].explanation ?? 'No explanation available'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_currentIndex < _flashcards.length - 1) {
                setState(() {
                  _currentIndex++;
                  _showHint = false;
                });
                _startTimer();
                _slideController.reset();
              } else {
                _showResults();
              }
            },
            child: Text(
              _currentIndex < _flashcards.length - 1 ? 'Next Question' : 'See Results',
              style: TextStyle(
                color: isCorrect ? Colors.green[900] : Colors.red[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResults() {
    final percentage = (_score / _flashcards.length) * 100;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              percentage >= 70 ? Icons.emoji_events : Icons.school,
              size: 48,
              color: percentage >= 70 ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 8),
            const Text('Quiz Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScoreWidget(
              score: _score,
              total: _flashcards.length,
            ),
            const SizedBox(height: 16),
            Text(
              'Time taken: ${_calculateTotalTime()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (_incorrectFlashcards.isNotEmpty)
              ElevatedButton.icon(
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
                icon: const Icon(Icons.refresh),
                label: const Text('Review Incorrect Answers'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _incorrectFlashcards.clear();
                _flashcardsFuture = _loadQuestions();
              });
              Navigator.pop(context);
            },
            icon: const Icon(Icons.replay),
            label: const Text('Retry Quiz'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.popUntil(
              context,
                  (route) => route.isFirst,
            ),
            icon: const Icon(Icons.home),
            label: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String _calculateTotalTime() {
    final totalSeconds = 30 * _flashcards.length - _timeLeft;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  void dispose() {
    _slideController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () => setState(() => _showHint = !_showHint),
            tooltip: 'Show/Hide Hint',
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading ${widget.category} questions...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _flashcardsFuture = _loadQuestions();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No questions available for this category'),
            );
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentIndex + 1}/${_flashcards.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _timeLeft > 10 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '$_timeLeft s',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_showHint && _flashcards[_currentIndex].hint != null)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.yellow[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_flashcards[_currentIndex].hint!),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PageTransitionSwitcher(
                    transitionBuilder: (child, animation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                    child: FlashcardWidget(
                      key: ValueKey(_currentIndex),
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