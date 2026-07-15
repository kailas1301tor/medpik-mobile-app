// lib/src/prescription/repo/prescription_repository_mock.dart
import 'package:either_dart/either.dart';
import 'package:tsuite/data/mock/mock_store.dart';
import 'package:tsuite/data/models/prescription_model.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/src/prescription/model/prescription_order_model.dart';
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

  @override
  Future<Either<ResponseError, PrescriptionOrderResponse>> placeOrder({
    required int addressId,
    required String prescriptionDescription,
    required String deliveryInstructions,
    required List<PrescriptionSelectedProductModel> products,
    required List<String> filePaths,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final orderId = int.tryParse(_store.nextOrderId()) ?? 1;
    _store.prescriptionDraft = null;
    return Right(
      PrescriptionOrderResponse(
        message: 'Prescription order placed successfully',
        results: PrescriptionOrderResults(
          data: PrescriptionOrderData(orderId: orderId),
        ),
      ),
    );
  }
}
