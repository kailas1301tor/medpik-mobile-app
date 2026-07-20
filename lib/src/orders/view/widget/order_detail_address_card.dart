// lib/src/orders/view/widget/order_detail_address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class OrderDetailAddressCard extends StatelessWidget {
  const OrderDetailAddressCard({super.key, required this.address});

  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final label = address.label.trim().isEmpty
        ? Strings.unavailableValue
        : address.label.trim();
    final fullAddress = address.fullAddress.trim().isEmpty
        ? Strings.unavailableValue
        : address.fullAddress.trim();
    final phone = address.phoneNumber.trim().isEmpty
        ? Strings.unavailableValue
        : address.phoneNumber.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.deliveryAddress,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.all(14.r),
          borderRadius: 14.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      label,
                      style: FontPalette.base700(
                        14,
                        color: colors.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Text(
                      fullAddress,
                      style: FontPalette.base400(
                        13,
                        color: colors.secondaryText,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      phone,
                      style: FontPalette.base500(
                        13,
                        color: colors.primaryText,
                      ),
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
