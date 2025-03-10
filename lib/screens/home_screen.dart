// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Ensure this import is included
import '../providers/settings_provider.dart';
import '../widgets/category_card.dart';
import '../providers/progress_provider.dart';
import 'custom_flashcard_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('Flashcard Quiz'),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<ProgressProvider>(
              builder: (context, progress, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Your Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress.totalQuestions == 0
                              ? 0
                              : progress.correctAnswers / progress.totalQuestions,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          minHeight: 10,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${progress.correctAnswers}/${progress.totalQuestions} Questions',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _navigateToQuiz(context),
                          child: const Text('Start Quiz'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildListDelegate([
                CategoryCard(
                  title: 'CS Questions',
                  icon: Icons.computer,
                  color: Colors.blue,
                  onTap: () => _navigateToQuiz(context, 'CS Questions'),
                ),
                CategoryCard(
                  title: 'Flutter Questions',
                  icon: Icons.flutter_dash,
                  color: Colors.teal,
                  onTap: () => _navigateToQuiz(context, 'Flutter Questions'),
                ),
                CategoryCard(
                  title: 'ML Questions',
                  icon: Icons.psychology,
                  color: Colors.purple,
                  onTap: () => _navigateToQuiz(context, 'ML Questions'),
                ),
                CategoryCard(
                  title: 'Math Questions',
                  icon: Icons.calculate,
                  color: Colors.orange,
                  onTap: () => _navigateToQuiz(context, 'Math Questions'),
                ),
                CategoryCard(
                  title: 'English',
                  icon: Icons.book,
                  color: Colors.green,
                  onTap: () => _navigateToQuiz(context, 'English'),
                ),
                CategoryCard(
                  title: 'Custom Flashcards',
                  icon: Icons.create,
                  color: Colors.pink,
                  onTap: () => _navigateToCustomFlashcards(context),
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSettingsDialog(context),
        child: const Icon(Icons.settings),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context, [String? category]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(category: category ?? 'Flutter Questions'), // Replace with the correct screen for the quiz
      ),
    );
  }
  void _navigateToCustomFlashcards(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomFlashcardScreen(),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<SettingsProvider>(
              builder: (context, settings, _) => Column(
                children: [
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    value: settings.option1,
                    onChanged: (value) => settings.setOption1(value),
                  ),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: settings.option2,
                    onChanged: (value) => settings.setOption2(value),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}