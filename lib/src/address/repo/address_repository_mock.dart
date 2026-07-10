// lib/src/address/repo/address_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_store.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/address/repo/address_repository.dart';

class AddressRepoMock implements AddressRepo {
  final _store = MockStore.instance;

  @override
  Future<Either<ResponseError, List<AddressModel>>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(List<AddressModel>.from(_store.addresses));
  }

  @override
  Future<Either<ResponseError, AddressModel>> saveAddress(
    AddressModel address,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _store.addresses.indexWhere((a) => a.id == address.id);
    if (index >= 0) {
      _store.addresses[index] = address;
      if (address.isDefault) _clearOtherDefaults(address.id);
      return Right(address);
    }

    final newAddress = address.id == 0
        ? address.copyWith(id: _store.nextAddressId())
        : address;
    if (newAddress.isDefault) _clearOtherDefaults(newAddress.id);
    _store.addresses.add(newAddress);
    return Right(newAddress);
  }

  @override
  Future<Either<ResponseError, bool>> deleteAddress(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lengthBefore = _store.addresses.length;
    _store.addresses.removeWhere((a) => a.id == id);
    if (_store.addresses.length == lengthBefore) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.notFound,
          message: Strings.noDataFound,
        ),
      );
    }
    if (_store.addresses.isNotEmpty &&
        !_store.addresses.any((a) => a.isDefault)) {
      _store.addresses[0] = _store.addresses[0].copyWith(isDefault: true);
    }
    return const Right(true);
  }

  @override
  Future<Either<ResponseError, AddressModel>> setDefaultAddress(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _store.addresses.indexWhere((a) => a.id == id);
    if (index < 0) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.notFound,
          message: Strings.noDataFound,
        ),
      );
    }
    _clearOtherDefaults(id);
    final updated = _store.addresses[index].copyWith(isDefault: true);
    _store.addresses[index] = updated;
    return Right(updated);
  }

  void _clearOtherDefaults(int id) {
    for (var i = 0; i < _store.addresses.length; i++) {
      if (_store.addresses[i].id != id && _store.addresses[i].isDefault) {
        _store.addresses[i] = _store.addresses[i].copyWith(isDefault: false);
      }
    }
  }
}
