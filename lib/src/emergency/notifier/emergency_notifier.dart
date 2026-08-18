// lib/src/emergency/notifier/emergency_notifier.dart
import 'package:either_dart/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/emergency/repo/emergency_repository.dart';
import 'package:medpik/src/emergency/state/emergency_state.dart';
import 'package:medpik/utils/helpers/api_error_handler.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';

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
            state = state.copyWith(
              loaderState: loaderStateForSessionAwareError(left.key),
            );
            if (!shouldReportFetchError(left)) return;
            showCustomErrorToast(
              message: left.message ?? Strings.somethingWentWrong,
            );
          },
          (right) {
            if (requestId != _requestId) return;

            final ambulances = right.ambulances;
            final doctors = right.doctors;
            final isEmpty = ambulances.isEmpty && doctors.isEmpty;

            state = state.copyWith(
              loaderState: isEmpty ? LoaderState.noData : LoaderState.loaded,
              isAmbulancesEmpty: ambulances.isEmpty,
              isDoctorsEmpty: doctors.isEmpty,
              ambulances: ambulances,
              doctors: doctors,
            );
          },
        )
        .catchError((error) {
          if (requestId != _requestId) return;
          state = state.copyWith(loaderState: LoaderState.error);
          showCustomErrorToast(message: Strings.somethingWentWrong);
        });
  }
}
