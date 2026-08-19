// lib/src/profile/view/widget/profile_user_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/providers/auth_providers.dart';
import 'package:medpik/src/profile/model/profile_model.dart';
import 'package:medpik/utils/common_widgets/common_cached_network_image.dart';
import 'package:medpik/utils/extensions/string_extensions.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key, this.profile, this.authModel});

  final ProfileModel? profile;
  final AuthModel? authModel;

  @override
  Widget build(BuildContext context) {
    final profileName = profile?.displayName.trim() ?? '';
    final authName = authModel?.name.trim() ?? '';
    final rawName = profileName.isNotEmpty ? profileName : authName;

    final profilePhone = profile?.phoneNumber.trim() ?? '';
    final authPhone = authModel?.phone.trim() ?? '';
    final phone = profilePhone.isNotEmpty ? profilePhone : authPhone;

    final profileImageUrl = authModel?.profileImageUrl.trim() ?? '';
    final displayName = rawName.isNotEmpty ? rawName : Strings.member;
    final initials = rawName.isNotEmpty
        ? (displayName.initials.isEmpty ? 'M' : displayName.initials)
        : 'M';
    final radius = BorderRadius.circular(20.r);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.productAccentTeal.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: SmoothClipRRect(
        smoothness: 2,
        borderRadius: radius,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorPalette.primaryColorDark,
                      ColorPalette.primaryColor,
                      ColorPalette.secondaryColor,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorPalette.black.withValues(alpha: 0.04),
                      ColorPalette.black.withValues(alpha: 0.22),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18.r),
              child: Row(
                children: [
                  _ProfileAvatar(imageUrl: profileImageUrl, initials: initials),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: FontPalette.base700(
                            18,
                            color: ColorPalette.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (phone.isNotEmpty) ...[
                          4.verticalSpace,
                          Text(
                            phone,
                            style: FontPalette.base400(
                              13,
                              color: ColorPalette.white.withValues(alpha: 0.78),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        10.verticalSpace,
                        SmoothContainer(
                          smoothness: 2,
                          borderRadius: BorderRadius.circular(999.r),
                          color: ColorPalette.black.withValues(alpha: 0.18),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
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
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl, required this.initials});

  final String imageUrl;
  final String initials;

  static const double _size = 60;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = BorderRadius.circular(_size.r / 2);
    final fallback = SmoothContainer(
      smoothness: 2,
      width: _size.r,
      height: _size.r,
      borderRadius: avatarRadius,
      color: ColorPalette.white.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          initials,
          style: FontPalette.base700(22, color: ColorPalette.white),
        ),
      ),
    );

    return SmoothContainer(
      smoothness: 2,
      width: (_size + 4).r,
      height: (_size + 4).r,
      borderRadius: BorderRadius.circular((_size + 4).r / 2),
      side: BorderSide(
        color: ColorPalette.white.withValues(alpha: 0.65),
        width: 2.w,
      ),
      color: Colors.transparent,
      child: SmoothClipRRect(
        smoothness: 2,
        borderRadius: avatarRadius,
        child: CommonCachedNetworkImage(
          imageUrl: imageUrl,
          width: _size.r,
          height: _size.r,
          borderRadius: _size.r / 2,
          placeholder: fallback,
          errorWidget: fallback,
        ),
      ),
    );
  }
}
