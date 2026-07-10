// lib/src/prescription/state/prescription_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tsuite/data/models/prescription_model.dart';
import 'package:tsuite/data/models/prescription_selected_product_model.dart';
import 'package:tsuite/res/enums/enums.dart';

part 'prescription_state.freezed.dart';

@freezed
sealed class PrescriptionState with _$PrescriptionState {
  const factory PrescriptionState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    PrescriptionDraftModel? draft,
    @Default(<String>[]) List<String> pickedPaths,
    @Default(<PrescriptionSelectedProductModel>[])
    List<PrescriptionSelectedProductModel> selectedProducts,
    String? errorMessage,
  }) = _PrescriptionState;
}
