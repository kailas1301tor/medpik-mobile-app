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

    orders.addAll([
      OrderModel(
        id: 'MPK1001',
        items: [
          OrderItemModel(
            product: MockCatalog.allProducts.first,
            quantity: 2,
          ),
        ],
        amount: 90,
        status: OrderStatus.outForDelivery,
        address: address,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        etaText: 'Arriving in 25 mins',
        hasPrescription: false,
      ),
      OrderModel(
        id: 'MPK0999',
        items: [
          OrderItemModel(
            product: MockCatalog.allProducts[3],
            quantity: 1,
          ),
        ],
        amount: 120,
        status: OrderStatus.delivered,
        address: address,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        hasPrescription: true,
      ),
    ]);
  }
}
