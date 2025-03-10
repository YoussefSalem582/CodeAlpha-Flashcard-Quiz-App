import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../services/trivia_service.dart';
import '../screens/quiz_screen.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = TriviaService.categories;
    final categoriesWithColors = [
      {
        'color': Colors.blue,
        'icon': Icons.computer,
        'description': 'Test your programming knowledge'
      },
      {
        'color': Colors.green,
        'icon': Icons.science,
        'description': 'Explore scientific concepts'
      },
      {
        'color': Colors.orange,
        'icon': Icons.calculate,
        'description': 'Challenge your math skills'
      },
      {
        'color': Colors.purple,
        'icon': Icons.public,
        'description': 'Learn about our world'
      },
      {
        'color': Colors.red,
        'icon': Icons.history,
        'description': 'Journey through time'
      },
      {
        'color': Colors.teal,
        'icon': Icons.book,
        'description': 'Master the language'
      },
      {
        'color': Colors.indigo,
        'icon': Icons.lightbulb,
        'description': 'Expand your horizons'
      },
      {
        'color': Colors.amber,
        'icon': Icons.games,
        'description': 'Fun and games'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Categories'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              title: categories[index],
              icon: categoriesWithColors[index]['icon'] as IconData,
              color: categoriesWithColors[index]['color'] as Color,
              description: categoriesWithColors[index]['description'] as String,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      category: categories[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/custom'),
        icon: const Icon(Icons.add),
        label: const Text('Custom Quiz'),
        tooltip: 'Create custom flashcards',
      ),
    );
  }
}