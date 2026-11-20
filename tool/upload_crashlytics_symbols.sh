#!/usr/bin/env bash
# Uploads Flutter --split-debug-info symbols to Firebase Crashlytics.
# Usage:
#   ./tool/upload_crashlytics_symbols.sh android
#   ./tool/upload_crashlytics_symbols.sh ios
#   ./tool/upload_crashlytics_symbols.sh all
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TARGET="${1:-all}"
DEBUG_INFO_DIR="${CRASHLYTICS_DEBUG_INFO_DIR:-build/debug-info}"

ANDROID_APP_ID="1:361036519579:android:43be5eb0744fe993a30e3e"
IOS_APP_ID="1:361036519579:ios:95ec9374e02cfb05a30e3e"
FIREBASE_ACCOUNT="${FIREBASE_ACCOUNT:-mednationspharmastore@gmail.com}"
FIREBASE_PROJECT="${FIREBASE_PROJECT:-medpik-ea048}"

if [[ ! -d "$DEBUG_INFO_DIR" ]]; then
  echo "Missing $DEBUG_INFO_DIR"
  echo "Build with --obfuscate --split-debug-info=$DEBUG_INFO_DIR first."
  exit 1
fi

if ! command -v firebase >/dev/null 2>&1; then
  echo "firebase CLI not found. Install Firebase CLI and login as $FIREBASE_ACCOUNT"
  exit 1
fi

upload_for_app() {
  local platform="$1"
  local app_id="$2"
  echo "Uploading Flutter Crashlytics symbols for $platform ($app_id)..."
  firebase crashlytics:symbols:upload \
    --app="$app_id" \
    --project="$FIREBASE_PROJECT" \
    --account="$FIREBASE_ACCOUNT" \
    "$DEBUG_INFO_DIR"
  echo "Done: $platform"
}

case "$TARGET" in
  android)
    upload_for_app android "$ANDROID_APP_ID"
    ;;
  ios)
    upload_for_app ios "$IOS_APP_ID"
    ;;
  all)
    upload_for_app android "$ANDROID_APP_ID"
    upload_for_app ios "$IOS_APP_ID"
    ;;
  *)
    echo "Usage: $0 [android|ios|all]"
    exit 1
    ;;
esac
