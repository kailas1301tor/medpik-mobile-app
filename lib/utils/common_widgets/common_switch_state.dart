// /Users/wac/Documents/tortilon/medpik/lib/utils/common_widgets/common_switch_state.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/constants/assets.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/connectivity_service.dart';
import 'package:medpik/utils/common_widgets/common_empty_state.dart';
import 'package:medpik/utils/common_widgets/common_error_state.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';

class CommonSwitchState extends ConsumerStatefulWidget {
  const CommonSwitchState({
    super.key,
    required this.loaderState,
    required this.child,
    this.reload,
    this.customButtonFunction,
    this.loader,
    this.errorTitle,
    this.errorMessage,
    this.buttonText,
    this.noData,
    this.noSearchData,
    this.errorWidget,
    this.topMargin,
    this.emptyMainAxisAlignment,
    this.emptyScreenTitle,
    this.emptyScreenDescription,
    this.emptyScreenImage,
    this.titleTextStyle,
    this.errorMessageTextStyle,
    this.backgroundColor,
  });

  final LoaderState loaderState;
  final VoidCallback? reload;
  final VoidCallback? customButtonFunction;
  final Widget child;
  final Widget? loader;
  final String? errorTitle;
  final String? errorMessage;
  final String? buttonText;
  final Widget? noData;
  final Widget? noSearchData;
  final Widget? errorWidget;
  final double? topMargin;
  final MainAxisAlignment? emptyMainAxisAlignment;
  final String? emptyScreenTitle;
  final String? emptyScreenDescription;
  final String? emptyScreenImage;
  final TextStyle? titleTextStyle;
  final TextStyle? errorMessageTextStyle;
  final Color? backgroundColor;

  @override
  ConsumerState<CommonSwitchState> createState() => _CommonSwitchStateState();
}

class _CommonSwitchStateState extends ConsumerState<CommonSwitchState> {
  bool? _lastNetworkState;

  @override
  Widget build(BuildContext context) {
    final hasNetwork = _hasNetwork();
    _scheduleAutoReload(hasNetwork);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;
        final content = _buildContent(
          hasNetwork: hasNetwork,
          fillAvailableSpace: hasBoundedHeight,
        );

        if (!hasBoundedHeight) {
          return content;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.topCenter,
              fit: StackFit.expand,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child: content,
        );
      },
    );
  }

  Widget _buildContent({
    required bool hasNetwork,
    required bool fillAvailableSpace,
  }) {
    if (!hasNetwork) {
      return _buildErrorState(
        key: const ValueKey('network_state'),
        title: Strings.connectionErrorTitle,
        message: Strings.connectionErrorDesc,
        imageAsset: Assets.lottieNoInternet,
        fillAvailableSpace: fillAvailableSpace,
      );
    }

    return switch (widget.loaderState) {
      LoaderState.loaded => KeyedSubtree(
        key: const ValueKey('loaded_state'),
        child: widget.child,
      ),
      LoaderState.loading => KeyedSubtree(
        key: const ValueKey('loading_state'),
        child: widget.loader ??
            (fillAvailableSpace
                ? const CommonLoader()
                : const Align(
                    alignment: Alignment.topCenter,
                    child: CommonLoader(),
                  )),
      ),
      LoaderState.noData => KeyedSubtree(
        key: const ValueKey('no_data_state'),
        child:
            widget.noData ??
            _buildEmptyState(
              title: widget.emptyScreenTitle ?? Strings.noDataTitle,
              message:
                  widget.emptyScreenDescription ?? Strings.noDataMessage,
              imageAsset: widget.emptyScreenImage ?? Assets.lottieNoData,
              onPressed: widget.customButtonFunction ?? widget.reload,
              buttonText: _resolvedButtonText(),
              fillAvailableSpace: fillAvailableSpace,
            ),
      ),
      LoaderState.noSearchData => KeyedSubtree(
        key: const ValueKey('no_search_state'),
        child:
            widget.noSearchData ??
            _buildEmptyState(
              title: widget.emptyScreenTitle ?? Strings.noResultsFound,
              message:
                  widget.emptyScreenDescription ?? Strings.noResultsDesc,
              imageAsset: widget.emptyScreenImage ?? Assets.lottieSearching,
              fillAvailableSpace: fillAvailableSpace,
            ),
      ),
      LoaderState.error => KeyedSubtree(
        key: const ValueKey('error_state'),
        child:
            widget.errorWidget ??
            _buildErrorState(
              title: widget.errorTitle ?? Strings.errorTitle,
              message: widget.errorMessage ?? Strings.errorDescription,
              imageAsset: Assets.lottieError,
              fillAvailableSpace: fillAvailableSpace,
            ),
      ),
      LoaderState.serverError => KeyedSubtree(
        key: const ValueKey('server_state'),
        child: _buildErrorState(
          title: Strings.error500Title,
          message: Strings.error500Message,
          imageAsset: Assets.lottieError,
          fillAvailableSpace: fillAvailableSpace,
        ),
      ),
      LoaderState.networkError => KeyedSubtree(
        key: const ValueKey('network_loader_state'),
        child: _buildErrorState(
          title: Strings.connectionErrorTitle,
          message: Strings.connectionErrorDesc,
          imageAsset: Assets.lottieNoInternet,
          fillAvailableSpace: fillAvailableSpace,
        ),
      ),
    };
  }

  bool _hasNetwork() {
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    return connectivityAsync.when(
      data: (connected) => connected,
      loading: () => true,
      error: (_, __) => true,
    );
  }

  void _scheduleAutoReload(bool hasNetwork) {
    if (_lastNetworkState == false &&
        hasNetwork &&
        widget.loaderState != LoaderState.loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.reload?.call();
      });
    }
    _lastNetworkState = hasNetwork;
  }

  Widget _buildEmptyState({
    required String title,
    required String message,
    String? imageAsset,
    String? buttonText,
    VoidCallback? onPressed,
    bool fillAvailableSpace = true,
  }) {
    return CommonEmptyState(
      title: title,
      message: message,
      imageAsset: imageAsset,
      buttonText: buttonText,
      onPressed: onPressed,
      titleStyle: widget.titleTextStyle,
      messageStyle: widget.errorMessageTextStyle,
      topSpacing: widget.topMargin,
      mainAxisAlignment:
          widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
      backgroundColor: widget.backgroundColor,
      fillAvailableSpace: fillAvailableSpace,
    );
  }

  Widget _buildErrorState({
    Key? key,
    required String title,
    required String message,
    String? imageAsset,
    bool fillAvailableSpace = true,
  }) {
    return KeyedSubtree(
      key: key,
      child: CommonErrorState(
        title: title,
        message: message,
        imageAsset: imageAsset,
        buttonText: _resolvedButtonText(),
        onRetry: widget.customButtonFunction ?? widget.reload,
        titleStyle: widget.titleTextStyle,
        messageStyle: widget.errorMessageTextStyle,
        topSpacing: widget.topMargin,
        mainAxisAlignment:
            widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
        backgroundColor: widget.backgroundColor,
        fillAvailableSpace: fillAvailableSpace,
      ),
    );
  }

  String? _resolvedButtonText() {
    if (widget.customButtonFunction == null && widget.reload == null) {
      return null;
    }
    return widget.buttonText ?? Strings.refresh;
  }
}

class CommonSwitchStateSliver extends ConsumerStatefulWidget {
  const CommonSwitchStateSliver({
    super.key,
    required this.loaderState,
    required this.child,
    this.reload,
    this.customButtonFunction,
    this.loader,
    this.loaderIsSliver = false,
    this.errorTitle,
    this.errorMessage,
    this.buttonText,
    this.noData,
    this.noSearchData,
    this.errorWidget,
    this.topMargin,
    this.emptyMainAxisAlignment,
    this.emptyScreenTitle,
    this.emptyScreenDescription,
    this.emptyScreenImage,
    this.titleTextStyle,
    this.errorMessageTextStyle,
    this.backgroundColor,
    this.fillRemaining = true,
  });

  final LoaderState loaderState;
  final VoidCallback? reload;
  final VoidCallback? customButtonFunction;
  final Widget child;
  final Widget? loader;
  final bool loaderIsSliver;
  final String? errorTitle;
  final String? errorMessage;
  final String? buttonText;
  final Widget? noData;
  final Widget? noSearchData;
  final Widget? errorWidget;
  final double? topMargin;
  final MainAxisAlignment? emptyMainAxisAlignment;
  final String? emptyScreenTitle;
  final String? emptyScreenDescription;
  final String? emptyScreenImage;
  final TextStyle? titleTextStyle;
  final TextStyle? errorMessageTextStyle;
  final Color? backgroundColor;
  final bool fillRemaining;

  @override
  ConsumerState<CommonSwitchStateSliver> createState() =>
      _CommonSwitchStateSliverState();
}

class _CommonSwitchStateSliverState
    extends ConsumerState<CommonSwitchStateSliver> {
  bool? _lastNetworkState;

  @override
  Widget build(BuildContext context) {
    final connectivityAsync = ref.watch(connectivityStatusProvider);
    final hasNetwork = connectivityAsync.when(
      data: (connected) => connected,
      loading: () => true,
      error: (_, __) => true,
    );

    if (_lastNetworkState == false &&
        hasNetwork &&
        widget.loaderState != LoaderState.loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.reload?.call();
      });
    }
    _lastNetworkState = hasNetwork;

    if (!hasNetwork) {
      return _toSliver(
        CommonErrorState(
          title: Strings.connectionErrorTitle,
          message: Strings.connectionErrorDesc,
          imageAsset: Assets.lottieNoInternet,
          buttonText: _resolvedButtonText(),
          onRetry: widget.customButtonFunction ?? widget.reload,
          titleStyle: widget.titleTextStyle,
          messageStyle: widget.errorMessageTextStyle,
          topSpacing: widget.topMargin,
          mainAxisAlignment:
              widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
          backgroundColor: widget.backgroundColor,
          fillAvailableSpace: false,
        ),
      );
    }

    return switch (widget.loaderState) {
      LoaderState.loaded => widget.child,
      LoaderState.loading =>
        widget.loader != null
            ? (widget.loaderIsSliver
                  ? widget.loader!
                  : _toSliver(widget.loader!))
            : SliverFillRemaining(
                hasScrollBody: false,
                child: const CommonLoader(),
              ),
      LoaderState.noData =>
        widget.noData != null
            ? _toSliver(widget.noData!)
            : _toSliver(
                CommonEmptyState(
                  title: widget.emptyScreenTitle ?? Strings.noDataTitle,
                  message:
                      widget.emptyScreenDescription ?? Strings.noDataMessage,
                  imageAsset: widget.emptyScreenImage ?? Assets.lottieNoData,
                  buttonText: _resolvedButtonText(),
                  onPressed: widget.customButtonFunction ?? widget.reload,
                  titleStyle: widget.titleTextStyle,
                  messageStyle: widget.errorMessageTextStyle,
                  topSpacing: widget.topMargin,
                  mainAxisAlignment:
                      widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
                  backgroundColor: widget.backgroundColor,
                  fillAvailableSpace: false,
                ),
              ),
      LoaderState.noSearchData =>
        widget.noSearchData != null
            ? _toSliver(widget.noSearchData!)
            : _toSliver(
                CommonEmptyState(
                  title: widget.emptyScreenTitle ?? Strings.noResultsFound,
                  message:
                      widget.emptyScreenDescription ?? Strings.noResultsDesc,
                  imageAsset: widget.emptyScreenImage ?? Assets.lottieSearching,
                  titleStyle: widget.titleTextStyle,
                  messageStyle: widget.errorMessageTextStyle,
                  topSpacing: widget.topMargin,
                  mainAxisAlignment:
                      widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
                  backgroundColor: widget.backgroundColor,
                  fillAvailableSpace: false,
                ),
              ),
      LoaderState.error =>
        widget.errorWidget != null
            ? _toSliver(widget.errorWidget!)
            : _toSliver(
                CommonErrorState(
                  title: widget.errorTitle ?? Strings.errorTitle,
                  message: widget.errorMessage ?? Strings.errorDescription,
                  imageAsset: Assets.lottieError,
                  buttonText: _resolvedButtonText(),
                  onRetry: widget.customButtonFunction ?? widget.reload,
                  titleStyle: widget.titleTextStyle,
                  messageStyle: widget.errorMessageTextStyle,
                  topSpacing: widget.topMargin,
                  mainAxisAlignment:
                      widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
                  backgroundColor: widget.backgroundColor,
                  fillAvailableSpace: false,
                ),
              ),
      LoaderState.serverError => _toSliver(
        CommonErrorState(
          title: Strings.error500Title,
          message: Strings.error500Message,
          imageAsset: Assets.lottieError,
          buttonText: _resolvedButtonText(),
          onRetry: widget.customButtonFunction ?? widget.reload,
          titleStyle: widget.titleTextStyle,
          messageStyle: widget.errorMessageTextStyle,
          topSpacing: widget.topMargin,
          mainAxisAlignment:
              widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
          backgroundColor: widget.backgroundColor,
          fillAvailableSpace: false,
        ),
      ),
      LoaderState.networkError => _toSliver(
        CommonErrorState(
          title: Strings.connectionErrorTitle,
          message: Strings.connectionErrorDesc,
          imageAsset: Assets.lottieNoInternet,
          buttonText: _resolvedButtonText(),
          onRetry: widget.customButtonFunction ?? widget.reload,
          titleStyle: widget.titleTextStyle,
          messageStyle: widget.errorMessageTextStyle,
          topSpacing: widget.topMargin,
          mainAxisAlignment:
              widget.emptyMainAxisAlignment ?? MainAxisAlignment.center,
          backgroundColor: widget.backgroundColor,
          fillAvailableSpace: false,
        ),
      ),
    };
  }

  Widget _toSliver(Widget child) {
    if (widget.fillRemaining) {
      return SliverFillRemaining(hasScrollBody: false, child: child);
    }
    return SliverToBoxAdapter(child: child);
  }

  String? _resolvedButtonText() {
    if (widget.customButtonFunction == null && widget.reload == null) {
      return null;
    }
    return widget.buttonText ?? Strings.refresh;
  }
}
