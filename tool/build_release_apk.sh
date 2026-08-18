#!/usr/bin/env bash
# Builds a release APK or App Bundle with Geocoding dart-defines baked in.
# Plain `flutter build apk` omits GOOGLE_MAPS_API_KEY and breaks address lookup.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DART_DEFINES="$ROOT/config/dart_defines.json"
TARGET="${1:-apk}"

cd "$ROOT"

if [[ ! -f "$DART_DEFINES" ]]; then
  echo "Missing $DART_DEFINES"
  echo "Copy config/secrets.example.json → config/secrets.local.json,"
  echo "then run ./tool/bootstrap_secrets.sh"
  exit 1
fi

python3 - "$DART_DEFINES" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open(encoding="utf-8") as f:
    data = json.load(f)

key = (data.get("GOOGLE_MAPS_API_KEY") or "").strip()
if not key:
    raise SystemExit(
        f"GOOGLE_MAPS_API_KEY is empty in {path}. "
        "Set GOOGLE_GEOCODING_KEY in config/secrets.local.json "
        "and run ./tool/bootstrap_secrets.sh"
    )
print(f"Using dart-defines from {path} (GOOGLE_MAPS_API_KEY present)")
PY

case "$TARGET" in
  apk)
    echo "Building release APK..."
    flutter build apk --release --dart-define-from-file=config/dart_defines.json
    echo "Done: build/app/outputs/flutter-apk/app-release.apk"
    ;;
  appbundle|aab)
    echo "Building release App Bundle..."
    flutter build appbundle --release --dart-define-from-file=config/dart_defines.json
    echo "Done: build/app/outputs/bundle/release/app-release.aab"
    ;;
  *)
    echo "Usage: $0 [apk|appbundle]"
    echo "  apk        Build release APK (default)"
    echo "  appbundle  Build release App Bundle (Play Store)"
    exit 1
    ;;
esac
