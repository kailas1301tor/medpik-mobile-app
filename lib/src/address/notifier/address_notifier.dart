
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';
import 'package:medpik/src/address/repo/address_repository.dart';
import 'package:medpik/src/address/state/address_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

part 'address_notifier.g.dart';

@Riverpod(keepAlive: true)
class AddressNotifier extends _$AddressNotifier {
  // ? Form controllers — owned here per project convention; disposed in build.
  late TextEditingController labelController;
  late TextEditingController phoneController;
  late TextEditingController line1Controller;
  late TextEditingController line2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pincodeController;

  late AddressRepo addressRepo;
  bool _lifecycleInitialized = false;

  // ? Non-null when editing; null when adding a new address.
  int? _editingId;

  // ? Map metadata — form-only fields from PickedLocationModel or AddressModel.
  double? _pickedLatitude;
  double? _pickedLongitude;
  String? _pickedPlaceId;
  String? _pickedFormattedAddress;

  @override
  AddressState build() {
    if (_lifecycleInitialized) {
      return state;
    }

    labelController = TextEditingController();
    phoneController = TextEditingController();
    line1Controller = TextEditingController();
    line2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();
    addressRepo = ref.read(addressRepositoryProvider);
    _lifecycleInitialized = true;

    ref.onDispose(() {
      labelController.dispose();
      phoneController.dispose();
      line1Controller.dispose();
      line2Controller.dispose();
      cityController.dispose();
      stateController.dispose();
      pincodeController.dispose();
      _lifecycleInitialized = false;
    });

    Future.microtask(() {
      if (AppConstants.hasSession) {
        fetchAddresses();
      }
    });
    return const AddressState(loaderState: LoaderState.loading);
  }

  // ? GET /api/addresses — drives AddressBookScreen loader / empty / error states.
  Future<void> fetchAddresses() async {
    if (!AppConstants.hasSession) {
      state = state.copyWith(loaderState: LoaderState.noData);
      return;
    }
    state = state.copyWith(loaderState: LoaderState.loading);
    return await addressRepo
        .getAddresses()
        .fold(
          (error) {
            final loaderState = handleResponseError(error.key);
            debugPrint("🔴 ADDRESS ERROR: ${error.message}");
            state = state.copyWith(loaderState: loaderState);
          },
          (response) {
            final addresses = response.addresses;
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

  // ? Resets form for a new address. Pass [pick] when returning from LocationPickerScreen.
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
    state = state.copyWith(
      // * First address in the book is always default.
      isDefaultSelected: state.addresses.isEmpty,
      pickedLocationSummary: '',
    );
    if (pick != null) {
      applyPickedLocation(pick);
    }
  }

  // ? Hydrates controllers and map metadata from an existing AddressModel.
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
    state = state.copyWith(
      isDefaultSelected: address.isDefault,
      pickedLocationSummary: _formatLocationSummary(
        formattedAddress: address.formattedAddress,
        line1: address.line1,
        city: address.city,
      ),
    );
  }

  // ? One-liner shown in AddressFormMapPickRow.
  String _formatLocationSummary({
    required String? formattedAddress,
    required String line1,
    required String city,
  }) {
    final formatted = formattedAddress?.trim() ?? '';
    if (formatted.isNotEmpty) return formatted;
    return [line1, city].where((part) => part.trim().isNotEmpty).join(', ');
  }

  void setDefaultSelection(bool value) {
    state = state.copyWith(isDefaultSelected: value);
  }

  void toggleDefaultSelection() {
    state = state.copyWith(isDefaultSelected: !state.isDefaultSelected);
  }

  // ? Merges map pick into form. Only overwrites non-empty fields (keeps manual edits).
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

    state = state.copyWith(
      pickedLocationSummary: _formatLocationSummary(
        formattedAddress: pick.formattedAddress,
        line1: pick.line1,
        city: pick.city,
      ),
    );
  }

  void _clearPickMeta() {
    _pickedLatitude = null;
    _pickedLongitude = null;
    _pickedPlaceId = null;
    _pickedFormattedAddress = null;
  }

  double? get pickedLatitude => _pickedLatitude;

  double? get pickedLongitude => _pickedLongitude;

  String? get pickedFormattedAddress => _pickedFormattedAddress;

  bool get hasPickedCoordinates =>
      _pickedLatitude != null && _pickedLongitude != null;

  // ? Validates required fields; returns null + toast on failure.
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
      showCustomErrorToast(message: Strings.fieldRequired);
      return null;
    }
    return address;
  }

  // ? POST /api/addresses — refreshes list on success.
  Future<bool> addAddress() async {
    if (state.isSaving) return false;

    final address = _buildAddressFromForm();
    if (address == null) return false;

    state = state.copyWith(isSaving: true);
    return await addressRepo
        .createAddress(address)
        .fold(
          (error) {
            debugPrint("🔴 ADDRESS CREATE ERROR: ${error.message}");
            state = state.copyWith(isSaving: false);
            showCustomErrorToast(
              message: error.message ?? Strings.somethingWentWrong,
            );
            return false;
          },
          (response) async {
            final saved = response.address;
            if (saved == null || saved.id == 0) {
              debugPrint("🔴 ADDRESS CREATE ERROR: missing saved address");
              showCustomErrorToast(message: Strings.somethingWentWrong);
              return false;
            }
            debugPrint("🟢 ADDRESS CREATED: ${saved.id}");
            showCustomToast(message: Strings.addressSaved, isSuccess: true);
            await fetchAddresses();
            state = state.copyWith(isSaving: false);
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ADDRESS CREATE ERROR: $error");
          state = state.copyWith(isSaving: false);
          showCustomErrorToast(message: Strings.somethingWentWrong);
          return false;
        });
  }

  // ? PUT /api/addresses with id in body.
  Future<bool> updateAddress() async {
    if (state.isSaving) return false;

    final editingId = _editingId;
    if (editingId == null || editingId == 0) {
      debugPrint("🔴 ADDRESS UPDATE ERROR: missing editing id");
      showCustomErrorToast(message: Strings.somethingWentWrong);
      return false;
    }

    final address = _buildAddressFromForm();
    if (address == null) return false;

    state = state.copyWith(isSaving: true);
    return await addressRepo
        .updateAddress(address.copyWith(id: editingId))
        .fold(
          (error) {
            debugPrint("🔴 ADDRESS UPDATE ERROR: ${error.message}");
            state = state.copyWith(isSaving: false);
            showCustomErrorToast(
              message: error.message ?? Strings.somethingWentWrong,
            );
            return false;
          },
          (response) async {
            final saved = response.address;
            if (saved == null || saved.id == 0) {
              debugPrint("🔴 ADDRESS UPDATE ERROR: missing saved address");
              showCustomErrorToast(message: Strings.somethingWentWrong);
              return false;
            }
            debugPrint("🟢 ADDRESS UPDATED: ${saved.id}");
            showCustomToast(message: Strings.addressSaved, isSuccess: true);
            await fetchAddresses();
            state = state.copyWith(isSaving: false);
            return true;
          },
        )
        .catchError((error) {
          debugPrint("🔴 UNEXPECTED ADDRESS UPDATE ERROR: $error");
          state = state.copyWith(isSaving: false);
          showCustomErrorToast(message: Strings.somethingWentWrong);
          return false;
        });
  }

  // * Form save entry — routes to addAddress or updateAddress via _editingId.
  Future<bool> saveCurrent() {
    final editingId = _editingId;
    if (editingId != null && editingId != 0) {
      return updateAddress();
    }
    return addAddress();
  }

  // ? DELETE /api/addresses — isDeletingAddress drives dialog confirm-button loader.
  Future<bool> deleteAddress(int id) async {
    if (state.isDeletingAddress) return false;

    state = state.copyWith(isDeletingAddress: true);
    try {
      return await addressRepo
          .deleteAddress(id)
          .fold(
            (error) {
              debugPrint("🔴 ADDRESS DELETE ERROR: ${error.message}");
              showCustomErrorToast(
                message: error.message ?? Strings.somethingWentWrong,
              );
              return false;
            },
            (_) async {
              showCustomToast(message: Strings.addressDeleted, isSuccess: true);
              await fetchAddresses();
              return true;
            },
          )
          .catchError((error) {
            debugPrint("🔴 UNEXPECTED ADDRESS DELETE ERROR: $error");
            showCustomErrorToast(message: Strings.somethingWentWrong);
            return false;
          });
    } finally {
      state = state.copyWith(isDeletingAddress: false);
    }
  }
}
