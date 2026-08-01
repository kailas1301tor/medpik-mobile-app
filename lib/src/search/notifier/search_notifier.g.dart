// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchCatalogInitHash() => r'52978303766942bd9e8a8ad3b8be19c14b2df972';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchCatalogInit].
@ProviderFor(searchCatalogInit)
const searchCatalogInitProvider = SearchCatalogInitFamily();

/// See also [searchCatalogInit].
class SearchCatalogInitFamily extends Family<void> {
  /// See also [searchCatalogInit].
  const SearchCatalogInitFamily();

  /// See also [searchCatalogInit].
  SearchCatalogInitProvider call(ProductCatalogArgs args) {
    return SearchCatalogInitProvider(args);
  }

  @override
  SearchCatalogInitProvider getProviderOverride(
    covariant SearchCatalogInitProvider provider,
  ) {
    return call(provider.args);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchCatalogInitProvider';
}

/// See also [searchCatalogInit].
class SearchCatalogInitProvider extends AutoDisposeProvider<void> {
  /// See also [searchCatalogInit].
  SearchCatalogInitProvider(ProductCatalogArgs args)
    : this._internal(
        (ref) => searchCatalogInit(ref as SearchCatalogInitRef, args),
        from: searchCatalogInitProvider,
        name: r'searchCatalogInitProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchCatalogInitHash,
        dependencies: SearchCatalogInitFamily._dependencies,
        allTransitiveDependencies:
            SearchCatalogInitFamily._allTransitiveDependencies,
        args: args,
      );

  SearchCatalogInitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final ProductCatalogArgs args;

  @override
  Override overrideWith(void Function(SearchCatalogInitRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: SearchCatalogInitProvider._internal(
        (ref) => create(ref as SearchCatalogInitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        args: args,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _SearchCatalogInitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchCatalogInitProvider && other.args == args;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, args.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchCatalogInitRef on AutoDisposeProviderRef<void> {
  /// The parameter `args` of this provider.
  ProductCatalogArgs get args;
}

class _SearchCatalogInitProviderElement extends AutoDisposeProviderElement<void>
    with SearchCatalogInitRef {
  _SearchCatalogInitProviderElement(super.provider);

  @override
  ProductCatalogArgs get args => (origin as SearchCatalogInitProvider).args;
}

String _$searchNotifierHash() => r'254dd6674d05c29e17d589b9db4e7f80f1576483';

/// See also [SearchNotifier].
@ProviderFor(SearchNotifier)
final searchNotifierProvider =
    AutoDisposeNotifierProvider<SearchNotifier, SearchState>.internal(
      SearchNotifier.new,
      name: r'searchNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchNotifier = AutoDisposeNotifier<SearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
