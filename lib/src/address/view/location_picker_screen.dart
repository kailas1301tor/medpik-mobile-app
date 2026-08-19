
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/helpers/location_picker_confirm_helper.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';
import 'package:medpik/src/address/notifier/location_picker_notifier.dart';
import 'package:medpik/src/address/view/widget/location_confirm_card.dart';
import 'package:medpik/src/address/view/widget/location_picker_map.dart';
import 'package:medpik/src/address/view/widget/location_search_bar.dart';
import 'package:medpik/utils/common_widgets/common_back_button.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:tuple/tuple.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  // ? Optional seed coordinates from [LocationPickerArgs] when editing a pick.
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationPickerNotifierProvider.notifier).refreshLocationAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notifier = ref.read(locationPickerNotifierProvider.notifier);

    notifier.scheduleInitialCoordinates(
      latitude: widget.initialLatitude,
      longitude: widget.initialLongitude,
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
        (s) => Tuple5(
          s.isReverseLoading,
          s.isServiceable,
          s.errorMessage,
          s.reverseResult,
          s.locationAccessIssue,
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
          const Positioned.fill(child: LocationPickerMap()),
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
              locationAccessIssue: confirmData.item5,
              canConfirm: canConfirm,
              onUseCurrentLocation: notifier.useCurrentLocation,
              onLocationAccessAction: notifier.onLocationAccessAction,
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
