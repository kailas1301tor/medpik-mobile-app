// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_facade_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wishlistFacadeServiceHash() =>
    r'502845c475071f6e5de97fb5918caabfcd2deca8';

/// See also [wishlistFacadeService].
@ProviderFor(wishlistFacadeService)
final wishlistFacadeServiceProvider = Provider<WishlistFacadeService>.internal(
  wishlistFacadeService,
  name: r'wishlistFacadeServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wishlistFacadeServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WishlistFacadeServiceRef = ProviderRef<WishlistFacadeService>;
String _$isProductWishlistedHash() =>
    r'5dcec0c378428e8f0b5419bf98300f585714a4eb';

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

/// See also [isProductWishlisted].
@ProviderFor(isProductWishlisted)
const isProductWishlistedProvider = IsProductWishlistedFamily();

/// See also [isProductWishlisted].
class IsProductWishlistedFamily extends Family<bool> {
  /// See also [isProductWishlisted].
  const IsProductWishlistedFamily();

  /// See also [isProductWishlisted].
  IsProductWishlistedProvider call(int productId) {
    return IsProductWishlistedProvider(productId);
  }

  @override
  IsProductWishlistedProvider getProviderOverride(
    covariant IsProductWishlistedProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isProductWishlistedProvider';
}

/// See also [isProductWishlisted].
class IsProductWishlistedProvider extends Provider<bool> {
  /// See also [isProductWishlisted].
  IsProductWishlistedProvider(int productId)
    : this._internal(
        (ref) => isProductWishlisted(ref as IsProductWishlistedRef, productId),
        from: isProductWishlistedProvider,
        name: r'isProductWishlistedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isProductWishlistedHash,
        dependencies: IsProductWishlistedFamily._dependencies,
        allTransitiveDependencies:
            IsProductWishlistedFamily._allTransitiveDependencies,
        productId: productId,
      );

  IsProductWishlistedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(bool Function(IsProductWishlistedRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: IsProductWishlistedProvider._internal(
        (ref) => create(ref as IsProductWishlistedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  ProviderElement<bool> createElement() {
    return _IsProductWishlistedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsProductWishlistedProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsProductWishlistedRef on ProviderRef<bool> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _IsProductWishlistedProviderElement extends ProviderElement<bool>
    with IsProductWishlistedRef {
  _IsProductWishlistedProviderElement(super.provider);

  @override
  int get productId => (origin as IsProductWishlistedProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
