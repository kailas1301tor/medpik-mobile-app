// lib/src/orders/view/widget/order_detail_address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/view/widget/order_detail_section_card.dart';

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

    return OrderDetailSectionCard(
      title: Strings.deliveryAddress,
      titleIcon: Icons.location_on_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FontPalette.base700(15, color: colors.primaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          6.verticalSpace,
          Text(
            fullAddress,
            style: FontPalette.base400(14, color: colors.secondaryText),
          ),
          10.verticalSpace,
          Text(
            phone,
            style: FontPalette.base600(14, color: colors.primaryText),
          ),
        ],
      ),
    );
  }
}
