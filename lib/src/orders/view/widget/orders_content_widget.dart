// lib/src/orders/view/widget/orders_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/src/orders/view/widget/order_tile.dart';
import 'package:medpik/utils/helpers/shell_insets_helper.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class OrdersContentWidget extends StatelessWidget {
  const OrdersContentWidget({super.key, required this.orders});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        16.w,
        0,
        16.w,
        shellScrollBottomPadding(context),
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: OrderTile(
          order: order,
          onTap: () => Navigator.pushNamed(
            context,
            RouteConstants.routeOrderDetailScreen,
            arguments: order.id,
          ),
          ),
        );
      },
    );
  }
}
