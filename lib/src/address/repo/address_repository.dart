// lib/src/address/repo/address_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/src/address/model/address_create_response_model.dart';
import 'package:tsuite/src/address/model/addresses_response_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

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
    return await _networkServices
        .safe(
          _networkServices.getRequest(endPoint: AppConstants.addresses),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((right) {
          final response = AddressesResponse.fromJson(convertToMap(right));
          return response.addresses;
        });
  }

  @override
  Future<Either<ResponseError, AddressModel>> saveAddress(
    AddressModel address,
  ) async {
    if (address.id != 0) {
      return const Left(
        ResponseError(
          key: ApiErrorTypes.oops,
          message: Strings.addressUpdateUnavailable,
        ),
      );
    }

    return await _networkServices
        .safe(
          _networkServices.postRequest(
            endPoint: AppConstants.addresses,
            parameters: address.toCreateJson(),
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => AddressCreateResponse.fromJson(convertToMap(right)),
        )
        .then((either) {
          return either.fold(
            (error) => Left(error),
            (response) {
              final saved = response.address;
              if (saved == null || saved.id == 0) {
                return const Left(
                  ResponseError(
                    key: ApiErrorTypes.jsonParsing,
                    message: Strings.somethingWentWrong,
                  ),
                );
              }
              return Right(saved);
            },
          );
        });
  }

  @override
  Future<Either<ResponseError, bool>> deleteAddress(int id) async {
    return const Left(
      ResponseError(
        key: ApiErrorTypes.oops,
        message: Strings.addressDeleteUnavailable,
      ),
    );
  }

  @override
  Future<Either<ResponseError, AddressModel>> setDefaultAddress(int id) async {
    return const Left(
      ResponseError(
        key: ApiErrorTypes.oops,
        message: Strings.setDefaultAddressUnavailable,
      ),
    );
  }
}
