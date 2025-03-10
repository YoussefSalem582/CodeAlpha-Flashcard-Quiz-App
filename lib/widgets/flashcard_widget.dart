import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> with SingleTickerProviderStateMixin {
  int _selectedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuestionCard(),
            const SizedBox(height: 40),
            _buildAnswerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.9),
            Theme.of(context).primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.overlay,
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const Icon(
                  Icons.quiz_outlined,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.flashcard.question,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerSection() {
    return widget.flashcard.type == FlashcardType.trueFalse
        ? _buildTrueFalseButtons()
        : _buildMultipleChoiceGrid();
  }

  Widget _buildTrueFalseButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['True', 'False'].asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        final isSelected = _selectedIndex == index;
        final isCorrect = isSelected &&
            widget.showCorrectAnswer &&
            widget.flashcard.answer == text;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: () {
              setState(() => _selectedIndex = index);
              widget.onNext(text == widget.flashcard.answer);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect
                  ? Colors.green
                  : isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              foregroundColor: isSelected ? Colors.white : Colors.black87,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              elevation: isSelected ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.flashcard.options!.length,
      itemBuilder: (context, index) {
        final option = widget.flashcard.options![index];
        final isSelected = _selectedIndex == index;
        final isCorrect = isSelected &&
            widget.showCorrectAnswer &&
            widget.flashcard.answer == option;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: () {
              setState(() => _selectedIndex = index);
              widget.onNext(widget.flashcard.answer == option);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect
                  ? Colors.green
                  : isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              foregroundColor: isSelected ? Colors.white : Colors.black87,
              elevation: isSelected ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              option,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}