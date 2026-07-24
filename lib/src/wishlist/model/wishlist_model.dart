// lib/src/wishlist/model/wishlist_model.dart
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class WishlistResponse {
  const WishlistResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final WishlistResultsModel results;
  final String message;
  final bool status;

  List<ProductModel> get productsDetail =>
      results.data?.productsDetail ?? const [];

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return WishlistResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: WishlistResultsModel.fromJson(convertToMap(json['results'])),
    );
  }
}

class WishlistResultsModel {
  const WishlistResultsModel({this.data});

  final WishlistDataModel? data;

  factory WishlistResultsModel.fromJson(Map<String, dynamic> json) =>
      WishlistResultsModel(
        data: json['data'] == null
            ? null
            : WishlistDataModel.fromJson(convertToMap(json['data'])),
      );
}

class WishlistDataModel {
  const WishlistDataModel({
    this.id = 0,
    this.customer = 0,
    this.products = const [],
    this.productsDetail = const [],
  });

  final int id;
  final int customer;
  final List<int> products;
  final List<ProductModel> productsDetail;

  factory WishlistDataModel.fromJson(Map<String, dynamic> json) {
    return WishlistDataModel(
      id: convertToInt(json['id']),
      customer: convertToInt(json['customer']),
      products: convertToList(json['products']).map(_parseProductId).toList(),
      productsDetail: convertToList(json['products_detail'])
          .map((e) => ProductModel.fromJson(convertToMap(e)))
          .map((p) => p.copyWith(isWishlisted: true))
          .toList(),
    );
  }

  static int _parseProductId(dynamic value) {
    if (value is Map) {
      return convertToInt(value['id']);
    }
    return convertToInt(value);
  }
}

class WishlistToggleResponse {
  const WishlistToggleResponse({
    this.message = '',
    this.status = true,
  });

  final String message;
  final bool status;

  factory WishlistToggleResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return WishlistToggleResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
    );
  }
}
