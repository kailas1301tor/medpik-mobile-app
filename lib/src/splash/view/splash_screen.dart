// lib/src/splash/view/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/src/splash/view/widget/splash_animated_logo.dart';
import 'package:medpik/src/splash/notifier/splash_notifier.dart';
import 'package:medpik/utils/common_widgets/common_dialog_box.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/helpers/pre_cache_images.dart';
import 'package:medpik/utils/helpers/store_launch_helper.dart';
import 'package:medpik/utils/routes/route_constants.dart';
import 'package:tuple/tuple.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _precacheStarted = false;
  bool _imagesPrecached = false;
  bool _didNavigate = false;
  bool _forceUpdateDialogShown = false;

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

  Future<void> _showForceUpdateDialog() async {
    if (_forceUpdateDialogShown || !mounted) return;
    _forceUpdateDialogShown = true;

    await CommonDialogBox.show(
      context: context,
      barrierDismissible: false,
      title: Strings.forceUpdateTitle,
      message: Strings.forceUpdateMessage,
      primaryLabel: Strings.forceUpdateCta,
      onPrimaryAsync: () async {
        await launchAppStoreListing();
        // Keep dialog open so the user returns from the store and taps again.
        return false;
      },
    );
  }

  void _tryNavigate() {
    if (_didNavigate || !_imagesPrecached) return;

    final splash = ref.read(splashNotifierProvider);
    if (splash.loaderState != LoaderState.loaded) return;

    if (splash.requiresForceUpdate) {
      _showForceUpdateDialog();
      return;
    }

    _didNavigate = true;
    final route = splash.hasSession
        ? RouteConstants.mainScreen
        : RouteConstants.routeLoginScreen;
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      splashNotifierProvider.select(
        (s) => Tuple2(s.loaderState, s.requiresForceUpdate),
      ),
      (previous, next) {
        if (next.item1 == LoaderState.loaded) {
          _tryNavigate();
        }
      },
    );

    return const CommonScaffold(
      backgroundColor: ColorPalette.splashColor,
      statusBarIconBrightness: Brightness.light,
      body: Center(
        child: SplashAnimatedLogo(),
      ),
    );
  }
}
