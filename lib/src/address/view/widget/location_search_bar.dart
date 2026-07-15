// lib/src/address/view/widget/location_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/services/location/places_session_client.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_inline_loader.dart';
import 'package:tsuite/utils/common_widgets/common_search_bar.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    super.key,
    required this.controller,
    required this.predictions,
    required this.isSearching,
    required this.onChanged,
    required this.onClear,
    required this.onPredictionTap,
  });

  final TextEditingController controller;
  final List<PlacePrediction> predictions;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<PlacePrediction> onPredictionTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonSearchBar(
          controller: controller,
          hintText: Strings.searchDeliveryLocation,
          onChanged: onChanged,
          onClear: onClear,
        ),
        if (isSearching || predictions.isNotEmpty) ...[
          8.verticalSpace,
          CommonContainer(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            borderRadius: 14.r,
            color: colors.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSearching)
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Center(
                      child: CommonInlineLoader(color: colors.primary),
                    ),
                  )
                else
                  ...predictions.take(5).map(
                        (prediction) => ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.place_outlined,
                            color: colors.primary,
                            size: 20.r,
                          ),
                          title: Text(prediction.primaryText),
                          subtitle: prediction.secondaryText.isEmpty
                              ? null
                              : Text(prediction.secondaryText),
                          onTap: () => onPredictionTap(prediction),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
