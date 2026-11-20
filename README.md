# BISMA: AI Cartoon Typing Tutor (Flutter & Dart)

A production-grade, child-friendly typing adventure app converted from the original BISMA educational web application into native Flutter/Dart.

## 🌟 Key Features
- **4 Progressive Stages:**
  - **Stage A (Alphabet):** Uppercase and lowercase letters with phonetic rhymes and optional bilingual Urdu hints.
  - **Stage B (Words):** 16 vocabulary words with child-friendly hints, animated illustrations, and interactive letter tiles.
  - **Stage C (Sentences):** Complete sentences highlighting capital letters, spaces, and punctuation dots.
  - **Stage D (Story Paragraphs):** Charming storybook paragraphs (e.g. *The Golden Bell*, *Bisma's Honey Picnic*).
- **Real Gemini AI Model Integration:**
  - Connects to Google's `gemini-2.5-flash` model to generate custom typing exercises adapted to the child's tricky keys, speed, and favorite themes.
  - Generates personalized AI coaching cheers.
  - Robust error handling with zero UI blocking and seamless on-device intelligent rule engine fallback when offline.
- **5 Animated Cartoon Companions:**
  - 🐻 **Bisma Bear Cub** (Bandana & warm hugs)
  - 🐰 **Pip Bunny** (Long pink ears & cheerful hops)
  - 🦖 **Sparky Baby Dino** (Magical bubbles & friendly cheer)
  - 🐝 **Buzzy Bee** (Golden stripes & star trails)
  - 🦉 **Ollie Owl** (Wise glasses & storybook love)
- **On-Screen & Physical Keyboard:**
  - Pastel color-coded finger guides (Pinky, Ring, Middle, Index, Thumbs).
  - Active key golden glowing highlight with bounce and ping indicator.
  - Real hardware keyboard listener on desktop/Android.
- **Audio & Haptics:**
  - Bubbly pops on correct taps, gentle wobble boings on mistakes, spacebar swooshes, rewind squeaks on backspace, and victory fanfares.
  - Built-in Text-To-Speech (TTS) pronunciation at a gentle child cadence.
- **Unified "My Progress Dashboard":**
  - 5 Core Metrics: Practice Time, Accuracy %, Correct Keystrokes, Words Typed, Gentle WPM.
  - Tricky Keys practice log.
  - 8 Achievement Badges & Star collection.
  - SharedPreferences persistent local storage.

---

## 🚀 Running the Project

### Prerequisites
- Flutter SDK 3.3.0 or higher
- Android Studio / VS Code with Flutter extension
- Android SDK (API 21+)

### Installation
1. Navigate to the project directory:
   ```bash
   cd bisma_typing_tutor
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the unit & widget tests:
   ```bash
   flutter test
   ```
4. Run on an Android emulator or device:
   ```bash
   flutter run
   ```

---

## 🤖 Gemini AI Configuration
To enable live AI generation directly from your device, configure your Gemini API Key in one of two secure ways:

### Option 1: At compile/run time via `--dart-define`
```bash
flutter run --dart-define=GEMINI_API_KEY="YOUR_GEMINI_API_KEY"
```

### Option 2: Using the Educational Backend Proxy
If running alongside the Express backend proxy on port 3000:
```bash
flutter run --dart-define=BACKEND_URL="http://10.0.2.2:3000"
```

*Note: If no API key is provided, BISMA automatically engages its intelligent on-device rule engine, ensuring 100% uninterrupted offline practice.*

---

## 📁 Project Architecture
```
bisma_typing_tutor/
├── android/               # Native Android configuration, manifest, Gradle
├── assets/
│   ├── characters/        # SVG vector assets for Bisma, Pip, Sparky, Buzzy, Ollie
│   └── sounds/            # 16-bit PCM WAV sound effects (pop, boing, space, rewind, victory)
├── lib/
│   ├── main.dart          # Entrypoint & engine initializers
│   ├── app.dart           # BismaTypingTutorApp root & theme
│   ├── constants/         # AppColors, AppTheme, AppStrings
│   ├── models/            # Typing models, Companions, Worlds, Progress, Settings
│   ├── data/              # Alphabet, Words, Sentences, Stories, Companions, Worlds, Badges
│   ├── services/          # SoundService, TtsService, StorageService, AiTutorService
│   ├── controllers/       # TypingController (ChangeNotifier state engine)
│   ├── widgets/           # CartoonKeyboard, WordTiles, SentenceDisplay, CompanionAvatar
│   ├── screens/           # WelcomeScreen, TypingAdventureScreen, ProgressDashboardScreen, Dialogs
│   └── utils/             # Formatters
├── test/                  # Unit and Widget tests
└── pubspec.yaml           # Flutter package manifest
```
