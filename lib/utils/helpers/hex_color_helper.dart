// lib/utils/helpers/hex_color_helper.dart
import 'package:flutter/material.dart';

/// Parses `#RRGGBB` / `RRGGBB` / `#AARRGGBB` into a [Color].
Color? tryParseHexColor(String? hex) {
  if (hex == null) return null;
  var cleaned = hex.trim();
  if (cleaned.isEmpty) return null;
  if (cleaned.startsWith('#')) {
    cleaned = cleaned.substring(1);
  }
  if (cleaned.length == 6) {
    cleaned = 'FF$cleaned';
  }
  if (cleaned.length != 8) return null;
  final value = int.tryParse(cleaned, radix: 16);
  if (value == null) return null;
  return Color(value);
}
