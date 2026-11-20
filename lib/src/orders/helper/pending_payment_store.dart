// lib/src/orders/helper/pending_payment_store.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

/// Local snapshot of an in-flight Razorpay payment so we can resume verify
/// after a crash, kill, or network drop mid-checkout.
class PendingPaymentSnapshot {
  const PendingPaymentSnapshot({
    required this.orderId,
    required this.parsedOrderId,
    required this.razorpayOrderId,
    this.razorpayPaymentId = '',
    this.razorpaySignature = '',
  });

  final String orderId;
  final int parsedOrderId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  bool get canResumeVerify =>
      razorpayPaymentId.trim().isNotEmpty &&
      razorpaySignature.trim().isNotEmpty &&
      razorpayOrderId.trim().isNotEmpty &&
      parsedOrderId > 0;

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'parsedOrderId': parsedOrderId,
        'razorpayOrderId': razorpayOrderId,
        'razorpayPaymentId': razorpayPaymentId,
        'razorpaySignature': razorpaySignature,
      };

  factory PendingPaymentSnapshot.fromJson(Map<String, dynamic> json) {
    return PendingPaymentSnapshot(
      orderId: convertToString(json['orderId']),
      parsedOrderId: convertToInt(json['parsedOrderId']),
      razorpayOrderId: convertToString(json['razorpayOrderId']),
      razorpayPaymentId: convertToString(json['razorpayPaymentId']),
      razorpaySignature: convertToString(json['razorpaySignature']),
    );
  }

  PendingPaymentSnapshot copyWith({
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) {
    return PendingPaymentSnapshot(
      orderId: orderId,
      parsedOrderId: parsedOrderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
      razorpaySignature: razorpaySignature ?? this.razorpaySignature,
    );
  }
}

abstract final class PendingPaymentStore {
  static const _key = 'medpik_pending_razorpay_payment';

  static Future<void> save(PendingPaymentSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(snapshot.toJson()));
  }

  static Future<PendingPaymentSnapshot?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return PendingPaymentSnapshot.fromJson(convertToMap(jsonDecode(raw)));
    } catch (_) {
      await prefs.remove(_key);
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
