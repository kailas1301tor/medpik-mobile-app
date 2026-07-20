// lib/src/orders/view/widget/order_detail_notes_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

class OrderDetailNotesSection extends StatelessWidget {
  const OrderDetailNotesSection({
    super.key,
    required this.deliveryInstructions,
    required this.prescriptionDescription,
  });

  final String deliveryInstructions;
  final String prescriptionDescription;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final delivery = deliveryInstructions.trim().isEmpty
        ? Strings.unavailableValue
        : deliveryInstructions.trim();
    final prescription = prescriptionDescription.trim().isEmpty
        ? Strings.unavailableValue
        : prescriptionDescription.trim();

    return CommonContainer(
      padding: EdgeInsets.all(14.r),
      borderRadius: 14.r,
      color: colors.surface,
      side: BorderSide(color: colors.cardBorder, width: 1.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NoteRow(
            title: Strings.orderDeliveryInstructions,
            body: delivery,
          ),
          12.verticalSpace,
          _NoteRow(
            title: Strings.orderPrescriptionNotes,
            body: prescription,
          ),
        ],
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FontPalette.base600(13, color: colors.primaryText),
        ),
        4.verticalSpace,
        Text(
          body,
          style: FontPalette.base400(13, color: colors.secondaryText),
        ),
      ],
    );
  }
}
