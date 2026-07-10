// lib/utils/extensions/num_extensions.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NumExtension on num {
  String toCurrency({String symbol = '₹', int decimalDigits = 2}) =>
      NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits)
          .format(this);

  String get compact => NumberFormat.compact().format(this);

  double get asProgress => clamp(0.0, 1.0).toDouble();

  bool get isPositive => this > 0;
  bool get isNegative => this < 0;
  bool get isZero => this == 0;

  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
}

extension IntExtension on int {
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  String get withCommas => NumberFormat('#,##0').format(this);

  String get toFileSize {
    if (this < 1024) return '$this B';
    if (this < 1048576) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1073741824) return '${(this / 1048576).toStringAsFixed(1)} MB';
    return '${(this / 1073741824).toStringAsFixed(1)} GB';
  }

  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;

  void times(VoidCallback action) {
    for (var i = 0; i < this; i++) {
      action();
    }
  }
}

extension DoubleExtension on double {
  double roundTo(int places) {
    final factor = pow(10, places);
    return (this * factor).round() / factor;
  }

  String get asPercent => '${(this * 100).toStringAsFixed(1)}%';

  double get toFahrenheit => this * 9 / 5 + 32;
  double get toCelsius => (this - 32) * 5 / 9;
}
