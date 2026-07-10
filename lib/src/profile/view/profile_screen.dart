// lib/src/profile/view/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/auth/notifier/auth_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final authModel = ref.watch(authNotifierProvider.select((s) => s.authModel));

    return CommonScaffold(
      backgroundColor: colors.background,
      body: ListView(
        padding: EdgeInsets.all(20.r),
        children: [
          Text(
            Strings.profile,
            style: FontPalette.base700(24, color: colors.primaryText),
          ),
          24.verticalSpace,
          CommonContainer(
            padding: EdgeInsets.all(16.r),
            borderRadius: 16.r,
            color: colors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authModel?.name ?? Strings.guestUser,
                  style: FontPalette.base700(18, color: colors.primaryText),
                ),
                4.verticalSpace,
                Text(
                  authModel?.phone ?? '',
                  style: FontPalette.base400(14, color: colors.secondaryText),
                ),
              ],
            ),
          ),
          24.verticalSpace,
          _ProfileMenuTile(
            icon: Icons.location_on_outlined,
            title: Strings.savedAddresses,
            onTap: () => Navigator.pushNamed(
              context,
              RouteConstants.routeAddressBookScreen,
            ),
          ),
          8.verticalSpace,
          _ProfileMenuTile(
            icon: Icons.logout,
            title: Strings.signOut,
            onTap: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteConstants.routeLoginScreen,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      borderRadius: 12.r,
      color: colors.surface,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 22.r),
          12.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: FontPalette.base500(15, color: colors.primaryText),
            ),
          ),
          Icon(Icons.chevron_right, color: colors.secondaryText, size: 22.r),
        ],
      ),
    );
  }
}
