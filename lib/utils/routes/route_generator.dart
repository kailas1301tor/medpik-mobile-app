import 'package:flutter/material.dart';

import '../../src/address/view/address_book_screen.dart';
import '../../src/auth/view/login_screen.dart';
import '../../src/auth/view/otp_screen.dart';
import '../../src/auth/view/register_screen.dart';
import '../../src/checkout/view/checkout_screen.dart';
import '../../src/checkout/view/order_confirmation_screen.dart';
import '../../src/main/main_screen.dart';
import '../../src/orders/view/order_detail_screen.dart';
import '../../src/orders/view/order_review_bill_screen.dart';
import '../../src/orders/view/order_review_pay_screen.dart';
import '../../src/orders/view/order_tracking_screen.dart';
import '../../src/prescription/view/prescription_upload_screen.dart';
import '../../src/product_detail/view/product_detail_screen.dart';
import '../../src/search/view/search_results_screen.dart';
import '../../src/search/view/search_screen.dart';
import '../../src/splash/view/splash_screen.dart';
import '../../src/wishlist/view/wishlist_screen.dart';
import '../../src/notifications/view/notifications_screen.dart';
import 'route_constants.dart';

/// Global navigator key for accessing navigation from anywhere.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Route generator for named navigation.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.routeInitial:
      case RouteConstants.routeSplash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case RouteConstants.routeLoginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case RouteConstants.routeOtpScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(),
          settings: settings,
        );

      case RouteConstants.routeRegisterScreen:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case RouteConstants.mainScreen:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case RouteConstants.routeSearchScreen:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );

      case RouteConstants.routeSearchResultsScreen:
        final query = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => SearchResultsScreen(initialQuery: query),
          settings: settings,
        );

      case RouteConstants.routeProductDetailScreen:
        final productId = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
          settings: settings,
        );

      case RouteConstants.routePrescriptionUploadScreen:
        return MaterialPageRoute(
          builder: (_) => const PrescriptionUploadScreen(),
          settings: settings,
        );

      case RouteConstants.routeCheckoutScreen:
        return MaterialPageRoute(
          builder: (_) => const CheckoutScreen(),
          settings: settings,
        );

      case RouteConstants.routeConfirmationScreen:
        final orderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(orderId: orderId),
          settings: settings,
        );

      case RouteConstants.routeOrderDetailScreen:
        final orderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: orderId),
          settings: settings,
        );

      case RouteConstants.routeOrderReviewBillScreen:
        final reviewBillOrderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderReviewBillScreen(orderId: reviewBillOrderId),
          settings: settings,
        );

      case RouteConstants.routeOrderReviewPayScreen:
        final reviewPayOrderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderReviewPayScreen(orderId: reviewPayOrderId),
          settings: settings,
        );

      case RouteConstants.routeTrackingScreen:
        final orderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: orderId),
          settings: settings,
        );

      case RouteConstants.routeAddressBookScreen:
        return MaterialPageRoute(
          builder: (_) => const AddressBookScreen(),
          settings: settings,
        );

      case RouteConstants.routeWishlistScreen:
        return MaterialPageRoute(
          builder: (_) => const WishlistScreen(),
          settings: settings,
        );

      case RouteConstants.routeNotificationsScreen:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
