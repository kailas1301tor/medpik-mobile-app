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

    test('uses dosage when how-to-use is empty', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '1 drop twice daily',
        packLabel: '',
        aboutText: '',
        howToUse: '',
        safetyInformation: '',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.howToUse, '1 drop twice daily');
    });

    test('uses generic safety fallback when API safety is empty', () {
      final display = resolveProductDetailDisplay(emptyDetail(otcProduct));

      expect(display.safetyBlocks, hasLength(1));
      expect(display.safetyBlocks.first.title, Strings.safetyInformation);
      expect(display.safetyBlocks.first.body, Strings.genericSafetyBody);
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

      expect(display.safetyBlocks, hasLength(1));
      expect(display.safetyBlocks.first.body, 'Avoid during pregnancy.');
    });

    test('builds structured safety blocks from enrichment fields', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '',
        packLabel: '',
        aboutText: '',
        howToUse: '',
        safetyInformation: '',
        warnings: 'Do not swallow',
        sideEffects: 'Mild irritation',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.safetyBlocks, hasLength(2));
      expect(display.safetyBlocks.first.title, Strings.warnings);
      expect(display.safetyBlocks.last.title, Strings.sideEffects);
    });

    test('hides uses when identical to about', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '',
        packLabel: '',
        aboutText: 'Same copy',
        howToUse: '',
        safetyInformation: '',
        uses: 'Same copy',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.showUses, isFalse);
    });

    test('shows composition when present', () {
      final detail = ProductDetailModel(
        product: otcProduct.copyWith(composition: 'PEG + PG'),
        dosage: '',
        packLabel: '',
        aboutText: '',
        howToUse: '',
        safetyInformation: '',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.showComposition, isTrue);
      expect(display.composition, 'PEG + PG');
    });

    test('prefers API storage over generic fallback', () {
      final detail = ProductDetailModel(
        product: otcProduct,
        dosage: '',
        packLabel: '',
        aboutText: '',
        howToUse: '',
        safetyInformation: '',
        storage: 'Store below 25C',
      );

      final display = resolveProductDetailDisplay(detail);

      expect(display.storageBody, 'Store below 25C');
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
