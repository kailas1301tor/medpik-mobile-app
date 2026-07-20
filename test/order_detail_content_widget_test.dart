// test/order_detail_content_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/app_theme.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_address_card.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_customer_card.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_prescriptions_section.dart';

void main() {
  Future<void> pumpScoped(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }

  testWidgets('order detail sections show address, customer, and prescriptions', (
    tester,
  ) async {
    await pumpScoped(
      tester,
      const Column(
        children: [
          OrderDetailAddressCard(
            address: AddressModel(
              id: 1,
              label: 'Home',
              line1: '12 Palm Street',
              line2: '',
              city: 'Mumbai',
              state: 'Maharashtra',
              pincode: '400076',
              phoneNumber: '9999999999',
            ),
          ),
          OrderDetailCustomerCard(
            name: 'Anita Sharma',
            phone: '+919876543210',
          ),
          OrderDetailPrescriptionsSection(
            imageUrls: ['https://cdn.example.com/rx.png'],
          ),
        ],
      ),
    );

    expect(find.text(Strings.deliveryAddress), findsOneWidget);
    expect(find.textContaining('12 Palm Street'), findsOneWidget);
    expect(find.text(Strings.orderCustomerDetails), findsOneWidget);
    expect(find.text('Anita Sharma'), findsOneWidget);
    expect(find.text('+919876543210'), findsOneWidget);
    expect(find.text(Strings.attachedPrescriptionsTitle), findsOneWidget);
  });

  testWidgets('customer card shows ----- for missing name and phone', (
    tester,
  ) async {
    await pumpScoped(
      tester,
      const OrderDetailCustomerCard(name: '', phone: ''),
    );

    expect(find.text(Strings.orderCustomerDetails), findsOneWidget);
    expect(find.text(Strings.unavailableValue), findsNWidgets(2));
  });
}
