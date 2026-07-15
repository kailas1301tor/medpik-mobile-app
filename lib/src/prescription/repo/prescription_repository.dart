// lib/src/prescription/repo/prescription_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:path/path.dart' as p;
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/data/models/prescription_model.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/data/remote/network_base_services.dart';
import 'package:tsuite/data/remote/network_services.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/prescription/model/prescription_order_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

abstract class PrescriptionRepo {
  Future<Either<ResponseError, PrescriptionDraftModel>> uploadPrescription({
    required List<String> filePaths,
    String? notes,
    List<PrescriptionSelectedProductModel> selectedProducts = const [],
  });

  Future<Either<ResponseError, PrescriptionDraftModel?>> getDraft();

  Future<Either<ResponseError, bool>> clearDraft();

  Future<Either<ResponseError, PrescriptionOrderResponse>> placeOrder({
    required int addressId,
    required String prescriptionDescription,
    required String deliveryInstructions,
    required List<PrescriptionSelectedProductModel> products,
    required List<String> filePaths,
  });
}

/// Local draft until Place Order; multipart create lives here (not in cart checkout).
class PrescriptionRepoImpl implements PrescriptionRepo {
  PrescriptionRepoImpl(this._networkServices);

  final NetworkServices _networkServices;
  PrescriptionDraftModel? _draft;

  @override
  Future<Either<ResponseError, PrescriptionDraftModel>> uploadPrescription({
    required List<String> filePaths,
    String? notes,
    List<PrescriptionSelectedProductModel> selectedProducts = const [],
  }) async {
    final draft = PrescriptionDraftModel(
      filePaths: List<String>.from(filePaths),
      notes: notes ?? '',
      uploadedAt: DateTime.now(),
      selectedProducts: List<PrescriptionSelectedProductModel>.from(
        selectedProducts,
      ),
    );
    _draft = draft;
    return Right(draft);
  }

  @override
  Future<Either<ResponseError, PrescriptionDraftModel?>> getDraft() async {
    return Right(_draft);
  }

  @override
  Future<Either<ResponseError, bool>> clearDraft() async {
    _draft = null;
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
    final productPayload = products
        .map(
          (item) => {
            'product_id': item.product.id,
            'quantity': item.quantity,
          },
        )
        .toList();

    final formFields = FormData();
    formFields.fields.addAll([
      const MapEntry('source', 'prescription'),
      MapEntry('address_id', '$addressId'),
      MapEntry('delivery_instructions', deliveryInstructions),
      MapEntry('prescription_description', prescriptionDescription),
      MapEntry('products', jsonEncode(productPayload)),
    ]);

    for (final path in filePaths) {
      formFields.files.add(
        MapEntry(
          'prescriptions',
          await MultipartFile.fromFile(
            path,
            filename: p.basename(path),
          ),
        ),
      );
    }

    return await _networkServices
        .safe(
          _networkServices.multiPartRequest(
            endPoint: AppConstants.orders,
            formFields: formFields,
          ),
        )
        .thenRight(_networkServices.checkHttpStatus)
        .thenRight(_networkServices.parseJson)
        .mapRight(
          (right) => PrescriptionOrderResponse.fromJson(convertToMap(right)),
        );
  }
}

extension PrescriptionOrderX on PrescriptionOrderResponse {
  OrderModel toOrderModel({required AddressModel address}) {
    return OrderModel(
      id: orderId,
      items: const [],
      amount: 0,
      status: OrderStatus.prescriptionUploaded,
      address: address,
      createdAt: DateTime.now(),
      hasPrescription: true,
    );
  }
}
