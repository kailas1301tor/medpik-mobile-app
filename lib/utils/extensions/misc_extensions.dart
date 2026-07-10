// lib/utils/extensions/misc_extensions.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'string_extensions.dart';
import 'num_extensions.dart';

extension ColorExtension on Color {
  Color mimicOpacityColor(double opacity) => withValues(alpha: opacity);

  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  bool get isDark => computeLuminance() < 0.179;
  bool get isLight => !isDark;

  Color get contrastColor => isDark ? Colors.white : Colors.black;

  String get toHex =>
      '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

extension BoolExtension on bool {
  bool get toggled => !this;

  Widget widget(Widget ifTrue,
          {Widget ifFalse = const SizedBox.shrink()}) =>
      this ? ifTrue : ifFalse;
}

extension NullableBoolExtension on bool? {
  bool get orFalse => this ?? false;
  bool get orTrue => this ?? true;
}

extension ObjectExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);

  T also(void Function(T) block) {
    block(this);
    return this;
  }

  T applyIf(bool condition, T Function(T) block) =>
      condition ? block(this) : this;
}

extension FileExtension on File {
  String get name => path.split('/').last;
  String get extension =>
      name.contains('.') ? name.split('.').last : '';
  String get nameWithoutExtension =>
      name.contains('.') ? name.substring(0, name.lastIndexOf('.')) : name;

  bool get isImage => [
        'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp',
      ].contains(extension.toLowerCase());

  bool get isVideo =>
      ['mp4', 'mov', 'avi', 'mkv', 'webm']
          .contains(extension.toLowerCase());

  bool get isPdf => extension.toLowerCase() == 'pdf';

  Future<String> get sizeFormatted async {
    final bytes = await length();
    return bytes.toFileSize;
  }
}

extension EnumExtension on Enum {
  String get label => name.camelToSentence.capitalize;

  bool isAny(List<Enum> values) => values.contains(this);
}

extension PlatformExtension on Platform {
  static bool get isApple => Platform.isIOS || Platform.isMacOS;
  static bool get isGoogle => Platform.isAndroid;
  static bool get isDesktopOS =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
