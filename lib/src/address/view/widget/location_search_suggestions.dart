// lib/src/address/view/widget/location_search_suggestions.dart
//
// ? Post-submit Geocoding pick list under the location search bar.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/services/location/geocode_client.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class LocationSearchSuggestions extends StatelessWidget {
  const LocationSearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  final List<ReverseGeocodeResult> suggestions;
  final ValueChanged<ReverseGeocodeResult> onSelect;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final colors = context.appColors;

    return CommonContainer(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 6.h),
      borderRadius: 16.r,
      color: colors.surface,
      boxShadow: [
        BoxShadow(
          color: colors.primaryText.withValues(alpha: 0.1),
          blurRadius: 16.r,
          offset: Offset(0, 6.h),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
            child: Text(
              Strings.searchLocationResultsTitle,
              style: FontPalette.base600(12, color: colors.secondaryText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 280.h),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              separatorBuilder: (_, __) => Divider(
                height: 1.h,
                thickness: 1.h,
                color: colors.divider,
                indent: 52.w,
                endIndent: 16.w,
              ),
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return _SuggestionTile(
                  result: item,
                  onTap: () => onSelect(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.result,
    required this.onTap,
  });

  final ReverseGeocodeResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final lines = _displayLines(result);

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.homeLocation,
                width: 22.r,
                height: 22.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lines.$1,
                      style: FontPalette.base600(14, color: colors.primaryText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lines.$2.isNotEmpty) ...[
                      4.verticalSpace,
                      Text(
                        lines.$2,
                        style: FontPalette.base400(
                          12,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              8.horizontalSpace,
              Icon(
                Icons.chevron_right_rounded,
                size: 20.r,
                color: colors.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Title = primary place name; subtitle = remaining address detail.
  (String, String) _displayLines(ReverseGeocodeResult result) {
    final formatted = result.formattedAddress.trim();
    if (formatted.isEmpty) return ('', '');

    final city = result.city.trim();
    final state = result.state.trim();
    final pincode = result.pincode.trim();

    if (city.isNotEmpty) {
      final subtitleParts = <String>[
        if (state.isNotEmpty) state,
        if (pincode.isNotEmpty) pincode,
      ];
      final subtitle = subtitleParts.isNotEmpty
          ? subtitleParts.join(', ')
          : _tailAfterTitle(formatted, city);
      return (city, subtitle);
    }

    final comma = formatted.indexOf(',');
    if (comma > 0 && comma < formatted.length - 1) {
      return (
        formatted.substring(0, comma).trim(),
        formatted.substring(comma + 1).trim(),
      );
    }

    return (formatted, '');
  }

  String _tailAfterTitle(String formatted, String title) {
    final lower = formatted.toLowerCase();
    final idx = lower.indexOf(title.toLowerCase());
    if (idx < 0) return '';
    var rest = formatted.substring(idx + title.length).trim();
    if (rest.startsWith(',')) rest = rest.substring(1).trim();
    return rest;
  }
}
