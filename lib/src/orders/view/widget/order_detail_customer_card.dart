// lib/src/orders/view/widget/order_detail_customer_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class OrderDetailCustomerCard extends StatelessWidget {
  const OrderDetailCustomerCard({
    super.key,
    required this.name,
    required this.phone,
  });

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayName = name.trim().isEmpty ? Strings.unavailableValue : name.trim();
    final displayPhone =
        phone.trim().isEmpty ? Strings.unavailableValue : phone.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.orderCustomerDetails,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        10.verticalSpace,
        CommonContainer(
          padding: EdgeInsets.all(14.r),
          borderRadius: 14.r,
          color: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: FontPalette.base700(14, color: colors.primaryText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.verticalSpace,
              Text(
                displayPhone,
                style: FontPalette.base400(13, color: colors.secondaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
