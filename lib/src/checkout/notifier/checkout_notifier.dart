// lib/src/checkout/notifier/checkout_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/providers/address_providers.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/orders_providers.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/checkout/repo/checkout_repository.dart';
import 'package:medpik/src/checkout/state/checkout_state.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';
import 'package:medpik/utils/helpers/address_resolution_helper.dart';

part 'checkout_notifier.g.dart';

@Riverpod(keepAlive: false)
class CheckoutNotifier extends _$CheckoutNotifier {
  late final TextEditingController pharmacistInstructionsController;
  late final CheckoutRepo _checkoutRepo;

  @override
  CheckoutState build() {
    pharmacistInstructionsController = TextEditingController();
    _checkoutRepo = ref.read(checkoutRepositoryProvider);
    ref.onDispose(pharmacistInstructionsController.dispose);
    Future.microtask(prepareCheckout);
    return const CheckoutState(loaderState: LoaderState.loading);
  }

  Future<void> prepareCheckout() async {
    final cartItems = ref.read(cartNotifierProvider).items;

    await ref.read(addressNotifierProvider.notifier).fetchAddresses();
    final addressLoaderState = ref.read(addressNotifierProvider).loaderState;
    if (addressLoaderState == LoaderState.networkError ||
        addressLoaderState == LoaderState.serverError ||
        addressLoaderState == LoaderState.error) {
      state = state.copyWith(
        loaderState: addressLoaderState,
        errorMessage: Strings.errorDescription,
        isPlacingOrder: false,
      );
      return;
    }

    final addresses = ref.read(addressNotifierProvider).addresses;

    if (cartItems.isEmpty) {
      state = state.copyWith(
        loaderState: LoaderState.error,
        errorMessage: Strings.cartEmptyMessage,
      );
      return;
    }

    state = state.copyWith(
      loaderState: LoaderState.loaded,
      selectedAddress: resolveSelectedAddress(
        addresses,
        current: state.selectedAddress,
      ),
      pharmacistInstructions: state.pharmacistInstructions,
      isPlacingOrder: false,
    );
    pharmacistInstructionsController.text = state.pharmacistInstructions;
  }

  Future<void> refreshSelectedAddress() async {
    await ref.read(addressNotifierProvider.notifier).fetchAddresses();
    state = state.copyWith(
      selectedAddress: resolveSelectedAddress(
        ref.read(addressNotifierProvider).addresses,
        current: state.selectedAddress,
      ),
    );
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  void savePharmacistInstructions(String value) {
    state = state.copyWith(pharmacistInstructions: value);
  }

  Future<String?> placeMedicineCartOrder() async {
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

    return await _checkoutRepo
        .placeOrder(
          addressId: address.id,
          deliveryInstructions: state.pharmacistInstructions.trim(),
        )
        .fold(
          (error) {
            debugPrint('🔴 PLACE ORDER ERROR: ${error.message}');
            state = state.copyWith(isPlacingOrder: false);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return null;
          },
          (response) async {
            final orderId = response.orderId.trim();
            if (orderId.isEmpty) {
              debugPrint('🔴 PLACE ORDER ERROR: empty order id');
              state = state.copyWith(isPlacingOrder: false);
              showCustomToast(
                message: Strings.somethingWentWrong,
                isSuccess: false,
              );
              return null;
            }

            debugPrint('🟢 ORDER PLACED: $orderId');
             ref
                .read(cartNotifierProvider.notifier)
                .fetchCart(showLoader: false);
             ref.read(ordersNotifierProvider.notifier).fetchOrders();
            state = state.copyWith(isPlacingOrder: false);
            return orderId;
          },
        )
        .catchError((error) {
          debugPrint('🔴 UNEXPECTED PLACE ORDER ERROR: $error');
          state = state.copyWith(isPlacingOrder: false);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return null;
        });
  }
}
