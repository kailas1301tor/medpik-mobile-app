// lib/src/address/view/widget/address_book_tile.dart
//
// ? Single address row in [AddressBookScreen].
//
// ? Three visual modes (parent callbacks + [isSelectable]):
// ? - Manage — edit + delete action buttons on the right
// ? - Select — radio indicator; tap handled by parent [onTap]
// ? - Deleting — inline loader on delete button; tile ignores pointer
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/address/notifier/address_notifier.dart';
import 'package:medpik/src/address/view/widget/address_tile_action_button.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_delete_icon.dart';
import 'package:medpik/utils/common_widgets/common_inline_loader.dart';

class AddressBookTile extends ConsumerWidget {
  const AddressBookTile({
    super.key,
    required this.address,
    this.isSelectable = false,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final AddressModel address;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final deletingAddressId = ref.watch(
      addressNotifierProvider.select((s) => s.deletingAddressId),
    );
    final isDeleting = deletingAddressId == address.id;
    final showManagementActions =
        !isSelectable && onEdit != null && onDelete != null;

    return IgnorePointer(
      ignoring: isDeleting,
      child: CommonContainer(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        borderRadius: 16.r,
        color: colors.surface,
        side: isSelected ? BorderSide(color: colors.primary, width: 1.5.w) : null,
        onTap: onTap,
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
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          address.label,
                          style: FontPalette.base700(
                            16,
                            color: colors.primaryText,
                          ),
                        ),
                      ),
                      if (address.isDefault) ...[
                        8.horizontalSpace,
                        CommonContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          borderRadius: 8.r,
                          color: colors.primary.withValues(alpha: 0.12),
                          child: Text(
                            Strings.defaultAddress,
                            style: FontPalette.base600(
                              11,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    address.fullAddress,
                    style: FontPalette.base400(
                      14,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (showManagementActions) ...[
              8.horizontalSpace,
              AddressTileActionButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20.r,
                  color: colors.secondaryText,
                ),
                onTap: onEdit,
              ),
              4.horizontalSpace,
              AddressTileActionButton(
                icon: isDeleting
                    ? CommonInlineLoader(size: 20.r, color: colors.errorText)
                    : CommonDeleteIcon(size: 20.r),
                onTap: isDeleting ? null : onDelete,
              ),
            ] else if (isSelectable) ...[
              8.horizontalSpace,
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 22.r,
                color: isSelected ? colors.primary : colors.secondaryText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
