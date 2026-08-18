#!/usr/bin/env bash
# Fails iOS release/profile builds when Google Maps config is not baked in.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IOS_SECRETS="$ROOT/ios/Flutter/Secrets.xcconfig"
DART_DEFINES_FILE="$ROOT/config/dart_defines.json"
REQUIRE_BUILD_DART_DEFINES=false

if [[ "${1:-}" == "--require-build-dart-defines" ]]; then
  REQUIRE_BUILD_DART_DEFINES=true
fi

fail() {
  echo "error: $*" >&2
  exit 1
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

if [[ ! -f "$IOS_SECRETS" ]]; then
  fail "Missing ios/Flutter/Secrets.xcconfig. Run ./tool/bootstrap_secrets.sh before building the iOS release."
fi

ios_key="$(
  awk -F= '
    $1 ~ /^[[:space:]]*GOOGLE_MAPS_API_KEY[[:space:]]*$/ {
      sub(/^[[:space:]]*/, "", $2)
      sub(/[[:space:]]*$/, "", $2)
      print $2
      exit
    }
  ' "$IOS_SECRETS"
)"
ios_key="$(trim "$ios_key")"

if [[ -z "$ios_key" || "$ios_key" == your_* || "$ios_key" == *'$('* ]]; then
  fail "GOOGLE_MAPS_API_KEY is empty or unresolved in ios/Flutter/Secrets.xcconfig. Run ./tool/bootstrap_secrets.sh with a valid GOOGLE_MAPS_IOS_KEY."
fi

if [[ ! -f "$DART_DEFINES_FILE" ]]; then
  fail "Missing config/dart_defines.json. Run ./tool/bootstrap_secrets.sh before building the iOS release."
fi

python3 - "$DART_DEFINES_FILE" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open(encoding="utf-8") as handle:
    data = json.load(handle)

key = str(data.get("GOOGLE_MAPS_API_KEY") or "").strip()
if not key or key.startswith("your_") or "$(" in key:
    raise SystemExit(
        "error: GOOGLE_MAPS_API_KEY is empty or unresolved in "
        "config/dart_defines.json. Set GOOGLE_GEOCODING_KEY in "
        "config/secrets.local.json, then run ./tool/bootstrap_secrets.sh."
    )
PY

if [[ "$REQUIRE_BUILD_DART_DEFINES" == true ]]; then
  python3 <<'PY'
import base64
import os
import sys

raw_defines = os.environ.get("DART_DEFINES", "")
decoded_defines = []

for item in raw_defines.split(","):
    item = item.strip()
    if not item:
        continue
    try:
        decoded_defines.append(base64.b64decode(item).decode("utf-8"))
    except Exception:
        continue

for define in decoded_defines:
    if define.startswith("GOOGLE_MAPS_API_KEY="):
        value = define.split("=", 1)[1].strip()
        if value and not value.startswith("your_") and "$(" not in value:
            sys.exit(0)

raise SystemExit(
    "error: GOOGLE_MAPS_API_KEY was not passed into this Flutter iOS build. "
    "Build TestFlight archives with: flutter build ipa --release "
    "--dart-define-from-file=config/dart_defines.json"
)
PY
fi

echo "iOS release config OK: Google Maps iOS key and Dart geocoding define are present."
