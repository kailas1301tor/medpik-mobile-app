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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product_detail'] ?? json['product'];
    return OrderItemModel(
      product: ProductModel.fromJson(convertToMap(productJson)),
      quantity: convertToInt(json['quantity']),
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.amount,
    required this.status,
    required this.address,
    required this.createdAt,
    this.orderCode,
    this.statusRaw = '',
    this.hasKnownAmount = true,
    this.etaText,
    this.hasPrescription = false,
    this.rejectionReason,
    this.billBreakdown,
    this.prescriptionImageUrls = const [],
  });

  /// Numeric (or mock) id used for navigation / detail lookup.
  final String id;

  /// Backend display code (`order_id`). Null/empty → UI shows an em dash.
  final String? orderCode;

  final List<OrderItemModel> items;
  final double amount;

  /// False when API sends `total_amount: null` (do not show ₹0).
  final bool hasKnownAmount;

  final OrderStatus status;

  /// Exact `status` string from the API (e.g. `PENDING`).
  final String statusRaw;

  final AddressModel address;
  final DateTime createdAt;
  final String? etaText;
  final bool hasPrescription;
  final String? rejectionReason;
  final OrderBillBreakdown? billBreakdown;
  final List<String> prescriptionImageUrls;

  /// Prefer `order_id`; fall back to legacy/mock non-numeric `id`; else dash token.
  String get displayOrderId {
    final code = orderCode?.trim() ?? '';
    if (code.isNotEmpty) return code;
    if (id.isNotEmpty && int.tryParse(id) == null) return id;
    return '';
  }

  /// Badge text: API status when present, else mapped enum label.
  String get displayStatus {
    final raw = statusRaw.trim();
    return raw.isNotEmpty ? raw : '';
  }

  bool get isActive => switch (status) {
        OrderStatus.delivered ||
        OrderStatus.cancelled ||
        OrderStatus.prescriptionRejected ||
        OrderStatus.billRejected =>
          false,
        _ => true,
      };

  double get displayGrandTotal => billBreakdown?.grandTotal ?? amount;

  List<String> get previewImageUrls {
    final urls = <String>[];
    final seen = <String>{};
    for (final item in items) {
      final url = item.product.imageUrl.trim();
      if (url.isEmpty || seen.contains(url)) continue;
      urls.add(url);
      seen.add(url);
    }
    for (final url in prescriptionImageUrls) {
      final trimmed = url.trim();
      if (trimmed.isEmpty || seen.contains(trimmed)) continue;
      urls.add(trimmed);
      seen.add(trimmed);
    }
    return urls;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final orderCodeRaw = convertToString(json['order_id']);
    final orderCode = orderCodeRaw.isEmpty ? null : orderCodeRaw;

    final addressJson = json['address_detail'] ?? json['address'];

    final hasTotalAmountKey = json.containsKey('total_amount');
    final hasKnownAmount = hasTotalAmountKey
        ? json['total_amount'] != null
        : true;
    final amount = hasTotalAmountKey
        ? convertToDouble(json['total_amount'])
        : convertToDouble(json['amount']);

    final prescriptionUrls = convertToList(json['prescriptions'])
        .map((e) {
          final map = convertToMap(e);
          final imageUrl = convertToString(map['image_url']);
          return imageUrl.isNotEmpty ? imageUrl : convertToString(map['image']);
        })
        .where((url) => url.trim().isNotEmpty)
        .toList();

    final statusRaw = convertToString(json['status']);

    return OrderModel(
      id: convertToString(json['id']),
      orderCode: orderCode,
      items: convertToList(json['items'])
          .map((e) => OrderItemModel.fromJson(convertToMap(e)))
          .toList(),
      amount: amount,
      hasKnownAmount: hasKnownAmount,
      status: _parseStatus(statusRaw),
      statusRaw: statusRaw,
      address: AddressModel.fromJson(convertToMap(addressJson)),
      createdAt: DateTime.tryParse(convertToString(json['created_at'])) ??
          DateTime.now(),
      etaText: convertToString(json['eta_text']).isEmpty
          ? null
          : convertToString(json['eta_text']),
      hasPrescription: convertToBool(json['is_prescription_order']) ||
          convertToBool(json['has_prescription']),
      rejectionReason: convertToString(json['rejection_reason']).isEmpty
          ? null
          : convertToString(json['rejection_reason']),
      billBreakdown: json['bill_breakdown'] == null
          ? null
          : OrderBillBreakdown.fromJson(
              convertToMap(json['bill_breakdown']),
            ),
      prescriptionImageUrls: prescriptionUrls,
    );
  }

  static OrderStatus _parseStatus(String value) {
    return switch (value.toLowerCase().replaceAll(' ', '_')) {
      'pending' => OrderStatus.underReview,
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
