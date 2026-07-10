# medpik-mobile-app

Medpik mobile application — a Flutter app for medicine delivery and pharmacy services.

## Getting Started

### Prerequisites

- Flutter SDK (see `pubspec.yaml` for SDK constraints)
- Xcode (iOS) / Android Studio (Android)

### Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Project structure

- `lib/src/` — feature modules (auth, home, cart, prescription, checkout, etc.)
- `lib/utils/` — shared widgets and helpers
- `lib/res/` — constants, colors, fonts, and themes
- `assets/` — images, icons, fonts, and lottie files

## Development

Mock data is enabled by default (`AppConstants.useMockData = true`).
