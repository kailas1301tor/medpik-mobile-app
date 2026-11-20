// lib/src/home/view/widget/home_prescription_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_surface.dart';
import 'package:medpik/utils/helpers/phone_launch_helper.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:medpik/utils/helpers/whatsapp_launch_helper.dart';

class HomePrescriptionCard extends StatelessWidget {
  const HomePrescriptionCard({
    super.key,
    this.onUploadTap,
    this.supportPhone = '',
  });

  final VoidCallback? onUploadTap;
  final String supportPhone;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24.r);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          ...ColorPalette.productCardShadow,
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: isDark ? 0.28 : 0.06),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: SmoothClipRRect(
        smoothness: 1.2,
        borderRadius: radius,
        child: HomePrescriptionCardSurface(
          radius: radius,
          onUploadTap: onUploadTap,
          onCallTap: _onCallTap,
          onWhatsAppTap: _onWhatsAppTap,
        ),
      ),
    );
  }

  String? get _resolvedPhone {
    final phone = supportPhone.trim();
    return phone.isEmpty ? null : phone;
  }

  Future<void> _onCallTap() async {
    final phone = _resolvedPhone;
    if (phone == null) {
      showCustomErrorToast(message: Strings.supportPhoneUnavailable);
      return;
    }
    await launchPhoneCall(phone);
  }

  Future<void> _onWhatsAppTap() async {
    final phone = _resolvedPhone;
    if (phone == null) {
      showCustomErrorToast(message: Strings.supportPhoneUnavailable);
      return;
    }
    await launchWhatsAppChat(
      phone,
      message: Strings.whatsappOrderPrefillMessage,
    );
  }
}
