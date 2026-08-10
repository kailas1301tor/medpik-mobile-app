// test/data/models/product_detail_args_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/product_detail_args.dart';

void main() {
  group('ProductDetailArgs', () {
    test('from int preserves product id', () {
      final args = ProductDetailArgs.from(42);
      expect(args.productId, 42);
      expect(args.isFromUploadPrescription, isFalse);
    });

    test('from ProductDetailArgs preserves flags', () {
      final input = ProductDetailArgs(
        productId: 7,
        isFromUploadPrescription: true,
      );
      final args = ProductDetailArgs.from(input);
      expect(args.productId, 7);
      expect(args.isFromUploadPrescription, isTrue);
    });

    test('from null defaults to zero id', () {
      final args = ProductDetailArgs.from(null);
      expect(args.productId, 0);
      expect(args.isFromUploadPrescription, isFalse);
    });
  });
}
