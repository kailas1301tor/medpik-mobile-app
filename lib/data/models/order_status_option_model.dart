// lib/data/models/order_status_option_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class OrderStatusOptionModel {
  const OrderStatusOptionModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory OrderStatusOptionModel.fromJson(Map<String, dynamic> json) =>
      OrderStatusOptionModel(
        id: convertToString(json['id']),
        name: convertToString(json['name']),
      );
}
