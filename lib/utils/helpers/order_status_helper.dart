// lib/utils/helpers/order_status_helper.dart
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/constants/string_constants.dart';

String orderStatusLabel(OrderStatus status) {
  return switch (status) {
    OrderStatus.placed => Strings.orderStatusPlaced,
    OrderStatus.confirmed => Strings.orderStatusConfirmed,
    OrderStatus.packed => Strings.orderStatusPacked,
    OrderStatus.outForDelivery => Strings.orderStatusOutForDelivery,
    OrderStatus.delivered => Strings.orderStatusDelivered,
    OrderStatus.cancelled => Strings.orderStatusCancelled,
  };
}

List<OrderStatus> orderTimelineStatuses() => const [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.packed,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

int orderStatusIndex(OrderStatus status) {
  final timeline = orderTimelineStatuses();
  final index = timeline.indexOf(status);
  return index < 0 ? 0 : index;
}

class OrderTrackingStep {
  const OrderTrackingStep({
    required this.label,
    required this.isCompleted,
  });

  final String label;
  final bool isCompleted;
}

List<OrderTrackingStep> orderTrackingSteps(OrderStatus currentStatus) {
  final timeline = orderTimelineStatuses();
  final currentIndex = orderStatusIndex(currentStatus);

  return timeline
      .map(
        (status) => OrderTrackingStep(
          label: orderStatusLabel(status),
          isCompleted: orderStatusIndex(status) <= currentIndex,
        ),
      )
      .toList();
}
