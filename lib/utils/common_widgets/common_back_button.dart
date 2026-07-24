import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/utils/common_widgets/common_floating_circle_button.dart';

class CommonBackButton extends StatelessWidget {
  const CommonBackButton({
    super.key,
    this.onTap,
    this.size,
    this.iconSize,
    this.margin,
    this.overlayStyle = false,
  });

  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final EdgeInsetsGeometry? margin;
  final bool overlayStyle;

  @override
  Widget build(BuildContext context) {
    return CommonFloatingCircleButton(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      size: size,
      margin: margin,
      overlayStyle: overlayStyle,
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: iconSize ?? 18.r,
        color: CommonFloatingCircleButton.foregroundColor(
          context,
          overlayStyle: overlayStyle,
        ),
      ),
    );
  }
}
