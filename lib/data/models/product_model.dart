// lib/data/models/product_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.requiresPrescription,
    this.description = '',
    this.mrp,
    this.discountPercent,
    this.packSize = '',
    this.manufacturerName = '',
    this.isWishlisted = false,
    this.images = const [],
    this.isDrugsetuProducts = false,
    this.drugsetuProductId = '',
    this.productType = '',
    this.composition = '',
    this.packageType = '',
    this.productForm = '',
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool requiresPrescription;
  final String description;
  final double? mrp;
  final int? discountPercent;
  final String packSize;
  final String manufacturerName;
  final bool isWishlisted;
  final List<String> images;
  final bool isDrugsetuProducts;
  final String drugsetuProductId;
  final String productType;
  final String composition;
  final String packageType;
  final String productForm;

  static List<String> _parseImageList(Map<String, dynamic> json) {
    final fromImages = convertToList(json['images'])
        .map(convertToString)
        .where((url) => url.isNotEmpty)
        .toList();
    if (fromImages.isNotEmpty) return fromImages;

    final fromProductImages = convertToList(json['product_images'])
        .map(convertToString)
        .where((url) => url.isNotEmpty)
        .toList();
    if (fromProductImages.isNotEmpty) return fromProductImages;

    final single = convertToString(json['image']).isNotEmpty
        ? convertToString(json['image'])
        : convertToString(json['image_url']);
    return single.isEmpty ? const [] : [single];
  }

  static String _resolveImageUrl(
    Map<String, dynamic> json,
    List<String> images,
  ) {
    final image = convertToString(json['image']);
    if (image.isNotEmpty) return image;
    if (images.isNotEmpty) return images.first;
    return convertToString(json['image_url']);
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final categoryDetail = convertToMap(json['category_detail']);
    final manufacturerDetail = convertToMap(json['manufacturer_detail']);

    final categoryDetailName = convertToString(categoryDetail['name']);
    final rawCategory = json['category'];
    final category = categoryDetailName.isNotEmpty
        ? categoryDetailName
        : rawCategory is String
            ? convertToString(rawCategory)
            : '';

    final images = _parseImageList(json);
    final imageUrl = _resolveImageUrl(json, images);

    final price = json['rate'] != null
        ? convertToDouble(json['rate'])
        : convertToDouble(json['price']);

    final requiresPrescription = json.containsKey('is_otc')
        ? !convertToBool(json['is_otc'])
        : convertToBool(json['requires_prescription']);

    final manufacturerName =
        convertToString(json['manufacturer_name']).isNotEmpty
            ? convertToString(json['manufacturer_name'])
            : convertToString(manufacturerDetail['name']);

    return ProductModel(
      id: convertToInt(json['id']),
      name: convertToString(json['name']),
      category: category,
      price: price,
      imageUrl: imageUrl,
      requiresPrescription: requiresPrescription,
      description: convertToString(json['description']),
      mrp: json['mrp'] == null ? null : convertToDouble(json['mrp']),
      discountPercent: json['discount_percent'] == null
          ? null
          : convertToInt(json['discount_percent']),
      packSize: convertToString(json['pack_size']),
      manufacturerName: manufacturerName,
      isWishlisted: convertToBool(json['is_wishlisted']),
      images: images,
      isDrugsetuProducts: convertToBool(json['is_drugsetu_products']),
      drugsetuProductId: convertToString(json['drugsetu_product_id']),
      productType: convertToString(json['product_type']),
      composition: convertToString(json['composition']),
      packageType: convertToString(json['package']),
      productForm: convertToString(json['product_form']),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    String? imageUrl,
    bool? requiresPrescription,
    String? description,
    double? mrp,
    int? discountPercent,
    String? packSize,
    String? manufacturerName,
    bool? isWishlisted,
    List<String>? images,
    bool? isDrugsetuProducts,
    String? drugsetuProductId,
    String? productType,
    String? composition,
    String? packageType,
    String? productForm,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      description: description ?? this.description,
      mrp: mrp ?? this.mrp,
      discountPercent: discountPercent ?? this.discountPercent,
      packSize: packSize ?? this.packSize,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      images: images ?? this.images,
      isDrugsetuProducts: isDrugsetuProducts ?? this.isDrugsetuProducts,
      drugsetuProductId: drugsetuProductId ?? this.drugsetuProductId,
      productType: productType ?? this.productType,
      composition: composition ?? this.composition,
      packageType: packageType ?? this.packageType,
      productForm: productForm ?? this.productForm,
    );
  }
}
