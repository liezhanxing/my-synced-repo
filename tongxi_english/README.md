# 童希英语 (TongXi English)

## Overview

An interactive English learning app for Chinese high school students, built with Flutter and Firebase, featuring anime-style (二次元) UI design.

## Features

- **7 Learning Modules**: Phonetics, Vocabulary, Phrases, Grammar, Reading, Listening, Translation
- **Spaced Repetition (SM-2)**: Intelligent vocabulary review algorithm
- **Interactive Exercises**: Quizzes, flashcards, and practice activities
- **Progress Tracking**: XP system, streaks, achievements, and detailed statistics
- **Anime-Style UI**: Beautiful gradient designs with mascot characters
- **Firebase Backend**: Real-time sync, authentication, and content management

## Tech Stack

- **Flutter 3.x** + Dart
- **Firebase**: Auth, Firestore, Storage, Remote Config
- **Riverpod**: State Management
- **GoRouter**: Navigation
- **Hive**: Local caching
- **Audio Players**: Text-to-speech and audio playback

## Project Structure

```
lib/
├── app/
│   ├── app.dart              # App initialization
│   ├── routes.dart           # GoRouter configuration
│   └── theme.dart            # AppTheme and styling
├── core/
│   ├── constants/
│   │   ├── app_colors.dart   # Color palette
│   │   ├── app_sizes.dart    # Spacing and dimensions
│   │   ├── app_strings.dart  # Localization strings
│   │   └── firebase_constants.dart
│   ├── errors/
│   │   └── failures.dart     # Error handling classes
│   ├── extensions/
│   │   └── context_extensions.dart
│   ├── services/
│   │   ├── audio_service.dart
│   │   ├── firebase_service.dart
│   │   ├── storage_service.dart
│   │   └── tts_service.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── sm2_algorithm.dart    # Spaced repetition
│   └── widgets/
│       ├── achievement_badge.dart
│       ├── anime_button.dart
│       ├── anime_card.dart
│       ├── error_widget.dart
│       ├── loading_widget.dart
│       ├── mascot_widget.dart
│       └── progress_bar.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── user_model.dart
│   │   └── presentation/
│   │       └── auth_controller.dart
│   ├── grammar/              # Grammar learning module
│   ├── home/                 # Home dashboard
│   ├── listening/            # Listening comprehension
│   ├── phonetics/            # Phonetics/pronunciation
│   ├── phrases/              # Common phrases
│   ├── profile/              # User profile
│   ├── reading/              # Reading comprehension
│   ├── translation/          # Translation exercises
│   └── vocabulary/           # Vocabulary learning
├── models/
│   ├── grammar_model.dart
│   ├── listening_model.dart
│   ├── phonetic_model.dart
│   ├── phrase_model.dart
│   ├── reading_model.dart
│   ├── translation_model.dart
│   ├── user_progress_model.dart
│   └── word_model.dart
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK
- Firebase CLI
- Android Studio / VS Code

### Setup

1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase:
   - Create a Firebase project
   - Add Android app in Firebase Console
   - Download `google-services.json` to `android/app/`
   - Enable Authentication, Firestore, Storage, Remote Config
4. Run `flutter run`

## Modules

### 1. Phonetics (语音)
Learn English pronunciation with interactive phonetic charts, audio examples, and practice exercises.

### 2. Vocabulary (词汇)
Master vocabulary using spaced repetition (SM-2 algorithm), flashcards, and contextual learning.

### 3. Phrases (短语)
Learn common English phrases and expressions for daily communication.

### 4. Grammar (语法)
Interactive grammar lessons with examples, quizzes, and practice exercises.

### 5. Reading (阅读)
Reading comprehension exercises with various difficulty levels and topics.

### 6. Listening (听力)
Audio-based listening exercises with transcripts and comprehension questions.

### 7. Translation (翻译)
Practice Chinese-English translation with instant feedback and explanations.

## Architecture

- **Feature-first organization**: Each feature has its own directory
- **Clean Architecture**: Data/Domain/Presentation layers
- **Riverpod**: Reactive state management
- **GoRouter**: Declarative routing
- **Repository Pattern**: Abstracted data access

## Testing

Run tests with:
```bash
flutter test
```

Test files:
- `test/core/utils/sm2_algorithm_test.dart` - SM-2 algorithm unit tests
- `test/models/word_model_test.dart` - Word model serialization tests
- `test/models/user_model_test.dart` - User model serialization tests
- `test/core/widgets/anime_button_test.dart` - AnimeButton widget tests

## License

MIT
