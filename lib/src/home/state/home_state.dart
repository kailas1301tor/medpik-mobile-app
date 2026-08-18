// lib/src/home/state/home_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/src/home/model/customer_general_data_model.dart';
import 'package:medpik/src/home/model/home_model.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LoaderState.loading) LoaderState loaderState,
    HomeFeedModel? data,
    CustomerGeneralDataModel? generalData,
    @Default(LoaderState.loading) LoaderState generalDataLoaderState,
    String? errorMessage,
    @Default(0) double compactHeaderProgress,
  }) = _HomeState;
}
