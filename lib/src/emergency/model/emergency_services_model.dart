// lib/src/emergency/model/emergency_services_model.dart
import 'package:medpik/utils/helpers/safe_converters.dart';

class EmergencyServicesResponse {
  const EmergencyServicesResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final EmergencyServicesResultsModel results;
  final String message;
  final bool status;

  List<EmergencyAmbulanceModel> get ambulances =>
      results.data?.ambulances ?? const [];

  List<EmergencyDoctorModel> get doctors => results.data?.doctors ?? const [];

  factory EmergencyServicesResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return EmergencyServicesResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: EmergencyServicesResultsModel.fromJson(
        convertToMap(json['results']),
      ),
    );
  }
}

class EmergencyServicesResultsModel {
  const EmergencyServicesResultsModel({this.data});

  final EmergencyServicesDataModel? data;

  factory EmergencyServicesResultsModel.fromJson(Map<String, dynamic> json) =>
      EmergencyServicesResultsModel(
        data: json['data'] == null
            ? null
            : EmergencyServicesDataModel.fromJson(convertToMap(json['data'])),
      );
}

class EmergencyServicesDataModel {
  const EmergencyServicesDataModel({
    this.ambulances = const [],
    this.doctors = const [],
  });

  final List<EmergencyAmbulanceModel> ambulances;
  final List<EmergencyDoctorModel> doctors;

  factory EmergencyServicesDataModel.fromJson(Map<String, dynamic> json) =>
      EmergencyServicesDataModel(
        ambulances: convertToList(json['ambulances'])
            .map((e) => EmergencyAmbulanceModel.fromJson(convertToMap(e)))
            .toList(),
        doctors: convertToList(json['doctors'])
            .map((e) => EmergencyDoctorModel.fromJson(convertToMap(e)))
            .toList(),
      );
}

class EmergencyLocationDetailModel {
  const EmergencyLocationDetailModel({
    required this.id,
    this.locationName = '',
    this.district = '',
    this.isActive = true,
  });

  final int id;
  final String locationName;
  final String district;
  final bool isActive;

  String get displayLine {
    if (locationName.isNotEmpty && district.isNotEmpty) {
      return '$locationName · $district';
    }
    return locationName.isNotEmpty ? locationName : district;
  }

  factory EmergencyLocationDetailModel.fromJson(Map<String, dynamic> json) =>
      EmergencyLocationDetailModel(
        id: convertToInt(json['id']),
        locationName: convertToString(json['location_name']),
        district: convertToString(json['district']),
        isActive: convertToBool(json['is_active']),
      );
}

class EmergencyAmbulanceModel {
  const EmergencyAmbulanceModel({
    required this.id,
    this.name = '',
    this.phoneNumber = '',
    this.location = 0,
    this.locationDetail,
  });

  final int id;
  final String name;
  final String phoneNumber;
  final int location;
  final EmergencyLocationDetailModel? locationDetail;

  factory EmergencyAmbulanceModel.fromJson(Map<String, dynamic> json) =>
      EmergencyAmbulanceModel(
        id: convertToInt(json['id']),
        name: convertToString(json['name']),
        phoneNumber: convertToString(json['phone_number']),
        location: convertToInt(json['location']),
        locationDetail: json['location_detail'] == null
            ? null
            : EmergencyLocationDetailModel.fromJson(
                convertToMap(json['location_detail']),
              ),
      );
}

class EmergencyDoctorModel {
  const EmergencyDoctorModel({
    required this.id,
    this.name = '',
    this.phoneNumber = '',
    this.designation = '',
    this.location = 0,
    this.locationDetail,
  });

  final int id;
  final String name;
  final String phoneNumber;
  final String designation;
  final int location;
  final EmergencyLocationDetailModel? locationDetail;

  factory EmergencyDoctorModel.fromJson(Map<String, dynamic> json) =>
      EmergencyDoctorModel(
        id: convertToInt(json['id']),
        name: convertToString(json['name']),
        phoneNumber: convertToString(json['phone_number']),
        designation: convertToString(json['designation']),
        location: convertToInt(json['location']),
        locationDetail: json['location_detail'] == null
            ? null
            : EmergencyLocationDetailModel.fromJson(
                convertToMap(json['location_detail']),
              ),
      );
}
