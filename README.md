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

### Release builds (Android)

Address search / reverse-geocode need the Geocoding key from `config/dart_defines.json`. Android Gradle release builds automatically pass that file into Flutter after `./tool/bootstrap_secrets.sh` has generated it.

```bash
./tool/bootstrap_secrets.sh   # if secrets changed
./tool/build_release_apk.sh           # APK
./tool/build_release_apk.sh appbundle # Play Store AAB
```

Or manually:

```bash
flutter build apk --release
flutter build appbundle --release
```

### Release builds (iOS / TestFlight)

TestFlight builds need both the native iOS Maps SDK key from `ios/Flutter/Secrets.xcconfig` and the Dart Geocoding key from `config/dart_defines.json`. The Xcode Runner target validates both files, and Release/Profile builds automatically pass `config/dart_defines.json` into Flutter.

```bash
./tool/bootstrap_secrets.sh   # if secrets changed
./tool/build_release_ipa.sh
```

Or manually:

```bash
./tool/check_ios_release_config.sh
flutter build ipa --release --dart-define-from-file=config/dart_defines.json
```

For the normal Xcode/TestFlight flow, run `./tool/bootstrap_secrets.sh` once after changing keys, then use **Product → Build → Archive**. The archive fails early if the iOS key or Dart define file is missing.

## Project structure

- `lib/src/` — feature modules (auth, home, cart, prescription, checkout, etc.)
- `lib/utils/` — shared widgets and helpers
- `lib/res/` — constants, colors, fonts, and themes
- `assets/` — images, icons, fonts, and lottie files

## Development

All features use the live backend API. Configure Google Maps keys for the location picker (see above).
