// lib/src/prescription/model/customer_products_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class CustomerProductsResponse {
  const CustomerProductsResponse({
    required this.results,
    this.message = '',
  });

  final CustomerProductsResults results;
  final String message;

  List<ProductModel> get products => results.data;
  int get currentPage => results.currentPage;
  int get totalPages => results.totalPages;
  int get totalCount => results.totalCount;
  bool get hasMore => results.currentPage < results.totalPages;

  factory CustomerProductsResponse.fromJson(Map<String, dynamic> json) =>
      CustomerProductsResponse(
        message: convertToString(json['message']),
        results: CustomerProductsResults.fromJson(
          convertToMap(json['results']),
        ),
      );
}

class CustomerProductsResults {
  const CustomerProductsResults({
    this.totalCount = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.itemPerPage = 10,
    this.data = const [],
  });

  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int itemPerPage;
  final List<ProductModel> data;

  factory CustomerProductsResults.fromJson(Map<String, dynamic> json) =>
      CustomerProductsResults(
        totalCount: convertToInt(json['total_count']),
        totalPages: convertToInt(json['total_pages']),
        currentPage: convertToInt(json['current_page'], defValue: 1),
        itemPerPage: convertToInt(json['item_per_page'], defValue: 10),
        data: convertToList(json['data'])
            .map((e) => ProductModel.fromJson(convertToMap(e)))
            .toList(),
      );
}
