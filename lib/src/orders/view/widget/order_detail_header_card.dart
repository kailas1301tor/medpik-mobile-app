// lib/src/orders/view/widget/order_detail_header_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/view/widget/order_detail_section_card.dart';
import 'package:medpik/src/orders/view/widget/order_horizontal_stepper.dart';
import 'package:medpik/src/orders/view/widget/order_status_badge.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderDetailHeaderCard extends StatelessWidget {
  const OrderDetailHeaderCard({
    super.key,
    required this.order,
    this.showStepper = true,
    this.badgeLabel,
    this.badgeStatus,
    this.onStepperTap,
  });

  final OrderModel order;
  final bool showStepper;
  final String? badgeLabel;
  final OrderStatus? badgeStatus;
  final VoidCallback? onStepperTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final steps = showStepper
        ? orderDetailHorizontalSteps(order.status)
        : const <OrderHorizontalStep>[];
    final orderId = order.displayOrderId.isNotEmpty
        ? order.displayOrderId
        : Strings.emDash;

    return OrderDetailSectionCard(
      padding: EdgeInsets.all(18.r),
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.orderIdLabel,
                      style: FontPalette.base500(
                        12,
                        color: colors.secondaryText,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      orderId,
                      style: FontPalette.base700(18, color: colors.primaryText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              12.horizontalSpace,
              OrderStatusBadge(
                status: badgeStatus ?? order.status,
                label:
                    badgeLabel ??
                    (order.displayStatus.isNotEmpty
                        ? order.displayStatus
                        : orderDetailStatusLabel(order.status)),
              ),
            ],
          ),
          14.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(
                MedpikSvgAssets.calendar,
                width: 14.r,
                height: 14.r,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  formatOrderDateTime(order.createdAt),
                  style: FontPalette.base500(12, color: colors.secondaryText),
                ),
              ),
            ],
          ),
          if (showStepper && steps.isNotEmpty) ...[
            18.verticalSpace,
            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: onStepperTap,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  children: [
                    OrderHorizontalStepper(
                      steps: steps,
                      activeColor: colors.primary,
                      inactiveColor: colors.secondaryText.withValues(
                        alpha: 0.24,
                      ),
                    ),
                    if (onStepperTap != null) ...[
                      4.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.viewDetailedStatus,
                            style: FontPalette.base600(
                              12,
                              color: colors.primary,
                            ),
                          ),
                          4.horizontalSpace,
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18.r,
                            color: colors.primary,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
