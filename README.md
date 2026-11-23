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

### Secrets & API keys (best approach)

Use two buckets. Do not mix them.

| Kind | Examples | In git? | How we handle it |
|------|----------|---------|------------------|
| **Server / billable secrets** | Maps SDK Android/iOS, Geocoding, OneSignal App ID | **No** | `config/secrets.local.json` → `./tool/bootstrap_secrets.sh` |
| **Firebase client config** | `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist` | **Yes** (FlutterFire default) | Restrict keys in Google Cloud; optional App Check |

#### 1. Maps / Geocoding / OneSignal (never commit)

1. Copy `config/secrets.example.json` → `config/secrets.local.json`
2. Fill in Maps SDK (Android/iOS), Geocoding, and OneSignal values
3. Run `./tool/bootstrap_secrets.sh`
4. Launch with `flutter run --dart-define-from-file=config/dart_defines.json`

Generated / local-only (gitignored): `config/secrets.local.json`, `config/dart_defines.json`, `ios/Flutter/Secrets.xcconfig`, Maps key in `android/local.properties`.

Restrict each Maps/Geocoding key in [Google Cloud Credentials](https://console.cloud.google.com/apis/credentials) (package/SHA, bundle ID, API allowlist). Details: [`docs/location_maps_quota.md`](docs/location_maps_quota.md).

```bash
flutter run --dart-define-from-file=config/dart_defines.json
```

#### 2. Firebase client keys (committed on purpose)

These ship inside the app binary. Keeping them in the repo is normal. Protect them instead of trying to hide them:

1. In Google Cloud → Credentials, open each Firebase API key
2. **Application restrictions:** Android apps (package + SHA) / iOS apps (bundle ID)
3. **API restrictions:** only the Firebase APIs you use
4. Prefer [Firebase App Check](https://firebase.google.com/docs/app-check) for production
5. Set billing budgets / quota alerts on the GCP project

Do **not** put service-account JSON, Cloud Functions secrets, or unrestricted Maps keys in these files.

#### 3. If GitHub secret scanning emails you

GitHub often flags the Firebase keys in `firebase_options.dart` / `GoogleService-Info.plist` / `google-services.json`.

1. Confirm they are Firebase **client** keys (not a service account)
2. Restrict (and rotate if they were unrestricted) in Google Cloud
3. Close the alert as **Revoked** (after rotate) or **False positive** (restricted client config kept on purpose)
4. Never paste live keys into issues, PRs, or chat

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

All features use the live backend API. Configure Maps/Geocoding via `config/secrets.local.json` (see **Secrets & API keys** above).
