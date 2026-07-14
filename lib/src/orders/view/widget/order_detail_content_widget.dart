// lib/src/orders/view/widget/order_detail_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/data/models/order_model.dart';
import 'package:tsuite/src/orders/view/widget/order_detail_header_card.dart';
import 'package:tsuite/src/orders/view/widget/order_ordered_items_section.dart';
import 'package:tsuite/src/orders/view/widget/order_status_banner.dart';
import 'package:tsuite/utils/helpers/order_status_helper.dart';

class OrderDetailContentWidget extends StatelessWidget {
  const OrderDetailContentWidget({
    super.key,
    required this.order,
    this.onBannerTap,
  });

  final OrderModel order;
  final VoidCallback? onBannerTap;

  @override
  Widget build(BuildContext context) {
    final banner = orderDetailStatusBanner(order.status, order);

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      children: [
        OrderDetailHeaderCard(order: order),
        if (banner != null) ...[
          16.verticalSpace,
          OrderStatusBanner(data: banner, onTap: onBannerTap),
        ],
        20.verticalSpace,
        OrderOrderedItemsSection(order: order),
      ],
    );
  }
}
