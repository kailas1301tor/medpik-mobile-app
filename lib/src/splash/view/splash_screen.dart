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
  bool _precacheStarted = false;
  bool _imagesPrecached = false;
  bool _didNavigate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precacheStarted) return;
    _precacheStarted = true;

    // Warm Flutter ImageCache before leaving splash so home/login first paint
    // reuses the same ImageProviders.
    PreCacheImages.preCacheImages(context).whenComplete(() {
      if (!mounted) return;
      setState(() => _imagesPrecached = true);
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (_didNavigate || !_imagesPrecached) return;

    final splash = ref.read(splashNotifierProvider);
    if (splash.loaderState != LoaderState.loaded) return;

    _didNavigate = true;
    final route = splash.hasSession
        ? RouteConstants.mainScreen
        : RouteConstants.routeLoginScreen;
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashNotifierProvider.select((s) => s.loaderState), (
      previous,
      next,
    ) {
      if (next == LoaderState.loaded) {
        _tryNavigate();
      }
    });

    return const CommonScaffold(
      backgroundColor: ColorPalette.white,
      body: Center(
        child: SplashAnimatedLogo(),
      ),
    );
  }
}
