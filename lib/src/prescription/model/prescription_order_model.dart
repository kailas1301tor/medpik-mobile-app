// lib/src/prescription/model/prescription_order_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class PrescriptionOrderResponse {
  const PrescriptionOrderResponse({
    required this.results,
    this.message = '',
  });

  final PrescriptionOrderResults results;
  final String message;

  String get orderId {
    final raw = results.data?.orderId;
    if (raw == null || raw.isEmpty) return '';
    return raw;
  }

  factory PrescriptionOrderResponse.fromJson(Map<String, dynamic> json) =>
      PrescriptionOrderResponse(
        message: convertToString(json['message']),
        results: PrescriptionOrderResults.fromJson(
          convertToMap(json['results']),
        ),
      );
}

class PrescriptionOrderResults {
  const PrescriptionOrderResults({this.data});

  final PrescriptionOrderData? data;

  factory PrescriptionOrderResults.fromJson(Map<String, dynamic> json) =>
      PrescriptionOrderResults(
        data: json['data'] == null
            ? null
            : PrescriptionOrderData.fromJson(convertToMap(json['data'])),
      );
}

class PrescriptionOrderData {
  const PrescriptionOrderData({required this.orderId});

  final String orderId;

  factory PrescriptionOrderData.fromJson(Map<String, dynamic> json) {
    final raw = json['order_id'] ?? json['id'];
    if (raw == null) {
      return const PrescriptionOrderData(orderId: '');
    }
    return PrescriptionOrderData(orderId: convertToString(raw));
  }
}
