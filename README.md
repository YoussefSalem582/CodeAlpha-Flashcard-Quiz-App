# Flashcard Quiz App

A beautifully designed, feature-rich Flashcard Quiz App built with Flutter and Dart. Test your knowledge across various categories, create custom flashcards, track your progress, and review mistakes—all in an engaging, animated interface!

---

## Overview

The Flashcard Quiz App is an educational tool that allows users to practice and learn through interactive quizzes. It fetches trivia questions from the Open Trivia Database API, supports custom flashcard creation, and provides detailed progress tracking and review features. With a modern UI, animations, and state management via Provider, this app is perfect for students, educators, or anyone looking to sharpen their skills.

---

## Features

- **Multiple Quiz Categories**: Choose from Computer Science, Science, Mathematics, Geography, History, English, General Knowledge, and Entertainment.
- **Custom Flashcards**: Create your own multiple-choice or true/false flashcards with a user-friendly interface.
- **Progress Tracking**: Monitor your correct answers, total questions, and success rate with persistent storage.
- **Review System**: Revisit incorrect answers with explanations and hints for better learning.
- **Timed Quizzes**: Answer questions within 30 seconds for an added challenge.
- **Animated UI**: Enjoy smooth transitions, gradients, and staggered animations powered by packages like `animations` and `flutter_staggered_animations`.
- **Settings**: Customize options, difficulty levels (easy, medium, hard), and preferred categories.
- **Persistent Storage**: Flashcards and progress are saved locally using `SharedPreferences`.
- **Responsive Design**: Works seamlessly across Android, iOS, and web platforms.

---


## Screenshots

Here’s a glimpse of the Flashcard Quiz App in action:

- **Home Screen with category selection**  
  <img src="https://github.com/user-attachments/assets/ea2aebc0-fc06-4d79-8c7a-443f74770624" width="300" alt="Home Screen">

- **Quiz Screen with timer and hint**  
  <img src="https://github.com/user-attachments/assets/adb1af98-1f2d-49ab-9ad7-838dbfa1001a" width="300" alt="Quiz">  
  *Additional views:*  
  <img src="https://github.com/user-attachments/assets/2f3bfa77-11d0-4851-9f12-a0ae527f6006" width="300" alt="Correct Answer Feedback"> (Correct Answer Feedback)  
  <img src="https://github.com/user-attachments/assets/87cb2cd1-88cb-4bb8-b41d-70a1e830b7e3" width="300" alt="Incorrect Answer Feedback"> (Incorrect Answer Feedback)

- **Review Screen with incorrect answers**  
  <img src="https://github.com/user-attachments/assets/582dc9de-5fcf-4d46-9734-457407f5a8df" width="300" alt="Review Page">

- **Custom Flashcard creation**  
  *(Screenshot not yet available—add your own once captured!)*  
  Placeholder: *Image of the custom flashcard creation screen will go here.*

- **Bonus: Quiz Complete Screen**  
  <img src="https://github.com/user-attachments/assets/04152409-0702-4ac7-a630-d3d85119a600" width="300" alt="Quiz Complete">


---

## Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart (2.18 or higher)
- Android Studio / VS Code with Flutter plugins
- An internet connection (for fetching trivia questions)

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/flashcard-quiz-app.git
   cd flashcard-quiz-app
   ```

2. **Install Dependencies**:
   Run the following command to fetch all required packages:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Connect a device/emulator and launch the app:
   ```bash
   flutter run
   ```

4. **Build for Release** (optional):
   ```bash
   flutter build apk  # For Android
   flutter build ios  # For iOS (requires macOS)
   ```

---

## Usage

1. **Home Screen**:
   - Browse popular categories or recent quizzes.
   - Use the search bar to filter categories.
   - Tap a category to start a quiz or press the FAB to create a custom flashcard.

2. **Quiz Screen**:
   - Answer questions within 30 seconds.
   - Toggle hints if available.
   - View instant feedback (correct/incorrect) with explanations.

3. **Review Screen**:
   - After completing a quiz, review incorrect answers with detailed breakdowns.
   - Expand cards to see hints or explanations.

4. **Custom Flashcards**:
   - Navigate to "Create Quiz" from the Home or Categories screen.
   - Input a question, answer, category, and options (for multiple-choice).
   - Save and use your flashcards in future quizzes.

5. **Settings**:
   - Adjust quiz difficulty or toggle options as needed.

---

## Project Structure

```
lib/
├── main.dart              # App entry point and routing
├── models/                # Data models
│   ├── category.dart      # Category enum
│   ├── flashcard.dart     # Flashcard model and FlashcardType enum
│   └── custom_flashcard.dart  # Simplified custom flashcard model
├── providers/             # State management
│   ├── flashcard_provider.dart  # Manages flashcard data
│   ├── progress_provider.dart   # Tracks quiz progress
│   └── settings_provider.dart   # Handles app settings
├── screens/               # UI screens
│   ├── home_screen.dart       # Main dashboard
│   ├── categories_screen.dart # Category selection
│   ├── quiz_screen.dart       # Quiz interface
│   ├── review_screen.dart     # Review incorrect answers
│   ├── custom_flashcard_screen.dart  # Custom flashcard creation
│   ├── add_flashcard_screen.dart     # Alternative flashcard creation
│   └── settings_screen.dart   # Settings interface
├── services/              # External services
│   └── trivia_service.dart  # Fetches questions from Open Trivia DB
└── widgets/               # Reusable UI components
    ├── category_card.dart    # Category display card
    ├── flashcard_widget.dart # Flashcard UI with answers
    ├── score_widget.dart     # Score display with animation
    └── achievement_banner.dart # Achievement notification
```

---

## Dependencies

- `flutter`: Core framework
- `provider`: State management
- `shared_preferences`: Persistent storage
- `http`: API requests
- `google_fonts`: Custom typography
- `animations`: UI transitions
- `flutter_staggered_animations`: Grid animations
- `animated_text_kit`: Animated app bar text

Add these to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  http: ^0.13.0
  google_fonts: ^4.0.0
  animations: ^2.0.0
  flutter_staggered_animations: ^1.0.0
  animated_text_kit: ^4.2.0
```

---

## Contributing

We welcome contributions! Here’s how to get started:

1. **Fork the Repository**: Click "Fork" on GitHub.
2. **Clone Your Fork**:
   ```bash
   git clone https://github.com/yourusername/flashcard-quiz-app.git
   ```
3. **Create a Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make Changes**: Implement your feature or fix.
5. **Commit and Push**:
   ```bash
   git commit -m "Add your feature description"
   git push origin feature/your-feature-name
   ```
6. **Submit a Pull Request**: Open a PR on GitHub with a clear description.

### Guidelines
- Follow Flutter’s style guide.
- Write clear, concise commit messages.
- Test your changes on an emulator/device.
- Update this README if new features are added.
- 
