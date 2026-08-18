#!/usr/bin/env bash
# Builds a release IPA with iOS Maps config and Geocoding dart-defines baked in.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

./tool/check_ios_release_config.sh

echo "Building release IPA..."
flutter build ipa --release --dart-define-from-file=config/dart_defines.json "$@"
echo "Done: build/ios/ipa"
