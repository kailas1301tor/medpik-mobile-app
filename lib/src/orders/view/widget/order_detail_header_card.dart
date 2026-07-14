// lib/src/orders/view/widget/order_detail_header_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/res/constants/medpik_svg_assets.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/orders/view/widget/order_horizontal_stepper.dart';
import 'package:tsuite/src/orders/view/widget/order_status_badge.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderDetailHeaderCard extends StatelessWidget {
  const OrderDetailHeaderCard({
    super.key,
    required this.order,
    this.showStepper = true,
    this.badgeLabel,
    this.badgeStatus,
  });

  final OrderModel order;
  final bool showStepper;
  final String? badgeLabel;
  final OrderStatus? badgeStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final steps = showStepper ? orderDetailHorizontalSteps(order.status) : const <OrderHorizontalStep>[];

    return CommonContainer(
      padding: EdgeInsets.all(16.r),
      borderRadius: 16.r,
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${Strings.orderIdLabel}: ${order.id}',
                  style: FontPalette.base700(16, color: colors.primaryText),
                ),
              ),
              OrderStatusBadge(
                status: badgeStatus ?? order.status,
                label: badgeLabel ?? orderDetailStatusLabel(order.status),
              ),
            ],
          ),
          6.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.calendar,
                width: 14.r,
                height: 14.r,
                fit: BoxFit.contain,
              ),
              6.horizontalSpace,
              Expanded(
                child: Text(
                  formatOrderDateTime(order.createdAt),
                  style: FontPalette.base400(12, color: colors.secondaryText),
                ),
              ),
            ],
          ),
          if (showStepper) ...[
            16.verticalSpace,
            OrderHorizontalStepper(steps: steps),
          ],
        ],
      ),
    );
  }
}
