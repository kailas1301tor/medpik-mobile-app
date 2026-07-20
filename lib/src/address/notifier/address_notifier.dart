// lib/src/address/notifier/address_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/services/repo_di.dart';
import 'package:tsuite/src/address/model/picked_location_model.dart';
import 'package:tsuite/src/address/repo/address_repository.dart';
import 'package:tsuite/src/address/state/address_state.dart';
import 'package:tsuite/utils/common_widgets/custom_toast.dart';
import 'package:tsuite/utils/helpers/api_error_handler.dart';

part 'address_notifier.g.dart';

@Riverpod(keepAlive: true)
class AddressNotifier extends _$AddressNotifier {
  late final TextEditingController labelController;
  late final TextEditingController phoneController;
  late final TextEditingController line1Controller;
  late final TextEditingController line2Controller;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController pincodeController;

  late AddressRepo addressRepo;
  int? _editingId;
  double? _pickedLatitude;
  double? _pickedLongitude;
  String? _pickedPlaceId;
  String? _pickedFormattedAddress;

  @override
  AddressState build() {
    labelController = TextEditingController();
    phoneController = TextEditingController();
    line1Controller = TextEditingController();
    line2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();
    addressRepo = ref.read(addressRepositoryProvider);

    ref.onDispose(() {
      labelController.dispose();
      phoneController.dispose();
      line1Controller.dispose();
      line2Controller.dispose();
      cityController.dispose();
      stateController.dispose();
      pincodeController.dispose();
    });

    Future.microtask(fetchAddresses);
    return const AddressState(loaderState: LoaderState.loading);
  }

  Future<void> fetchAddresses() async {
    state = state.copyWith(loaderState: LoaderState.loading);
    return await addressRepo
        .getAddresses()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 ADDRESS ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
          },
          (addresses) {
            state = state.copyWith(
              loaderState:
                  addresses.isEmpty ? LoaderState.noData : LoaderState.loaded,
              addresses: addresses,
            );
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ADDRESS ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }

  void startAdd({PickedLocationModel? pick}) {
    _editingId = null;
    labelController.clear();
    phoneController.clear();
    line1Controller.clear();
    line2Controller.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    _clearPickMeta();
    state = state.copyWith(isDefaultSelected: state.addresses.isEmpty);
    if (pick != null) {
      applyPickedLocation(pick);
    }
  }

  void startEdit(AddressModel address) {
    _editingId = address.id;
    labelController.text = address.label;
    phoneController.text = address.phoneNumber;
    line1Controller.text = address.line1;
    line2Controller.text = address.line2;
    cityController.text = address.city;
    stateController.text = address.state;
    pincodeController.text = address.pincode;
    _pickedLatitude = address.latitude;
    _pickedLongitude = address.longitude;
    _pickedPlaceId = address.placeId;
    _pickedFormattedAddress = address.formattedAddress;
    state = state.copyWith(isDefaultSelected: address.isDefault);
  }

  void setDefaultSelection(bool value) {
    state = state.copyWith(isDefaultSelected: value);
  }

  void toggleDefaultSelection() {
    state = state.copyWith(isDefaultSelected: !state.isDefaultSelected);
  }

  void applyPickedLocation(PickedLocationModel pick) {
    _pickedLatitude = pick.latitude;
    _pickedLongitude = pick.longitude;
    _pickedPlaceId = pick.placeId;
    _pickedFormattedAddress = pick.formattedAddress;

    if (pick.line1.isNotEmpty) {
      line1Controller.text = pick.line1;
    }
    if (pick.line2.isNotEmpty) {
      line2Controller.text = pick.line2;
    }
    if (pick.city.isNotEmpty) {
      cityController.text = pick.city;
    }
    if (pick.state.isNotEmpty) {
      stateController.text = pick.state;
    }
    if (pick.pincode.isNotEmpty) {
      pincodeController.text = pick.pincode;
    }
  }

  void _clearPickMeta() {
    _pickedLatitude = null;
    _pickedLongitude = null;
    _pickedPlaceId = null;
    _pickedFormattedAddress = null;
  }

  AddressModel? _buildAddressFromForm() {
    final isDefault = state.isDefaultSelected || state.addresses.isEmpty;
    final address = AddressModel(
      id: _editingId ?? 0,
      label: labelController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      line1: line1Controller.text.trim(),
      line2: line2Controller.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      pincode: pincodeController.text.trim(),
      isDefault: isDefault,
      latitude: _pickedLatitude,
      longitude: _pickedLongitude,
      placeId: _pickedPlaceId,
      formattedAddress: _pickedFormattedAddress,
    );

    if (address.label.isEmpty ||
        address.phoneNumber.isEmpty ||
        address.line1.isEmpty ||
        address.city.isEmpty ||
        address.state.isEmpty ||
        address.pincode.isEmpty) {
      showCustomToast(message: Strings.fieldRequired, isSuccess: false);
      return null;
    }
    return address;
  }

  /// Creates a new address via POST `/api/addresses`.
  Future<bool> addAddress() async {
    if (state.saveLoaderState == LoaderState.loading) return false;

    final address = _buildAddressFromForm();
    if (address == null) return false;

    state = state.copyWith(saveLoaderState: LoaderState.loading);
    return await addressRepo
        .createAddress(address)
        .fold(
          (error) {
            debugPrint("🔴 ADDRESS CREATE ERROR: ${error.message}");
            state = state.copyWith(saveLoaderState: LoaderState.error);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return false;
          },
          (saved) async {
            debugPrint("🟢 ADDRESS CREATED: ${saved.id}");
            showCustomToast(message: Strings.addressSaved, isSuccess: true);
            await fetchAddresses();
            state = state.copyWith(saveLoaderState: LoaderState.loaded);
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ADDRESS CREATE ERROR: $error");
          state = state.copyWith(saveLoaderState: LoaderState.error);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return false;
        });
  }

  /// Updates an existing address via PUT `/api/addresses` with `id` in the body.
  Future<bool> updateAddress() async {
    if (state.saveLoaderState == LoaderState.loading) return false;

    final editingId = _editingId;
    if (editingId == null || editingId == 0) {
      debugPrint("🔴 ADDRESS UPDATE ERROR: missing editing id");
      showCustomToast(message: Strings.somethingWentWrong, isSuccess: false);
      return false;
    }

    final address = _buildAddressFromForm();
    if (address == null) return false;

    state = state.copyWith(saveLoaderState: LoaderState.loading);
    return await addressRepo
        .updateAddress(address.copyWith(id: editingId))
        .fold(
          (error) {
            debugPrint("🔴 ADDRESS UPDATE ERROR: ${error.message}");
            state = state.copyWith(saveLoaderState: LoaderState.error);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return false;
          },
          (saved) async {
            debugPrint("🟢 ADDRESS UPDATED: ${saved.id}");
            showCustomToast(message: Strings.addressSaved, isSuccess: true);
            await fetchAddresses();
            state = state.copyWith(saveLoaderState: LoaderState.loaded);
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ADDRESS UPDATE ERROR: $error");
          state = state.copyWith(saveLoaderState: LoaderState.error);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
          return false;
        });
  }

  /// Form entry point — routes to create or update based on edit mode.
  Future<bool> saveCurrent() {
    final editingId = _editingId;
    if (editingId != null && editingId != 0) {
      return updateAddress();
    }
    return addAddress();
  }

  Future<void> deleteAddress(int id) async {
    if (state.deletingAddressId != null) return;

    state = state.copyWith(deletingAddressId: id);
    await addressRepo
        .deleteAddress(id)
        .fold(
          (error) {
            debugPrint("🔴 ADDRESS DELETE ERROR: ${error.message}");
            state = state.copyWith(deletingAddressId: null);
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) async {
            showCustomToast(message: Strings.addressDeleted, isSuccess: true);
            await fetchAddresses();
            state = state.copyWith(deletingAddressId: null);
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ADDRESS DELETE ERROR: $error");
          state = state.copyWith(deletingAddressId: null);
          showCustomToast(
            message: Strings.somethingWentWrong,
            isSuccess: false,
          );
        });
  }
}
