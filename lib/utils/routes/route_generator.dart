import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/data/models/product_detail_args.dart';
import 'package:medpik/res/enums/enums.dart';

import 'package:medpik/data/models/address_book_args.dart';
import 'package:medpik/data/models/legal_document_args.dart';
import 'package:medpik/data/models/personal_information_args.dart';
import '../../src/address/model/location_picker_args.dart';
import '../../src/address/model/picked_location_model.dart';
import '../../src/address/view/address_book_screen.dart';
import '../../src/address/view/location_picker_screen.dart';
import '../../src/auth/view/login_screen.dart';
import '../../src/auth/view/otp_screen.dart';
import 'package:medpik/data/models/order_confirmation_args.dart';
import '../../src/checkout/view/checkout_screen.dart';
import '../../src/checkout/view/order_confirmation_screen.dart';
import '../../src/main/main_screen.dart';
import '../../src/orders/view/order_bill_pdf_screen.dart';
import '../../src/orders/view/order_detail_screen.dart';
import '../../src/orders/view/order_payment_failure_screen.dart';
import '../../src/orders/view/order_payment_success_screen.dart';
import '../../src/orders/view/order_review_bill_screen.dart';
import '../../src/orders/view/order_review_pay_screen.dart';
import '../../src/orders/view/order_tracking_screen.dart';
import '../../src/orders/model/order_payment_result_args.dart';
import '../../src/prescription/view/prescription_checkout_screen.dart';
import '../../src/prescription/view/prescription_upload_screen.dart';
import '../../src/product_detail/view/product_detail_screen.dart';
import 'package:medpik/data/models/product_catalog_args.dart';
import '../../src/search/view/search_results_screen.dart';
import '../../src/splash/view/splash_screen.dart';
import '../../src/wishlist/view/wishlist_screen.dart';
import '../../src/notifications/view/notifications_screen.dart';
import '../../src/emergency/view/emergency_services_screen.dart';
import '../../src/profile/view/legal_document_screen.dart';
import '../../src/profile/view/personal_information_screen.dart';
import 'route_constants.dart';

/// Route generator for named navigation.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.routeInitial:
      case RouteConstants.routeSplash:
        return _route(builder: (_) => const SplashScreen(), settings: settings);

      case RouteConstants.routeLoginScreen:
        return _route(builder: (_) => const LoginScreen(), settings: settings);

      case RouteConstants.routeOtpScreen:
        return _route(builder: (_) => const OtpScreen(), settings: settings);

      case RouteConstants.mainScreen:
        return _route(builder: (_) => const MainScreen(), settings: settings);

      case RouteConstants.routeSearchScreen:
      case RouteConstants.routeSearchResultsScreen:
        final args = settings.name == RouteConstants.routeSearchScreen
            ? ProductCatalogArgs.searchEntry
            : ProductCatalogArgs.from(settings.arguments);
        return _route(
          builder: (_) => SearchResultsScreen(args: args),
          settings: settings,
        );

      case RouteConstants.routeProductDetailScreen:
        final args = ProductDetailArgs.from(settings.arguments);
        return _route(
          builder: (_) => ProductDetailScreen(
            productId: args.productId,
            isFromUploadPrescription: args.isFromUploadPrescription,
          ),
          settings: settings,
        );

      case RouteConstants.routePrescriptionUploadScreen:
        return _route(
          builder: (_) => const PrescriptionUploadScreen(),
          settings: settings,
        );

      case RouteConstants.routePrescriptionCheckoutScreen:
        return _route(
          builder: (_) => const PrescriptionCheckoutScreen(),
          settings: settings,
        );

      case RouteConstants.routeCheckoutScreen:
        return _route(
          builder: (_) => const CheckoutScreen(),
          settings: settings,
        );

      case RouteConstants.routeConfirmationScreen:
        final args = settings.arguments is OrderConfirmationArgs
            ? settings.arguments as OrderConfirmationArgs
            : OrderConfirmationArgs(
                orderId: settings.arguments as String? ?? '',
                source: OrderSubmissionSource.medicineCart,
              );
        return _route(
          builder: (_) => OrderConfirmationScreen(args: args),
          settings: settings,
        );

      case RouteConstants.routeOrderDetailScreen:
        final orderId = settings.arguments as String? ?? '';
        return _route(
          builder: (_) => OrderDetailScreen(orderId: orderId),
          settings: settings,
        );

      case RouteConstants.routeOrderReviewBillScreen:
        final reviewBillOrderId = settings.arguments as String? ?? '';
        return _route(
          builder: (_) => OrderReviewBillScreen(orderId: reviewBillOrderId),
          settings: settings,
        );

      case RouteConstants.routeOrderReviewPayScreen:
        final reviewPayOrderId = settings.arguments as String? ?? '';
        return _route(
          builder: (_) => OrderReviewPayScreen(orderId: reviewPayOrderId),
          settings: settings,
        );

      case RouteConstants.routeOrderPaymentSuccessScreen:
        final successArgs = settings.arguments is OrderPaymentResultArgs
            ? settings.arguments as OrderPaymentResultArgs
            : OrderPaymentResultArgs(
                orderId: settings.arguments as String? ?? '',
              );
        return _route(
          builder: (_) => OrderPaymentSuccessScreen(args: successArgs),
          settings: settings,
        );

      case RouteConstants.routeOrderPaymentFailureScreen:
        final failureArgs = settings.arguments is OrderPaymentResultArgs
            ? settings.arguments as OrderPaymentResultArgs
            : OrderPaymentResultArgs(
                orderId: settings.arguments as String? ?? '',
              );
        return _route(
          builder: (_) => OrderPaymentFailureScreen(args: failureArgs),
          settings: settings,
        );

      case RouteConstants.routeOrderBillPdfScreen:
        final pdfUrl = settings.arguments as String? ?? '';
        return _route(
          builder: (_) => OrderBillPdfScreen(pdfUrl: pdfUrl),
          settings: settings,
        );

      case RouteConstants.routeTrackingScreen:
        final orderId = settings.arguments as String? ?? '';
        return _route(
          builder: (_) => OrderTrackingScreen(orderId: orderId),
          settings: settings,
        );

      case RouteConstants.routeAddressBookScreen:
        final args = settings.arguments is AddressBookArgs
            ? settings.arguments as AddressBookArgs
            : const AddressBookArgs();
        return _route<AddressModel>(
          builder: (_) => AddressBookScreen(args: args),
          settings: settings,
        );

      case RouteConstants.routeLocationPickerScreen:
        final args = settings.arguments is LocationPickerArgs
            ? settings.arguments as LocationPickerArgs
            : null;
        return _route<PickedLocationModel>(
          builder: (_) => LocationPickerScreen(
            initialLatitude: args?.initialLatitude,
            initialLongitude: args?.initialLongitude,
          ),
          settings: settings,
        );

      case RouteConstants.routeWishlistScreen:
        return _route(
          builder: (_) => const WishlistScreen(),
          settings: settings,
        );

      case RouteConstants.routeNotificationsScreen:
        return _route(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );

      case RouteConstants.routeEmergencyServicesScreen:
        return _route(
          builder: (_) => const EmergencyServicesScreen(),
          settings: settings,
        );

      case RouteConstants.routePersonalInformationScreen:
        final personalInfoArgs = PersonalInformationArgs.from(
          settings.arguments,
        );
        return _route(
          builder: (_) => PersonalInformationScreen(
            isOnboarding: personalInfoArgs.isOnboarding,
          ),
          settings: settings,
        );

      case RouteConstants.routeLegalDocumentScreen:
        final legalDocumentArgs = LegalDocumentArgs.from(settings.arguments);
        return _route(
          builder: (_) => LegalDocumentScreen(
            title: legalDocumentArgs.title,
            url: legalDocumentArgs.url,
          ),
          settings: settings,
        );

      default:
        return _route(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }

  static Route<T> _route<T>({
    required WidgetBuilder builder,
    required RouteSettings settings,
  }) {
    return CupertinoPageRoute<T>(builder: builder, settings: settings);
  }
}
