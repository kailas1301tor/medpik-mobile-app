// lib/src/address/view/location_picker_screen.dart
//
// * Full-screen Google Maps picker with a fixed center pin.
//
// ? Layout (top → bottom):
// ? - [LocationSearchBar] — forward geocode search
// ? - Map ([_LocationPickerMap]) — user pans; pin stays centered
// ? - [LocationConfirmCard] — reverse-geocoded address + confirm CTA
//
// ? Returns [PickedLocationModel] via Navigator.pop when user confirms
// ? a serviceable location.
//
// ! [_LocationPickerMap] is extracted so search/geocode state updates do not
// ! rebuild [GoogleMap] (which would reset the camera).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/services/location/location_config.dart';
import 'package:medpik/utils/helpers/location_picker_confirm_helper.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';
import 'package:medpik/src/address/notifier/location_picker_notifier.dart';
import 'package:medpik/src/address/view/widget/location_confirm_card.dart';
import 'package:medpik/src/address/view/widget/location_search_bar.dart';
import 'package:medpik/utils/common_widgets/common_back_button.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:tuple/tuple.dart';

class LocationPickerScreen extends ConsumerWidget {
  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  // ? Optional seed coordinates from [LocationPickerArgs] when editing a pick.
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(locationPickerNotifierProvider.notifier);

    final searchErrorMessage = ref.watch(
      locationPickerNotifierProvider.select((s) => s.searchErrorMessage),
    );
    final isSearching = ref.watch(
      locationPickerNotifierProvider.select((s) => s.isSearching),
    );
    final canConfirm = ref.watch(
      locationPickerNotifierProvider.select(
        (s) => canConfirmLocationPicker(
          isServiceable: s.isServiceable,
          isReverseLoading: s.isReverseLoading,
          errorMessage: s.errorMessage,
          reverseResult: s.reverseResult,
          pinLat: s.latitude,
          pinLng: s.longitude,
        ),
      ),
    );
    final confirmData = ref.watch(
      locationPickerNotifierProvider.select(
        (s) => Tuple4(
          s.isReverseLoading,
          s.isServiceable,
          s.errorMessage,
          s.reverseResult,
        ),
      ),
    );

    final padding = MediaQuery.paddingOf(context);
    final initialLat = initialLatitude ?? LocationConfig.defaultLat;
    final initialLng = initialLongitude ?? LocationConfig.defaultLng;

    return CommonScaffold(
      backgroundColor: colors.background,
      safeAreaTop: false,
      safeAreaBottom: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: _LocationPickerMap(
              initialLat: initialLat,
              initialLng: initialLng,
              routeLat: initialLatitude,
              routeLng: initialLongitude,
            ),
          ),
          // Fixed pin — map moves underneath; coordinates come from camera center.
          Center(
            child: IgnorePointer(
              child: Padding(
                padding: EdgeInsets.only(bottom: 28.h),
                child: Icon(
                  Icons.location_on,
                  size: 42.r,
                  color: colors.primary,
                ),
              ),
            ),
          ),
          Positioned(
            top: padding.top + 8.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: const CommonBackButton(margin: EdgeInsets.zero),
                ),
                10.verticalSpace,
                LocationSearchBar(
                  controller: notifier.searchController,
                  isSearching: isSearching,
                  searchErrorMessage: searchErrorMessage,
                  onSubmit: notifier.submitAddressSearch,
                  onClear: notifier.clearSearch,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: padding.bottom + 16.h,
            child: LocationConfirmCard(
              result: confirmData.item4,
              isLoading: confirmData.item1,
              isServiceable: confirmData.item2,
              errorMessage: confirmData.item3,
              canConfirm: canConfirm,
              onUseCurrentLocation: notifier.useCurrentLocation,
              onConfirm: () {
                final pick = notifier.confirmSelection();
                if (pick != null && context.mounted) {
                  Navigator.of(context).pop<PickedLocationModel>(pick);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ! Isolated map widget — prevents parent rebuilds from resetting [GoogleMap].
class _LocationPickerMap extends ConsumerWidget {
  const _LocationPickerMap({
    required this.initialLat,
    required this.initialLng,
    required this.routeLat,
    required this.routeLng,
  });

  final double initialLat;
  final double initialLng;
  final double? routeLat;
  final double? routeLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(locationPickerNotifierProvider.notifier);

    return RepaintBoundary(
      child: GoogleMap(
        key: const ValueKey('location_picker_map'),
        initialCameraPosition: CameraPosition(
          target: LatLng(initialLat, initialLng),
          zoom: LocationConfig.mapDefaultZoom,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        buildingsEnabled: false,
        trafficEnabled: false,
        indoorViewEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        onMapCreated: (controller) {
          notifier.onMapCreated(controller);
          notifier.applyInitialCoordinates(
            latitude: routeLat,
            longitude: routeLng,
          );
        },
        onCameraMove: notifier.onCameraMove,
        onCameraIdle: notifier.onCameraIdle,
      ),
    );
  }
}
