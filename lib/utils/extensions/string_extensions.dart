// lib/utils/extensions/string_extensions.dart
import 'package:flutter/services.dart';

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  String get camelToSentence => replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => ' ${m.group(0)}',
      ).trim().capitalize;

  bool get isValidEmail =>
      RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPhone =>
      RegExp(r'^\+?[0-9]{7,15}$').hasMatch(replaceAll(' ', ''));

  bool get isValidUrl =>
      RegExp(r'^https?://[^\s/$.?#].[^\s]*$').hasMatch(this);

  bool get isValidPassword =>
      length >= 8 &&
      contains(RegExp(r'[A-Z]')) &&
      contains(RegExp(r'[0-9]')) &&
      contains(RegExp(r'[!@#\$%^&*]'));

  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  bool get isBlank => trim().isEmpty;

  String? get nullIfEmpty => isEmpty ? null : this;

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  String truncate(int maxLength, {String ellipsis = '...'}) =>
      length <= maxLength ? this : '${substring(0, maxLength)}$ellipsis';

  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  String get snakeToCamel {
    final parts = split('_');
    return parts[0] + parts.skip(1).map((p) => p.capitalize).join();
  }

  void copyToClipboard() => Clipboard.setData(ClipboardData(text: this));
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
  String get orEmpty => this ?? '';
}
