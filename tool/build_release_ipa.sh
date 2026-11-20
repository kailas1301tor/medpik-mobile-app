#!/usr/bin/env bash
# Builds a release IPA with iOS Maps config and Geocoding dart-defines baked in.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

./tool/check_ios_release_config.sh

echo "Building release IPA..."
flutter build ipa --release \
  --dart-define-from-file=config/dart_defines.json \
  --obfuscate \
  --split-debug-info=build/debug-info \
  "$@"
echo "Done: build/ios/ipa"
echo "Uploading Flutter Crashlytics symbols for iOS..."
"$ROOT/tool/upload_crashlytics_symbols.sh" ios
echo "Native/dSYM upload also runs via the Xcode Crashlytics build phase (flutterfire)."
echo "Keep build/debug-info for audits / re-upload if needed."
