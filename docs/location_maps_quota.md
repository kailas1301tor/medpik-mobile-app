# Google Maps / Geocoding — quotas & key restrictions

Use this checklist when enabling location pick in production.

## Enable APIs (Cloud Console)

- Maps SDK for Android
- Maps SDK for iOS
- Geocoding API

Do **not** enable Places API, Distance Matrix, Roads, or Static Maps for this flow.

## Unified secrets setup

All keys live in one gitignored file. A bootstrap script fans them out to platform files.

1. Copy the template:
   ```bash
   cp config/secrets.example.json config/secrets.local.json
   ```
2. Fill in your keys in `config/secrets.local.json`:
   ```json
   {
     "GOOGLE_MAPS_ANDROID_KEY": "android_maps_sdk_key",
     "GOOGLE_MAPS_IOS_KEY": "ios_maps_sdk_key",
     "GOOGLE_GEOCODING_KEY": "geocoding_api_key"
   }
   ```
3. Run bootstrap:
   ```bash
   chmod +x tool/bootstrap_secrets.sh
   ./tool/bootstrap_secrets.sh
   ```
4. Run the app:
   ```bash
   flutter run --dart-define-from-file=config/dart_defines.json
   ```

Or use the VS Code / Cursor launch config **medpik** (`.vscode/launch.json`), which passes `dartDefineFile` automatically.

### What each key is for

| Key in `secrets.local.json` | Written to | Google restriction |
|-----------------------------|------------|-------------------|
| `GOOGLE_MAPS_ANDROID_KEY` | `android/local.properties` | Maps SDK for Android + package / SHA-1 |
| `GOOGLE_MAPS_IOS_KEY` | `ios/Flutter/Secrets.xcconfig` | Maps SDK for iOS + bundle ID |
| `GOOGLE_GEOCODING_KEY` | `config/dart_defines.json` | Geocoding API only |

Never commit `config/secrets.local.json` or `config/dart_defines.json`.

## Quotas & billing alerts

- Set budget alerts on the Google Cloud billing account.
- Cap daily quotas for Geocoding if abuse is a concern.
- This app reduces cost with:
  - Forward geocode only on explicit search submit (no live autocomplete)
  - Forward geocode uses `country:in` + `region=in` bias
  - Reverse geocode only on `cameraIdle` (700ms debounce) and skip moves &lt; 50m
  - Skip reverse-geocode HTTP when pin is outside Kerala bbox **and** outside hub radius
  - In-memory LRU geocode cache (~111m grid + query cache, 96 entries)
  - Plus-code stripping for cleaner display (no extra API calls)
  - **Local Haversine** serviceability (no Distance Matrix)
  - Saved addresses store lat/lng so list/cart/home never re-call Google

## Serviceability radius

Configured in `LocationConfig`:

- Default map center: Thrissur, Kerala `10.5241, 76.2121`
- Hub (Haversine fallback): Thrissur `10.5241, 76.2121`
- Radius fallback: `150` km (before geocode returns state)
- State match: `Kerala` (from reverse/forward geocode — primary check)

Out-of-area picks show `Strings.locationNotServiceable` and block confirm.

## Blank map tiles (search works, map is beige)

Geocoding and **Maps SDK** use different keys. If the address card updates but tiles are empty:

1. **Enable** [Maps SDK for Android](https://console.cloud.google.com/apis/library/maps-android-backend.googleapis.com) on the project that owns `GOOGLE_MAPS_ANDROID_KEY`.
2. **Enable billing** on the Google Cloud project (required for map tiles).
3. **Restrict the Android key** (Credentials → your Android key):
   - Application restriction: **Android apps**
   - Package name: `com.medpik`
   - SHA-1 (debug): run `./tool/print_android_sha1.sh` — see output for your machine's fingerprint
   - API restriction: **Maps SDK for Android** only
4. **Rebuild** after key changes (hot reload is not enough):
   ```bash
   flutter clean
   flutter run --dart-define-from-file=config/dart_defines.json
   ```
5. **Verify logs** (optional):
   ```bash
   adb logcat | grep -iE "Authorization failure|Google Maps Android|DEVELOPER_ERROR"
   ```

**Quick test:** Temporarily set the Android key to unrestricted. If tiles load, fix package name + SHA-1 restrictions and re-apply.
