import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpik/res/styles/color_palette.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.navigationBarColor,
    this.forceDarkIcons = false,
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    /// Off by default — route transitions already animate; a second fade makes
    /// Android navigation feel lagged (content starts transparent).
    this.enableFadeIn = false,
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.fadeInCurve = Curves.easeOut,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Color? navigationBarColor;
  final bool forceDarkIcons;
  final bool useSafeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;

  /// Optional body fade after mount. Prefer leaving off for push/pop routes.
  final bool enableFadeIn;
  final Duration fadeInDuration;
  final Curve fadeInCurve;

  bool _isNearBlack(Color color) => color.computeLuminance() < 0.05;

  Brightness _iconBrightness(Color bg) =>
      bg.computeLuminance() > 0.179 ? Brightness.dark : Brightness.light;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBg = backgroundColor ?? colorScheme.surface;
    // Icon brightness still follows the scaffold surface / optional override.
    // System bar *colors* stay transparent for Android 15 edge-to-edge.
    final navBarIconSource =
        navigationBarColor ??
        (bottomNavigationBar != null
            ? colorScheme.surfaceContainerHighest
            : resolvedBg);

    final statusIconBrightness =
        statusBarIconBrightness ??
        (forceDarkIcons
            ? Brightness.dark
            : (_isNearBlack(resolvedBg) || isDark)
            ? Brightness.light
            : Brightness.dark);

    final applyTop = useSafeArea && safeAreaTop && appBar == null;
    final applyBottom =
        useSafeArea && safeAreaBottom && bottomNavigationBar == null;

    Widget effectiveBody = (applyTop || applyBottom)
        ? SafeArea(top: applyTop, bottom: applyBottom, child: body)
        : body;

    if (enableFadeIn) {
      effectiveBody = _ScaffoldFadeIn(
        duration: fadeInDuration,
        curve: fadeInCurve,
        child: effectiveBody,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? ColorPalette.transparent,
        statusBarBrightness: statusIconBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarIconBrightness: statusIconBrightness,
        systemNavigationBarColor: ColorPalette.transparent,
        systemNavigationBarIconBrightness: _iconBrightness(navBarIconSource),
        systemNavigationBarDividerColor: ColorPalette.transparent,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: resolvedBg,
        appBar: appBar,
        body: effectiveBody,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        drawer: drawer,
        endDrawer: endDrawer,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
      ),
    );
  }
}

/// Isolated ticker so most screens never pay AnimationController cost.
class _ScaffoldFadeIn extends StatefulWidget {
  const _ScaffoldFadeIn({
    required this.child,
    required this.duration,
    required this.curve,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  State<_ScaffoldFadeIn> createState() => _ScaffoldFadeInState();
}

class _ScaffoldFadeInState extends State<_ScaffoldFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: widget.child);
  }
}
