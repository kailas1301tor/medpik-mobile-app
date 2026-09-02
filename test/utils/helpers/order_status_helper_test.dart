import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/order_status_option_model.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

void main() {
  group('orderTrackingStepsFromApi', () {
    test('uses the 13 backend choices when API options are unavailable', () {
      final steps = orderTrackingStepsFromApi(
        currentStatusId: 'Bill Sent',
        statuses: const [],
      );

      expect(backendOrderStatusChoices, hasLength(13));
      expect(steps, hasLength(5));
      expect(steps.map((step) => step.label), [
        'Accepted',
        'Bill Generated',
        'Bill Sent',
        'Bill Accepted',
        'Bill Rejected',
      ]);
      expect(steps[2].isCompleted, isTrue);
      expect(steps[3].isCompleted, isFalse);
    });

    test('centers a five-status window around the current API status', () {
      const statuses = [
        OrderStatusOptionModel(id: 'one', name: 'One'),
        OrderStatusOptionModel(id: 'two', name: 'Two'),
        OrderStatusOptionModel(id: 'three', name: 'Three'),
        OrderStatusOptionModel(id: 'four', name: 'Four'),
        OrderStatusOptionModel(id: 'five', name: 'Five'),
        OrderStatusOptionModel(id: 'six', name: 'Six'),
        OrderStatusOptionModel(id: 'seven', name: 'Seven'),
      ];

      final steps = orderTrackingStepsFromApi(
        currentStatusId: 'four',
        statuses: statuses,
      );

      expect(steps.map((step) => step.label), [
        'Two',
        'Three',
        'Four',
        'Five',
        'Six',
      ]);
    });

    test('marks terminal failure as failed inside its visible window', () {
      final steps = orderTrackingStepsFromApi(
        currentStatusId: 'Cancelled By Admin',
        statuses: const [],
      );

      expect(steps, hasLength(5));
      expect(
        steps.singleWhere((step) => step.isFailed).label,
        'Cancelled By Admin',
      );
    });

    test(
      'matches the backend status against option name when id is numeric',
      () {
        final steps = orderTrackingStepsFromApi(
          currentStatusId: 'Packed',
          statuses: const [
            OrderStatusOptionModel(id: '1', name: 'Payment Received'),
            OrderStatusOptionModel(id: '2', name: 'Packed'),
            OrderStatusOptionModel(id: '3', name: 'Out for Delivery'),
          ],
        );

        expect(steps[1].label, 'Packed');
        expect(steps[1].isCompleted, isTrue);
        expect(steps[2].isCompleted, isFalse);
      },
    );
  });
}
