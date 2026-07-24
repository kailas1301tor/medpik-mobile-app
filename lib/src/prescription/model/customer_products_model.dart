// lib/src/prescription/model/customer_products_model.dart
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

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
  int get itemPerPage => results.itemPerPage;

  /// Prefer server pagination meta; fall back to page-size heuristic.
  bool get hasMore {
    if (totalPages > 0) return currentPage < totalPages;
    return data.length >= (itemPerPage > 0 ? itemPerPage : 10);
  }

  List<ProductModel> get data => results.data;

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

  factory CustomerProductsResults.fromJson(Map<String, dynamic> json) {
    final data = convertToList(json['data'])
        .map((e) => ProductModel.fromJson(convertToMap(e)))
        .toList();
    final itemPerPage = convertToInt(json['item_per_page'], defValue: 10);
    final currentPage = convertToInt(json['current_page'], defValue: 1);
    var totalPages = convertToInt(json['total_pages']);
    var totalCount = convertToInt(json['total_count']);

    // Responses that only return `data` — infer pagination from page size.
    if (totalPages <= 0 && data.isNotEmpty) {
      if (data.length >= itemPerPage) {
        totalPages = currentPage + 1;
      } else {
        totalPages = currentPage;
      }
    }
    if (totalCount <= 0) {
      totalCount = data.length;
    }

    return CustomerProductsResults(
      totalCount: totalCount,
      totalPages: totalPages,
      currentPage: currentPage,
      itemPerPage: itemPerPage > 0 ? itemPerPage : 10,
      data: data,
    );
  }
}
