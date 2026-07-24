// lib/utils/helpers/geocode_address_formatter.dart

/// Strips a leading Google Plus Code from a geocoded address when present.
/// Example: "J7HM+397, Malakka, Kerala" → "Malakka, Kerala".
String formatGeocodeDisplayAddress(String formatted) {
  final trimmed = formatted.trim();
  if (trimmed.isEmpty) return trimmed;

  final withoutPlusCode = trimmed.replaceFirst(
    RegExp(r'^[A-Z0-9]{4,}\+[A-Z0-9]{2,},\s*', caseSensitive: false),
    '',
  );
  return withoutPlusCode.trim();
}
