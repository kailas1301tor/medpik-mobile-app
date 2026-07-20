// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_facade_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartFacadeServiceHash() => r'8cd61d408a2f749d0b036c99f4bb002bb2529d3b';

/// See also [cartFacadeService].
@ProviderFor(cartFacadeService)
final cartFacadeServiceProvider = Provider<CartFacadeService>.internal(
  cartFacadeService,
  name: r'cartFacadeServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartFacadeServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartFacadeServiceRef = ProviderRef<CartFacadeService>;
String _$cartItemsHash() => r'fc6b08da3e938dd736f12943432e85bca00b1e1c';

/// See also [cartItems].
@ProviderFor(cartItems)
final cartItemsProvider = Provider<List<CartItemModel>>.internal(
  cartItems,
  name: r'cartItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartItemsRef = ProviderRef<List<CartItemModel>>;
String _$cartTotalItemCountHash() =>
    r'8bcfbd99f0e9916e108d0b710043a870334c20e8';

/// See also [cartTotalItemCount].
@ProviderFor(cartTotalItemCount)
final cartTotalItemCountProvider = Provider<int>.internal(
  cartTotalItemCount,
  name: r'cartTotalItemCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartTotalItemCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalItemCountRef = ProviderRef<int>;
String _$cartProductQuantityHash() =>
    r'66d104d6163bb62a0db030aa216eb2d42b7dfea6';

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

/// See also [cartProductQuantity].
@ProviderFor(cartProductQuantity)
const cartProductQuantityProvider = CartProductQuantityFamily();

/// See also [cartProductQuantity].
class CartProductQuantityFamily extends Family<int> {
  /// See also [cartProductQuantity].
  const CartProductQuantityFamily();

  /// See also [cartProductQuantity].
  CartProductQuantityProvider call(int productId) {
    return CartProductQuantityProvider(productId);
  }

  @override
  CartProductQuantityProvider getProviderOverride(
    covariant CartProductQuantityProvider provider,
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
  String? get name => r'cartProductQuantityProvider';
}

/// See also [cartProductQuantity].
class CartProductQuantityProvider extends Provider<int> {
  /// See also [cartProductQuantity].
  CartProductQuantityProvider(int productId)
    : this._internal(
        (ref) => cartProductQuantity(ref as CartProductQuantityRef, productId),
        from: cartProductQuantityProvider,
        name: r'cartProductQuantityProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cartProductQuantityHash,
        dependencies: CartProductQuantityFamily._dependencies,
        allTransitiveDependencies:
            CartProductQuantityFamily._allTransitiveDependencies,
        productId: productId,
      );

  CartProductQuantityProvider._internal(
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
  Override overrideWith(int Function(CartProductQuantityRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: CartProductQuantityProvider._internal(
        (ref) => create(ref as CartProductQuantityRef),
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
  ProviderElement<int> createElement() {
    return _CartProductQuantityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartProductQuantityProvider && other.productId == productId;
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
mixin CartProductQuantityRef on ProviderRef<int> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _CartProductQuantityProviderElement extends ProviderElement<int>
    with CartProductQuantityRef {
  _CartProductQuantityProviderElement(super.provider);

  @override
  int get productId => (origin as CartProductQuantityProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
