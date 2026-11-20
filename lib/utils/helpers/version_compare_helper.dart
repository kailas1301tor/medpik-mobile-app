// lib/utils/helpers/version_compare_helper.dart

/// Returns true when [current] is strictly older than [minimum] (semver-ish).
/// Empty [minimum] means no gate. Non-numeric segments compare as 0.
bool isAppVersionBelowMinimum({
  required String current,
  required String minimum,
}) {
  final min = minimum.trim();
  if (min.isEmpty) return false;

  final currentParts = _parseVersionParts(current);
  final minimumParts = _parseVersionParts(min);
  final length = currentParts.length > minimumParts.length
      ? currentParts.length
      : minimumParts.length;

  for (var i = 0; i < length; i++) {
    final a = i < currentParts.length ? currentParts[i] : 0;
    final b = i < minimumParts.length ? minimumParts[i] : 0;
    if (a < b) return true;
    if (a > b) return false;
  }
  return false;
}

List<int> _parseVersionParts(String version) {
  final cleaned = version.trim().split('+').first.split('-').first;
  if (cleaned.isEmpty) return const [0];
  return cleaned.split('.').map((part) {
    final match = RegExp(r'^\d+').firstMatch(part.trim());
    return match == null ? 0 : int.tryParse(match.group(0)!) ?? 0;
  }).toList();
}
