// lib/src/cart/view/widget/cart_address_picker_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/data/models/address_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/address/notifier/address_notifier.dart';
import 'package:tsuite/src/cart/notifier/cart_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_bottom_sheet.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class CartAddressPickerSheet {
  static Future<void> show(BuildContext context, WidgetRef ref) {
    return CommonBottomSheet.show(
      context: context,
      title: Strings.selectDeliveryAddress,
      isScrollControlled: true,
      child: const _CartAddressPickerContent(),
    );
  }
}

class _CartAddressPickerContent extends ConsumerWidget {
  const _CartAddressPickerContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final addresses = ref.watch(
      addressNotifierProvider.select((s) => s.addresses),
    );
    final selectedAddress = ref.watch(
      cartNotifierProvider.select((s) => s.selectedAddress),
    );
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    if (addresses.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Strings.noAddressSaved,
            style: FontPalette.base400(14, color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouteConstants.routeAddressBookScreen);
            },
            child: Text(
              Strings.addAddress,
              style: FontPalette.base600(14, color: colors.primary),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final address in addresses) ...[
          _AddressOptionTile(
            address: address,
            isSelected: selectedAddress?.id == address.id,
            onTap: () {
              cartNotifier.selectAddress(address);
              Navigator.pop(context);
            },
          ),
          if (address != addresses.last) 10.verticalSpace,
        ],
        16.verticalSpace,
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteConstants.routeAddressBookScreen);
          },
          child: Text(
            Strings.addAddress,
            style: FontPalette.base600(14, color: colors.primary),
          ),
        ),
      ],
    );
  }
}

class _AddressOptionTile extends StatelessWidget {
  const _AddressOptionTile({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      padding: EdgeInsets.all(14.r),
      borderRadius: 14.r,
      color: isSelected
          ? colors.primary.withValues(alpha: 0.06)
          : colors.background,
      border: Border.all(
        color: isSelected ? colors.primary : colors.inputBorder,
      ),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            MedpikSvgAssets.location,
            width: 20.r,
            height: 20.r,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: FontPalette.base600(14, color: colors.primaryText),
                    ),
                    if (address.isDefault) ...[
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.statusInfoBg,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          Strings.defaultAddress,
                          style: FontPalette.base500(
                            10,
                            color: colors.statusInfoText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                4.verticalSpace,
                Text(
                  address.fullAddress,
                  style: FontPalette.base400(12, color: colors.secondaryText),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isSelected) ...[
            8.horizontalSpace,
            Icon(Icons.check_circle_rounded, size: 20.r, color: colors.primary),
          ],
        ],
      ),
    );
  }
}
