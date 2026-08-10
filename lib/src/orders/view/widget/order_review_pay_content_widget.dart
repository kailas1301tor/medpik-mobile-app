// lib/src/orders/view/widget/order_review_pay_content_widget.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/data/models/order_model.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/orders/notifier/orders_notifier.dart';
import 'package:medpik/src/orders/view/widget/order_bill_summary_widget.dart';
import 'package:medpik/src/orders/view/widget/order_detail_header_card.dart';
import 'package:medpik/src/orders/view/widget/order_payment_method_card.dart';
import 'package:medpik/src/orders/view/widget/order_status_banner.dart';
import 'package:medpik/utils/helpers/legal_url_helper.dart';
import 'package:medpik/utils/helpers/order_status_helper.dart';

class OrderReviewPayContentWidget extends ConsumerWidget {
  const OrderReviewPayContentWidget({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final selectedMethod = ref.watch(
      ordersNotifierProvider.select((s) => s.selectedPaymentMethod),
    );
    final notifier = ref.read(ordersNotifierProvider.notifier);
    final acceptedBanner = OrderStatusBannerData(
      type: OrderStatusBannerType.billAccepted,
      title: Strings.billAcceptedBannerTitle,
      subtitle: Strings.billAcceptedBannerSubtitle,
      icon: Icons.verified_rounded,
    );
    final secureBanner = OrderStatusBannerData(
      type: OrderStatusBannerType.securePayment,
      title: Strings.securePaymentTitle,
      subtitle: Strings.securePaymentSubtitle,
      icon: Icons.shield_outlined,
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      children: [
        OrderDetailHeaderCard(
          order: order,
          showStepper: false,
          badgeStatus: OrderStatus.billAccepted,
          badgeLabel: Strings.orderStatusBillAccepted,
        ),
        16.verticalSpace,
        OrderStatusBanner(data: acceptedBanner),
        20.verticalSpace,
        OrderBillSummaryWidget(order: order, title: Strings.orderSummaryTitle),
        20.verticalSpace,
        Text(
          Strings.choosePaymentMethod,
          style: FontPalette.base700(16, color: colors.primaryText),
        ),
        12.verticalSpace,
        OrderPaymentMethodCard(
          method: OrderPaymentMethod.online,
          isSelected: selectedMethod == OrderPaymentMethod.online,
          onTap: () => notifier.selectPaymentMethod(OrderPaymentMethod.online),
        ),
        OrderPaymentMethodCard(
          method: OrderPaymentMethod.cashOnDelivery,
          isSelected: selectedMethod == OrderPaymentMethod.cashOnDelivery,
          onTap: () =>
              notifier.selectPaymentMethod(OrderPaymentMethod.cashOnDelivery),
        ),
        12.verticalSpace,
        OrderStatusBanner(data: secureBanner),
        16.verticalSpace,
        const _OrderTermsAgreementText(),
      ],
    );
  }
}

class _OrderTermsAgreementText extends StatefulWidget {
  const _OrderTermsAgreementText();

  @override
  State<_OrderTermsAgreementText> createState() =>
      _OrderTermsAgreementTextState();
}

class _OrderTermsAgreementTextState extends State<_OrderTermsAgreementText> {
  late final TapGestureRecognizer _termsRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => openTermsAndConditions(context);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text.rich(
      TextSpan(
        text: Strings.termsAgreementPrefix,
        style: FontPalette.base400(12, color: colors.secondaryText),
        children: [
          TextSpan(
            text: ' ${Strings.termsAndConditions}',
            style: FontPalette.base500(12, color: colors.primary),
            recognizer: _termsRecognizer,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
