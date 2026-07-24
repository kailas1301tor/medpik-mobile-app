// lib/utils/helpers/order_bill_pdf_loader.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:medpik/res/constants/app_constants.dart';

class OrderBillPdfLoadException implements Exception {
  const OrderBillPdfLoadException({
    required this.message,
    this.statusCode,
    this.resolvedUrl = '',
  });

  final String message;
  final int? statusCode;
  final String resolvedUrl;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => message;
}

String resolveBillPdfUrl(String rawUrl) {
  final trimmed = rawUrl.trim();
  if (trimmed.isEmpty) return '';

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final base = AppConstants.baseURL.replaceAll(RegExp(r'/+$'), '');
  if (trimmed.startsWith('/')) {
    return '$base$trimmed';
  }
  return '$base/$trimmed';
}

Map<String, String> billPdfRequestHeaders() {
  final token = AppConstants.accessToken;
  if (token != null && token.isNotEmpty) {
    return {'Authorization': 'Bearer $token'};
  }
  return const {};
}

bool isPdfBytes(Uint8List bytes) {
  if (bytes.length < 4) return false;
  return bytes[0] == 0x25 && // %
      bytes[1] == 0x50 && // P
      bytes[2] == 0x44 && // D
      bytes[3] == 0x46; // F
}

Future<Uint8List> loadOrderBillPdfBytes(String url) async {
  final resolvedUrl = resolveBillPdfUrl(url);
  if (resolvedUrl.isEmpty) {
    throw const OrderBillPdfLoadException(message: 'Bill PDF URL is empty');
  }

  debugPrint('🔵 ACTION: loadOrderBillPdfBytes $resolvedUrl');

  final response = await http.get(
    Uri.parse(resolvedUrl),
    headers: billPdfRequestHeaders(),
  );

  if (response.statusCode != 200) {
    debugPrint(
      '🔴 PDF download failed: status=${response.statusCode} url=$resolvedUrl',
    );
    throw OrderBillPdfLoadException(
      message: 'PDF download failed with status ${response.statusCode}',
      statusCode: response.statusCode,
      resolvedUrl: resolvedUrl,
    );
  }

  final bytes = response.bodyBytes;
  if (bytes.isEmpty) {
    debugPrint('🔴 PDF download failed: empty body url=$resolvedUrl');
    throw OrderBillPdfLoadException(
      message: 'PDF download returned empty body',
      statusCode: response.statusCode,
      resolvedUrl: resolvedUrl,
    );
  }

  if (!isPdfBytes(bytes)) {
    debugPrint('🔴 PDF download failed: invalid PDF header url=$resolvedUrl');
    throw OrderBillPdfLoadException(
      message: 'Downloaded file is not a valid PDF',
      statusCode: response.statusCode,
      resolvedUrl: resolvedUrl,
    );
  }

  debugPrint('🟢 PDF download success: ${bytes.length} bytes');
  return bytes;
}
