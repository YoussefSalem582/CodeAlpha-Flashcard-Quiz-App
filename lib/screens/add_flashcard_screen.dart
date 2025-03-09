import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../main.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  _AddFlashcardScreenState createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
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
        child: Column(
          children: <Widget>[
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            DropdownButton<FlashcardType>(
              value: _selectedType,
              onChanged: (FlashcardType? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: FlashcardType.values.map((FlashcardType type) {
                return DropdownMenuItem<FlashcardType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
            ),
            if (_selectedType == FlashcardType.multipleChoice)
              ...optionsController.map((controller) {
                return TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Option'),
                );
              }).toList(),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            ElevatedButton(
              onPressed: () {
                final question = questionController.text;
                final answer = answerController.text;
                final options = optionsController.map((controller) => controller.text).toList();

                if (question.isNotEmpty && answer.isNotEmpty) {
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
              child: const Text('Add Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}