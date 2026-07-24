// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderDetailLoaderHash() => r'e05411cc20df62f1a4e3408c92412963248df078';

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

/// See also [orderDetailLoader].
@ProviderFor(orderDetailLoader)
const orderDetailLoaderProvider = OrderDetailLoaderFamily();

/// See also [orderDetailLoader].
class OrderDetailLoaderFamily extends Family<void> {
  /// See also [orderDetailLoader].
  const OrderDetailLoaderFamily();

  /// See also [orderDetailLoader].
  OrderDetailLoaderProvider call(String orderId) {
    return OrderDetailLoaderProvider(orderId);
  }

  @override
  OrderDetailLoaderProvider getProviderOverride(
    covariant OrderDetailLoaderProvider provider,
  ) {
    return call(provider.orderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderDetailLoaderProvider';
}

/// See also [orderDetailLoader].
class OrderDetailLoaderProvider extends AutoDisposeProvider<void> {
  /// See also [orderDetailLoader].
  OrderDetailLoaderProvider(String orderId)
    : this._internal(
        (ref) => orderDetailLoader(ref as OrderDetailLoaderRef, orderId),
        from: orderDetailLoaderProvider,
        name: r'orderDetailLoaderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$orderDetailLoaderHash,
        dependencies: OrderDetailLoaderFamily._dependencies,
        allTransitiveDependencies:
            OrderDetailLoaderFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  OrderDetailLoaderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(void Function(OrderDetailLoaderRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailLoaderProvider._internal(
        (ref) => create(ref as OrderDetailLoaderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _OrderDetailLoaderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailLoaderProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderDetailLoaderRef on AutoDisposeProviderRef<void> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailLoaderProviderElement extends AutoDisposeProviderElement<void>
    with OrderDetailLoaderRef {
  _OrderDetailLoaderProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailLoaderProvider).orderId;
}

String _$ordersNotifierHash() => r'0247ca13fc31bf47b37fee2af0f9560211d3f9b3';

/// See also [OrdersNotifier].
@ProviderFor(OrdersNotifier)
final ordersNotifierProvider =
    AutoDisposeNotifierProvider<OrdersNotifier, OrdersState>.internal(
      OrdersNotifier.new,
      name: r'ordersNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ordersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrdersNotifier = AutoDisposeNotifier<OrdersState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
