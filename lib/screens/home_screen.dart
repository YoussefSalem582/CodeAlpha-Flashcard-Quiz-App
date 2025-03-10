import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/progress_provider.dart';
import '../widgets/score_widget.dart';
import '../widgets/category_card.dart';
import '../widgets/achievement_banner.dart';
import '../services/trivia_service.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSearch = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> categoriesWithColors = [
    {'color': Colors.blue, 'icon': Icons.computer, 'name': 'Computer Science', 'description': 'Test your programming knowledge'},
    {'color': Colors.green, 'icon': Icons.science, 'name': 'Science', 'description': 'Explore scientific concepts'},
    {'color': Colors.orange, 'icon': Icons.calculate, 'name': 'Mathematics', 'description': 'Challenge your math skills'},
    {'color': Colors.purple, 'icon': Icons.public, 'name': 'Geography', 'description': 'Learn about our world'},
    {'color': Colors.red, 'icon': Icons.history, 'name': 'History', 'description': 'Journey through time'},
    {'color': Colors.teal, 'icon': Icons.book, 'name': 'English', 'description': 'Master the language'},
    {'color': Colors.indigo, 'icon': Icons.lightbulb, 'name': 'General Knowledge', 'description': 'Expand your horizons'},
    {'color': Colors.amber, 'icon': Icons.games, 'name': 'Entertainment', 'description': 'Fun and games'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkAchievements();
  }

  void _checkAchievements() {
    final progress = Provider.of<ProgressProvider>(context, listen: false);
    if (progress.totalQuestions > 0 && progress.correctAnswers / progress.totalQuestions >= 0.8) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAchievementBanner('High Achiever!', 'You\'ve maintained an 80% success rate!');
      });
    }
  }

  void _showAchievementBanner(String title, String message) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: AchievementBanner(title: title, message: message),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('DISMISS'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) return categoriesWithColors;
    return categoriesWithColors.where((category) =>
        category['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
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
        title: _showSearch
            ? TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search categories...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        )
            : AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Flashcard Quiz App',
              textStyle: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              colors: [Colors.blue, Colors.purple, Colors.red, Colors.green],
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
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () => setState(() => _showSearch = !_showSearch),
            tooltip: _showSearch ? 'Clear search' : 'Search categories',
          ),
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
          indicatorColor: Colors.white,
          indicatorWeight: 3,
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
        return RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic here
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Progress',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => _showProgressDetails(context, progressProvider),
                              ),
                            ],
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
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: _buildCategoryCard(context, category),
                          ),
                        ),
                      );
                    },
                    childCount: 4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: _buildCategoryCard(
                  context,
                  _filteredCategories[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return Hero(
      tag: 'category-${category['name']}',
      child: CategoryCard(
        title: category['name'] as String,
        icon: category['icon'] as IconData,
        color: category['color'] as Color,
        description: category['description'] as String,
        onTap: () => _navigateToQuiz(context, category['name'] as String),
      ),
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

  void _showProgressDetails(BuildContext context, ProgressProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Progress Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Correct Answers'),
              trailing: Text('${provider.correctAnswers}'),
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Total Questions'),
              trailing: Text('${provider.totalQuestions}'),
            ),
            ListTile(
              leading: const Icon(Icons.percent),
              title: const Text('Success Rate'),
              trailing: Text(
                '${((provider.correctAnswers / provider.totalQuestions) * 100).toStringAsFixed(1)}%',
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