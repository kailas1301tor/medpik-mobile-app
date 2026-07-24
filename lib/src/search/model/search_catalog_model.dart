// lib/src/search/model/search_catalog_model.dart
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class SearchCatalogResponse {
  const SearchCatalogResponse({
    required this.results,
    this.message = '',
  });

  final SearchCatalogResults results;
  final String message;

  List<ProductModel> get products => results.data;
  int get currentPage => results.currentPage;
  int get totalPages => results.totalPages;
  int get totalCount => results.totalCount;
  int get itemPerPage => results.itemPerPage;

  bool get hasMore {
    if (totalPages > 0) return currentPage < totalPages;
    return data.length >= (itemPerPage > 0 ? itemPerPage : 10);
  }

  List<ProductModel> get data => results.data;

  factory SearchCatalogResponse.fromJson(Map<String, dynamic> json) =>
      SearchCatalogResponse(
        message: convertToString(json['message']),
        results: SearchCatalogResults.fromJson(
          convertToMap(json['results']),
        ),
      );
}

class SearchCatalogResults {
  const SearchCatalogResults({
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

  factory SearchCatalogResults.fromJson(Map<String, dynamic> json) {
    final data = convertToList(json['data'])
        .map((e) => ProductModel.fromJson(convertToMap(e)))
        .toList();
    final itemPerPage = convertToInt(json['item_per_page'], defValue: 10);
    final currentPage = convertToInt(json['current_page'], defValue: 1);
    var totalPages = convertToInt(json['total_pages']);
    var totalCount = convertToInt(json['total_count']);

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

    return SearchCatalogResults(
      totalCount: totalCount,
      totalPages: totalPages,
      currentPage: currentPage,
      itemPerPage: itemPerPage > 0 ? itemPerPage : 10,
      data: data,
    );
  }
}
