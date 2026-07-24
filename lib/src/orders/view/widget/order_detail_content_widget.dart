// lib/src/orders/view/widget/order_detail_content_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/src/orders/view/widget/order_bill_pdf_button.dart';
import 'package:medpik/src/orders/view/widget/order_bill_summary_widget.dart';
import 'package:medpik/src/orders/view/widget/order_detail_address_card.dart';
import 'package:medpik/src/orders/view/widget/order_detail_header_card.dart';
import 'package:medpik/src/orders/view/widget/order_detail_notes_section.dart';
import 'package:medpik/src/orders/view/widget/order_detail_prescriptions_section.dart';
import 'package:medpik/src/orders/view/widget/order_ordered_items_section.dart';
import 'package:medpik/src/orders/view/widget/order_status_banner.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

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
    final hasPrescriptions = order.prescriptionImageUrls.isNotEmpty;
    final showBillPdf = order.hasBillPdf;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      children: [
        OrderDetailHeaderCard(order: order),
        if (banner != null) ...[
          16.verticalSpace,
          OrderStatusBanner(data: banner, onTap: onBannerTap),
        ],
        if (showBillPdf) ...[
          16.verticalSpace,
          OrderBillPdfButton(pdfUrl: order.billPdfUrl!),
        ],
        20.verticalSpace,
        OrderDetailAddressCard(address: order.address),
        20.verticalSpace,
        OrderOrderedItemsSection(
          order: order,
          showPrices: !orderDetailUsesBillPricing(order),
        ),
        if (orderDetailShowsBillSummary(order)) ...[
          20.verticalSpace,
          OrderBillSummaryWidget(
            order: order,
            title: Strings.orderSummaryTitle,
          ),
        ],
        if (hasPrescriptions) ...[
          20.verticalSpace,
          OrderDetailPrescriptionsSection(
            imageUrls: order.prescriptionImageUrls,
          ),
        ],
        20.verticalSpace,
        OrderDetailNotesSection(
          deliveryInstructions: order.deliveryInstructions,
          prescriptionDescription: order.prescriptionDescription,
        ),
      ],
    );
  }
}
