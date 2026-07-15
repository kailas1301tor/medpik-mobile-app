// lib/data/mock/mock_store.dart
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/models/prescription_model.dart';
import 'package:tsuite/data/mock/mock_catalog.dart';
import 'package:tsuite/res/enums/enums.dart';

class MockStore {
  MockStore._();

  static final MockStore instance = MockStore._();

  PrescriptionDraftModel? prescriptionDraft;

  final List<AddressModel> addresses = [
    const AddressModel(
      id: 1,
      label: 'Home',
      line1: 'Flat 12B, Sunrise Apartments',
      line2: 'Andheri West',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400001',
      isDefault: true,
      latitude: 19.1136,
      longitude: 72.8697,
      formattedAddress: 'Andheri West, Mumbai, Maharashtra 400001',
    ),
  ];

  final List<OrderModel> orders = [];
  int _orderCounter = 1000;
  int _addressCounter = 1;

  String nextOrderId() {
    _orderCounter += 1;
    return 'MPK$_orderCounter';
  }

  int nextAddressId() {
    _addressCounter += 1;
    return _addressCounter;
  }

  AddressModel? get defaultAddress {
    for (final address in addresses) {
      if (address.isDefault) return address;
    }
    return addresses.isEmpty ? null : addresses.first;
  }

  void seedDemoOrdersIfEmpty() {
    if (orders.isNotEmpty) return;
    final address = defaultAddress;
    if (address == null) return;

    final products = MockCatalog.allProducts;

    final billBreakdown1245 = const OrderBillBreakdown(
      itemTotal: 1185,
      deliveryCharges: 40,
      packagingCharges: 20,
    );
    final billBreakdown890 = const OrderBillBreakdown(
      itemTotal: 830,
      deliveryCharges: 40,
      packagingCharges: 20,
    );
    final billBreakdown560 = const OrderBillBreakdown(
      itemTotal: 500,
      deliveryCharges: 40,
      packagingCharges: 20,
    );

    orders.addAll([
      OrderModel(
        id: 'MPK1001',
        items: [
          OrderItemModel(product: products[0], quantity: 1),
          OrderItemModel(product: products[1], quantity: 1),
          OrderItemModel(product: products[2], quantity: 1),
          OrderItemModel(product: products[3], quantity: 1),
          OrderItemModel(product: products[4], quantity: 1),
          OrderItemModel(product: products[5], quantity: 1),
        ],
        amount: 1245,
        status: OrderStatus.awaitingBillApproval,
        address: address,
        createdAt: DateTime(2025, 5, 10, 10, 30),
        hasPrescription: true,
        billBreakdown: billBreakdown1245,
      ),
      OrderModel(
        id: 'MPK1002',
        items: [
          OrderItemModel(product: products[1], quantity: 2),
          OrderItemModel(product: products[6], quantity: 1),
        ],
        amount: 430,
        status: OrderStatus.outForDelivery,
        address: address,
        createdAt: DateTime(2025, 5, 9, 14, 15),
        etaText: 'Arriving today by 08:00 PM',
        hasPrescription: false,
      ),
      OrderModel(
        id: 'MPK1003',
        items: [
          OrderItemModel(product: products[2], quantity: 2),
          OrderItemModel(product: products[7], quantity: 1),
        ],
        amount: 890,
        status: OrderStatus.billGenerated,
        address: address,
        createdAt: DateTime(2025, 5, 8, 9, 0),
        hasPrescription: true,
        billBreakdown: billBreakdown890,
      ),
      OrderModel(
        id: 'MPK1004',
        items: [
          OrderItemModel(product: products[3], quantity: 2),
          OrderItemModel(product: products[4], quantity: 1),
        ],
        amount: 1100,
        status: OrderStatus.delivered,
        address: address,
        createdAt: DateTime(2025, 5, 5, 18, 45),
        hasPrescription: false,
      ),
      OrderModel(
        id: 'MPK1005',
        items: [
          OrderItemModel(product: products[0], quantity: 1),
        ],
        amount: 0,
        status: OrderStatus.underReview,
        address: address,
        createdAt: DateTime(2025, 5, 11, 8, 20),
        hasPrescription: true,
      ),
      OrderModel(
        id: 'MPK1006',
        items: [
          OrderItemModel(product: products[5], quantity: 1),
        ],
        amount: 0,
        status: OrderStatus.prescriptionRejected,
        address: address,
        createdAt: DateTime(2025, 5, 7, 11, 0),
        hasPrescription: true,
        rejectionReason:
            'Prescription is not clear. Please upload a clear prescription and try again.',
      ),
      OrderModel(
        id: 'MPK1007',
        items: [
          OrderItemModel(product: products[6], quantity: 2),
        ],
        amount: 560,
        status: OrderStatus.paymentPending,
        address: address,
        createdAt: DateTime(2025, 5, 6, 16, 30),
        hasPrescription: false,
        billBreakdown: billBreakdown560,
      ),
      OrderModel(
        id: 'MPK1008',
        items: [
          OrderItemModel(product: products[7], quantity: 1),
        ],
        amount: 0,
        status: OrderStatus.cancelled,
        address: address,
        createdAt: DateTime(2025, 5, 4, 12, 0),
        hasPrescription: false,
      ),
    ]);
  }
}
