import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../providers/progress_provider.dart';
import '../widgets/score_widget.dart';
import '../widgets/category_card.dart';
import '../services/trivia_service.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> categoriesWithColors = [
    {'color': Colors.blue, 'icon': Icons.computer, 'name': 'Computer Science'},
    {'color': Colors.green, 'icon': Icons.science, 'name': 'Science'},
    {'color': Colors.orange, 'icon': Icons.calculate, 'name': 'Mathematics'},
    {'color': Colors.purple, 'icon': Icons.public, 'name': 'Geography'},
    {'color': Colors.red, 'icon': Icons.history, 'name': 'History'},
    {'color': Colors.teal, 'icon': Icons.book, 'name': 'English'},
    {'color': Colors.indigo, 'icon': Icons.lightbulb, 'name': 'General Knowledge'},
    {'color': Colors.amber, 'icon': Icons.games, 'name': 'Entertainment'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Flashcard Quiz App',
              textStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.blue,
                Colors.purple,
                Colors.red,
                Colors.green,
              ],
            ),
          ],
          isRepeatingAnimation: true,
        ),
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
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.category), text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildCategoriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/custom'),
        icon: const Icon(Icons.add),
        label: const Text('Custom Quiz'),
        tooltip: 'Create custom flashcards',
      ),
    );
  }

  Widget _buildHomeTab() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Your Progress',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ScoreWidget(
                          score: progressProvider.correctAnswers,
                          total: progressProvider.totalQuestions,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index >= 4) return null;
                    final category = categoriesWithColors[index];
                    return _buildCategoryCard(context, category);
                  },
                  childCount: 4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: categoriesWithColors.length,
      itemBuilder: (context, index) => _buildCategoryCard(
        context,
        categoriesWithColors[index],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return CategoryCard(
      title: category['name'] as String,
      icon: category['icon'] as IconData,
      color: category['color'] as Color,
      onTap: () => _navigateToQuiz(context, category['name'] as String),
    );
  }

  void _navigateToQuiz(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(category: category),
      ),
    );
  }
}