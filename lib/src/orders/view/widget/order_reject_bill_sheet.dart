// lib/src/orders/view/widget/order_reject_bill_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/notifier/orders_notifier.dart';
import 'package:medpik/utils/common_widgets/common_bottom_sheet.dart';
import 'package:medpik/utils/common_widgets/common_text_form_field.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';

class OrderRejectBillSheet {
  OrderRejectBillSheet._();

  static Future<bool> show({
    required BuildContext context,
    required WidgetRef ref,
    required String orderId,
  }) async {
    final notifier = ref.read(ordersNotifierProvider.notifier);
    notifier.clearRejectReason();

    final result = await CommonBottomSheet.show<bool>(
      context: context,
      title: Strings.rejectBillTitle,
      isScrollControlled: true,
      child: _OrderRejectBillSheetContent(orderId: orderId),
    );

    return result ?? false;
  }
}

class _OrderRejectBillSheetContent extends ConsumerWidget {
  const _OrderRejectBillSheetContent({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final notifier = ref.read(ordersNotifierProvider.notifier);
    final isLoading = ref.watch(
      ordersNotifierProvider.select((s) => s.isRejectBillLoading),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.rejectBillReasonLabel,
          style: FontPalette.base500(14, color: colors.primaryText),
        ),
        12.verticalSpace,
        CommonTextFormField(
          controller: notifier.rejectReasonController,
          hintText: Strings.rejectBillReasonHint,
          maxLines: 3,
          minLines: 3,
          inputAction: TextInputAction.done,
          borderRadius: 0,
          enableSmoothRadius: false,
        ),
        20.verticalSpace,
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: Strings.cancel,
                height: 48.h,
                radius: 0,
                backgroundColor: colors.surface,
                textColor: colors.secondaryText,
                borderSide: BorderSide(color: colors.cardBorder, width: 1.5.w),
                isLoading: false,
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(context).pop(false),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: PrimaryButton(
                text: Strings.rejectBillConfirm,
                height: 48.h,
                radius: 0,
                backgroundColor: colors.surface,
                textColor: ColorPalette.orderRejectButtonBorder,
                borderSide: BorderSide(
                  color: ColorPalette.orderRejectButtonBorder,
                  width: 1.5.w,
                ),
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        final success = await notifier.rejectBill(
                          orderId: orderId,
                          rejectReason: notifier.rejectReasonController.text,
                        );
                        if (!context.mounted) return;
                        if (success) {
                          Navigator.of(context).pop(true);
                        }
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
