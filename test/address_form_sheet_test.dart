import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/app_theme.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/address/state/address_state.dart';
import 'package:tsuite/src/address/view/widget/address_form_sheet.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('AddressFormSheet shows default toggle and disables for first address', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AddressState(
          isDefaultSelected: true,
          addresses: [],
        ),
      ),
    );

    expect(find.text(Strings.setAsDefault), findsOneWidget);
    final switchFinder = find.byType(SwitchListTile);
    expect(switchFinder, findsOneWidget);

    final switchTile = tester.widget<SwitchListTile>(switchFinder);
    expect(switchTile.value, isTrue);
    expect(switchTile.onChanged, isNull);
  });

  testWidgets('AddressFormSheet allows toggling default when addresses exist', (
    tester,
  ) async {
    final notifier = _FormTestAddressNotifier(
      const AddressState(
        isDefaultSelected: false,
        addresses: [
          AddressModel(
            id: 1,
            label: 'Home',
            line1: 'Line 1',
            line2: '',
            city: 'Mumbai',
            state: 'Maharashtra',
            pincode: '400076',
          ),
        ],
      ),
    );

    await tester.pumpWidget(_wrap(notifier.initialState, notifier: notifier));

    final switchTile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(switchTile.value, isFalse);
    expect(switchTile.onChanged, isNotNull);

    switchTile.onChanged?.call(true);
    await tester.pump();

    expect(notifier.state.isDefaultSelected, isTrue);
  });
}

Widget _wrap(AddressState state, {_FormTestAddressNotifier? notifier}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => ProviderScope(
      overrides: [
        addressNotifierProvider.overrideWith(
          () => notifier ?? _FormTestAddressNotifier(state),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: AddressFormSheet(),
          ),
        ),
      ),
    ),
  );
}

class _FormTestAddressNotifier extends AddressNotifier {
  _FormTestAddressNotifier(this.initialState);

  final AddressState initialState;

  @override
  AddressState build() {
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

    return initialState;
  }
}
