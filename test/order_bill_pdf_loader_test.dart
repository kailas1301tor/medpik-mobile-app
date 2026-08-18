// test/order_bill_pdf_loader_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/utils/helpers/order_bill_pdf_loader.dart';

void main() {
  group('resolveBillPdfUrl', () {
    test('returns absolute https url unchanged', () {
      const url =
          'https://stage-backend.medpik.in/media/order_bills/Invoice.pdf';
      expect(resolveBillPdfUrl(url), url);
    });

    test('resolves root-relative media path', () {
      expect(
        resolveBillPdfUrl('/media/order_bills/Invoice.pdf'),
        '${AppConstants.baseURL}/media/order_bills/Invoice.pdf',
      );
    });

    test('resolves relative media path without leading slash', () {
      expect(
        resolveBillPdfUrl('media/order_bills/Invoice.pdf'),
        '${AppConstants.baseURL}/media/order_bills/Invoice.pdf',
      );
    });

    test('returns empty for blank input', () {
      expect(resolveBillPdfUrl(''), '');
      expect(resolveBillPdfUrl('   '), '');
    });
  });

  group('isPdfBytes', () {
    test('detects valid PDF header', () {
      expect(isPdfBytes(Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D])), isTrue);
    });

    test('rejects non-pdf bytes', () {
      expect(isPdfBytes(Uint8List.fromList([0x3C, 0x68, 0x74, 0x6D])), isFalse);
    });
  });

  group('OrderBillPdfLoadException', () {
    test('isNotFound is true for 404 status', () {
      const error = OrderBillPdfLoadException(
        message: 'not found',
        statusCode: 404,
      );
      expect(error.isNotFound, isTrue);
    });

    test('isNotFound is false for other status codes', () {
      const error = OrderBillPdfLoadException(
        message: 'server error',
        statusCode: 500,
      );
      expect(error.isNotFound, isFalse);
    });
  });
}
