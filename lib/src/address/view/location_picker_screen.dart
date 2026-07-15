// lib/src/address/view/location_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tsuite/res/constants/app_constants.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/services/location/location_config.dart';
import 'package:tsuite/src/address/model/picked_location_model.dart';
import 'package:tsuite/src/address/notifier/location_picker_notifier.dart';
import 'package:tsuite/src/address/view/widget/location_confirm_card.dart';
import 'package:tsuite/src/address/view/widget/location_search_bar.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tuple/tuple.dart';

class LocationPickerScreen extends ConsumerWidget {
  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(locationPickerNotifierProvider.notifier);

    final searchData = ref.watch(
      locationPickerNotifierProvider.select(
        (s) => Tuple2(s.predictions, s.isSearching),
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
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(initialLat, initialLng),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) {
                notifier.onMapCreated(controller);
                notifier.applyInitialCoordinates(
                  latitude: initialLatitude,
                  longitude: initialLongitude,
                );
              },
              onCameraMove: notifier.onCameraMove,
              onCameraIdle: notifier.onCameraIdle,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 28.h),
              child: Icon(
                Icons.location_on,
                size: 42.r,
                color: colors.primary,
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
                  child: Material(
                    color: colors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18.r,
                        color: colors.primaryText,
                      ),
                    ),
                  ),
                ),
                10.verticalSpace,
                if (AppConstants.useMockData) ...[
                  CommonContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    borderRadius: 12.r,
                    color: colors.surface.withValues(alpha: 0.94),
                    child: Text(
                      Strings.locationMockMapHint,
                      style: FontPalette.base400(
                        11,
                        color: colors.secondaryText,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                ],
                LocationSearchBar(
                  controller: notifier.searchController,
                  predictions: searchData.item1,
                  isSearching: searchData.item2,
                  onChanged: notifier.onSearchChanged,
                  onClear: notifier.clearSearch,
                  onPredictionTap: notifier.selectPrediction,
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
