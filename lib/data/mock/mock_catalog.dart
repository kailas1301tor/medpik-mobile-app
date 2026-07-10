// lib/data/mock/mock_catalog.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/src/home/model/home_model.dart';

class MockCatalog {
  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 1,
      name: 'Pain Relief',
      iconKey: 'pain',
      imageUrl:
          'https://images.pexels.com/photos/31406912/pexels-photo-31406912.jpeg',
    ),
    CategoryModel(
      id: 2,
      name: 'Vitamins',
      iconKey: 'vitamins',
      imageUrl:
          'https://images.pexels.com/photos/14027300/pexels-photo-14027300.jpeg',
    ),
    CategoryModel(
      id: 3,
      name: 'Skin Care',
      iconKey: 'skin',
      imageUrl:
          'https://images.pexels.com/photos/7691164/pexels-photo-7691164.jpeg',
    ),
    CategoryModel(
      id: 4,
      name: 'Diabetes',
      iconKey: 'diabetes',
      imageUrl:
          'https://images.pexels.com/photos/6303706/pexels-photo-6303706.jpeg',
    ),
    CategoryModel(
      id: 5,
      name: 'Baby',
      iconKey: 'baby',
      imageUrl:
          'https://images.pexels.com/photos/7282811/pexels-photo-7282811.jpeg',
    ),
  ];

  static const List<OfferModel> offers = [
    OfferModel(
      id: 1,
      title: 'Flat 15% OFF',
      subtitle: '+ Free delivery on your first order',
      badgeLabel: 'FIRST ORDER OFFER',
      promoCode: 'NEW15',
      backgroundKey: 'blue_cyan',
    ),
    OfferModel(
      id: 2,
      title: 'Free delivery',
      subtitle: 'On orders above ₹499',
      badgeLabel: 'DELIVERY OFFER',
      promoCode: 'FREEDEL',
      backgroundKey: 'orange_amber',
    ),
    OfferModel(
      id: 3,
      title: 'Extra 10% OFF',
      subtitle: 'On wellness & supplements',
      badgeLabel: 'WELLNESS OFFER',
      promoCode: 'WELL10',
      backgroundKey: 'purple_pink',
    ),
    OfferModel(
      id: 4,
      title: '20% OFF on skincare',
      subtitle: 'On selected skin care products',
      badgeLabel: 'SKIN CARE OFFER',
      promoCode: 'SKIN20',
      backgroundKey: 'green_lime',
    ),
    OfferModel(
      id: 5,
      title: 'Buy 2 Get 1 Free',
      subtitle: 'On baby care essentials',
      badgeLabel: 'BABY CARE OFFER',
      promoCode: 'BABY3',
      backgroundKey: 'red_orange',
    ),
  ];

  static const List<ProductModel> allProducts = [
    ProductModel(
      id: 101,
      name: 'Crocin Advance Tablet',
      category: 'Pain Relief',
      price: 120,
      mrp: 150,
      discountPercent: 20,
      packSize: '15s',
      imageUrl: 'https://picsum.photos/seed/medpik-crocin/400/400',
      requiresPrescription: false,
      description: 'Effective pain and fever relief tablets.',
    ),
    ProductModel(
      id: 102,
      name: 'Dabur Chyawanprash',
      category: 'Vitamins',
      price: 299,
      mrp: 349,
      discountPercent: 15,
      packSize: '500g',
      imageUrl: 'https://picsum.photos/seed/medpik-chyawanprash/400/400',
      requiresPrescription: false,
      description: 'Immunity support supplement.',
    ),
    ProductModel(
      id: 103,
      name: 'Calcium + Vitamin D3 Tablets',
      category: 'Vitamins',
      price: 185,
      mrp: 220,
      discountPercent: 16,
      packSize: '30s',
      imageUrl: 'https://picsum.photos/seed/medpik-vitamind3/400/400',
      requiresPrescription: false,
      description: 'Bone health supplement.',
    ),
    ProductModel(
      id: 104,
      name: 'Himalaya Face Wash',
      category: 'Skin Care',
      price: 149,
      mrp: 179,
      discountPercent: 17,
      packSize: '100ml',
      imageUrl: 'https://picsum.photos/seed/medpik-himalaya/400/400',
      requiresPrescription: false,
      description: 'Gentle daily face wash.',
    ),
    ProductModel(
      id: 105,
      name: 'Metformin 500mg',
      category: 'Diabetes Care',
      price: 120,
      mrp: 140,
      discountPercent: 14,
      packSize: '10s',
      imageUrl: 'https://picsum.photos/seed/medpik-metformin/400/400',
      requiresPrescription: true,
      description: 'Prescription medicine for blood sugar management.',
    ),
    ProductModel(
      id: 106,
      name: 'Ibuprofen 400mg',
      category: 'Pain Relief',
      price: 65,
      mrp: 80,
      discountPercent: 19,
      packSize: '10s',
      imageUrl: 'https://picsum.photos/seed/medpik-ibuprofen/400/400',
      requiresPrescription: false,
      description: 'Anti-inflammatory pain relief.',
    ),
    ProductModel(
      id: 107,
      name: 'Cetaphil Cleanser',
      category: 'Skin Care',
      price: 549,
      mrp: 649,
      discountPercent: 15,
      packSize: '250ml',
      imageUrl: 'https://picsum.photos/seed/medpik-cetaphil/400/400',
      requiresPrescription: false,
      description: 'Gentle skin cleanser for daily use.',
    ),
    ProductModel(
      id: 108,
      name: 'Baby Diaper Rash Cream',
      category: 'Baby Care',
      price: 199,
      mrp: 249,
      discountPercent: 20,
      packSize: '50g',
      imageUrl: 'https://picsum.photos/seed/medpik-baby/400/400',
      requiresPrescription: false,
      description: 'Soothes and protects baby skin.',
    ),
    ProductModel(
      id: 109,
      name: 'Dolo 650',
      category: 'Pain Relief',
      price: 32,
      mrp: 40,
      discountPercent: 20,
      packSize: '15s',
      imageUrl: 'https://picsum.photos/seed/medpik-dolo650/400/400',
      requiresPrescription: false,
      description: 'Paracetamol tablets for fever and pain relief.',
    ),
  ];

  static List<ProductModel> get featuredProducts {
    const ids = [101, 109, 102, 104, 107, 103];
    return ids
        .map((id) => productById(id))
        .whereType<ProductModel>()
        .toList();
  }

  static const String defaultDeliveryHint = 'Home · Mumbai, 400001';

  static List<ProductModel> searchProducts({
    required String query,
    String? category,
  }) {
    final normalized = query.trim().toLowerCase();
    return allProducts.where((product) {
      final matchesCategory = category == null ||
          category.isEmpty ||
          product.category.toLowerCase() == category.toLowerCase();
      if (!matchesCategory) return false;
      if (normalized.isEmpty) return true;
      return product.name.toLowerCase().contains(normalized) ||
          product.category.toLowerCase().contains(normalized);
    }).toList();
  }

  static ProductModel? productById(int id) {
    for (final product in allProducts) {
      if (product.id == id) return product;
    }
    return null;
  }
}
