import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/flashcard.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/score_widget.dart';
import 'review_screen.dart';
import '../providers/progress_provider.dart';

class QuizScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  const QuizScreen({required this.flashcards, super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Duration _quizDuration = const Duration(minutes: 5);
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _currentIndex = 0;
  int _score = 0;
  int _remainingSeconds = 0;
  final List<Flashcard> _incorrectFlashcards = [];
  final List<int> _timeTaken = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _stopwatch.start();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _startTimer() {
    _remainingSeconds = _quizDuration.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _endQuiz();
      }
    });
  }

  void _endQuiz() {
    _stopwatch.stop();
    Provider.of<ProgressProvider>(context, listen: false).updateProgress(_score, widget.flashcards.length);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Quiz Finished'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScoreWidget(score: _score, total: widget.flashcards.length),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReviewScreen(incorrectFlashcards: _incorrectFlashcards)),
                    );
                  },
                  child: const Text('Review Incorrect Answers'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nextFlashcard(bool correct) async {
    _stopwatch.stop();
    _timeTaken.add(_stopwatch.elapsed.inSeconds);
    _stopwatch.reset();
    _stopwatch.start();

    if (correct) {
      _score++;
      _audioPlayer.play(AssetSource('assets/sounds/correct.mp3')); // No await
    } else {
      _incorrectFlashcards.add(widget.flashcards[_currentIndex]);
      _audioPlayer.play(AssetSource('assets/sounds/incorrect.mp3')); // No await
    }
    setState(() {
      _currentIndex++;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _audioPlayer.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.flashcards.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Finished'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScoreWidget(score: _score, total: widget.flashcards.length),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewScreen(incorrectFlashcards: _incorrectFlashcards)),
                  );
                },
                child: const Text('Review Incorrect Answers'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Remaining: ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Score: $_score',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: _currentIndex / widget.flashcards.length,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.flashcards.length,
              itemBuilder: (context, index) {
                return Center(
                  child: FlashcardWidget(
                    flashcard: widget.flashcards[index],
                    onNext: _nextFlashcard,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}