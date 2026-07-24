// lib/src/address/model/address_save_response_model.dart
//
// ? POST/PUT /api/addresses envelope: { message, results: { data: AddressModel } }
// ? Backend may return data as object OR one-item array — both handled below.
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/utils/helpers/safe_converters.dart';

class AddressSaveResponse {
  const AddressSaveResponse({
    required this.results,
    this.message = '',
  });

  final AddressSaveResults results;
  final String message;

  AddressModel? get address => results.data;

  factory AddressSaveResponse.fromJson(Map<String, dynamic> json) =>
      AddressSaveResponse(
        message: convertToString(json['message']),
        results: AddressSaveResults.fromJson(convertToMap(json['results'])),
      );
}

class AddressSaveResults {
  const AddressSaveResults({this.data});

  final AddressModel? data;

  factory AddressSaveResults.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw == null) {
      return const AddressSaveResults();
    }
    if (raw is List) {
      final list = convertToList(raw);
      if (list.isEmpty) return const AddressSaveResults();
      return AddressSaveResults(
        data: AddressModel.fromJson(convertToMap(list.first)),
      );
    }
    return AddressSaveResults(
      data: AddressModel.fromJson(convertToMap(raw)),
    );
  }
}
