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
    line1Controller = TextEditingController();
    line2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();
    addressRepo = ref.read(addressRepositoryProvider);

    ref.onDispose(() {
      labelController.dispose();
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
    line1Controller.clear();
    line2Controller.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    _clearPickMeta();
    if (pick != null) {
      applyPickedLocation(pick);
    }
  }

  void startEdit(AddressModel address) {
    _editingId = address.id;
    labelController.text = address.label;
    line1Controller.text = address.line1;
    line2Controller.text = address.line2;
    cityController.text = address.city;
    stateController.text = address.state;
    pincodeController.text = address.pincode;
    _pickedLatitude = address.latitude;
    _pickedLongitude = address.longitude;
    _pickedPlaceId = address.placeId;
    _pickedFormattedAddress = address.formattedAddress;
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

  Future<bool> saveCurrent({bool isDefault = false}) async {
    final address = AddressModel(
      id: _editingId ?? 0,
      label: labelController.text.trim(),
      line1: line1Controller.text.trim(),
      line2: line2Controller.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      pincode: pincodeController.text.trim(),
      isDefault: isDefault || state.addresses.isEmpty,
      latitude: _pickedLatitude,
      longitude: _pickedLongitude,
      placeId: _pickedPlaceId,
      formattedAddress: _pickedFormattedAddress,
    );

    if (address.label.isEmpty ||
        address.line1.isEmpty ||
        address.city.isEmpty ||
        address.pincode.isEmpty) {
      showCustomToast(message: Strings.fieldRequired, isSuccess: false);
      return false;
    }

    return await addressRepo.saveAddress(address).fold(
          (error) {
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
            return false;
          },
          (saved) async {
            showCustomToast(message: Strings.addressSaved, isSuccess: true);
            await fetchAddresses();
            return true;
          },
        );
  }

  Future<void> deleteAddress(int id) async {
    await addressRepo.deleteAddress(id).fold(
          (error) {
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) async {
            showCustomToast(message: Strings.addressDeleted, isSuccess: true);
            await fetchAddresses();
          },
        );
  }

  Future<void> setDefault(int id) async {
    await addressRepo.setDefaultAddress(id).fold(
          (error) {
            showCustomToast(
              message: error.message ?? Strings.somethingWentWrong,
              isSuccess: false,
            );
          },
          (_) => fetchAddresses(),
        );
  }
}
