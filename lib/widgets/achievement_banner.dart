import 'package:flutter/material.dart';

class AchievementBanner extends StatelessWidget {
  final String title;
  final String message;

  const AchievementBanner({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.emoji_events, color: Colors.amber),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(message),
            ],
          ),
        ),
      ],
    );
  }
}