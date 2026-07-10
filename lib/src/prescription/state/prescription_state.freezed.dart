// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrescriptionState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  PrescriptionDraftModel? get draft => throw _privateConstructorUsedError;
  List<String> get pickedPaths => throw _privateConstructorUsedError;
  List<PrescriptionSelectedProductModel> get selectedProducts =>
      throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionStateCopyWith<PrescriptionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionStateCopyWith<$Res> {
  factory $PrescriptionStateCopyWith(
    PrescriptionState value,
    $Res Function(PrescriptionState) then,
  ) = _$PrescriptionStateCopyWithImpl<$Res, PrescriptionState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    PrescriptionDraftModel? draft,
    List<String> pickedPaths,
    List<PrescriptionSelectedProductModel> selectedProducts,
    String? errorMessage,
  });
}

/// @nodoc
class _$PrescriptionStateCopyWithImpl<$Res, $Val extends PrescriptionState>
    implements $PrescriptionStateCopyWith<$Res> {
  _$PrescriptionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? draft = freezed,
    Object? pickedPaths = null,
    Object? selectedProducts = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            draft: freezed == draft
                ? _value.draft
                : draft // ignore: cast_nullable_to_non_nullable
                      as PrescriptionDraftModel?,
            pickedPaths: null == pickedPaths
                ? _value.pickedPaths
                : pickedPaths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            selectedProducts: null == selectedProducts
                ? _value.selectedProducts
                : selectedProducts // ignore: cast_nullable_to_non_nullable
                      as List<PrescriptionSelectedProductModel>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrescriptionStateImplCopyWith<$Res>
    implements $PrescriptionStateCopyWith<$Res> {
  factory _$$PrescriptionStateImplCopyWith(
    _$PrescriptionStateImpl value,
    $Res Function(_$PrescriptionStateImpl) then,
  ) = __$$PrescriptionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    PrescriptionDraftModel? draft,
    List<String> pickedPaths,
    List<PrescriptionSelectedProductModel> selectedProducts,
    String? errorMessage,
  });
}

/// @nodoc
class __$$PrescriptionStateImplCopyWithImpl<$Res>
    extends _$PrescriptionStateCopyWithImpl<$Res, _$PrescriptionStateImpl>
    implements _$$PrescriptionStateImplCopyWith<$Res> {
  __$$PrescriptionStateImplCopyWithImpl(
    _$PrescriptionStateImpl _value,
    $Res Function(_$PrescriptionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrescriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? draft = freezed,
    Object? pickedPaths = null,
    Object? selectedProducts = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$PrescriptionStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        draft: freezed == draft
            ? _value.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as PrescriptionDraftModel?,
        pickedPaths: null == pickedPaths
            ? _value._pickedPaths
            : pickedPaths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        selectedProducts: null == selectedProducts
            ? _value._selectedProducts
            : selectedProducts // ignore: cast_nullable_to_non_nullable
                  as List<PrescriptionSelectedProductModel>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PrescriptionStateImpl implements _PrescriptionState {
  const _$PrescriptionStateImpl({
    this.loaderState = LoaderState.loaded,
    this.draft,
    final List<String> pickedPaths = const <String>[],
    final List<PrescriptionSelectedProductModel> selectedProducts =
        const <PrescriptionSelectedProductModel>[],
    this.errorMessage,
  }) : _pickedPaths = pickedPaths,
       _selectedProducts = selectedProducts;

  @override
  @JsonKey()
  final LoaderState loaderState;
  @override
  final PrescriptionDraftModel? draft;
  final List<String> _pickedPaths;
  @override
  @JsonKey()
  List<String> get pickedPaths {
    if (_pickedPaths is EqualUnmodifiableListView) return _pickedPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pickedPaths);
  }

  final List<PrescriptionSelectedProductModel> _selectedProducts;
  @override
  @JsonKey()
  List<PrescriptionSelectedProductModel> get selectedProducts {
    if (_selectedProducts is EqualUnmodifiableListView)
      return _selectedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedProducts);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PrescriptionState(loaderState: $loaderState, draft: $draft, pickedPaths: $pickedPaths, selectedProducts: $selectedProducts, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            const DeepCollectionEquality().equals(
              other._pickedPaths,
              _pickedPaths,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedProducts,
              _selectedProducts,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    draft,
    const DeepCollectionEquality().hash(_pickedPaths),
    const DeepCollectionEquality().hash(_selectedProducts),
    errorMessage,
  );

  /// Create a copy of PrescriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionStateImplCopyWith<_$PrescriptionStateImpl> get copyWith =>
      __$$PrescriptionStateImplCopyWithImpl<_$PrescriptionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PrescriptionState implements PrescriptionState {
  const factory _PrescriptionState({
    final LoaderState loaderState,
    final PrescriptionDraftModel? draft,
    final List<String> pickedPaths,
    final List<PrescriptionSelectedProductModel> selectedProducts,
    final String? errorMessage,
  }) = _$PrescriptionStateImpl;

  @override
  LoaderState get loaderState;
  @override
  PrescriptionDraftModel? get draft;
  @override
  List<String> get pickedPaths;
  @override
  List<PrescriptionSelectedProductModel> get selectedProducts;
  @override
  String? get errorMessage;

  /// Create a copy of PrescriptionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionStateImplCopyWith<_$PrescriptionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
