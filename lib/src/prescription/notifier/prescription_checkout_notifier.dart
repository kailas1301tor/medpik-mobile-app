// lib/src/prescription/notifier/prescription_checkout_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/address_book_service.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/src/prescription/repo/prescription_repository.dart';
import 'package:tsuite/src/prescription/state/prescription_checkout_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/address_resolution_helper.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

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
    final addressBook = ref.read(addressBookServiceProvider);

    await addressBook.fetchAddresses();
    final addressState = ref.read(addressNotifierProvider);
    if (addressState.loaderState == LoaderState.networkError ||
        addressState.loaderState == LoaderState.serverError ||
        addressState.loaderState == LoaderState.error) {
      state = state.copyWith(
        loaderState: addressState.loaderState,
        errorMessage: Strings.errorDescription,
        isPlacingOrder: false,
      );
      return;
    }

    final addresses = addressBook.addresses;

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
    final addressBook = ref.read(addressBookServiceProvider);
    await addressBook.fetchAddresses();
    state = state.copyWith(
      selectedAddress: resolveSelectedAddress(
        addressBook.addresses,
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
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 PRESCRIPTION ORDER ERROR: ${error.message}");
            state = state.copyWith(
              isPlacingOrder: false,
              loaderState: loaderState,
              errorMessage: error.message ?? Strings.somethingWentWrong,
            );
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
            await prescriptionRepo.clearDraft();
            await ref.read(prescriptionNotifierProvider.notifier).loadDraft();
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
