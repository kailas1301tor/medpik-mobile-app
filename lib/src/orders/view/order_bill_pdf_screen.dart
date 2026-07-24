// lib/src/orders/view/order_bill_pdf_screen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/res/styles/color_palette.dart';
import 'package:medpik/res/styles/font_palette.dart';
import 'package:medpik/utils/common_widgets/common_app_bar.dart';
import 'package:medpik/utils/common_widgets/common_loader.dart';
import 'package:medpik/utils/common_widgets/common_scaffold.dart';
import 'package:medpik/utils/common_widgets/primary_button.dart';
import 'package:medpik/utils/helpers/order_bill_pdf_loader.dart';

class OrderBillPdfScreen extends StatefulWidget {
  const OrderBillPdfScreen({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  State<OrderBillPdfScreen> createState() => _OrderBillPdfScreenState();
}

class _OrderBillPdfScreenState extends State<OrderBillPdfScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadPdf);
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pdfBytes = null;
    });

    try {
      final bytes = await loadOrderBillPdfBytes(widget.pdfUrl);
      if (!mounted) return;
      setState(() {
        _pdfBytes = bytes;
        _isLoading = false;
      });
    } on OrderBillPdfLoadException catch (error) {
      debugPrint('🔴 PDF VIEWER ERROR: $error');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.isNotFound
            ? Strings.billPdfNotFoundError
            : Strings.billPdfLoadError;
      });
    } catch (error) {
      debugPrint('🔴 PDF VIEWER ERROR: $error');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = Strings.billPdfLoadError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return CommonScaffold(
      appBar: const CommonAppBar(title: Strings.billPdfTitle),
      backgroundColor: colors.background,
      body: switch ((_isLoading, _errorMessage, _pdfBytes)) {
        (true, _, _) => const Center(child: CommonLoader()),
        (_, final message?, _) => _BillPdfErrorView(
            message: message,
            onRetry: _loadPdf,
          ),
        (_, _, final bytes?) => SfPdfViewer.memory(bytes),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _BillPdfErrorView extends StatelessWidget {
  const _BillPdfErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
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
            Icon(
              Icons.picture_as_pdf_outlined,
              size: 48.r,
              color: colors.secondaryText,
            ),
            16.verticalSpace,
            Text(
              message,
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
