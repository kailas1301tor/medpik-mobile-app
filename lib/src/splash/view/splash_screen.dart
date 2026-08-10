// lib/src/splash/view/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/splash/view/widget/splash_animated_logo.dart';
import 'package:medpik/src/splash/notifier/splash_notifier.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/helpers/pre_cache_images.dart';
import 'package:medpik/utils/routes/route_constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    PreCacheImages.initializeAllImages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PreCacheImages.preCacheImages(context);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashNotifierProvider.select((s) => s.loaderState), (
      previous,
      next,
    ) {
      if (next != LoaderState.loaded) return;
      final hasSession = ref.read(
        splashNotifierProvider.select((s) => s.hasSession),
      );
      final route = hasSession
          ? RouteConstants.mainScreen
          : RouteConstants.routeLoginScreen;
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    });

    return CommonScaffold(
      backgroundColor: ColorPalette.white,
      body: const Center(
        child: SplashAnimatedLogo(),
      ),
    );
  }
}
