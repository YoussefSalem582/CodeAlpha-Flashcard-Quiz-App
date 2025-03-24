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
  int _timeLeft = 30;
  late AnimationController _slideController;
  late AnimationController _timeController;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _loadQuestions();
    _initializeAnimationControllers();
  }

  void _initializeAnimationControllers() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _timeController =
    AnimationController(vsync: this, duration: const Duration(seconds: 30))
      ..addListener(() {
        setState(() {
          _timeLeft = (30 * (1 - _timeController.value)).ceil();
        });
      })
      ..addStatusListener((status) {
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
    _timeController
      ..reset()
      ..forward();
  }

  void _handleAnswer(bool correct) {
    _timeController.stop();
    if (correct) {
      setState(() => _score++);
    } else {
      _incorrectFlashcards.add(_flashcards[_currentIndex]);
    }
    _showFeedback(correct);
  }

  void _showFeedback(bool isCorrect) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: bottomPadding,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.8,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCorrect
                    ? [Colors.green.shade300, Colors.green.shade500]
                    : [Colors.red.shade300, Colors.red.shade500],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isCorrect ? 'Correct!' : 'Incorrect',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Answer: ${_flashcards[_currentIndex].answer}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          if (!isCorrect &&
                              _flashcards[_currentIndex].explanation != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Explanation:',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _flashcards[_currentIndex].explanation!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isCorrect ? Colors.green : Colors.red,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentIndex < _flashcards.length - 1
                          ? 'Next Question'
                          : 'See Results',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResults() {
    final percentage = (_score / _flashcards.length) * 100;
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 16,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.85,
            maxHeight: screenSize.height * 0.7,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: percentage >= 70
                  ? [Colors.blue.shade400, Colors.purple.shade400]
                  : [Colors.orange.shade400, Colors.red.shade400],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Adaptive Header
                CircleAvatar(
                  radius: screenSize.width < 360 ? 28 : 36,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    percentage >= 70 ? Icons.emoji_events : Icons.school,
                    size: screenSize.width < 360 ? 32 : 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quiz Complete!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Adaptive Score Card
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ScoreWidget(score: _score, total: _flashcards.length),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                'Time: ${_calculateTotalTime()}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: screenSize.width < 360 ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: percentage >= 70 ? Colors.green.shade600 : Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Review Button (if applicable)
                if (_incorrectFlashcards.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close the results dialog first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(incorrectFlashcards: _incorrectFlashcards),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Review Incorrect Questions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Action Buttons
                LayoutBuilder(
                  builder: (context, constraints) {
                    final useVerticalLayout = constraints.maxWidth < 280;

                    if (useVerticalLayout) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _buildActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _currentIndex = 0;
                                  _score = 0;
                                  _incorrectFlashcards.clear();
                                  _flashcardsFuture = _loadQuestions();
                                });
                              },
                              icon: Icons.replay,
                              label: 'Retry Quiz',
                              color: Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: _buildActionButton(
                              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                              icon: Icons.home,
                              label: 'Go to Home',
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _currentIndex = 0;
                                  _score = 0;
                                  _incorrectFlashcards.clear();
                                  _flashcardsFuture = _loadQuestions();
                                });
                              },
                              icon: Icons.replay,
                              label: 'Retry Quiz',
                              color: Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                              icon: Icons.home,
                              label: 'Go to Home',
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
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
        child: SafeArea(
          bottom: false,
          child: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget.category,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
            color: _showHint ? Colors.amber : Colors.white,
          ),
          onPressed: () => setState(() => _showHint = !_showHint),
          tooltip: 'Show/Hide Hint',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Flashcard>>(
      future: _flashcardsFuture,
      builder: (context, snapshot) {
        if (_isLoading) return _buildLoadingState();
        if (snapshot.hasError)
          return _buildErrorState(snapshot.error.toString());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return _buildEmptyState();
        return _buildQuizContent();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 24),
          Text(
            'Loading ${widget.category} questions...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => setState(() => _flashcardsFuture = _loadQuestions()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz_outlined, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              'No questions available for this category',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use constraints to adapt the layout based on available space
        final isSmallScreen = constraints.maxWidth < 350;

        return Column(
          children: [
            _buildProgressIndicator(),
            _buildQuestionInfo(isSmallScreen),
            if (_showHint && _flashcards[_currentIndex].hint != null)
              _buildHintCard(),
            Expanded(child: _buildFlashcard()),
          ],
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (_currentIndex + 1) / _flashcards.length,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionInfo(bool isSmallScreen) {
    if (isSmallScreen) {
      // Stack the timer and question number for smaller screens
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Question ${_currentIndex + 1}/${_flashcards.length}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildTimer(),
          ],
        ),
      );
    } else {
      // Side by side for larger screens
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Question ${_currentIndex + 1}/${_flashcards.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTimer(),
          ],
        ),
      );
    }
  }

  Widget _buildTimer() {
    final color = _timeLeft > 10 ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            '$_timeLeft s',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade200, Colors.orange.shade200],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _flashcards[_currentIndex].hint!,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
    );
  }
}