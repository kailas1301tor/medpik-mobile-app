#!/usr/bin/env bash
# Prints the debug SHA-1 for Google Cloud Console Android key restrictions.
set -euo pipefail

JAVA_HOME="${JAVA_HOME:-/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
export JAVA_HOME

if [[ ! -x "$JAVA_HOME/bin/keytool" ]]; then
  echo "keytool not found. Set JAVA_HOME to your JDK (Android Studio JBR works)."
  exit 1
fi

KEYSTORE="${HOME}/.android/debug.keystore"
if [[ ! -f "$KEYSTORE" ]]; then
  echo "Debug keystore not found at $KEYSTORE"
  exit 1
fi

SHA1="$("$JAVA_HOME/bin/keytool" -list -v \
  -keystore "$KEYSTORE" \
  -alias androiddebugkey \
  -storepass android \
  -keypass android 2>/dev/null | awk -F': ' '/SHA1:/ {print $2; exit}')"

echo ""
echo "Add this to Google Cloud Console → Credentials → Android API key:"
echo ""
echo "  Package name: com.medpik"
echo "  SHA-1:        ${SHA1}"
echo ""
echo "Also enable: Maps SDK for Android + billing on the project."
echo ""
