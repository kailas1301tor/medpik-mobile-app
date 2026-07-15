// lib/src/product_detail/repo/product_detail_data_builder.dart
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/product_detail/model/product_benefit_model.dart';
import 'package:tsuite/src/product_detail/model/product_detail_model.dart';
import 'package:tsuite/src/product_detail/model/product_trust_badge_model.dart';

class ProductDetailDataBuilder {
  const ProductDetailDataBuilder._();

  static ProductDetailModel build(ProductModel product) {
    if (product.id == 101) {
      return _crocinDetail(product);
    }
    return _genericDetail(product);
  }

  static ProductDetailModel _crocinDetail(ProductModel product) {
    return ProductDetailModel(
      product: product,
      dosage: '500mg',
      packLabel: 'Strip of 15 tablets',
      aboutText:
          'Crocin Advance Tablet is used to relieve pain and reduce fever. '
          'It contains paracetamol which helps manage headaches, body aches, '
          'toothache, and fever associated with common cold and flu.',
      howToUse: Strings.howToUseBody,
      safetyInformation: Strings.safetyInformationBody,
      trustBadges: const [
        ProductTrustBadgeModel(
          title: Strings.trustedAndEffective,
          subtitle: Strings.trustedBrandSubtitle,
          iconKey: 'shield',
        ),
        ProductTrustBadgeModel(
          title: Strings.clinicallyProven,
          subtitle: Strings.clinicallyProvenSubtitle,
          iconKey: 'beaker',
        ),
        ProductTrustBadgeModel(
          title: Strings.qualityAssured,
          subtitle: Strings.qualityAssuredSubtitle,
          iconKey: 'medal',
        ),
      ],
      keyBenefits: const [
        ProductBenefitModel(
          title: Strings.relievesPain,
          description: Strings.relievesPainSubtitle,
          iconKey: 'healing',
        ),
        ProductBenefitModel(
          title: Strings.reducesFever,
          description: Strings.reducesFeverSubtitle,
          iconKey: 'thermometer',
        ),
        ProductBenefitModel(
          title: Strings.fastActing,
          description: Strings.fastActingSubtitle,
          iconKey: 'schedule',
        ),
      ],
    );
  }

  static ProductDetailModel _genericDetail(ProductModel product) {
    final packLabel = product.packSize.isNotEmpty
        ? 'Pack of ${product.packSize}'
        : Strings.standardPack;

    return ProductDetailModel(
      product: product,
      dosage: '',
      packLabel: packLabel,
      aboutText: product.description.isNotEmpty
          ? product.description
          : Strings.genericProductAbout(product.name),
      howToUse: Strings.asDirectedByPhysician,
      safetyInformation: Strings.safetyInformationBody,
      trustBadges: const [
        ProductTrustBadgeModel(
          title: Strings.trustedAndEffective,
          subtitle: Strings.trustedBrandSubtitle,
          iconKey: 'shield',
        ),
        ProductTrustBadgeModel(
          title: Strings.clinicallyProven,
          subtitle: Strings.clinicallyProvenSubtitle,
          iconKey: 'beaker',
        ),
        ProductTrustBadgeModel(
          title: Strings.qualityAssured,
          subtitle: Strings.qualityAssuredSubtitle,
          iconKey: 'medal',
        ),
      ],
      keyBenefits: _benefitsForCategory(product.category),
    );
  }

  static List<ProductBenefitModel> _benefitsForCategory(String category) {
    return switch (category.toLowerCase()) {
      'pain relief' => const [
        ProductBenefitModel(
          title: Strings.relievesPain,
          description: Strings.relievesPainSubtitle,
          iconKey: 'healing',
        ),
        ProductBenefitModel(
          title: Strings.reducesFever,
          description: Strings.reducesFeverSubtitle,
          iconKey: 'thermometer',
        ),
        ProductBenefitModel(
          title: Strings.fastActing,
          description: Strings.fastActingSubtitle,
          iconKey: 'schedule',
        ),
      ],
      'vitamins' => const [
        ProductBenefitModel(
          title: Strings.dailyWellness,
          description: Strings.dailyWellnessSubtitle,
          iconKey: 'healing',
        ),
        ProductBenefitModel(
          title: Strings.qualityAssured,
          description: Strings.qualityAssuredSubtitle,
          iconKey: 'verified',
        ),
        ProductBenefitModel(
          title: Strings.safeAndEffective,
          description: Strings.safeAndEffectiveSubtitle,
          iconKey: 'science',
        ),
      ],
      _ => const [
        ProductBenefitModel(
          title: Strings.safeAndEffective,
          description: Strings.safeAndEffectiveSubtitle,
          iconKey: 'verified',
        ),
        ProductBenefitModel(
          title: Strings.qualityAssured,
          description: Strings.qualityAssuredSubtitle,
          iconKey: 'science',
        ),
        ProductBenefitModel(
          title: Strings.fastActing,
          description: Strings.fastActingSubtitle,
          iconKey: 'schedule',
        ),
      ],
    };
  }
}
