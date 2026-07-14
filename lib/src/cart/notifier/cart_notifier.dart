// lib/src/cart/notifier/cart_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/product_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/cart/model/cart_item_model.dart';
import 'package:tsuite/src/cart/state/cart_state.dart';
import 'package:tsuite/src/checkout/repo/checkout_repository.dart';
import 'package:tsuite/src/prescription/notifier/prescription_notifier.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  late final TextEditingController pharmacistInstructionsController;
  late CheckoutRepo checkoutRepo;

  @override
  CartState build() {
    checkoutRepo = ref.read(checkoutRepositoryProvider);
    pharmacistInstructionsController = TextEditingController();

    ref.onDispose(() {
      pharmacistInstructionsController.dispose();
    });

    ref.listen(
      addressNotifierProvider.select((s) => s.addresses),
      (previous, next) => _syncDefaultAddress(next),
    );

    Future.microtask(
      () => _syncDefaultAddress(ref.read(addressNotifierProvider).addresses),
    );

    return const CartState();
  }

  void _syncDefaultAddress(List<AddressModel> addresses) {
    if (state.selectedAddress != null || addresses.isEmpty) return;
    state = state.copyWith(selectedAddress: _resolveDefaultAddress(addresses));
  }

  AddressModel? _resolveDefaultAddress(List<AddressModel> addresses) {
    for (final address in addresses) {
      if (address.isDefault) return address;
    }
    return addresses.isNotEmpty ? addresses.first : null;
  }

  void addItem({required ProductModel product, required int quantity}) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      final existing = items[index];
      items[index] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      items.add(CartItemModel(product: product, quantity: quantity));
    }

    debugPrint("🟢 CART: added ${product.name} x$quantity");
    state = state.copyWith(items: items, submittedOrderId: null);
  }

  void incrementItem(int productId) {
    final items = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    state = state.copyWith(items: items, submittedOrderId: null);
  }

  void decrementItem(int productId) {
    final items = <CartItemModel>[];
    for (final item in state.items) {
      if (item.product.id != productId) {
        items.add(item);
        continue;
      }
      if (item.quantity > 1) {
        items.add(item.copyWith(quantity: item.quantity - 1));
      }
    }
    state = state.copyWith(items: items, submittedOrderId: null);
  }

  void removeItem(int productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
      submittedOrderId: null,
    );
  }

  void clearCart() {
    state = state.copyWith(items: [], submittedOrderId: null);
    debugPrint("🔵 CART: cleared");
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  void savePharmacistInstructions(String value) {
    pharmacistInstructionsController.text = value;
    state = state.copyWith(pharmacistInstructions: value.trim());
  }

  void resetSubmission() {
    state = state.copyWith(submittedOrderId: null);
  }

  double get subtotal =>
      state.items.fold(0, (sum, item) => sum + item.lineTotal);

  int get totalItemCount =>
      state.items.fold<int>(0, (sum, item) => sum + item.quantity);

  Future<void> submitOrder() async {
    final address = state.selectedAddress;
    if (address == null) {
      showCustomToast(message: Strings.addAddressToContinue, isSuccess: false);
      return;
    }

    if (state.items.isEmpty) {
      showCustomToast(message: Strings.cartEmptyMessage, isSuccess: false);
      return;
    }

    state = state.copyWith(loaderState: LoaderState.loading);
    final prescription = ref.read(prescriptionNotifierProvider).draft;
    final hasPrescription = prescription != null;

    return await checkoutRepo
        .placeOrder(
          items: state.items,
          address: address,
          hasPrescription: hasPrescription,
          amount: subtotal,
        )
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 CART SUBMIT ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (order) async {
            debugPrint("🟢 CART ORDER PLACED: ${order.id}");
            clearCart();
            await ref.read(prescriptionNotifierProvider.notifier).loadDraft();
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              submittedOrderId: order.id,
            );
            showCustomToast(message: Strings.orderPlacedSuccess);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED CART SUBMIT ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
          showCustomToast(message: Strings.somethingWentWrong, isSuccess: false);
        });
  }
}
