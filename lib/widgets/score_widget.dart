import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final int score;
  final int total;

  const ScoreWidget({required this.score, required this.total, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Your Score: $score / $total', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back to Home'),
        ),
      ],
    );
  }
}