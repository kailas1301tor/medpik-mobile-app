// lib/src/address/view/widget/address_book_tile.dart
//
// ? Single address row in [AddressBookScreen].
//
// ? Visual modes (parent callbacks + [isSelectable]):
// ? - Manage — edit + delete action buttons on the right
// ? - Select — radio indicator; tap handled by parent [onTap]
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/address_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/address/view/widget/address_tile_action_button.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_delete_icon.dart';

class AddressBookTile extends StatelessWidget {
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

  String get _streetLine {
    final parts = <String>[
      address.line1.trim(),
      if (address.line2.trim().isNotEmpty) address.line2.trim(),
    ].where((part) => part.isNotEmpty);
    if (parts.isEmpty) return '';
    return '${parts.join(', ')},';
  }

  String get _cityLine {
    final city = address.city.trim();
    final state = address.state.trim();
    final pin = address.pincode.trim();
    final left = [
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
    ].join(', ');
    if (left.isEmpty && pin.isEmpty) return '';
    if (pin.isEmpty) return left;
    if (left.isEmpty) return pin;
    return '$left – $pin';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final showManagementActions =
        !isSelectable && onEdit != null && onDelete != null;
    final phone = address.phoneNumber.trim();

    return CommonContainer(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      borderRadius: 20.r,
      color: colors.surface,
      side: isSelected
          ? BorderSide(color: colors.primary, width: 1.5.w)
          : BorderSide(
              color: colors.cardBorder.withValues(alpha: 0.45),
              width: 1.w,
            ),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconChip(
                icon: Icons.home_outlined,
                background: colors.statusInfoBg,
                foreground: colors.statusInfoText,
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (address.isDefault) ...[
                          8.horizontalSpace,
                          const _DefaultBadge(),
                        ],
                      ],
                    ),
                    if (_streetLine.isNotEmpty || _cityLine.isNotEmpty) ...[
                      8.verticalSpace,
                      if (_streetLine.isNotEmpty)
                        Text(
                          _streetLine,
                          style: FontPalette.base400(
                            13,
                            color: colors.secondaryText,
                          ),
                        ),
                      if (_cityLine.isNotEmpty) ...[
                        2.verticalSpace,
                        Text(
                          _cityLine,
                          style: FontPalette.base400(
                            13,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              if (showManagementActions) ...[
                4.horizontalSpace,
                AddressTileActionButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 24.r,
                    color: colors.secondaryText,
                  ),
                  onTap: onEdit,
                ),
                AddressTileActionButton(
                  icon: CommonDeleteIcon(
                    size: 24.r,
                    color: colors.statusErrorText,
                  ),
                  onTap: onDelete,
                ),
              ] else if (isSelectable) ...[
                8.horizontalSpace,
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 22.r,
                  color: isSelected ? colors.primary : colors.secondaryText,
                ),
              ],
            ],
          ),
          if (phone.isNotEmpty) ...[
            14.verticalSpace,
            Row(
              children: [
                _IconChip(
                  icon: Icons.phone_outlined,
                  background: colors.background.withValues(alpha: 0.85),
                  foreground: colors.secondaryText,
                  size: 32.r,
                  iconSize: 16.r,
                ),
                10.horizontalSpace,
                Flexible(
                  child: Text(
                    phone,
                    style: FontPalette.base700(
                      14,
                      color: colors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  const _DefaultBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.statusSuccessBg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 12.r,
              color: colors.statusSuccessText,
            ),
            4.horizontalSpace,
            Text(
              Strings.defaultAddress,
              style: FontPalette.base600(11, color: colors.statusSuccessText),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({
    required this.icon,
    required this.background,
    required this.foreground,
    this.size,
    this.iconSize,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final chipSize = size ?? 40.r;

    return Container(
      width: chipSize,
      height: chipSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, size: iconSize ?? 20.r, color: foreground),
    );
  }
}
