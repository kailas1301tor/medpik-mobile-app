// lib/src/orders/view/widget/order_detail_shimmer_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/orders/view/widget/order_detail_section_card.dart';
import 'package:medpik/src/orders/view/widget/order_detail_shimmer_rows.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class OrderHeaderShimmer extends StatelessWidget {
  const OrderHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderDetailSectionCard(
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: OrderIdShimmerBlock()),
              12.horizontalSpace,
              CommonShimmerBox(height: 32.h, width: 96.w, borderRadius: 999.r),
            ],
          ),
          14.verticalSpace,
          Row(
            children: [
              CommonShimmerBox(height: 14.r, width: 14.r, borderRadius: 4.r),
              8.horizontalSpace,
              CommonShimmerBox(height: 12.h, width: 184.w),
            ],
          ),
          18.verticalSpace,
          const OrderStepperShimmer(),
        ],
      ),
    );
  }
}

class OrderAddressShimmer extends StatelessWidget {
  const OrderAddressShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderDetailSectionCard(
      title: Strings.deliveryAddress,
      titleIcon: Icons.location_on_rounded,
      child: const TwoLineContentShimmer(width: 220),
    );
  }
}

class OrderItemsShimmer extends StatelessWidget {
  const OrderItemsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderDetailSectionCard(
      title: Strings.orderedItems,
      titleIcon: Icons.medication_liquid_rounded,
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 4.r),
      child: Column(
        children: [
          for (var i = 0; i < 3; i++) OrderItemShimmer(showDivider: i < 2),
        ],
      ),
    );
  }
}

class OrderSummaryShimmer extends StatelessWidget {
  const OrderSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderDetailSectionCard(
      title: Strings.orderSummaryTitle,
      titleIcon: Icons.receipt_long_rounded,
      child: const TwoLineContentShimmer(width: 160, showTotal: true),
    );
  }
}

class OrderNotesShimmer extends StatelessWidget {
  const OrderNotesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderDetailSectionCard(
      title: Strings.orderDeliveryInstructions,
      titleIcon: Icons.notes_rounded,
      child: const TwoLineContentShimmer(width: 260),
    );
  }
}
