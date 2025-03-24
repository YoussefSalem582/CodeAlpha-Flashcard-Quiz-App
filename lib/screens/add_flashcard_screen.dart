// lib/screens/add_flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/custom_text_form_field.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  _AddFlashcardScreenState createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final answerController = TextEditingController();
  final optionsController = List<TextEditingController>.generate(4, (_) => TextEditingController());
  FlashcardType _selectedType = FlashcardType.trueFalse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flashcard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Add a new flashcard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: questionController,
                label: 'Question',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Flashcard type:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  _buildTypeToggle(),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedType == FlashcardType.multipleChoice)
                ...optionsController.map((controller) {
                  return CustomTextFormField(
                    controller: controller,
                    label: 'Option',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  );
                }).toList(),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: answerController,
                label: 'Answer',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveFlashcard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Add Flashcard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Row(
      children: [
        Radio<FlashcardType>(
          value: FlashcardType.trueFalse,
          groupValue: _selectedType,
          onChanged: (FlashcardType? newValue) {
            setState(() {
              _selectedType = newValue!;
            });
          },
        ),
        const Text('True/False'),
        const SizedBox(width: 10),
        Radio<FlashcardType>(
          value: FlashcardType.multipleChoice,
          groupValue: _selectedType,
          onChanged: (FlashcardType? newValue) {
            setState(() {
              _selectedType = newValue!;
            });
          },
        ),
        const Text('Multiple Choice'),
      ],
    );
  }

  void _saveFlashcard() {
    if (_formKey.currentState!.validate()) {
      final question = questionController.text;
      final answer = answerController.text;
      final options = optionsController.map((controller) => controller.text).toList();

      final flashcard = Flashcard(
        question: question,
        answer: answer,
        type: _selectedType,
        options: _selectedType == FlashcardType.multipleChoice ? options : null,
      );
      Provider.of<FlashcardProvider>(context, listen: false).addFlashcard(flashcard);
      Navigator.pop(context);
    }
  }
}