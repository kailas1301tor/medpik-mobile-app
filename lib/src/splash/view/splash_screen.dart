// lib/src/splash/view/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/enums/enums.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';
import 'package:tsuite/src/splash/notifier/splash_notifier.dart';
import 'package:tsuite/utils/common_widgets/common_scaffold.dart';
import 'package:tsuite/utils/routes/route_constants.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    ref.listen(
      splashNotifierProvider.select((s) => s.loaderState),
      (previous, next) {
        if (next != LoaderState.loaded) return;
        final hasSession = ref.read(
          splashNotifierProvider.select((s) => s.hasSession),
        );
        final route = hasSession
            ? RouteConstants.mainScreen
            : RouteConstants.routeLoginScreen;
        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
      },
    );

    return CommonScaffold(
      backgroundColor: colors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.appName,
              style: FontPalette.base700(40, color: ColorPalette.white),
            ),
            12.verticalSpace,
            Text(
              Strings.splashTagline,
              style: FontPalette.base400(16, color: ColorPalette.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
