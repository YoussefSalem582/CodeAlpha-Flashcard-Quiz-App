import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final Function(bool) onNext;
  final bool showCorrectAnswer;

  const FlashcardWidget({
    required this.flashcard,
    required this.onNext,
    this.showCorrectAnswer = false,
    super.key,
  });

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                widget.flashcard.question,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (widget.flashcard.type == FlashcardType.trueFalse) ...[
            ToggleButtons(
              onPressed: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onNext(index == 0 ? widget.flashcard.answer == 'True' : widget.flashcard.answer == 'False');
              },
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              selectedColor: Colors.white,
              fillColor: Colors.blueAccent,
              selectedBorderColor: Colors.blueAccent,
              borderRadius: BorderRadius.circular(15),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'True',
                    style: TextStyle(
                      fontSize: 18,
                      color: _selectedIndex == 0 && widget.showCorrectAnswer && widget.flashcard.answer == 'True'
                          ? Colors.green
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'False',
                    style: TextStyle(
                      fontSize: 18,
                      color: _selectedIndex == 1 && widget.showCorrectAnswer && widget.flashcard.answer == 'False'
                          ? Colors.green
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (widget.flashcard.type == FlashcardType.multipleChoice) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                widget.flashcard.options!.length,
                    (index) {
                  return ChoiceChip(
                    label: Text(
                      widget.flashcard.options![index],
                      style: TextStyle(
                        fontSize: 18,
                        color: _selectedIndex == index && widget.showCorrectAnswer && widget.flashcard.answer == widget.flashcard.options![index]
                            ? Colors.green
                            : null,
                      ),
                    ),
                    selected: _selectedIndex == index,
                    onSelected: (value) {
                      setState(() {
                        _selectedIndex = value ? index : -1;
                      });
                      widget.onNext(value ? widget.flashcard.answer == widget.flashcard.options![index] : false);
                    },
                    selectedColor: Colors.blueAccent,
                    labelPadding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}