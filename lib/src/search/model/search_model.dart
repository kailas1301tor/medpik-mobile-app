// lib/src/search/model/search_model.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/home/model/home_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class SearchResponseModel {
  const SearchResponseModel({
    required this.products,
    required this.categories,
  });

  final List<ProductModel> products;
  final List<CategoryModel> categories;

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchResponseModel(
        products: convertToList(json['products'])
            .map((e) => ProductModel.fromJson(convertToMap(e)))
            .toList(),
        categories: convertToList(json['categories'])
            .map((e) => CategoryModel.fromJson(convertToMap(e)))
            .toList(),
      );
}
