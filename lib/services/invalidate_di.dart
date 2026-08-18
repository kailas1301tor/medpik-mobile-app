// lib/services/invalidate_di.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/src/profile/notifier/customer_general_notifier.dart';
import 'package:medpik/providers/order_status_options_provider.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/services/razorpay_payment_service.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/address/notifier/address_notifier.dart';
import 'package:medpik/src/cart/notifier/cart_notifier.dart';
import 'package:medpik/src/home/notifier/home_notifier.dart';
import 'package:medpik/src/prescription/notifier/prescription_notifier.dart';
import 'package:medpik/src/wishlist/notifier/wishlist_notifier.dart';

/// Disposes all session-scoped `@Riverpod(keepAlive: true)` providers on logout.
///
/// Excluded app infrastructure (must survive logout cleanup):
/// - [networkServicesProvider] — HTTP client and 401 session handler
/// - [sembastServicesProvider] — used while clearing persisted session data
/// - [oneSignalServiceProvider] — native SDK is process-lifetime; logout only
///   clears identity via [OneSignalService.clearIdentity]
class InvalidateDI {
  InvalidateDI._();

  static void invalidate(Ref ref) {
    _invalidateAll(ref.invalidate);
  }

  static void invalidateWidget(WidgetRef ref) {
    _invalidateAll(ref.invalidate);
  }

  static void _invalidateAll(void Function(ProviderOrFamily provider) invalidate) {
    invalidate(orderStatusOptionsProvider);
    invalidate(customerGeneralNotifierProvider);
    invalidate(homeNotifierProvider);
    invalidate(cartNotifierProvider);
    invalidate(wishlistNotifierProvider);
    invalidate(addressNotifierProvider);
    invalidate(prescriptionNotifierProvider);

    invalidate(cartRepositoryProvider);
    invalidate(prescriptionRepositoryProvider);
    invalidate(deviceRepositoryProvider);

    invalidate(razorpayPaymentServiceProvider);
    invalidate(geocodeClientProvider);
  }
}
