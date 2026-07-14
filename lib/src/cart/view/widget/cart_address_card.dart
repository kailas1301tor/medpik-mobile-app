// lib/src/cart/view/widget/cart_address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/src/cart/view/widget/cart_address_picker_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class CartAddressCard extends ConsumerWidget {
  const CartAddressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final address = ref.watch(
      cartNotifierProvider.select((s) => s.selectedAddress),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address != null) ...[
                      Text(
                        address.label,
                        style: FontPalette.base600(14, color: colors.primaryText),
                      ),
                      4.verticalSpace,
                    ],
                    Text(
                      address?.fullAddress ?? Strings.noAddressSaved,
                      style: FontPalette.base400(
                        13,
                        color: colors.secondaryText,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => CartAddressPickerSheet.show(context, ref),
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
