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
import 'package:medpik/src/address/view/widget/location_picker_map_shimmer.dart';
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

    notifier.scheduleInitialCoordinates(
      latitude: initialLatitude,
      longitude: initialLongitude,
    );

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

    return CommonScaffold(
      backgroundColor: colors.background,
      safeAreaTop: false,
      safeAreaBottom: false,
      body: Stack(
        children: [
          const Positioned.fill(child: _LocationPickerMap()),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonBackButton(
                  margin: EdgeInsets.zero,
                  overlayStyle: true,
                ),
                10.horizontalSpace,
                Expanded(
                  child: LocationSearchBar(
                    controller: notifier.searchController,
                    isSearching: isSearching,
                    searchErrorMessage: searchErrorMessage,
                    onSubmit: notifier.submitAddressSearch,
                    onClear: notifier.clearSearch,
                  ),
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
  const _LocationPickerMap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(
      locationPickerNotifierProvider.select(
        (s) => Tuple3(
          s.isInitialCameraReady,
          s.latitude,
          s.longitude,
        ),
      ),
    );
    final isReady = mapState.item1;
    final lat = mapState.item2;
    final lng = mapState.item3;
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
        onMapCreated: notifier.onMapCreated,
        onCameraMove: notifier.onCameraMove,
        onCameraIdle: notifier.onCameraIdle,
      ),
    );
  }
}
