# Google Maps / Places — quotas & key restrictions

Use this checklist when enabling location pick in production.

## Enable APIs (Cloud Console)

- Maps SDK for Android
- Maps SDK for iOS
- Places API (Autocomplete + Place Details)
- Geocoding API

Do **not** enable Distance Matrix, Roads, or Static Maps for this flow.

## Key strategy

Never commit real API keys. Inject them via local/CI config:

1. **Android Maps SDK key** — `AndroidManifest` uses `${GOOGLE_MAPS_API_KEY}`
   - Set in gitignored `android/local.properties`: `GOOGLE_MAPS_API_KEY=...`
   - Or export env var `GOOGLE_MAPS_API_KEY` for CI
   - The Android Gradle build **fails** if this key is missing/blank (avoids shipping an empty Maps SDK key)
   - Restrict to: Maps SDK for Android + app package / SHA-1
2. **iOS Maps SDK key** — `AppDelegate` reads `GMSApiKey` from Info.plist
   - Copy `ios/Flutter/Secrets.xcconfig.example` → `Secrets.xcconfig` (gitignored)
   - Set `GOOGLE_MAPS_API_KEY=...`
   - Restrict to: Maps SDK for iOS + bundle ID
3. **Dart HTTP key** (Places Autocomplete / Details + Geocoding)
   - Prefer `--dart-define=GOOGLE_MAPS_API_KEY=...` (see `LocationConfig.googleMapsApiKey`)
   - Restrict to: Places API + Geocoding API
   - Prefer IP / API restriction; rotate if the key was ever unrestricted in source

Never ship an unrestricted key. Treat any key embedded in the binary as public.
If a key was previously committed, rotate it in Google Cloud Console.

## Quotas & billing alerts

- Set budget alerts on the Google Cloud billing account.
- Cap daily quotas for Places Autocomplete, Place Details, and Geocoding if abuse is a concern.
- This app already reduces cost with:
  - Places **session tokens** (Autocomplete → Details = one session)
  - 400ms autocomplete debounce / min 3 characters
  - Reverse geocode only on `cameraIdle` (500ms debounce) and skip moves &lt; 30m
  - In-memory LRU reverse-geocode cache (~11m grid)
  - **Local Haversine** serviceability (no Distance Matrix)
  - Saved addresses store lat/lng so list/cart/home never re-call Google

## Serviceability radius

Configured in `LocationConfig`:

- Hub: Mumbai `19.0760, 72.8777`
- Radius: `25` km

Out-of-radius picks show `Strings.locationNotServiceable` and block confirm.
