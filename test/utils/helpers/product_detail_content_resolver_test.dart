// test/utils/helpers/product_detail_content_resolver_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/product_detail/model/product_benefit_model.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/utils/helpers/product_detail_content_resolver.dart';

void main() {
  const otcProduct = ProductModel(
    id: 1,
    name: 'CITRO-SODA',
    category: 'OTC',
    price: 50,
    imageUrl: '',
    requiresPrescription: false,
  );

  const rxProduct = ProductModel(
    id: 2,
    name: 'Rx Medicine',
    category: 'General',
    price: 100,
    imageUrl: '',
    requiresPrescription: true,
  );

  ProductDetailModel emptyDetail(ProductModel product) => ProductDetailModel(
        product: product,
        dosage: '',
        packLabel: '',
        aboutText: '',
        howToUse: '',
        safetyInformation: '',
      );

  group('resolveProductDetailDisplay', () {
    test('hides about when about text is empty', () {
      final display = resolveProductDetailDisplay(emptyDetail(otcProduct));

      expect(display.showAbout, isFalse);
    });

    test('shows about when about text is present', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '',
        packLabel: '',
        aboutText: 'Helps with acidity.',
        howToUse: '',
        safetyInformation: '',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.showAbout, isTrue);
    });

    test('uses OTC how-to-use fallback for non-prescription products', () {
      final display = resolveProductDetailDisplay(emptyDetail(otcProduct));

      expect(display.howToUse, Strings.genericHowToUseOtc);
    });

    test('uses Rx how-to-use fallback for prescription products', () {
      final display = resolveProductDetailDisplay(emptyDetail(rxProduct));

      expect(display.howToUse, Strings.howToUseBody);
    });

    test('prefers API how-to-use over fallback', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '',
        packLabel: '',
        aboutText: '',
        howToUse: 'Dissolve in water before use.',
        safetyInformation: '',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.howToUse, 'Dissolve in water before use.');
    });

    test('uses generic safety fallback when API safety is empty', () {
      final display = resolveProductDetailDisplay(emptyDetail(otcProduct));

      expect(display.safetyInformation, Strings.genericSafetyBody);
    });

    test('prefers API safety information over fallback', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '',
        packLabel: '',
        aboutText: '',
        howToUse: '',
        safetyInformation: 'Avoid during pregnancy.',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.safetyInformation, 'Avoid during pregnancy.');
    });

    test('shows benefits only when API provides key benefits', () {
      final empty = resolveProductDetailDisplay(emptyDetail(otcProduct));
      expect(empty.showBenefits, isFalse);

      final withBenefits = resolveProductDetailDisplay(
        ProductDetailModel(
          product: otcProduct,
          dosage: '',
          packLabel: '',
          aboutText: '',
          howToUse: '',
          safetyInformation: '',
          keyBenefits: const [
            ProductBenefitModel(
              title: 'Relief',
              description: 'Fast relief',
              iconKey: 'healing',
            ),
          ],
        ),
      );

      expect(withBenefits.showBenefits, isTrue);
    });
  });
}
