// lib/data/models/applied_offer_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class AppliedOfferModel {
  const AppliedOfferModel({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.offerLabel = '',
    this.couponCode = '',
    this.discountValue = 0,
    this.discountType = '',
    this.offerType = '',
  });

  final int id;
  final String title;
  final String description;
  final String offerLabel;
  final String couponCode;
  final double discountValue;
  final String discountType;
  final String offerType;

  String get displayLabel {
    final coupon = couponCode.trim();
    if (coupon.isNotEmpty) return coupon;
    final label = offerLabel.trim();
    if (label.isNotEmpty) return label;
    return title.trim();
  }

  factory AppliedOfferModel.fromJson(Map<String, dynamic> json) {
    final couponCode = convertToString(json['coupon_code']).trim();
    return AppliedOfferModel(
      id: convertToInt(json['id']),
      title: convertToString(json['title']),
      description: convertToString(json['description']),
      offerLabel: convertToString(json['offer_label']),
      couponCode: couponCode,
      discountValue: convertToDouble(json['discount_value']),
      discountType: convertToString(json['discount_type']),
      offerType: convertToString(json['offer_type']),
    );
  }
}
