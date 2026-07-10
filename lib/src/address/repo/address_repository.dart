// lib/src/address/repo/address_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';

abstract class AddressRepo {
  Future<Either<ResponseError, List<AddressModel>>> getAddresses();

  Future<Either<ResponseError, AddressModel>> saveAddress(AddressModel address);

  Future<Either<ResponseError, bool>> deleteAddress(int id);

  Future<Either<ResponseError, AddressModel>> setDefaultAddress(int id);
}

class AddressRepoImpl implements AddressRepo {
  AddressRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, List<AddressModel>>> getAddresses() async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, AddressModel>> saveAddress(
    AddressModel address,
  ) async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, bool>> deleteAddress(int id) async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, AddressModel>> setDefaultAddress(int id) async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }
}
