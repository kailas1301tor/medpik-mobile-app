// lib/src/home/view/widget/home_prescription_card_surface.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/medpik_svg_assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_art.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_chip.dart';
import 'package:medpik/src/home/view/widget/home_prescription_card_upload_button.dart';

class HomePrescriptionCardSurface extends StatelessWidget {
  const HomePrescriptionCardSurface({
    super.key,
    required this.radius,
    this.onUploadTap,
    this.onCallTap,
    this.onWhatsAppTap,
  });

  final BorderRadius radius;
  final VoidCallback? onUploadTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onWhatsAppTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: radius,
        border: Border.all(color: colors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 8.w, 14.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Strings.orderYourMedicines,
                      style: FontPalette.base700(
                        16,
                        color: colors.primaryText,
                      ),
                    ),
                    4.verticalSpace,
                    Text.rich(
                      TextSpan(
                        style: FontPalette.base400(
                          11,
                          color: colors.secondaryText,
                        ),
                        children: [
                          const TextSpan(
                            text: Strings.uploadPrescriptionSubtitle,
                          ),
                          TextSpan(
                            text: Strings.uploadPrescriptionSubtitleEmphasis,
                            style: FontPalette.base600(
                              11,
                              color: colors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    10.verticalSpace,
                    HomePrescriptionCardUploadButton(onTap: onUploadTap),
                    8.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: HomePrescriptionCardOutlineButton(
                            label: Strings.callLabel,
                            iconAsset: MedpikSvgAssets.phone,
                            onTap: onCallTap,
                          ),
                        ),
                        6.horizontalSpace,
                        Expanded(
                          child: HomePrescriptionCardOutlineButton(
                            label: Strings.whatsappLabel,
                            iconAsset: MedpikSvgAssets.whatsapp,
                            onTap: onWhatsAppTap,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              4.horizontalSpace,
              const Expanded(
                flex: 9,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: HomePrescriptionCardArt(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
