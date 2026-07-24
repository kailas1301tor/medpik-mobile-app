// test/location_picker_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/src/address/notifier/location_picker_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocationPickerNotifier', () {
    late ProviderContainer container;
    late FakeGeocodeClient fakeGeocode;

    setUp(() {
      fakeGeocode = FakeGeocodeClient();
      container = ProviderContainer(
        overrides: [
          geocodeClientProvider.overrideWithValue(fakeGeocode),
        ],
      );
    });

    tearDown(() => container.dispose());

    LocationPickerNotifier readNotifier() =>
        container.read(locationPickerNotifierProvider.notifier);

    test('submitAddressSearch sets searchErrorMessage on failure', () async {
      fakeGeocode.nextForward = null;
      final notifier = readNotifier();

      notifier.searchController.text = 'Unknown place xyz';
      await notifier.submitAddressSearch();

      final state = container.read(locationPickerNotifierProvider);
      expect(state.searchErrorMessage, Strings.locationLookupFailed);
      expect(state.reverseResult, isNull);
      expect(state.isSearching, isFalse);
    });

    test('submitAddressSearch clears searchErrorMessage on success', () async {
      fakeGeocode.nextForward = const ReverseGeocodeResult(
        latitude: 10.5241,
        longitude: 76.2121,
        formattedAddress: 'Thrissur, Kerala',
        state: 'Kerala',
      );
      final notifier = readNotifier();

      notifier.searchController.text = 'Thrissur';
      await notifier.submitAddressSearch();

      final state = container.read(locationPickerNotifierProvider);
      expect(state.searchErrorMessage, isNull);
      expect(state.reverseResult?.formattedAddress, 'Thrissur, Kerala');
    });

    test('reverseAt clears reverseResult on failure', () async {
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: 10.5241,
        longitude: 76.2121,
        formattedAddress: 'Thrissur, Kerala',
        state: 'Kerala',
      );
      final notifier = readNotifier();
      await notifier.reverseAt(10.5241, 76.2121, force: true);
      expect(
        container.read(locationPickerNotifierProvider).reverseResult,
        isNotNull,
      );

      fakeGeocode.nextReverse = null;
      await notifier.reverseAt(10.53, 76.22, force: true);

      final state = container.read(locationPickerNotifierProvider);
      expect(state.reverseResult, isNull);
      expect(state.errorMessage, Strings.locationLookupFailed);
    });

    test('confirmSelection returns null after reverse geocode failure', () async {
      fakeGeocode.nextReverse = null;
      final notifier = readNotifier();
      await notifier.reverseAt(10.5241, 76.2121, force: true);

      final pick = notifier.confirmSelection();
      expect(pick, isNull);
    });

    test('clearSearch clears searchErrorMessage', () async {
      fakeGeocode.nextForward = null;
      final notifier = readNotifier();
      notifier.searchController.text = 'bad query';
      await notifier.submitAddressSearch();
      expect(
        container.read(locationPickerNotifierProvider).searchErrorMessage,
        isNotNull,
      );

      notifier.clearSearch();

      expect(
        container.read(locationPickerNotifierProvider).searchErrorMessage,
        isNull,
      );
    });
  });
}

class FakeGeocodeClient extends GeocodeClient {
  ReverseGeocodeResult? nextReverse;
  ReverseGeocodeResult? nextForward;

  @override
  Future<ReverseGeocodeResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async =>
      nextReverse;

  @override
  Future<ReverseGeocodeResult?> forwardGeocode({
    required String address,
  }) async =>
      nextForward;
}
