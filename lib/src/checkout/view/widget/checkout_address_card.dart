// lib/src/checkout/view/widget/checkout_address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/checkout/view/widget/checkout_section_card.dart';

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

    return CheckoutSectionCard(
      title: Strings.deliveryAddress,
      titleIcon: Icons.location_on_rounded,
      trailing: GestureDetector(
        onTap: onChangeAddress,
        behavior: HitTestBehavior.opaque,
        child: Text(
          Strings.changeAddress,
          style: FontPalette.base600(13, color: colors.primary),
        ),
      ),
      child: selected == null
          ? Text(
              Strings.noAddressSaved,
              style: FontPalette.base400(14, color: colors.secondaryText),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected.label,
                  style: FontPalette.base700(15, color: colors.primaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                Text(
                  selected.fullAddress,
                  style: FontPalette.base400(14, color: colors.secondaryText),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
    );
  }
}
