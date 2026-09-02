// lib/src/orders/view/widget/order_support_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_nav_bar_button.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class OrderSupportAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const OrderSupportAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      title: title,
      actions: [
        CommonNavBarButton(
          icon: SvgPicture.asset(
            MedpikSvgAssets.phone,
            width: 22.r,
            height: 22.r,
          ),
          onTap: () => Navigator.pushNamed(
            context,
            RouteConstants.routeHelpAndSupportScreen,
          ),
        ),
      ],
    );
  }
}
