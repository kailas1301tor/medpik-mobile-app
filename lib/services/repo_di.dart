// lib/services/repo_di.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/src/address/repo/address_repository.dart';
import 'package:medpik/src/auth/repo/auth_repo.dart';
import 'package:medpik/src/cart/repo/cart_repository.dart';
import 'package:medpik/src/checkout/repo/checkout_repository.dart';
import 'package:medpik/src/device/repo/device_repository.dart';
import 'package:medpik/src/emergency/repo/emergency_repository.dart';
import 'package:medpik/src/home/repo/home_repository.dart';
import 'package:medpik/src/orders/repo/orders_repository.dart';
import 'package:medpik/src/notifications/repo/notifications_repository.dart';
import 'package:medpik/src/prescription/repo/customer_products_repository.dart';
import 'package:medpik/src/prescription/repo/prescription_repository.dart';
import 'package:medpik/src/product_detail/repo/product_detail_repository.dart';
import 'package:medpik/src/profile/repo/profile_repository.dart';
import 'package:medpik/src/search/repo/search_repository.dart';
import 'package:medpik/src/wishlist/repo/wishlist_repository.dart';

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
  final services = ref.watch(networkServicesProvider);
  return OrdersRepoImpl(services);
}

@Riverpod(keepAlive: false)
NotificationsRepo notificationsRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return NotificationsRepoImpl(services);
}

@Riverpod(keepAlive: false)
WishlistRepo wishlistRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return WishlistRepoImpl(services);
}

@Riverpod(keepAlive: true)
DeviceRepo deviceRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return DeviceRepoImpl(services);
}

@Riverpod(keepAlive: false)
EmergencyRepo emergencyRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return EmergencyRepoImpl(services);
}

@Riverpod(keepAlive: false)
ProfileRepo profileRepository(Ref ref) {
  final services = ref.watch(networkServicesProvider);
  return ProfileRepoImpl(services);
}
