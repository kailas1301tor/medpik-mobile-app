// lib/src/prescription/repo/prescription_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:path/path.dart' as p;
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/data/models/prescription_selected_product_model.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/data/remote/network_services.dart';
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/prescription/model/prescription_order_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

abstract class PrescriptionRepo {
  Future<Either<ResponseError, PrescriptionOrderResponse>> placeOrder({
    required int addressId,
    required String prescriptionDescription,
    required String deliveryInstructions,
    required List<PrescriptionSelectedProductModel> products,
    required List<String> filePaths,
  });
}

class PrescriptionRepoImpl implements PrescriptionRepo {
  PrescriptionRepoImpl(this._networkServices);

  final NetworkServices _networkServices;

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
