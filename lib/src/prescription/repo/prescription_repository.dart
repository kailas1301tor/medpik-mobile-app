// lib/src/prescription/repo/prescription_repository.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/models/prescription_model.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';

abstract class PrescriptionRepo {
  Future<Either<ResponseError, PrescriptionDraftModel>> uploadPrescription({
    required List<String> filePaths,
    String? notes,
    List<PrescriptionSelectedProductModel> selectedProducts = const [],
  });

  Future<Either<ResponseError, PrescriptionDraftModel?>> getDraft();

  Future<Either<ResponseError, bool>> clearDraft();
}

class PrescriptionRepoImpl implements PrescriptionRepo {
  PrescriptionRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

  @override
  Future<Either<ResponseError, PrescriptionDraftModel>> uploadPrescription({
    required List<String> filePaths,
    String? notes,
    List<PrescriptionSelectedProductModel> selectedProducts = const [],
  }) async {
    _networkServices.hashCode;
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, PrescriptionDraftModel?>> getDraft() async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }

  @override
  Future<Either<ResponseError, bool>> clearDraft() async {
    return const Left(
      ResponseError(key: ApiErrorTypes.oops, message: 'Not implemented'),
    );
  }
}
