// lib/src/profile/view/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/providers/auth_providers.dart';
import 'package:medpik/src/profile/view/widget/profile_dark_mode_tile.dart';
import 'package:medpik/src/profile/view/widget/profile_menu_section.dart';
import 'package:medpik/src/profile/view/widget/profile_menu_tile.dart';
import 'package:medpik/src/profile/view/widget/profile_user_card.dart';
import 'package:medpik/utils/common_widgets/common_container.dart';
import 'package:medpik/utils/common_widgets/common_dialog_box.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';
import 'package:medpik/utils/common_widgets/shell_tab_header.dart';
import 'package:medpik/utils/helpers/shell_insets_helper.dart';
import 'package:medpik/utils/helpers/toast_helper.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final authModel = ref.watch(
      authNotifierProvider.select((s) => s.authModel),
    );
    final isSigningOut = ref.watch(
      authNotifierProvider.select((s) => s.isSigningOut),
    );

    return Stack(
      children: [
        Column(
          children: [
            const ShellTabHeader(title: Strings.profileTitle),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  0,
                  16.w,
                  shellScrollBottomPadding(context),
                ),
                children: [
                  ProfileUserCard(authModel: authModel),
                  24.verticalSpace,
                  ProfileMenuSection(
                    title: Strings.myAccountSection,
                    children: [
                      ProfileMenuTile(
                        icon: Icons.person_outline_rounded,
                        title: Strings.personalInformation,
                        subtitle: Strings.personalInformationSubtitle,
                        onTap: () =>
                            showCustomToast(message: Strings.supportComingSoon),
                      ),
                      ProfileMenuTile(
                        icon: Icons.shield_outlined,
                        title: Strings.privacyAndSecurity,
                        subtitle: Strings.privacyAndSecuritySubtitle,
                        onTap: () =>
                            showCustomToast(message: Strings.supportComingSoon),
                      ),
                      const ProfileDarkModeTile(),
                    ],
                  ),
                  20.verticalSpace,
                  ProfileMenuSection(
                    title: Strings.emergencySection,
                    children: [
                      ProfileMenuTile(
                        icon: Icons.local_hospital_outlined,
                        iconColor: ColorPalette.prescriptionUploadBtn,
                        title: Strings.emergencyServices,
                        subtitle: Strings.emergencyServicesSubtitle,
                        showDivider: false,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteConstants.routeEmergencyServicesScreen,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  ProfileMenuSection(
                    title: Strings.supportSection,
                    children: [
                      ProfileMenuTile(
                        icon: Icons.help_outline_rounded,
                        title: Strings.helpAndSupport,
                        subtitle: Strings.helpAndSupportSubtitle,
                        onTap: () =>
                            showCustomToast(message: Strings.supportComingSoon),
                      ),
                      ProfileMenuTile(
                        icon: Icons.phone_outlined,
                        title: Strings.contactSupport,
                        subtitle: Strings.contactSupportSubtitle,
                        onTap: () =>
                            showCustomToast(message: Strings.supportComingSoon),
                      ),
                      ProfileMenuTile(
                        icon: Icons.info_outline_rounded,
                        title: Strings.aboutUs,
                        subtitle: Strings.aboutUsSubtitle,
                        showDivider: false,
                        onTap: () =>
                            showCustomToast(message: Strings.supportComingSoon),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  CommonContainer(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    borderRadius: 14.r,
                    color: colors.surface,
                    onTap: isSigningOut
                        ? null
                        : () => _confirmSignOut(context, ref),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 18.r,
                          color: ColorPalette.prescriptionUploadBtn,
                        ),
                        8.horizontalSpace,
                        Text(
                          Strings.signOut,
                          style: FontPalette.base600(
                            15,
                            color: ColorPalette.prescriptionUploadBtn,
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
        if (isSigningOut)
          Positioned.fill(
            child: ColoredBox(
              color: ColorPalette.black.withValues(alpha: 0.25),
              child: const CommonLoader(),
            ),
          ),
      ],
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    CommonDialogBox.show(
      context: context,
      title: Strings.signOutTitle,
      message: Strings.signOutMessage,
      primaryLabel: Strings.signOut,
      onPrimary: () async {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteConstants.routeLoginScreen,
            (route) => false,
          );
        }
      },
      secondaryLabel: Strings.cancel,
    );
  }
}
