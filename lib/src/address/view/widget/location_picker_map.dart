// lib/src/address/view/widget/location_picker_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medpik/services/location/location_access_status.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/src/address/notifier/location_picker_notifier.dart';
import 'package:medpik/src/address/view/widget/location_picker_map_shimmer.dart';
import 'package:tuple/tuple.dart';

class LocationPickerMap extends ConsumerWidget {
  const LocationPickerMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(
      locationPickerNotifierProvider.select(
        (s) => Tuple4(
          s.isInitialCameraReady,
          s.latitude,
          s.longitude,
          s.locationAccessIssue,
        ),
      ),
    );
    final isReady = mapState.item1;
    final lat = mapState.item2;
    final lng = mapState.item3;
    final myLocationEnabled =
        mapState.item4 == null ||
        mapState.item4 == LocationAccessStatus.granted;
    final notifier = ref.read(locationPickerNotifierProvider.notifier);

    if (!isReady) {
      return const LocationPickerMapShimmer();
    }

    return RepaintBoundary(
      child: GoogleMap(
        key: const ValueKey('location_picker_map'),
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: LocationConfig.mapDefaultZoom,
        ),
        myLocationEnabled: myLocationEnabled,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        buildingsEnabled: false,
        trafficEnabled: false,
        indoorViewEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        onMapCreated: notifier.onMapCreated,
        onCameraMove: notifier.onCameraMove,
        onCameraIdle: notifier.onCameraIdle,
      ),
    );
  }
}
