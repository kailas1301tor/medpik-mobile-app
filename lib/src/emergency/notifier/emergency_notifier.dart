// lib/src/emergency/notifier/emergency_notifier.dart
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/emergency/repo/emergency_repository.dart';
import 'package:medpik/src/emergency/state/emergency_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';

part 'emergency_notifier.g.dart';

@Riverpod(keepAlive: false)
class EmergencyNotifier extends _$EmergencyNotifier {
  late EmergencyRepo emergencyRepo;
  int _requestId = 0;

  @override
  EmergencyState build() {
    emergencyRepo = ref.read(emergencyRepositoryProvider);
    Future.microtask(fetchEmergencyServices);
    return const EmergencyState(loaderState: LoaderState.loading);
  }

  Future<void> fetchEmergencyServices() async {
    final requestId = ++_requestId;
    state = state.copyWith(loaderState: LoaderState.loading);

    return await emergencyRepo
        .getEmergencyServices()
        .fold(
          (left) {
            if (requestId != _requestId) return;
            final loaderState = handleResponseError(left.key);
            debugPrint("🔴 EMERGENCY SERVICES ERROR: ${left.message}");
            state = state.copyWith(
              loaderState: loaderState,
            );
          },
          (response) {
            if (requestId != _requestId) return;

            final ambulances = response.ambulances;
            final doctors = response.doctors;
            final isEmpty = ambulances.isEmpty && doctors.isEmpty;
            final isAmbulancesEmpty = ambulances.isEmpty;
            final isDoctorsEmpty = doctors.isEmpty;
            debugPrint(
              "🟢 EMERGENCY SERVICES SUCCESS: "
              "${ambulances.length} ambulances, ${doctors.length} doctors",
            );

            state = state.copyWith(
              loaderState: isEmpty ? LoaderState.noData : LoaderState.loaded,
              isAmbulancesEmpty: isAmbulancesEmpty,
              isDoctorsEmpty: isDoctorsEmpty,
              ambulances: ambulances,
              doctors: doctors,
            );
          },
        )
        .catchError((error) {
          if (requestId != _requestId) return;
          debugPrint("🔴 UNEXPECTED EMERGENCY SERVICES ERROR: $error");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }
}
