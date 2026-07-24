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
```

### Google Maps keys (location picker)

1. Copy `config/secrets.example.json` → `config/secrets.local.json`
2. Add your Maps SDK keys (Android/iOS) and Geocoding API key
3. Run `./tool/bootstrap_secrets.sh`
4. Launch with `flutter run --dart-define-from-file=config/dart_defines.json`

See [`docs/location_maps_quota.md`](docs/location_maps_quota.md) for Cloud Console setup.

```bash
flutter run --dart-define-from-file=config/dart_defines.json
```

## Project structure

- `lib/src/` — feature modules (auth, home, cart, prescription, checkout, etc.)
- `lib/utils/` — shared widgets and helpers
- `lib/res/` — constants, colors, fonts, and themes
- `assets/` — images, icons, fonts, and lottie files

## Development

All features use the live backend API. Configure Google Maps keys for the location picker (see above).
