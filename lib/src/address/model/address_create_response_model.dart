// lib/src/address/model/address_create_response_model.dart
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class AddressCreateResponse {
  const AddressCreateResponse({
    required this.results,
    this.message = '',
  });

  final AddressCreateResults results;
  final String message;

  AddressModel? get address => results.data;

  factory AddressCreateResponse.fromJson(Map<String, dynamic> json) =>
      AddressCreateResponse(
        message: convertToString(json['message']),
        results: AddressCreateResults.fromJson(convertToMap(json['results'])),
      );
}

class AddressCreateResults {
  const AddressCreateResults({this.data});

  final AddressModel? data;

  factory AddressCreateResults.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw == null) {
      return const AddressCreateResults();
    }
    if (raw is List) {
      final list = convertToList(raw);
      if (list.isEmpty) return const AddressCreateResults();
      return AddressCreateResults(
        data: AddressModel.fromJson(convertToMap(list.first)),
      );
    }
    return AddressCreateResults(
      data: AddressModel.fromJson(convertToMap(raw)),
    );
  }
}
