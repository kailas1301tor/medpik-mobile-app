// lib/src/orders/view/widget/order_detail_shimmer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/src/orders/view/widget/order_detail_shimmer_sections.dart';
import 'package:medpik/utils/common_widgets/common_shimmer_box.dart';

class OrderDetailShimmerWidget extends StatelessWidget {
  const OrderDetailShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const OrderHeaderShimmer(),
        16.verticalSpace,
        CommonShimmerBox(height: 52.h, borderRadius: 16.r),
        20.verticalSpace,
        const OrderAddressShimmer(),
        20.verticalSpace,
        const OrderItemsShimmer(),
        20.verticalSpace,
        const OrderSummaryShimmer(),
        20.verticalSpace,
        const OrderNotesShimmer(),
      ],
    );
  }
}
