// lib/data/models/order_model.dart
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class OrderBillBreakdown {
  const OrderBillBreakdown({
    required this.itemTotal,
    required this.deliveryCharges,
    required this.packagingCharges,
  });

  final double itemTotal;
  final double deliveryCharges;
  final double packagingCharges;

  double get grandTotal => itemTotal + deliveryCharges + packagingCharges;

  factory OrderBillBreakdown.fromJson(Map<String, dynamic> json) =>
      OrderBillBreakdown(
        itemTotal: convertToDouble(json['item_total']),
        deliveryCharges: convertToDouble(json['delivery_charges']),
        packagingCharges: convertToDouble(json['packaging_charges']),
      );
}

class OrderItemModel {
  const OrderItemModel({
    required this.product,
    required this.quantity,
  });

  final ProductModel product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        product: ProductModel.fromJson(convertToMap(json['product'])),
        quantity: convertToInt(json['quantity']),
      );
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.amount,
    required this.status,
    required this.address,
    required this.createdAt,
    this.etaText,
    this.hasPrescription = false,
    this.rejectionReason,
    this.billBreakdown,
  });

  final String id;
  final List<OrderItemModel> items;
  final double amount;
  final OrderStatus status;
  final AddressModel address;
  final DateTime createdAt;
  final String? etaText;
  final bool hasPrescription;
  final String? rejectionReason;
  final OrderBillBreakdown? billBreakdown;

  bool get isActive => switch (status) {
        OrderStatus.delivered ||
        OrderStatus.cancelled ||
        OrderStatus.prescriptionRejected ||
        OrderStatus.billRejected =>
          false,
        _ => true,
      };

  double get displayGrandTotal => billBreakdown?.grandTotal ?? amount;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: convertToString(json['id']),
        items: convertToList(json['items'])
            .map((e) => OrderItemModel.fromJson(convertToMap(e)))
            .toList(),
        amount: convertToDouble(json['amount']),
        status: _parseStatus(convertToString(json['status'])),
        address: AddressModel.fromJson(convertToMap(json['address'])),
        createdAt: DateTime.tryParse(convertToString(json['created_at'])) ??
            DateTime.now(),
        etaText: convertToString(json['eta_text']),
        hasPrescription: convertToBool(json['has_prescription']),
        rejectionReason: convertToString(json['rejection_reason']),
        billBreakdown: json['bill_breakdown'] == null
            ? null
            : OrderBillBreakdown.fromJson(
                convertToMap(json['bill_breakdown']),
              ),
      );

  static OrderStatus _parseStatus(String value) {
    return switch (value.toLowerCase().replaceAll(' ', '_')) {
      'prescription_uploaded' => OrderStatus.prescriptionUploaded,
      'under_review' => OrderStatus.underReview,
      'prescription_accepted' => OrderStatus.prescriptionAccepted,
      'prescription_rejected' => OrderStatus.prescriptionRejected,
      'bill_generated' => OrderStatus.billGenerated,
      'awaiting_bill_approval' => OrderStatus.awaitingBillApproval,
      'bill_accepted' => OrderStatus.billAccepted,
      'bill_rejected' => OrderStatus.billRejected,
      'payment_pending' => OrderStatus.paymentPending,
      'payment_completed' => OrderStatus.paymentCompleted,
      'cash_on_delivery' => OrderStatus.cashOnDelivery,
      'order_confirmed' => OrderStatus.orderConfirmed,
      'preparing_order' => OrderStatus.preparingOrder,
      'packed' => OrderStatus.packed,
      'delivery_partner_assigned' => OrderStatus.deliveryPartnerAssigned,
      'outfordelivery' || 'out_for_delivery' => OrderStatus.outForDelivery,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      'placed' => OrderStatus.orderConfirmed,
      'confirmed' => OrderStatus.orderConfirmed,
      _ => OrderStatus.prescriptionUploaded,
    };
  }
}
