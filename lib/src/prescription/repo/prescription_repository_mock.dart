// lib/src/prescription/repo/prescription_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_store.dart';
import 'package:tsuite/data/models/prescription_model.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/src/prescription/repo/prescription_repository.dart';

class PrescriptionRepoMock implements PrescriptionRepo {
  final _store = MockStore.instance;

  @override
  Future<Either<ResponseError, PrescriptionDraftModel>> uploadPrescription({
    required List<String> filePaths,
    String? notes,
    List<PrescriptionSelectedProductModel> selectedProducts = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final draft = PrescriptionDraftModel(
      filePaths: filePaths,
      notes: notes ?? '',
      uploadedAt: DateTime.now(),
      selectedProducts: selectedProducts,
    );
    _store.prescriptionDraft = draft;
    return Right(draft);
  }

  @override
  Future<Either<ResponseError, PrescriptionDraftModel?>> getDraft() async {
    return Right(_store.prescriptionDraft);
  }

  @override
  Future<Either<ResponseError, bool>> clearDraft() async {
    _store.prescriptionDraft = null;
    return const Right(true);
  }
}
