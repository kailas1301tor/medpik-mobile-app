// lib/src/splash/state/splash_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'splash_state.freezed.dart';

@freezed
sealed class SplashState with _$SplashState {
  const factory SplashState({
    @Default(LoaderState.loading) LoaderState loaderState,
    @Default(false) bool hasSession,
  }) = _SplashState;
}
