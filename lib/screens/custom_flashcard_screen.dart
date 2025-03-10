import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class CustomFlashcardScreen extends StatefulWidget {
  @override
  _CustomFlashcardScreenState createState() => _CustomFlashcardScreenState();
}

class _CustomFlashcardScreenState extends State<CustomFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _optionControllers = List.generate(3, (_) => TextEditingController());
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _categoryController.dispose();
    super.dispose();
  }

  void _saveFlashcard() {
    if (_formKey.currentState!.validate()) {
      final question = _questionController.text;
      final answer = _answerController.text;
      final category = _categoryController.text;
      final options = _optionControllers.map((controller) => controller.text).toList();
      options.add(answer);
      options.shuffle();

      final flashcard = Flashcard(
        question: question,
        answer: answer,
        type: FlashcardType.multipleChoice,
        options: options,
      );

      // Save the flashcard (e.g., add to a list or save to a database)
      // For now, just print it
      print('Flashcard saved: $flashcard');

      // Clear the form
      _formKey.currentState!.reset();
      _questionController.clear();
      _answerController.clear();
      for (var controller in _optionControllers) {
        controller.clear();
      }
      _categoryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Flashcard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Correct Answer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the correct answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _optionControllers.map((controller) {
                  return TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Option',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFlashcard,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Save Flashcard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}