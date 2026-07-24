// lib/src/home/model/customer_general_data_model.dart
import 'package:medpik/data/models/order_status_option_model.dart';
import 'package:medpik/src/home/model/home_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class CustomerGeneralDataResponse {
  const CustomerGeneralDataResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final CustomerGeneralDataResultsModel results;
  final String message;
  final bool status;

  CustomerGeneralDataModel? get data => results.data;

  List<CategoryModel> get categories => results.data?.categories ?? const [];

  List<OrderStatusOptionModel> get orderStatuses =>
      results.data?.orderStatuses ?? const [];

  factory CustomerGeneralDataResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return CustomerGeneralDataResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: CustomerGeneralDataResultsModel.fromJson(
        convertToMap(json['results']),
      ),
    );
  }
}

class CustomerGeneralDataResultsModel {
  const CustomerGeneralDataResultsModel({this.data});

  final CustomerGeneralDataModel? data;

  factory CustomerGeneralDataResultsModel.fromJson(Map<String, dynamic> json) =>
      CustomerGeneralDataResultsModel(
        data: json['data'] == null
            ? null
            : CustomerGeneralDataModel.fromJson(convertToMap(json['data'])),
      );
}

class CustomerGeneralDataModel {
  const CustomerGeneralDataModel({
    this.categories = const [],
    this.orderStatuses = const [],
  });

  final List<CategoryModel> categories;
  final List<OrderStatusOptionModel> orderStatuses;

  factory CustomerGeneralDataModel.fromJson(Map<String, dynamic> json) =>
      CustomerGeneralDataModel(
        categories: convertToList(json['categories'])
            .map((e) => CategoryModel.fromJson(convertToMap(e)))
            .toList(),
        orderStatuses: convertToList(json['order_statuses'])
            .map((e) => OrderStatusOptionModel.fromJson(convertToMap(e)))
            .toList(),
      );
}
