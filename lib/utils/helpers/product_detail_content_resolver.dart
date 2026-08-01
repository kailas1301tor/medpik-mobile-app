// lib/utils/helpers/product_detail_content_resolver.dart
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';

class ProductDetailDisplayContent {
  const ProductDetailDisplayContent({
    required this.showAbout,
    required this.showBenefits,
    required this.howToUse,
    required this.safetyInformation,
  });

  final bool showAbout;
  final bool showBenefits;
  final String howToUse;
  final String safetyInformation;
}

ProductDetailDisplayContent resolveProductDetailDisplay(
  ProductDetailModel detail,
) {
  return ProductDetailDisplayContent(
    showAbout: detail.aboutText.trim().isNotEmpty,
    showBenefits: detail.keyBenefits.isNotEmpty,
    howToUse: detail.howToUse.trim().isNotEmpty
        ? detail.howToUse.trim()
        : _defaultHowToUse(detail),
    safetyInformation: detail.safetyInformation.trim().isNotEmpty
        ? detail.safetyInformation.trim()
        : Strings.genericSafetyBody,
  );
}

String _defaultHowToUse(ProductDetailModel detail) {
  return detail.product.requiresPrescription
      ? Strings.howToUseBody
      : Strings.genericHowToUseOtc;
}
