// lib/src/address/repo/address_repository.dart
//
// * REST layer for saved addresses — all methods return Either<ResponseError, T>.
//
// ? Base path: AppConstants.addresses → /api/addresses
// ? GET    — list addresses for authenticated user
// ? POST   — create (AddressModel.toCreateJson)
// ? PUT    — update (body includes id + fields)
// ? DELETE — remove (body { id })
//
// ! Errors are never thrown to the UI — always map via handleResponseError in notifier.
// ? JSON envelopes parsed in feature models; repo passes full response map.
import 'package:either_dart/either.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/src/address/model/address_save_response_model.dart';
import 'package:medpik/src/address/model/addresses_response_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class AddressRepo {
  Future<Either<ResponseError, AddressesResponse>> getAddresses();

  Future<Either<ResponseError, AddressSaveResponse>> createAddress(
    AddressModel address,
  );

  Future<Either<ResponseError, AddressSaveResponse>> updateAddress(
    AddressModel address,
  );

  Future<Either<ResponseError, bool>> deleteAddress(int id);
}

class AddressRepoImpl implements AddressRepo {
  AddressRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, AddressesResponse>> getAddresses() async {
    return await _networkServices
        .safe(
          _networkServices.getRequest(endPoint: AppConstants.addresses),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => AddressesResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, AddressSaveResponse>> createAddress(
    AddressModel address,
  ) async {
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
          (right) => AddressSaveResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, AddressSaveResponse>> updateAddress(
    AddressModel address,
  ) async {
    return await _networkServices
        .safe(
          _networkServices.putRequest(
            endPoint: AppConstants.addresses,
            parameters: {
              'id': address.id,
              ...address.toCreateJson(),
            },
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => AddressSaveResponse.fromJson(convertToMap(right)),
        );
  }

  @override
  Future<Either<ResponseError, bool>> deleteAddress(int id) async {
    return await _networkServices
        .safe(
          _networkServices.deleteRequest(
            endPoint: AppConstants.addresses,
            parameters: {'id': id},
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight((_) => true);
  }
}
