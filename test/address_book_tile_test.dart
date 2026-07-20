import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/app_theme.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/address/state/address_state.dart';
import 'package:tsuite/src/address/view/widget/address_book_tile.dart';

void main() {
  testWidgets('AddressBookTile shows edit and delete in manage mode', (
    tester,
  ) async {
    const address = AddressModel(
      id: 1,
      label: 'Home',
      line1: 'Line 1',
      line2: '',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400076',
      isDefault: true,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => ProviderScope(
          overrides: [
            addressNotifierProvider.overrideWith(
              () => _IdleAddressNotifier(const AddressState()),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: AddressBookTile(
                address: address,
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.text(Strings.defaultAddress), findsOneWidget);
  });

  testWidgets('AddressBookTile hides management actions in select mode', (
    tester,
  ) async {
    const address = AddressModel(
      id: 1,
      label: 'Home',
      line1: 'Line 1',
      line2: '',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400076',
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => ProviderScope(
          overrides: [
            addressNotifierProvider.overrideWith(
              () => _IdleAddressNotifier(const AddressState()),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: AddressBookTile(
                address: address,
                isSelectable: true,
                isSelected: true,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.edit_outlined), findsNothing);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
  });
}

class _IdleAddressNotifier extends AddressNotifier {
  _IdleAddressNotifier(this.initialState);

  final AddressState initialState;

  @override
  AddressState build() {
    _initControllers();
    return initialState;
  }

  void _initControllers() {
    labelController = TextEditingController();
    phoneController = TextEditingController();
    line1Controller = TextEditingController();
    line2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();

    ref.onDispose(() {
      labelController.dispose();
      phoneController.dispose();
      line1Controller.dispose();
      line2Controller.dispose();
      cityController.dispose();
      stateController.dispose();
      pincodeController.dispose();
    });
  }
}
