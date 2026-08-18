#!/usr/bin/env python3
"""Encode dart-defines JSON for Flutter's Xcode backend."""

import base64
import json
import os
import sys
from pathlib import Path


def _decode_existing(raw_defines: str) -> list[str]:
    decoded: list[str] = []
    for item in raw_defines.split(","):
        value = item.strip()
        if not value:
            continue
        try:
            decoded.append(base64.b64decode(value).decode("utf-8"))
        except Exception:
            continue
    return decoded


def _encode(value: str) -> str:
    return base64.b64encode(value.encode("utf-8")).decode("ascii")


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: encode_dart_defines.py <dart_defines.json>", file=sys.stderr)
        return 64

    defines_path = Path(sys.argv[1])
    with defines_path.open(encoding="utf-8") as handle:
        defines = json.load(handle)

    pairs = {
        str(key): str(value).strip()
        for key, value in defines.items()
        if str(key).strip() and str(value).strip()
    }

    if not pairs:
        print(f"error: no dart-defines found in {defines_path}", file=sys.stderr)
        return 1

    existing_pairs = {}
    for item in _decode_existing(os.environ.get("DART_DEFINES", "")):
        if "=" not in item:
            continue
        key, value = item.split("=", 1)
        key = key.strip()
        value = value.strip()
        if key and value:
            existing_pairs[key] = value

    merged_pairs = {**pairs, **existing_pairs}
    merged = [f"{key}={value}" for key, value in merged_pairs.items()]

    print(",".join(_encode(item) for item in merged))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
