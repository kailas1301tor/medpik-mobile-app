// lib/src/prescription/model/prescription_order_model.dart
import 'package:tsuite/utils/helpers/safe_converters.dart';

class PrescriptionOrderResponse {
  const PrescriptionOrderResponse({
    required this.results,
    this.message = '',
  });

  final PrescriptionOrderResults results;
  final String message;

  String get orderId => '${results.data?.orderId ?? ''}';

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

  final int orderId;

  factory PrescriptionOrderData.fromJson(Map<String, dynamic> json) =>
      PrescriptionOrderData(
        orderId: convertToInt(json['order_id']),
      );
}
