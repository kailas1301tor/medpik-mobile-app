// lib/src/checkout/view/widget/checkout_address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class CheckoutAddressCard extends StatelessWidget {
  const CheckoutAddressCard({
    super.key,
    required this.address,
    required this.onChangeAddress,
  });

  final AddressModel? address;
  final VoidCallback onChangeAddress;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selected = address;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Strings.deliveryAddress,
                style: FontPalette.base700(16, color: colors.primaryText),
              ),
            ),
            GestureDetector(
              onTap: onChangeAddress,
              behavior: HitTestBehavior.opaque,
              child: Text(
                Strings.changeAddress,
                style: FontPalette.base600(13, color: colors.primary),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          borderRadius: 12.r,
          color: colors.surface,
          child: Row(
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.homeLocation,
                width: 20.r,
                height: 20.r,
              ),
              10.horizontalSpace,
              Expanded(
                child: selected == null
                    ? Text(
                        Strings.noAddressSaved,
                        style: FontPalette.base400(
                          13,
                          color: colors.secondaryText,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected.label,
                            style: FontPalette.base700(
                              14,
                              color: colors.primaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          2.verticalSpace,
                          Text(
                            selected.fullAddress,
                            style: FontPalette.base400(
                              12,
                              color: colors.secondaryText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
