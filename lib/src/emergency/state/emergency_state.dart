// lib/src/emergency/state/emergency_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/emergency/model/emergency_services_model.dart';

part 'emergency_state.freezed.dart';

@freezed
sealed class EmergencyState with _$EmergencyState {
  const factory EmergencyState({
    @Default(LoaderState.loading) LoaderState loaderState,
    @Default([]) List<EmergencyAmbulanceModel> ambulances,
    @Default([]) List<EmergencyDoctorModel> doctors,
  }) = _EmergencyState;
}
