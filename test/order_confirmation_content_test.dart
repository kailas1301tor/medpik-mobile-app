import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/checkout/model/order_confirmation_args.dart';

void main() {
  group('OrderConfirmationContent', () {
    test('uses medicine cart confirmation copy for cart orders', () {
      final content = OrderConfirmationContent.forSource(
        OrderSubmissionSource.medicineCart,
      );

      expect(content.title, Strings.orderSubmittedSuccessTitle);
      expect(content.message, Strings.orderSubmittedSuccessMessage);
    });

    test('uses prescription confirmation copy for prescription orders', () {
      final content = OrderConfirmationContent.forSource(
        OrderSubmissionSource.prescription,
      );

      expect(content.title, Strings.prescriptionOrderSubmittedSuccessTitle);
      expect(content.message, Strings.prescriptionOrderSubmittedSuccessMessage);
    });
  });
}
