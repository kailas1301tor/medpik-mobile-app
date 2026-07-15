// lib/utils/helpers/order_status_helper.dart
import 'package:intl/intl.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:flutter/material.dart';

String orderStatusLabel(OrderStatus status) {
  return switch (status) {
    OrderStatus.prescriptionUploaded => Strings.orderStatusPrescriptionUploaded,
    OrderStatus.underReview => Strings.orderStatusUnderReview,
    OrderStatus.prescriptionAccepted => Strings.orderStatusPrescriptionAccepted,
    OrderStatus.prescriptionRejected => Strings.orderStatusPrescriptionRejected,
    OrderStatus.billGenerated => Strings.orderStatusBillGenerated,
    OrderStatus.awaitingBillApproval => Strings.orderStatusAwaitingBillApproval,
    OrderStatus.billAccepted => Strings.orderStatusBillAccepted,
    OrderStatus.billRejected => Strings.orderStatusBillRejected,
    OrderStatus.paymentPending => Strings.orderStatusPaymentPending,
    OrderStatus.paymentCompleted => Strings.orderStatusPaymentCompleted,
    OrderStatus.cashOnDelivery => Strings.orderStatusCashOnDelivery,
    OrderStatus.orderConfirmed => Strings.orderStatusOrderConfirmed,
    OrderStatus.preparingOrder => Strings.orderStatusPreparingOrder,
    OrderStatus.packed => Strings.orderStatusPacked,
    OrderStatus.deliveryPartnerAssigned =>
      Strings.orderStatusDeliveryPartnerAssigned,
    OrderStatus.outForDelivery => Strings.orderStatusOutForDelivery,
    OrderStatus.delivered => Strings.orderStatusDelivered,
    OrderStatus.cancelled => Strings.orderStatusCancelled,
  };
}

OrderStatusTone orderStatusTone(OrderStatus status) {
  return switch (status) {
    OrderStatus.billGenerated ||
    OrderStatus.awaitingBillApproval ||
    OrderStatus.paymentPending =>
      OrderStatusTone.warning,
    OrderStatus.prescriptionUploaded ||
    OrderStatus.underReview ||
    OrderStatus.prescriptionAccepted ||
    OrderStatus.orderConfirmed ||
    OrderStatus.preparingOrder ||
    OrderStatus.packed ||
    OrderStatus.deliveryPartnerAssigned ||
    OrderStatus.outForDelivery =>
      OrderStatusTone.info,
    OrderStatus.billAccepted ||
    OrderStatus.paymentCompleted ||
    OrderStatus.delivered =>
      OrderStatusTone.success,
    OrderStatus.prescriptionRejected ||
    OrderStatus.billRejected ||
    OrderStatus.cancelled =>
      OrderStatusTone.error,
    OrderStatus.cashOnDelivery => OrderStatusTone.neutral,
  };
}

(Color background, Color text) orderStatusBadgeColors(
  OrderStatus status,
  AppColors colors,
) {
  return switch (orderStatusTone(status)) {
    OrderStatusTone.warning => (
        colors.statusWarningBg,
        colors.statusWarningText,
      ),
    OrderStatusTone.info => (
        colors.statusInfoBg,
        colors.statusInfoText,
      ),
    OrderStatusTone.success => (
        colors.statusSuccessBg,
        colors.statusSuccessText,
      ),
    OrderStatusTone.error => (
        colors.statusErrorBg,
        colors.statusErrorText,
      ),
    OrderStatusTone.neutral => (
        colors.statusNeutralBg,
        colors.statusNeutralText,
      ),
  };
}

bool orderStatusShowsTotal(OrderStatus status) {
  return switch (status) {
    OrderStatus.prescriptionUploaded ||
    OrderStatus.underReview ||
    OrderStatus.prescriptionAccepted ||
    OrderStatus.prescriptionRejected ||
    OrderStatus.cancelled =>
      false,
    _ => true,
  };
}

String formatOrderDateTime(DateTime dateTime) {
  return DateFormat('dd MMM yyyy • h:mm a').format(dateTime);
}

String orderDetailStatusLabel(OrderStatus status) {
  return switch (status) {
    OrderStatus.billGenerated ||
    OrderStatus.awaitingBillApproval =>
      Strings.orderStatusBillReceived,
    OrderStatus.prescriptionRejected => Strings.orderStatusRejectedByAdmin,
    _ => orderStatusLabel(status),
  };
}

class OrderHorizontalStep {
  const OrderHorizontalStep({
    required this.label,
    required this.icon,
    required this.state,
  });

  final String label;
  final IconData icon;
  final OrderStepperNodeState state;
}

List<OrderHorizontalStep> orderDetailHorizontalSteps(OrderStatus status) {
  if (status == OrderStatus.prescriptionRejected) {
    return const [
      OrderHorizontalStep(
        label: Strings.stepperUploaded,
        icon: Icons.upload_rounded,
        state: OrderStepperNodeState.completed,
      ),
      OrderHorizontalStep(
        label: Strings.stepperReviewed,
        icon: Icons.visibility_outlined,
        state: OrderStepperNodeState.completed,
      ),
      OrderHorizontalStep(
        label: Strings.stepperRejected,
        icon: Icons.close_rounded,
        state: OrderStepperNodeState.failed,
      ),
      OrderHorizontalStep(
        label: Strings.stepperBill,
        icon: Icons.receipt_long_outlined,
        state: OrderStepperNodeState.pending,
      ),
      OrderHorizontalStep(
        label: Strings.stepperDelivery,
        icon: Icons.local_shipping_outlined,
        state: OrderStepperNodeState.pending,
      ),
    ];
  }

  final isDeliveryPhase = status == OrderStatus.packed ||
      status == OrderStatus.deliveryPartnerAssigned ||
      status == OrderStatus.outForDelivery ||
      status == OrderStatus.delivered;

  if (isDeliveryPhase) {
    final currentIndex = switch (status) {
      OrderStatus.packed => 3,
      OrderStatus.deliveryPartnerAssigned => 3,
      OrderStatus.outForDelivery => 4,
      OrderStatus.delivered => 4,
      _ => 3,
    };
    return _buildBillPhaseSteps(
      labels: const [
        Strings.stepperUploaded,
        Strings.stepperAccepted,
        Strings.stepperBillReceived,
        Strings.stepperPacked,
        Strings.stepperOutForDelivery,
      ],
      icons: const [
        Icons.upload_rounded,
        Icons.check_circle_outline_rounded,
        Icons.receipt_long_outlined,
        Icons.inventory_2_outlined,
        Icons.delivery_dining_rounded,
      ],
      currentIndex: currentIndex,
    );
  }

  final currentIndex = switch (status) {
    OrderStatus.prescriptionUploaded => 0,
    OrderStatus.underReview => 1,
    OrderStatus.prescriptionAccepted => 1,
    OrderStatus.billGenerated => 2,
    OrderStatus.awaitingBillApproval => 2,
    OrderStatus.billAccepted => 3,
    OrderStatus.billRejected => 3,
    OrderStatus.paymentPending => 3,
    OrderStatus.cashOnDelivery => 3,
    OrderStatus.paymentCompleted => 4,
    OrderStatus.orderConfirmed => 4,
    OrderStatus.preparingOrder => 4,
    _ => 2,
  };

  return _buildBillPhaseSteps(
    labels: const [
      Strings.stepperUploaded,
      Strings.stepperAccepted,
      Strings.stepperBillReceived,
      Strings.stepperPayment,
      Strings.stepperDelivery,
    ],
    icons: const [
      Icons.upload_rounded,
      Icons.check_circle_outline_rounded,
      Icons.receipt_long_outlined,
      Icons.payments_outlined,
      Icons.local_shipping_outlined,
    ],
    currentIndex: currentIndex,
  );
}

List<OrderHorizontalStep> _buildBillPhaseSteps({
  required List<String> labels,
  required List<IconData> icons,
  required int currentIndex,
}) {
  return List.generate(labels.length, (index) {
    final state = index < currentIndex
        ? OrderStepperNodeState.completed
        : index == currentIndex
        ? OrderStepperNodeState.current
        : OrderStepperNodeState.pending;
    return OrderHorizontalStep(
      label: labels[index],
      icon: icons[index],
      state: state,
    );
  });
}

class OrderStatusBannerData {
  const OrderStatusBannerData({
    required this.type,
    required this.title,
    this.subtitle,
    required this.icon,
    this.isTappable = false,
  });

  final OrderStatusBannerType type;
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isTappable;
}

OrderStatusBannerData? orderDetailStatusBanner(
  OrderStatus status,
  OrderModel order,
) {
  return switch (status) {
    OrderStatus.outForDelivery => OrderStatusBannerData(
        type: OrderStatusBannerType.delivery,
        title: Strings.deliveryBannerTitle,
        subtitle: order.etaText,
        icon: Icons.check_circle_rounded,
      ),
    OrderStatus.prescriptionRejected => OrderStatusBannerData(
        type: OrderStatusBannerType.rejection,
        title: Strings.prescriptionRejectedBannerTitle,
        subtitle: order.rejectionReason == null ||
                order.rejectionReason!.isEmpty
            ? null
            : '${Strings.prescriptionRejectedReasonPrefix} ${order.rejectionReason}',
        icon: Icons.edit_document,
      ),
    OrderStatus.billGenerated || OrderStatus.awaitingBillApproval =>
      OrderStatusBannerData(
        type: OrderStatusBannerType.billGenerated,
        title: Strings.billGeneratedBannerTitle,
        subtitle: Strings.billGeneratedBannerSubtitle,
        icon: Icons.account_balance_wallet_outlined,
        isTappable: true,
      ),
    _ => null,
  };
}

bool orderDetailShowsBillCard(OrderStatus status) {
  return status == OrderStatus.billGenerated ||
      status == OrderStatus.awaitingBillApproval;
}

class OrderDetailCta {
  const OrderDetailCta({
    required this.label,
    required this.icon,
    required this.action,
    this.isOutlined = false,
  });

  final String label;
  final IconData icon;
  final OrderDetailCtaAction action;
  final bool isOutlined;
}

OrderDetailCta? orderDetailPrimaryCta(OrderStatus status) {
  return switch (status) {
    OrderStatus.billGenerated || OrderStatus.awaitingBillApproval =>
      const OrderDetailCta(
        label: Strings.reviewAndPayCta,
        icon: Icons.receipt_long_outlined,
        action: OrderDetailCtaAction.reviewBill,
      ),
    OrderStatus.billAccepted || OrderStatus.paymentPending =>
      const OrderDetailCta(
        label: Strings.reviewAndPayCta,
        icon: Icons.payments_outlined,
        action: OrderDetailCtaAction.reviewPay,
      ),
    OrderStatus.outForDelivery ||
    OrderStatus.deliveryPartnerAssigned ||
    OrderStatus.packed =>
      const OrderDetailCta(
        label: Strings.trackOrder,
        icon: Icons.location_on_outlined,
        action: OrderDetailCtaAction.trackOrder,
        isOutlined: true,
      ),
    OrderStatus.prescriptionRejected => const OrderDetailCta(
        label: Strings.uploadNewPrescription,
        icon: Icons.upload_rounded,
        action: OrderDetailCtaAction.uploadPrescription,
        isOutlined: true,
      ),
    _ => null,
  };
}

OrderBillBreakdown resolveOrderBillBreakdown(OrderModel order) {
  if (order.billBreakdown != null) return order.billBreakdown!;
  final itemTotal = order.items.fold<double>(
    0,
    (sum, item) => sum + item.lineTotal,
  );
  return OrderBillBreakdown(
    itemTotal: itemTotal,
    deliveryCharges: 0,
    packagingCharges: 0,
  );
}

int orderItemCount(OrderModel order) {
  return order.items.fold<int>(0, (sum, item) => sum + item.quantity);
}

String orderCardCountLabel(OrderModel order) {
  final itemCount = orderItemCount(order);
  if (itemCount > 0) {
    return '$itemCount ${Strings.itemsLabel}';
  }
  final rxCount = order.prescriptionImageUrls.length;
  if (rxCount > 0) {
    return '$rxCount ${Strings.prescriptionsLabel}';
  }
  return '0 ${Strings.itemsLabel}';
}

int orderLifecycleIndex(OrderStatus status) {
  return switch (status) {
    OrderStatus.prescriptionUploaded => 0,
    OrderStatus.underReview => 1,
    OrderStatus.prescriptionAccepted => 2,
    OrderStatus.prescriptionRejected => 2,
    OrderStatus.billGenerated => 3,
    OrderStatus.awaitingBillApproval => 4,
    OrderStatus.billAccepted => 5,
    OrderStatus.billRejected => 5,
    OrderStatus.paymentPending => 6,
    OrderStatus.cashOnDelivery => 6,
    OrderStatus.paymentCompleted => 7,
    OrderStatus.orderConfirmed => 8,
    OrderStatus.preparingOrder => 9,
    OrderStatus.packed => 10,
    OrderStatus.deliveryPartnerAssigned => 11,
    OrderStatus.outForDelivery => 12,
    OrderStatus.delivered => 13,
    OrderStatus.cancelled => 0,
  };
}

List<OrderStatus> orderTimelineStatuses() => const [
      OrderStatus.prescriptionUploaded,
      OrderStatus.underReview,
      OrderStatus.prescriptionAccepted,
      OrderStatus.billGenerated,
      OrderStatus.awaitingBillApproval,
      OrderStatus.billAccepted,
      OrderStatus.paymentPending,
      OrderStatus.paymentCompleted,
      OrderStatus.orderConfirmed,
      OrderStatus.preparingOrder,
      OrderStatus.packed,
      OrderStatus.deliveryPartnerAssigned,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

class OrderTrackingStep {
  const OrderTrackingStep({
    required this.label,
    required this.isCompleted,
    required this.isFailed,
  });

  final String label;
  final bool isCompleted;
  final bool isFailed;
}

List<OrderTrackingStep> orderTrackingSteps(OrderStatus currentStatus) {
  final timeline = orderTimelineStatuses();
  final currentIndex = orderLifecycleIndex(currentStatus);
  final isFailed = currentStatus == OrderStatus.prescriptionRejected ||
      currentStatus == OrderStatus.billRejected ||
      currentStatus == OrderStatus.cancelled;

  if (isFailed) {
    return [
      OrderTrackingStep(
        label: orderStatusLabel(currentStatus),
        isCompleted: true,
        isFailed: true,
      ),
    ];
  }

  return timeline
      .map((status) {
        final index = orderLifecycleIndex(status);
        return OrderTrackingStep(
          label: orderStatusLabel(status),
          isCompleted: index <= currentIndex,
          isFailed: false,
        );
      })
      .toList();
}
