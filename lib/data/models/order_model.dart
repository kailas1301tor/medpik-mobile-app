// lib/data/models/order_model.dart
import 'package:intl/intl.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/data/models/applied_offer_model.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/utils/helpers/order_bill_pdf_loader.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class OrderBillBreakdown {
  const OrderBillBreakdown({
    required this.itemTotal,
    required this.deliveryCharges,
    this.packagingCharges = 0,
    this.tax = 0,
    this.sgst = 0,
    this.cgst = 0,
    this.discountAmount = 0,
    this.appliedOfferId,
    this.appliedOfferDetail,
    this.isSentToCustomer = false,
    this.totalOverride,
    this.billPdfUrl,
  });

  final double itemTotal;
  final double deliveryCharges;
  final double packagingCharges;
  final double tax;
  final double sgst;
  final double cgst;
  final double discountAmount;
  final int? appliedOfferId;
  final AppliedOfferModel? appliedOfferDetail;
  final bool isSentToCustomer;
  final double? totalOverride;
  final String? billPdfUrl;

  double get grandTotal =>
      totalOverride ??
      (itemTotal + deliveryCharges + packagingCharges + tax - discountAmount);

  factory OrderBillBreakdown.fromJson(Map<String, dynamic> json) =>
      OrderBillBreakdown(
        itemTotal: convertToDouble(json['item_total']),
        deliveryCharges: convertToDouble(json['delivery_charges']),
        packagingCharges: convertToDouble(json['packaging_charges']),
      );

  factory OrderBillBreakdown.fromBillJson(Map<String, dynamic> json) {
    final total = convertToDouble(json['total']);
    final billPdfRaw = convertToString(json['bill_pdf']).trim();
    final resolvedPdfUrl = resolveBillPdfUrl(billPdfRaw);
    final sgst = convertToDouble(json['sgst']);
    final cgst = convertToDouble(json['cgst']);
    final taxField = convertToDouble(json['tax']);
    final resolvedTax = taxField > 0 ? taxField : sgst + cgst;
    final appliedOfferRaw = json['applied_offer'];
    final appliedOfferId = appliedOfferRaw == null
        ? null
        : convertToInt(appliedOfferRaw);

    return OrderBillBreakdown(
      itemTotal: convertToDouble(json['subtotal']),
      deliveryCharges: convertToDouble(json['delivery_fee']),
      tax: resolvedTax,
      sgst: sgst,
      cgst: cgst,
      discountAmount: convertToDouble(json['discount_amount']),
      appliedOfferId: appliedOfferId == 0 ? null : appliedOfferId,
      appliedOfferDetail: json['applied_offer_detail'] == null
          ? null
          : AppliedOfferModel.fromJson(
              convertToMap(json['applied_offer_detail']),
            ),
      isSentToCustomer: convertToBool(json['is_sent_to_customer']),
      totalOverride: total > 0 ? total : null,
      billPdfUrl: resolvedPdfUrl.isEmpty ? null : resolvedPdfUrl,
    );
  }
}

class OrderItemModel {
  const OrderItemModel({
    required this.product,
    required this.quantity,
    this.unitPrice = 0,
    this.totalPrice = 0,
    this.status = '',
    this.expiryDate = '',
    this.sgst = 0,
    this.cgst = 0,
    this.discountAmount = 0,
    this.appliedCouponCode = '',
    this.appliedOfferId,
    this.appliedOfferDetail,
  });

  final ProductModel product;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;
  final String expiryDate;
  final double sgst;
  final double cgst;
  final double discountAmount;
  final String appliedCouponCode;
  final int? appliedOfferId;
  final AppliedOfferModel? appliedOfferDetail;

  double get lineTotal => totalPrice > 0 ? totalPrice : unitPrice * quantity;

  double get grossLineTotal => unitPrice * quantity;

  bool get hasItemDiscount => discountAmount > 0;

  String get offerChipLabel {
    final coupon = appliedCouponCode.trim();
    if (coupon.isNotEmpty) return coupon;
    return appliedOfferDetail?.displayLabel ?? '';
  }

  bool get hasOfferChip => offerChipLabel.isNotEmpty;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product_detail'] ?? json['product'];
    final product = ProductModel.fromJson(convertToMap(productJson));
    final quantity = convertToInt(json['quantity']);
    final unitPrice = json.containsKey('price')
        ? convertToDouble(json['price'])
        : product.price;
    final totalPrice = convertToDouble(json['total_price']);
    final appliedOfferRaw = json['applied_offer'];
    final appliedOfferId = appliedOfferRaw == null
        ? null
        : convertToInt(appliedOfferRaw);

    return OrderItemModel(
      product: product,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      status: convertToString(json['status']),
      expiryDate: convertToString(json['expiry_date']),
      sgst: convertToDouble(json['sgst']),
      cgst: convertToDouble(json['cgst']),
      discountAmount: convertToDouble(json['discount_amount']),
      appliedCouponCode: convertToString(json['applied_coupon_code']),
      appliedOfferId: appliedOfferId == 0 ? null : appliedOfferId,
      appliedOfferDetail: json['applied_offer_detail'] == null
          ? null
          : AppliedOfferModel.fromJson(
              convertToMap(json['applied_offer_detail']),
            ),
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
    this.customerName = '',
    this.customerPhone = '',
    this.deliveryInstructions = '',
    this.prescriptionDescription = '',
  });

  /// Id used for navigation / detail lookup.
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
  final String customerName;
  final String customerPhone;
  final String deliveryInstructions;
  final String prescriptionDescription;

  /// Prefer `order_id`; fall back to legacy non-numeric `id`; else dash token.
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
    OrderStatus.billRejected => false,
    _ => true,
  };

  double get displayGrandTotal => billBreakdown?.grandTotal ?? amount;

  bool get hasBillPdf => billBreakdown?.billPdfUrl?.trim().isNotEmpty ?? false;

  String? get billPdfUrl => billBreakdown?.billPdfUrl;

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
    final address = AddressModel.fromJson(convertToMap(addressJson));

    final billBreakdown = _parseBillBreakdown(json);

    final hasTotalAmountKey = json.containsKey('total_amount');
    var hasKnownAmount = hasTotalAmountKey
        ? json['total_amount'] != null
        : true;
    var amount = hasTotalAmountKey
        ? convertToDouble(json['total_amount'])
        : convertToDouble(json['amount']);

    if (!hasKnownAmount &&
        billBreakdown != null &&
        billBreakdown.grandTotal > 0) {
      hasKnownAmount = true;
      amount = billBreakdown.grandTotal;
    }

    final prescriptionUrls = convertToList(json['prescriptions'])
        .map((e) {
          final map = convertToMap(e);
          final imageUrl = convertToString(map['image_url']);
          return imageUrl.isNotEmpty ? imageUrl : convertToString(map['image']);
        })
        .where((url) => url.trim().isNotEmpty)
        .toList();

    final statusRaw = convertToString(json['status']);
    final customer = _parseCustomerContact(
      convertToMap(json['customer_detail']),
    );
    final deliveryInstructions = convertToString(
      json['delivery_instructions'],
    ).trim();
    final prescriptionDescription = convertToString(
      json['prescription_description'],
    ).trim();

    final customerName = customer.$1.isNotEmpty
        ? customer.$1
        : address.label.trim();

    return OrderModel(
      id: convertToString(json['id']),
      orderCode: orderCode,
      items: convertToList(
        json['items'],
      ).map((e) => OrderItemModel.fromJson(convertToMap(e))).toList(),
      amount: amount,
      hasKnownAmount: hasKnownAmount,
      status: _parseStatus(statusRaw),
      statusRaw: statusRaw,
      address: address,
      createdAt: _parseCreatedAt(convertToString(json['created_at'])),
      etaText: convertToString(json['eta_text']).isEmpty
          ? null
          : convertToString(json['eta_text']),
      hasPrescription:
          convertToBool(json['is_prescription_order']) ||
          convertToBool(json['has_prescription']),
      rejectionReason: convertToString(json['rejection_reason']).isEmpty
          ? null
          : convertToString(json['rejection_reason']),
      billBreakdown: billBreakdown,
      prescriptionImageUrls: prescriptionUrls,
      customerName: customerName,
      customerPhone: customer.$2.isNotEmpty
          ? customer.$2
          : address.phoneNumber.trim(),
      deliveryInstructions: deliveryInstructions,
      prescriptionDescription: prescriptionDescription,
    );
  }

  static OrderBillBreakdown? _parseBillBreakdown(Map<String, dynamic> json) {
    if (json['bill'] != null) {
      return OrderBillBreakdown.fromBillJson(convertToMap(json['bill']));
    }
    if (json['bill_breakdown'] != null) {
      return OrderBillBreakdown.fromJson(convertToMap(json['bill_breakdown']));
    }
    return null;
  }

  static (String, String) _parseCustomerContact(Map<String, dynamic> json) {
    if (json.isEmpty) return ('', '');

    final userDetail = convertToMap(json['user_detail']);
    final firstName = convertToString(userDetail['first_name']).trim();
    final lastName = convertToString(userDetail['last_name']).trim();
    final name = [
      firstName,
      lastName,
    ].where((part) => part.isNotEmpty).join(' ');

    final countryCode = convertToString(json['country_code']).trim();
    final phoneNumber = convertToString(json['phone_number']).trim();
    final phone = phoneNumber.isEmpty
        ? ''
        : countryCode.isEmpty
        ? phoneNumber
        : '$countryCode$phoneNumber';

    return (name, phone);
  }

  static DateTime _parseCreatedAt(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return DateTime.now();

    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;

    for (final pattern in const [
      'd MMM yyyy, hh:mm a',
      'dd MMM yyyy, hh:mm a',
      'd MMM yyyy, h:mm a',
      'dd MMM yyyy, h:mm a',
    ]) {
      try {
        return DateFormat(pattern).parseLoose(value);
      } catch (_) {
        continue;
      }
    }
    return DateTime.now();
  }

  static OrderStatus _parseStatus(String value) {
    return switch (value.toLowerCase().replaceAll(' ', '_')) {
      'pending' => OrderStatus.underReview,
      'prescription_uploaded' => OrderStatus.prescriptionUploaded,
      'under_review' => OrderStatus.underReview,
      'prescription_accepted' || 'accepted' => OrderStatus.prescriptionAccepted,
      'prescription_rejected' || 'rejected' => OrderStatus.prescriptionRejected,
      'bill_generated' => OrderStatus.billGenerated,
      'bill_sent' => OrderStatus.awaitingBillApproval,
      'awaiting_bill_approval' => OrderStatus.awaitingBillApproval,
      'bill_accepted' => OrderStatus.billAccepted,
      'bill_rejected' => OrderStatus.billRejected,
      'payment_pending' => OrderStatus.paymentPending,
      'payment_completed' || 'payment_received' => OrderStatus.paymentCompleted,
      'cash_on_delivery' => OrderStatus.cashOnDelivery,
      'order_confirmed' => OrderStatus.orderConfirmed,
      'preparing_order' => OrderStatus.preparingOrder,
      'packed' => OrderStatus.packed,
      'delivery_partner_assigned' => OrderStatus.deliveryPartnerAssigned,
      'outfordelivery' || 'out_for_delivery' => OrderStatus.outForDelivery,
      'delivered' => OrderStatus.delivered,
      'cancelled' || 'cancelled_by_admin' => OrderStatus.cancelled,
      'placed' => OrderStatus.orderConfirmed,
      'confirmed' => OrderStatus.orderConfirmed,
      _ => OrderStatus.prescriptionUploaded,
    };
  }
}
