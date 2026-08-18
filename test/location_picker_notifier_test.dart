// test/location_picker_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/services/location/location_access_status.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/services/location/location_permission_service.dart';
import 'package:medpik/src/address/notifier/location_picker_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocationPickerNotifier', () {
    late ProviderContainer container;
    late FakeGeocodeClient fakeGeocode;
    late FakeLocationPermissionService fakePermission;

    setUp(() {
      fakeGeocode = FakeGeocodeClient();
      fakePermission = FakeLocationPermissionService();
      container = ProviderContainer(
        overrides: [
          geocodeClientProvider.overrideWithValue(fakeGeocode),
          locationPermissionServiceProvider.overrideWithValue(fakePermission),
        ],
      );
    });

    tearDown(() => container.dispose());

    LocationPickerNotifier readNotifier() =>
        container.read(locationPickerNotifierProvider.notifier);

    Position testPosition({
      double latitude = 9.9312,
      double longitude = 76.2673,
    }) =>
        Position(
          latitude: latitude,
          longitude: longitude,
          timestamp: DateTime(2026),
          accuracy: 1,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );

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

    test('applyInitialCoordinates uses GPS before map mount', () async {
      const gpsLat = 9.9312;
      const gpsLng = 76.2673;
      fakePermission.checkAccessStatus = LocationAccessStatus.granted;
      fakePermission.nextPosition = testPosition(
        latitude: gpsLat,
        longitude: gpsLng,
      );
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: gpsLat,
        longitude: gpsLng,
        formattedAddress: 'Kochi, Kerala',
        state: 'Kerala',
      );

      final notifier = readNotifier();
      await notifier.applyInitialCoordinates();

      final state = container.read(locationPickerNotifierProvider);
      expect(state.isInitialCameraReady, isTrue);
      expect(state.latitude, gpsLat);
      expect(state.longitude, gpsLng);
      expect(state.latitude, isNot(LocationConfig.defaultLat));
      expect(state.locationAccessIssue, isNull);
      expect(fakePermission.getCurrentPositionCallCount, 1);
    });

    test('applyInitialCoordinates uses route args without GPS', () async {
      const routeLat = 11.25;
      const routeLng = 75.78;
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: routeLat,
        longitude: routeLng,
        formattedAddress: 'Kozhikode, Kerala',
        state: 'Kerala',
      );

      final notifier = readNotifier();
      await notifier.applyInitialCoordinates(
        latitude: routeLat,
        longitude: routeLng,
      );

      final state = container.read(locationPickerNotifierProvider);
      expect(state.isInitialCameraReady, isTrue);
      expect(state.latitude, routeLat);
      expect(state.longitude, routeLng);
      expect(fakePermission.checkAccessCallCount, 0);
      expect(fakePermission.getCurrentPositionCallCount, 0);
    });

    test(
      'applyInitialCoordinates shows access issue when services disabled',
      () async {
        fakePermission.checkAccessStatus =
            LocationAccessStatus.servicesDisabled;
        fakeGeocode.nextReverse = const ReverseGeocodeResult(
          latitude: LocationConfig.defaultLat,
          longitude: LocationConfig.defaultLng,
          formattedAddress: 'Thrissur, Kerala',
          state: 'Kerala',
        );

        final notifier = readNotifier();
        await notifier.applyInitialCoordinates();

        final state = container.read(locationPickerNotifierProvider);
        expect(state.isInitialCameraReady, isTrue);
        expect(state.latitude, LocationConfig.defaultLat);
        expect(state.longitude, LocationConfig.defaultLng);
        expect(
          state.locationAccessIssue,
          LocationAccessStatus.servicesDisabled,
        );
        expect(state.errorMessage, Strings.locationServicesDisabled);
        expect(fakePermission.getCurrentPositionCallCount, 0);
        expect(fakePermission.resolveAccessCallCount, 0);
      },
    );

    test(
      'applyInitialCoordinates shows access issue when permission denied',
      () async {
        fakePermission.checkAccessStatus =
            LocationAccessStatus.permissionDenied;
        fakeGeocode.nextReverse = const ReverseGeocodeResult(
          latitude: LocationConfig.defaultLat,
          longitude: LocationConfig.defaultLng,
          formattedAddress: 'Thrissur, Kerala',
          state: 'Kerala',
        );

        final notifier = readNotifier();
        await notifier.applyInitialCoordinates();

        final state = container.read(locationPickerNotifierProvider);
        expect(state.isInitialCameraReady, isTrue);
        expect(state.latitude, LocationConfig.defaultLat);
        expect(state.longitude, LocationConfig.defaultLng);
        expect(
          state.locationAccessIssue,
          LocationAccessStatus.permissionDenied,
        );
        expect(state.errorMessage, Strings.locationPermissionRationale);
        expect(fakePermission.getCurrentPositionCallCount, 0);
      },
    );

    test('applyInitialCoordinates falls back when GPS unavailable', () async {
      fakePermission.checkAccessStatus = LocationAccessStatus.granted;
      fakePermission.nextPosition = null;
      fakePermission.nextLastKnown = null;
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: LocationConfig.defaultLat,
        longitude: LocationConfig.defaultLng,
        formattedAddress: 'Thrissur, Kerala',
        state: 'Kerala',
      );

      final notifier = readNotifier();
      await notifier.applyInitialCoordinates();

      final state = container.read(locationPickerNotifierProvider);
      expect(state.isInitialCameraReady, isTrue);
      expect(state.errorMessage, Strings.locationGpsUnavailable);
      expect(state.locationAccessIssue, isNull);
    });

    test('applyInitialCoordinates uses last known position when available',
        () async {
      const lastLat = 9.95;
      const lastLng = 76.28;
      fakePermission.checkAccessStatus = LocationAccessStatus.granted;
      fakePermission.nextLastKnown = testPosition(
        latitude: lastLat,
        longitude: lastLng,
      );
      fakePermission.nextPosition = null;
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: lastLat,
        longitude: lastLng,
        formattedAddress: 'Kochi, Kerala',
        state: 'Kerala',
      );

      final notifier = readNotifier();
      await notifier.applyInitialCoordinates();

      final state = container.read(locationPickerNotifierProvider);
      expect(state.isInitialCameraReady, isTrue);
      expect(state.latitude, lastLat);
      expect(state.longitude, lastLng);
      expect(fakePermission.getCurrentPositionCallCount, 1);
    });

    test('useCurrentLocation sets blocked issue when denied forever', () async {
      fakePermission.resolveAccessStatus =
          LocationAccessStatus.permissionDeniedForever;

      final notifier = readNotifier();
      await notifier.useCurrentLocation();

      final state = container.read(locationPickerNotifierProvider);
      expect(
        state.locationAccessIssue,
        LocationAccessStatus.permissionDeniedForever,
      );
      expect(state.errorMessage, Strings.locationPermissionBlocked);
      expect(fakePermission.resolveAccessCallCount, 1);
    });

    test('refreshLocationAccess centers map after permission granted', () async {
      const gpsLat = 9.9312;
      const gpsLng = 76.2673;
      fakePermission.checkAccessStatus = LocationAccessStatus.granted;
      fakePermission.nextPosition = testPosition(
        latitude: gpsLat,
        longitude: gpsLng,
      );
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: gpsLat,
        longitude: gpsLng,
        formattedAddress: 'Kochi, Kerala',
        state: 'Kerala',
      );

      final notifier = readNotifier();
      await notifier.refreshLocationAccess();

      final state = container.read(locationPickerNotifierProvider);
      expect(state.locationAccessIssue, isNull);
      expect(state.latitude, gpsLat);
      expect(state.longitude, gpsLng);
    });

    test('scheduleInitialCoordinates runs only once', () async {
      fakePermission.checkAccessStatus = LocationAccessStatus.granted;
      fakePermission.nextPosition = testPosition();
      fakeGeocode.nextReverse = const ReverseGeocodeResult(
        latitude: 9.9312,
        longitude: 76.2673,
        formattedAddress: 'Kochi, Kerala',
        state: 'Kerala',
      );

      final notifier = readNotifier();
      notifier.scheduleInitialCoordinates();
      notifier.scheduleInitialCoordinates();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(fakePermission.getCurrentPositionCallCount, 1);
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

class FakeLocationPermissionService extends LocationPermissionService {
  LocationAccessStatus checkAccessStatus = LocationAccessStatus.granted;
  LocationAccessStatus resolveAccessStatus = LocationAccessStatus.granted;
  Position? nextPosition;
  Position? nextLastKnown;
  int getCurrentPositionCallCount = 0;
  int checkAccessCallCount = 0;
  int resolveAccessCallCount = 0;

  @override
  Future<LocationAccessStatus> checkAccess() async {
    checkAccessCallCount++;
    return checkAccessStatus;
  }

  @override
  Future<LocationAccessStatus> resolveAccess({
    bool requestIfDenied = false,
  }) async {
    resolveAccessCallCount++;
    return resolveAccessStatus;
  }

  @override
  Future<bool> ensurePermission() async =>
      resolveAccessStatus == LocationAccessStatus.granted;

  @override
  Future<Position?> getCurrentPosition({
    bool preferFresh = false,
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 12),
    bool requestPermissionIfDenied = true,
  }) async {
    getCurrentPositionCallCount++;
    if (checkAccessStatus != LocationAccessStatus.granted &&
        resolveAccessStatus != LocationAccessStatus.granted) {
      return null;
    }
    if (!preferFresh && nextLastKnown != null) return nextLastKnown;
    return nextPosition;
  }
}
