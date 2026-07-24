// lib/src/prescription/view/widget/prescription_checkout_address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';

class PrescriptionCheckoutAddressCard extends StatelessWidget {
  const PrescriptionCheckoutAddressCard({
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.deliveryAddress,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        12.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.all(16.r),
          borderRadius: 16.r,
          color: colors.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.location,
                width: 22.r,
                height: 22.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: selected == null
                    ? Text(
                        Strings.noAddressSaved,
                        style: FontPalette.base400(
                          14,
                          color: colors.secondaryText,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected.label,
                            style: FontPalette.base700(
                              16,
                              color: colors.primaryText,
                            ),
                          ),
                          6.verticalSpace,
                          Text(
                            selected.fullAddress,
                            style: FontPalette.base400(
                              14,
                              color: colors.secondaryText,
                            ),
                          ),
                        ],
                      ),
              ),
              GestureDetector(
                onTap: onChangeAddress,
                child: Text(
                  Strings.changeAddress,
                  style: FontPalette.base600(13, color: colors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
