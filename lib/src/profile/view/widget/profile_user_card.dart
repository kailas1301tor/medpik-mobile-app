// lib/src/profile/view/widget/profile_user_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/auth/model/auth_model.dart';
import 'package:tsuite/utils/extensions/string_extensions.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key, this.authModel});

  final AuthModel? authModel;

  @override
  Widget build(BuildContext context) {
    final name = authModel?.name ?? Strings.guestUser;
    final initials = name.initials.isEmpty ? 'G' : name.initials;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ColorPalette.productAccentTeal,
            ColorPalette.productAccentTeal.withValues(alpha: 0.88),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.productAccentTeal.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -4.w,
            top: -16.h,
            bottom: -16.h,
            width: 130.w,
            child: CustomPaint(
              painter: _ProfileWavePainter(
                color: ColorPalette.white.withValues(alpha: 0.16),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: BoxDecoration(
                    color: ColorPalette.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorPalette.white.withValues(alpha: 0.55),
                        width: 1.5.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: FontPalette.base700(20, color: ColorPalette.white),
                    ),
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: FontPalette.base700(
                          20,
                          color: ColorPalette.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.black.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 12.r,
                              color: ColorPalette.white,
                            ),
                            4.horizontalSpace,
                            Text(
                              Strings.activeMember,
                              style: FontPalette.base600(
                                11,
                                color: ColorPalette.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileWavePainter extends CustomPainter {
  const _ProfileWavePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 5; i++) {
      final path = Path();
      final dx = size.width * (0.15 + i * 0.16);
      path.moveTo(dx, 0);
      path.cubicTo(
        dx - 18,
        size.height * 0.25,
        dx + 18,
        size.height * 0.55,
        dx - 10,
        size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProfileWavePainter oldDelegate) =>
      oldDelegate.color != color;
}
