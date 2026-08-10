// lib/src/profile/state/customer_general_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/home/model/customer_general_data_model.dart';

part 'customer_general_state.freezed.dart';

@freezed
sealed class CustomerGeneralState with _$CustomerGeneralState {
  const factory CustomerGeneralState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    CustomerGeneralDataModel? data,
  }) = _CustomerGeneralState;
}
