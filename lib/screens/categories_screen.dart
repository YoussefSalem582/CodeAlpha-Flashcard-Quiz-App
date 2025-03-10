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
      {'color': Colors.blue, 'icon': Icons.computer},
      {'color': Colors.green, 'icon': Icons.science},
      {'color': Colors.orange, 'icon': Icons.calculate},
      {'color': Colors.purple, 'icon': Icons.public},
      {'color': Colors.red, 'icon': Icons.history},
      {'color': Colors.teal, 'icon': Icons.book},
      {'color': Colors.indigo, 'icon': Icons.lightbulb},
      {'color': Colors.amber, 'icon': Icons.games},
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
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/custom');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}