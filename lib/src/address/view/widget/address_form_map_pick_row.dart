// lib/src/address/view/widget/address_form_map_pick_row.dart
//
// ? Summary row at top of [AddressFormSheet] showing map-picked location.
//
// ? "Change location on map" re-opens [LocationPickerScreen] with existing
// ? coordinates when available ([LocationPickerArgs]).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/address/model/location_picker_args.dart';
import 'package:medpik/src/address/model/picked_location_model.dart';
import 'package:medpik/src/address/notifier/address_notifier.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_text_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class AddressFormMapPickRow extends ConsumerWidget {
  const AddressFormMapPickRow({super.key, required this.notifier});

  final AddressNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final summary = ref.watch(
      addressNotifierProvider.select((s) => s.pickedLocationSummary),
    );
    final subtitle =
        summary.trim().isNotEmpty ? summary : Strings.selectLocationOnMap;

    return CommonContainer(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      borderRadius: 12.r,
      color: colors.inputBackground,
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 20.r, color: colors.primary),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.deliveryLocation,
                  style: FontPalette.base500(11, color: colors.secondaryText),
                ),
                2.verticalSpace,
                Text(
                  subtitle,
                  style: FontPalette.base600(13, color: colors.primaryText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          CommonTextButton(
            label: Strings.changeLocationOnMap,
            style: FontPalette.base600(12, color: colors.primary),
            onPressed: () => _openLocationPicker(context),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocationPicker(BuildContext context) async {
    final args = notifier.hasPickedCoordinates
        ? LocationPickerArgs(
            initialLatitude: notifier.pickedLatitude,
            initialLongitude: notifier.pickedLongitude,
          )
        : const LocationPickerArgs();

    final pick = await Navigator.pushNamed<PickedLocationModel>(
      context,
      RouteConstants.routeLocationPickerScreen,
      arguments: args,
    );
    if (pick == null || !context.mounted) return;
    notifier.applyPickedLocation(pick);
  }
}
