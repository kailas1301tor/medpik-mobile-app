import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonScaffold extends StatefulWidget {
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
    // ✅ Fade config
    this.enableFadeIn = true,
    this.fadeInDuration = const Duration(milliseconds: 350),
    this.fadeInCurve = Curves.easeIn,
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

  /// Enables fade-in animation when page mounts
  final bool enableFadeIn;
  final Duration fadeInDuration;
  final Curve fadeInCurve;

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.fadeInDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.fadeInCurve,
    );

    if (widget.enableFadeIn) {
      // Start invisible, then fade in after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0; // Skip animation — fully visible immediately
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isNearBlack(Color color) => color.computeLuminance() < 0.05;

  Brightness _iconBrightness(Color bg) =>
      bg.computeLuminance() > 0.179 ? Brightness.dark : Brightness.light;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBg = widget.backgroundColor ?? colorScheme.surface;
    final resolvedNavBarColor =
        widget.navigationBarColor ??
        (widget.bottomNavigationBar != null
            ? colorScheme.surfaceContainerHighest
            : resolvedBg);

    final statusIconBrightness =
        widget.statusBarIconBrightness ??
        (widget.forceDarkIcons
            ? Brightness.dark
            : (_isNearBlack(resolvedBg) || isDark)
            ? Brightness.light
            : Brightness.dark);

    final applyTop =
        widget.useSafeArea && widget.safeAreaTop && widget.appBar == null;
    final applyBottom =
        widget.useSafeArea &&
        widget.safeAreaBottom &&
        widget.bottomNavigationBar == null;

    Widget effectiveBody = (applyTop || applyBottom)
        ? SafeArea(top: applyTop, bottom: applyBottom, child: widget.body)
        : widget.body;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: widget.statusBarColor ?? Colors.transparent,
        statusBarBrightness: statusIconBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarIconBrightness: statusIconBrightness,
        systemNavigationBarColor: resolvedNavBarColor,
        systemNavigationBarIconBrightness: _iconBrightness(resolvedNavBarColor),
        systemNavigationBarDividerColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        // Keep the Android system nav bar opaque so edge-to-edge content
        // does not show through behind the back/home/recents buttons.
        systemNavigationBarContrastEnforced: true,
      ),
      child: Scaffold(
        backgroundColor: resolvedBg,
        appBar: widget.appBar,
        // ✅ Only the body fades — scaffold chrome (appbar, navbar) stays solid
        body: FadeTransition(opacity: _fadeAnimation, child: effectiveBody),
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        extendBody: widget.extendBody,
      ),
    );
  }
}
