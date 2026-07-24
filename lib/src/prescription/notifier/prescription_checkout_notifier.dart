// lib/src/prescription/notifier/prescription_checkout_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/providers/address_providers.dart';
import 'package:medpik/providers/orders_providers.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/prescription/notifier/prescription_notifier.dart';
import 'package:medpik/src/prescription/repo/prescription_repository.dart';
import 'package:medpik/src/prescription/state/prescription_checkout_state.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';
import 'package:medpik/utils/helpers/address_resolution_helper.dart';

part 'prescription_checkout_notifier.g.dart';

@Riverpod(keepAlive: false)
class PrescriptionCheckoutNotifier extends _$PrescriptionCheckoutNotifier {
  late PrescriptionRepo prescriptionRepo;

  @override
  PrescriptionCheckoutState build() {
    prescriptionRepo = ref.read(prescriptionRepositoryProvider);
    Future.microtask(prepareCheckout);
    return const PrescriptionCheckoutState(loaderState: LoaderState.loading);
  }

  Future<void> prepareCheckout() async {
    final draft = ref.read(prescriptionNotifierProvider).draft;

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

    if (draft == null || draft.filePaths.isEmpty) {
      state = state.copyWith(
        loaderState: LoaderState.error,
        errorMessage: Strings.attachPrescriptionToContinue,
      );
      return;
    }

    state = state.copyWith(
      loaderState: LoaderState.loaded,
      selectedAddress: resolveDefaultAddress(addresses),
      isPlacingOrder: false,
    );
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

  Future<String?> placePrescriptionOrder() async {
    if (state.isPlacingOrder) return null;

    final address = state.selectedAddress;
    final draft = ref.read(prescriptionNotifierProvider).draft;

    if (address == null) {
      showCustomToast(message: Strings.addAddressToContinue, isSuccess: false);
      return null;
    }

    if (draft == null || draft.filePaths.isEmpty) {
      showCustomToast(
        message: Strings.attachPrescriptionToContinue,
        isSuccess: false,
      );
      return null;
    }

    state = state.copyWith(isPlacingOrder: true);

    return await prescriptionRepo
        .placeOrder(
          addressId: address.id,
          prescriptionDescription: draft.notes,
          deliveryInstructions: draft.notes,
          products: draft.selectedProducts,
          filePaths: draft.filePaths,
        )
        .fold(
          (error) {
            debugPrint("🔴 PRESCRIPTION ORDER ERROR: ${error.message}");
            state = state.copyWith(isPlacingOrder: false);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return null;
          },
          (response) async {
            final orderId = response.orderId;
            if (orderId.isEmpty) {
              debugPrint("🔴 PRESCRIPTION ORDER: empty order_id");
              state = state.copyWith(isPlacingOrder: false);
              showCustomToast(
                message: Strings.somethingWentWrong,
                isSuccess: false,
              );
              return null;
            }
            debugPrint("🟢 PRESCRIPTION ORDER PLACED: $orderId");
            ref.read(prescriptionNotifierProvider.notifier).clearDraft();
            ref.read(ordersNotifierProvider.notifier).fetchOrders();
            state = state.copyWith(
              isPlacingOrder: false,
              placedOrderId: orderId,
            );
            return orderId;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED PRESCRIPTION ORDER ERROR: $error");
          state = state.copyWith(isPlacingOrder: false);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return null;
        });
  }
}
