import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<FlashcardType>(
                value: _selectedType,
                onChanged: (FlashcardType? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Flashcard Type',
                  border: OutlineInputBorder(),
                ),
                items: FlashcardType.values.map((FlashcardType type) {
                  return DropdownMenuItem<FlashcardType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (_selectedType == FlashcardType.multipleChoice)
                ...optionsController.map((controller) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Option',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an option';
                        }
                        return null;
                      },
                    ),
                  );
                }).toList(),
              const SizedBox(height: 20),
              TextFormField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Add Flashcard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}