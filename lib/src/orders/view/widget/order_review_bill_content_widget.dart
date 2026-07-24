// lib/src/orders/view/widget/order_review_bill_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/view/widget/order_bill_summary_widget.dart';
import 'package:medpik/src/orders/view/widget/order_bill_pdf_button.dart';
import 'package:medpik/src/orders/view/widget/order_detail_header_card.dart';
import 'package:medpik/src/orders/view/widget/order_ordered_items_section.dart';
import 'package:medpik/src/orders/view/widget/order_status_banner.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderReviewBillContentWidget extends StatelessWidget {
  const OrderReviewBillContentWidget({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final instructionBanner = OrderStatusBannerData(
      type: OrderStatusBannerType.billReview,
      title: Strings.billReviewInstructionTitle,
      subtitle: Strings.billReviewInstructionSubtitle,
      icon: Icons.description_outlined,
    );

    final pdfUrl = order.billPdfUrl;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      children: [
        OrderDetailHeaderCard(order: order, showStepper: false),
        16.verticalSpace,
        OrderStatusBanner(data: instructionBanner),
        if (pdfUrl != null && pdfUrl.isNotEmpty) ...[
          16.verticalSpace,
          OrderBillPdfButton(pdfUrl: pdfUrl),
        ],
        20.verticalSpace,
        OrderOrderedItemsSection(order: order),
        20.verticalSpace,
        OrderBillSummaryWidget(order: order, title: Strings.orderSummaryTitle),
        16.verticalSpace,
        Row(
          children: [
            Icon(Icons.verified_user_outlined, size: 16.r, color: colors.secondaryText),
            8.horizontalSpace,
            Expanded(
              child: Text(
                Strings.rejectBillHint,
                style: FontPalette.base400(12, color: colors.secondaryText),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
