// lib/utils/helpers/network_logger.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug-only network logger — box borders + summary, plain JSON body.
class NetworkLogger {
  NetworkLogger._();

  static const _indent = '│  ';

  static void request({
    required String method,
    required String url,
    String? token,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) {
    if (!kDebugMode) return;

    _boxTop('🌐 REQUEST', method);
    _line('URL', url);
    _line('Auth', _maskToken(token));
    if (queryParameters != null && queryParameters.isNotEmpty) {
      _line('Query', queryParameters.toString());
    }
    if (body != null) {
      _divider();
      if (body is FormData) {
        _section('FORM DATA');
        for (final field in body.fields) {
          _bodyLine('${field.key} = ${field.value}');
        }
      } else {
        _section('BODY');
        _jsonBody(body);
      }
    }
    _boxBottom();
  }

  static void response({
    required int? statusCode,
    required String method,
    required String path,
    required int durationMs,
    dynamic data,
  }) {
    if (!kDebugMode) return;

    final ok = statusCode != null && statusCode >= 200 && statusCode < 300;
    final icon = ok ? '✅' : '⚠️';
    final status = statusCode?.toString() ?? '?';
    final timing = _formatDuration(durationMs);

    _boxTop('$icon RESPONSE', '$status · $timing · $method $path');
    _printSummary(data);
    if (data != null) {
      _divider();
      _section('BODY');
      _jsonBody(data);
    }
    _boxBottom();
  }

  static void error({
    required int? statusCode,
    required String method,
    required String path,
    required int durationMs,
    dynamic data,
    String? message,
  }) {
    if (!kDebugMode) return;

    final status = statusCode?.toString() ?? '?';
    final timing = _formatDuration(durationMs);

    _boxTop('❌ ERROR', '$status · $timing · $method $path');
    if (message != null && message.isNotEmpty) {
      _line('Message', message);
    }
    if (data != null) {
      _divider();
      _section('ERROR BODY');
      _jsonBody(data);
    }
    _boxBottom();
  }

  // ── Summary ────────────────────────────────────────────────────────────

  static void _printSummary(dynamic data) {
    final map = _asMap(data);
    if (map == null) return;

    final apiMessage = map['message'];
    if (apiMessage != null) {
      _line('message', apiMessage.toString());
    }

    final payload = _unwrapData(map);
    if (payload == null) return;

    final counts = <String, int>{};
    for (final entry in payload.entries) {
      if (entry.value is List) {
        counts[entry.key] = (entry.value as List).length;
      }
    }
    if (counts.isEmpty) return;

    _divider();
    _section('SUMMARY');
    for (final entry in counts.entries) {
      _line(entry.key, '${entry.value} item(s)');
    }
  }

  static Map<String, dynamic>? _unwrapData(Map<String, dynamic> root) {
    final results = root['results'];
    if (results is Map) {
      final data = results['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
    }
    final data = root['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return root;
  }

  // ── Box layout ─────────────────────────────────────────────────────────

  static void _boxTop(String title, String subtitle) {
    debugPrint('┌─ $title  $subtitle');
  }

  static void _boxBottom() {
    debugPrint('└─');
  }

  static void _divider() {
    debugPrint('├${'─' * 58}');
  }

  static void _section(String label) {
    debugPrint('$_indent$label');
  }

  static void _line(String key, String value) {
    debugPrint('$_indent${key.padRight(12)} $value');
  }

  static void _bodyLine(String text) {
    debugPrint('$_indent  $text');
  }

  static void _jsonBody(dynamic data) {
    final pretty = _prettyJson(data);
    for (final line in pretty.split('\n')) {
      _bodyLine(line);
    }
  }

  static String _prettyJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  static Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  static String _maskToken(String? token) {
    if (token == null || token.isEmpty) return '[none]';
    final raw = token.startsWith('Bearer ') ? token.substring(7) : token;
    if (raw.length <= 10) return 'Bearer •••';
    return 'Bearer •••${raw.substring(raw.length - 6)}';
  }

  static String _formatDuration(int ms) {
    if (ms < 0) return '?ms';
    if (ms < 1000) return '${ms}ms';
    return '${(ms / 1000).toStringAsFixed(1)}s';
  }
}
