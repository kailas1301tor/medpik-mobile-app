// lib/src/address/view/widget/location_picker_map_shimmer.dart
//
// ? Full-bleed map placeholder while initial GPS / route coords resolve.
import 'package:flutter/material.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class LocationPickerMapShimmer extends StatelessWidget {
  const LocationPickerMapShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ColoredBox(
      color: colors.background,
      child: const SizedBox.expand(
        child: CommonShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
        ),
      ),
    );
  }
}
