// lib/src/home/state/home_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/src/home/model/home_model.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    HomeFeedModel? data,
    String? errorMessage,
    @Default(0) double compactHeaderProgress,
  }) = _HomeState;
}
