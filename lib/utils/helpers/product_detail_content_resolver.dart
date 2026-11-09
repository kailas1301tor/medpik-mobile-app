// lib/utils/helpers/product_detail_content_resolver.dart
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';

class ProductDetailSafetyBlock {
  const ProductDetailSafetyBlock({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class ProductDetailDisplayContent {
  const ProductDetailDisplayContent({
    required this.showAbout,
    required this.showBenefits,
    required this.showComposition,
    required this.showUses,
    required this.showPackagings,
    required this.howToUse,
    required this.safetyBlocks,
    required this.storageBody,
    required this.composition,
    required this.uses,
  });

  final bool showAbout;
  final bool showBenefits;
  final bool showComposition;
  final bool showUses;
  final bool showPackagings;
  final String howToUse;
  final List<ProductDetailSafetyBlock> safetyBlocks;
  final String storageBody;
  final String composition;
  final String uses;
}

ProductDetailDisplayContent resolveProductDetailDisplay(
  ProductDetailModel detail,
) {
  final about = detail.aboutText.trim();
  final uses = detail.uses.trim();
  final composition = detail.composition.trim();
  final showUses =
      uses.isNotEmpty && uses.toLowerCase() != about.toLowerCase();

  return ProductDetailDisplayContent(
    showAbout: about.isNotEmpty,
    showBenefits: detail.keyBenefits.isNotEmpty,
    showComposition: composition.isNotEmpty,
    showUses: showUses,
    showPackagings: detail.packagings.isNotEmpty,
    howToUse: _resolveHowToUse(detail),
    safetyBlocks: _resolveSafetyBlocks(detail),
    storageBody: detail.storage.trim().isNotEmpty
        ? detail.storage.trim()
        : Strings.genericStorageBody,
    composition: composition,
    uses: uses,
  );
}

String _resolveHowToUse(ProductDetailModel detail) {
  if (detail.howToUse.trim().isNotEmpty) return detail.howToUse.trim();
  if (detail.dosage.trim().isNotEmpty) return detail.dosage.trim();
  return detail.product.requiresPrescription
      ? Strings.howToUseBody
      : Strings.genericHowToUseOtc;
}

List<ProductDetailSafetyBlock> _resolveSafetyBlocks(ProductDetailModel detail) {
  final blocks = <ProductDetailSafetyBlock>[
    if (detail.indications.trim().isNotEmpty)
      ProductDetailSafetyBlock(
        title: Strings.indications,
        body: detail.indications.trim(),
      ),
    if (detail.contraindications.trim().isNotEmpty)
      ProductDetailSafetyBlock(
        title: Strings.contraindications,
        body: detail.contraindications.trim(),
      ),
    if (detail.warnings.trim().isNotEmpty)
      ProductDetailSafetyBlock(
        title: Strings.warnings,
        body: detail.warnings.trim(),
      ),
    if (detail.precautions.trim().isNotEmpty)
      ProductDetailSafetyBlock(
        title: Strings.precautions,
        body: detail.precautions.trim(),
      ),
    if (detail.sideEffects.trim().isNotEmpty)
      ProductDetailSafetyBlock(
        title: Strings.sideEffects,
        body: detail.sideEffects.trim(),
      ),
    if (detail.drugInteractions.trim().isNotEmpty)
      ProductDetailSafetyBlock(
        title: Strings.drugInteractions,
        body: detail.drugInteractions.trim(),
      ),
  ];

  if (blocks.isNotEmpty) return blocks;

  final legacy = detail.safetyInformation.trim().isNotEmpty
      ? detail.safetyInformation.trim()
      : Strings.genericSafetyBody;

  return [
    ProductDetailSafetyBlock(
      title: Strings.safetyInformation,
      body: legacy,
    ),
  ];
}
