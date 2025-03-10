import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/settings_provider.dart';
import '../services/trivia_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListTile(
                  title: const Text('Option 1'),
                  trailing: Switch(
                    value: settings.option1,
                    onChanged: (bool value) {
                      settings.setOption1(value);
                    },
                  ),
                );
              },
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListTile(
                  title: const Text('Option 2'),
                  trailing: Switch(
                    value: settings.option2,
                    onChanged: (bool value) {
                      settings.setOption2(value);
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Category'),
              trailing: Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return DropdownButton<Category>(
                    value: settings.category,
                    onChanged: (Category? newValue) {
                      settings.setCategory(newValue!);
                    },
                    items: Category.values.map<DropdownMenuItem<Category>>((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Difficulty'),
              trailing: Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return DropdownButton<String>(
                    value: settings.difficulty,
                    onChanged: (String? newValue) {
                      settings.setDifficulty(newValue!);
                    },
                    items: TriviaService.difficulties.map<DropdownMenuItem<String>>((String difficulty) {
                      return DropdownMenuItem<String>(
                        value: difficulty,
                        child: Text(difficulty),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}