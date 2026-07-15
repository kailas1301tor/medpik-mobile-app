// lib/src/address/model/addresses_response_model.dart
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/utils/helpers/safe_converters.dart';

class AddressesResponse {
  const AddressesResponse({
    required this.results,
    this.message = '',
  });

  final AddressesResults results;
  final String message;

  List<AddressModel> get addresses => results.data;

  factory AddressesResponse.fromJson(Map<String, dynamic> json) =>
      AddressesResponse(
        message: convertToString(json['message']),
        results: AddressesResults.fromJson(convertToMap(json['results'])),
      );
}

class AddressesResults {
  const AddressesResults({this.data = const []});

  final List<AddressModel> data;

  factory AddressesResults.fromJson(Map<String, dynamic> json) =>
      AddressesResults(
        data: convertToList(json['data'])
            .map((e) => AddressModel.fromJson(convertToMap(e)))
            .toList(),
      );
}
