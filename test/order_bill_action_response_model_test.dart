// test/order_bill_action_response_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/src/orders/model/order_bill_action_response_model.dart';

void main() {
  group('OrderBillActionResponse', () {
    test('parses accept success envelope', () {
      final response = OrderBillActionResponse.fromJson({
        'message': 'Bill accepted successfully',
        'results': {},
      });

      expect(response.message, 'Bill accepted successfully');
      expect(response.results, isA<OrderBillActionResults>());
    });

    test('parses reject success envelope', () {
      final response = OrderBillActionResponse.fromJson({
        'message': 'Bill rejected successfully',
        'results': <String, dynamic>{},
      });

      expect(response.message, 'Bill rejected successfully');
      expect(response.results, isA<OrderBillActionResults>());
    });
  });
}
