// lib/src/cart/model/cart_response_model.dart
import 'package:medpik/data/models/cart_item_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class CartResponse {
  const CartResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final CartResultsModel results;
  final String message;
  final bool status;

  List<CartItemModel> get items => results.data?.items ?? const [];

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return CartResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: CartResultsModel.fromJson(convertToMap(json['results'])),
    );
  }
}

class CartResultsModel {
  const CartResultsModel({this.data});

  final CartDataModel? data;

  factory CartResultsModel.fromJson(Map<String, dynamic> json) =>
      CartResultsModel(
        data: json['data'] == null
            ? null
            : CartDataModel.fromJson(convertToMap(json['data'])),
      );
}

class CartDataModel {
  const CartDataModel({
    this.id = 0,
    this.customer = 0,
    this.items = const [],
  });

  final int id;
  final int customer;
  final List<CartItemModel> items;

  factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
        id: convertToInt(json['id']),
        customer: convertToInt(json['customer']),
        items: convertToList(json['items'])
            .map((e) => CartItemModel.fromJson(convertToMap(e)))
            .toList(),
      );
}
