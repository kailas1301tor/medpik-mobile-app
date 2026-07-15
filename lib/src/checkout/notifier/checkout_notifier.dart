// lib/src/checkout/notifier/checkout_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';
import 'package:tsuite/src/checkout/state/checkout_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';

part 'checkout_notifier.g.dart';

@Riverpod(keepAlive: false)
class CheckoutNotifier extends _$CheckoutNotifier {
  late CheckoutRepo checkoutRepo;

  @override
  CheckoutState build() {
    checkoutRepo = ref.read(checkoutRepositoryProvider);
    Future.microtask(prepareCheckout);
    return const CheckoutState(loaderState: LoaderState.loading);
  }

  Future<void> prepareCheckout() async {
    final cartItems = ref.read(cartNotifierProvider).items;

    await ref.read(addressNotifierProvider.notifier).fetchAddresses();
    final addresses = ref.read(addressNotifierProvider).addresses;

    if (cartItems.isEmpty) {
      state = state.copyWith(
        loaderState: LoaderState.error,
        errorMessage: Strings.cartEmptyMessage,
      );
      return;
    }

    final subtotal = cartItems.fold<double>(0, (sum, i) => sum + i.lineTotal);

    state = state.copyWith(
      loaderState: LoaderState.loaded,
      selectedAddress: _resolveDefaultAddress(addresses),
      payableTotal: subtotal,
      isPlacingOrder: false,
    );
  }

  Future<void> refreshSelectedAddress() async {
    await ref.read(addressNotifierProvider.notifier).fetchAddresses();
    final addresses = ref.read(addressNotifierProvider).addresses;
    state = state.copyWith(
      selectedAddress: _resolveSelectedAddress(addresses),
    );
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  Future<String?> placeOrder() async {
    if (state.isPlacingOrder) return null;

    final cartItems = ref.read(cartNotifierProvider).items;
    final address = state.selectedAddress;

    if (address == null) {
      showCustomToast(message: Strings.addAddressToContinue, isSuccess: false);
      return null;
    }

    if (cartItems.isEmpty) {
      showCustomToast(message: Strings.cartEmptyMessage, isSuccess: false);
      return null;
    }

    state = state.copyWith(isPlacingOrder: true);
    return await checkoutRepo
        .placeOrder(
          items: cartItems,
          address: address,
          amount: state.payableTotal,
        )
        .fold(
          (error) {
            debugPrint("🔴 PLACE ORDER ERROR: ${error.message}");
            state = state.copyWith(isPlacingOrder: false);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return null;
          },
          (order) async {
            debugPrint("🟢 ORDER PLACED: ${order.id}");
            ref.read(cartNotifierProvider.notifier).clearCart();
            state = state.copyWith(
              isPlacingOrder: false,
              placedOrderId: order.id,
            );
            return order.id;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PLACE ORDER ERROR: $error");
          state = state.copyWith(isPlacingOrder: false);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return null;
        });
  }

  AddressModel? _resolveSelectedAddress(List<AddressModel> addresses) {
    final selectedId = state.selectedAddress?.id;
    if (selectedId != null) {
      for (final address in addresses) {
        if (address.id == selectedId) return address;
      }
    }
    return _resolveDefaultAddress(addresses);
  }

  AddressModel? _resolveDefaultAddress(List<AddressModel> addresses) {
    for (final address in addresses) {
      if (address.isDefault) return address;
    }
    return addresses.isNotEmpty ? addresses.first : null;
  }
}
