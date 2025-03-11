import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/progress_provider.dart';
import 'screens/custom_flashcard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Flashcard Quiz App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purpleAccent),
          textTheme: TextTheme(
            headlineSmall: TextStyle(fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(color: Colors.grey[600]),
          ),
        ),
        home: HomeScreen(),
        routes: {
          '/settings': (context) => SettingsScreen(),
          '/custom': (context) => CustomFlashcardScreen(),
        },
      ),
    );
  }
}