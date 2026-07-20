// lib/services/repo_di.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/address/repo/address_repository.dart';
import 'package:tsuite/src/auth/repo/auth_repo.dart';
import 'package:tsuite/src/cart/repo/cart_repository.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';
import 'package:tsuite/src/home/repo/home_repository.dart';
import 'package:tsuite/src/orders/repo/orders_repository.dart';
import 'package:tsuite/src/orders/repo/orders_repository_mock.dart';
import 'package:tsuite/src/notifications/repo/notifications_repository.dart';
import 'package:tsuite/src/notifications/repo/notifications_repository_mock.dart';
import 'package:tsuite/src/prescription/repo/customer_products_repository.dart';
import 'package:tsuite/src/prescription/repo/prescription_repository.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_repository.dart';
import 'package:tsuite/src/search/repo/search_repository.dart';
import 'package:tsuite/src/search/repo/search_repository_mock.dart';
import 'package:tsuite/src/wishlist/repo/wishlist_repository.dart';

part 'repo_di.g.dart';

@Riverpod(keepAlive: false)
AuthRepo authRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return AuthRepoImpl(services);
}

@Riverpod(keepAlive: false)
HomeRepo homeRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return HomeRepoImpl(services);
}

@Riverpod(keepAlive: false)
SearchRepo searchRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return SearchRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return SearchRepoImpl(services);
}

@Riverpod(keepAlive: false)
ProductDetailRepo productDetailRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return ProductDetailRepoImpl(services);
}

@Riverpod(keepAlive: false)
CustomerProductsRepo customerProductsRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return CustomerProductsRepoImpl(services);
}

@Riverpod(keepAlive: true)
PrescriptionRepo prescriptionRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return PrescriptionRepoImpl(services);
}

@Riverpod(keepAlive: false)
AddressRepo addressRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return AddressRepoImpl(services);
}

@Riverpod(keepAlive: true)
CartRepo cartRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return CartRepoImpl(services);
}

@Riverpod(keepAlive: false)
CheckoutRepo checkoutRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return CheckoutRepoImpl(services);
}

@Riverpod(keepAlive: false)
OrdersRepo ordersRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return OrdersRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return OrdersRepoImpl(services);
}

@Riverpod(keepAlive: false)
NotificationsRepo notificationsRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return NotificationsRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return NotificationsRepoImpl(services);
}

@Riverpod(keepAlive: false)
WishlistRepo wishlistRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return WishlistRepoImpl(services);
}
