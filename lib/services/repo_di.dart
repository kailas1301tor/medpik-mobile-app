// lib/services/repo_di.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/src/address/repo/address_repository.dart';
import 'package:tsuite/src/address/repo/address_repository_mock.dart';
import 'package:tsuite/src/auth/repo/auth_repo.dart';
import 'package:tsuite/src/auth/repo/auth_repo_mock.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository_mock.dart';
import 'package:tsuite/src/home/repo/home_repository.dart';
import 'package:tsuite/src/home/repo/home_repository_mock.dart';
import 'package:tsuite/src/orders/repo/orders_repository.dart';
import 'package:tsuite/src/orders/repo/orders_repository_mock.dart';
import 'package:tsuite/src/prescription/repo/prescription_repository.dart';
import 'package:tsuite/src/prescription/repo/prescription_repository_mock.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_repository.dart';
import 'package:tsuite/src/product_detail/repo/product_detail_repository_mock.dart';
import 'package:tsuite/src/search/repo/search_repository.dart';
import 'package:tsuite/src/search/repo/search_repository_mock.dart';

part 'repo_di.g.dart';

@Riverpod(keepAlive: false)
AuthRepo authRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return AuthRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return AuthRepoImpl(services);
}

@Riverpod(keepAlive: false)
HomeRepo homeRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return HomeRepoMock();
  }
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
  if (AppConstants.useMockData) {
    return ProductDetailRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return ProductDetailRepoImpl(services);
}

@Riverpod(keepAlive: false)
PrescriptionRepo prescriptionRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return PrescriptionRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return PrescriptionRepoImpl(services);
}

@Riverpod(keepAlive: false)
AddressRepo addressRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return AddressRepoMock();
  }
  final services = ref.watch(networkServicesProvider);
  return AddressRepoImpl(services);
}

@Riverpod(keepAlive: false)
CheckoutRepo checkoutRepository(Ref ref) {
  if (AppConstants.useMockData) {
    return CheckoutRepoMock();
  }
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
