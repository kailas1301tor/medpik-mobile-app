// lib/src/profile/view/legal_document_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  WebViewController? _controller;
  var _isLoading = true;
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null || !uri.hasScheme) {
      _setPageState(loading: false, hasError: true);
      return;
    }

    try {
      final params = _createPlatformParams();
      final controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(ColorPalette.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => _setPageState(loading: true, hasError: false),
            onPageFinished: (_) => _setPageState(loading: false),
            onWebResourceError: (_) =>
                _setPageState(loading: false, hasError: true),
          ),
        );

      if (!mounted) return;
      setState(() => _controller = controller);
      await controller.loadRequest(uri);
    } catch (error, stackTrace) {
      debugPrint('🔴 LEGAL WEBVIEW ERROR: $error');
      debugPrint('$stackTrace');
      _setPageState(loading: false, hasError: true);
    }
  }

  PlatformWebViewControllerCreationParams _createPlatformParams() {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    }

    return const PlatformWebViewControllerCreationParams();
  }

  void _setPageState({required bool loading, bool hasError = false}) {
    if (!mounted) return;
    setState(() {
      _isLoading = loading;
      _hasError = hasError;
    });
  }

  Future<void> _retry() async {
    _setPageState(loading: true, hasError: false);
    final controller = _controller;
    if (controller == null) {
      await _initWebView();
      return;
    }

    final uri = Uri.tryParse(widget.url);
    if (uri == null || !uri.hasScheme) {
      _setPageState(loading: false, hasError: true);
      return;
    }

    try {
      await controller.loadRequest(uri);
    } catch (error) {
      debugPrint('🔴 LEGAL WEBVIEW RETRY ERROR: $error');
      _setPageState(loading: false, hasError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = _controller;

    return CommonScaffold(
      backgroundColor: colors.background,
      appBar: CommonAppBar(title: widget.title),
      body: Stack(
        children: [
          if (!_hasError && controller != null)
            WebViewWidget(controller: controller),
          if (_isLoading && !_hasError)
            const Center(child: CommonLoader()),
          if (_hasError)
            _LegalWebViewErrorView(onRetry: _retry),
        ],
      ),
    );
  }
}

class _LegalWebViewErrorView extends StatelessWidget {
  const _LegalWebViewErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.legalDocumentEmpty,
              textAlign: TextAlign.center,
              style: FontPalette.base400(14, color: colors.secondaryText),
            ),
            16.verticalSpace,
            PrimaryButton(
              text: Strings.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
