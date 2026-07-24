// lib/src/address/view/widget/address_tile_action_button.dart
//
// ? Circular tap target for edit/delete icons on [AddressBookTile].
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/styles/color_palette.dart';

class AddressTileActionButton extends StatelessWidget {
  const AddressTileActionButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: icon,
        ),
      ),
    );
  }
}
