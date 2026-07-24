// lib/src/orders/view/widget/order_bill_pdf_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class OrderBillPdfButton extends StatelessWidget {
  const OrderBillPdfButton({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      borderRadius: 12.r,
      color: colors.surface,
      side: BorderSide(color: colors.primary, width: 1.w),
      onTap: () => Navigator.pushNamed(
        context,
        RouteConstants.routeOrderBillPdfScreen,
        arguments: pdfUrl,
      ),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 20.r,
            color: colors.primary,
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              Strings.viewBillPdf,
              style: FontPalette.base600(14, color: colors.primary),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20.r,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}
