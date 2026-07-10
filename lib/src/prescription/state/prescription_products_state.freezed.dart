// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription_products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrescriptionProductsState {
  LoaderState get loaderState => throw _privateConstructorUsedError;
  List<ProductModel> get mostBoughtProducts =>
      throw _privateConstructorUsedError;
  List<ProductModel> get searchResults => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  bool get hasSearched => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionProductsStateCopyWith<PrescriptionProductsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionProductsStateCopyWith<$Res> {
  factory $PrescriptionProductsStateCopyWith(
    PrescriptionProductsState value,
    $Res Function(PrescriptionProductsState) then,
  ) = _$PrescriptionProductsStateCopyWithImpl<$Res, PrescriptionProductsState>;
  @useResult
  $Res call({
    LoaderState loaderState,
    List<ProductModel> mostBoughtProducts,
    List<ProductModel> searchResults,
    String searchQuery,
    bool hasSearched,
    String? errorMessage,
  });
}

/// @nodoc
class _$PrescriptionProductsStateCopyWithImpl<
  $Res,
  $Val extends PrescriptionProductsState
>
    implements $PrescriptionProductsStateCopyWith<$Res> {
  _$PrescriptionProductsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? mostBoughtProducts = null,
    Object? searchResults = null,
    Object? searchQuery = null,
    Object? hasSearched = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            loaderState: null == loaderState
                ? _value.loaderState
                : loaderState // ignore: cast_nullable_to_non_nullable
                      as LoaderState,
            mostBoughtProducts: null == mostBoughtProducts
                ? _value.mostBoughtProducts
                : mostBoughtProducts // ignore: cast_nullable_to_non_nullable
                      as List<ProductModel>,
            searchResults: null == searchResults
                ? _value.searchResults
                : searchResults // ignore: cast_nullable_to_non_nullable
                      as List<ProductModel>,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            hasSearched: null == hasSearched
                ? _value.hasSearched
                : hasSearched // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$PrescriptionProductsStateImplCopyWith<$Res>
    implements $PrescriptionProductsStateCopyWith<$Res> {
  factory _$$PrescriptionProductsStateImplCopyWith(
    _$PrescriptionProductsStateImpl value,
    $Res Function(_$PrescriptionProductsStateImpl) then,
  ) = __$$PrescriptionProductsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LoaderState loaderState,
    List<ProductModel> mostBoughtProducts,
    List<ProductModel> searchResults,
    String searchQuery,
    bool hasSearched,
    String? errorMessage,
  });
}

/// @nodoc
class __$$PrescriptionProductsStateImplCopyWithImpl<$Res>
    extends
        _$PrescriptionProductsStateCopyWithImpl<
          $Res,
          _$PrescriptionProductsStateImpl
        >
    implements _$$PrescriptionProductsStateImplCopyWith<$Res> {
  __$$PrescriptionProductsStateImplCopyWithImpl(
    _$PrescriptionProductsStateImpl _value,
    $Res Function(_$PrescriptionProductsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrescriptionProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loaderState = null,
    Object? mostBoughtProducts = null,
    Object? searchResults = null,
    Object? searchQuery = null,
    Object? hasSearched = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$PrescriptionProductsStateImpl(
        loaderState: null == loaderState
            ? _value.loaderState
            : loaderState // ignore: cast_nullable_to_non_nullable
                  as LoaderState,
        mostBoughtProducts: null == mostBoughtProducts
            ? _value._mostBoughtProducts
            : mostBoughtProducts // ignore: cast_nullable_to_non_nullable
                  as List<ProductModel>,
        searchResults: null == searchResults
            ? _value._searchResults
            : searchResults // ignore: cast_nullable_to_non_nullable
                  as List<ProductModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        hasSearched: null == hasSearched
            ? _value.hasSearched
            : hasSearched // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PrescriptionProductsStateImpl implements _PrescriptionProductsState {
  const _$PrescriptionProductsStateImpl({
    this.loaderState = LoaderState.loading,
    final List<ProductModel> mostBoughtProducts = const <ProductModel>[],
    final List<ProductModel> searchResults = const <ProductModel>[],
    this.searchQuery = '',
    this.hasSearched = false,
    this.errorMessage,
  }) : _mostBoughtProducts = mostBoughtProducts,
       _searchResults = searchResults;

  @override
  @JsonKey()
  final LoaderState loaderState;
  final List<ProductModel> _mostBoughtProducts;
  @override
  @JsonKey()
  List<ProductModel> get mostBoughtProducts {
    if (_mostBoughtProducts is EqualUnmodifiableListView)
      return _mostBoughtProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mostBoughtProducts);
  }

  final List<ProductModel> _searchResults;
  @override
  @JsonKey()
  List<ProductModel> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool hasSearched;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PrescriptionProductsState(loaderState: $loaderState, mostBoughtProducts: $mostBoughtProducts, searchResults: $searchResults, searchQuery: $searchQuery, hasSearched: $hasSearched, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionProductsStateImpl &&
            (identical(other.loaderState, loaderState) ||
                other.loaderState == loaderState) &&
            const DeepCollectionEquality().equals(
              other._mostBoughtProducts,
              _mostBoughtProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._searchResults,
              _searchResults,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.hasSearched, hasSearched) ||
                other.hasSearched == hasSearched) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loaderState,
    const DeepCollectionEquality().hash(_mostBoughtProducts),
    const DeepCollectionEquality().hash(_searchResults),
    searchQuery,
    hasSearched,
    errorMessage,
  );

  /// Create a copy of PrescriptionProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionProductsStateImplCopyWith<_$PrescriptionProductsStateImpl>
  get copyWith =>
      __$$PrescriptionProductsStateImplCopyWithImpl<
        _$PrescriptionProductsStateImpl
      >(this, _$identity);
}

abstract class _PrescriptionProductsState implements PrescriptionProductsState {
  const factory _PrescriptionProductsState({
    final LoaderState loaderState,
    final List<ProductModel> mostBoughtProducts,
    final List<ProductModel> searchResults,
    final String searchQuery,
    final bool hasSearched,
    final String? errorMessage,
  }) = _$PrescriptionProductsStateImpl;

  @override
  LoaderState get loaderState;
  @override
  List<ProductModel> get mostBoughtProducts;
  @override
  List<ProductModel> get searchResults;
  @override
  String get searchQuery;
  @override
  bool get hasSearched;
  @override
  String? get errorMessage;

  /// Create a copy of PrescriptionProductsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionProductsStateImplCopyWith<_$PrescriptionProductsStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
