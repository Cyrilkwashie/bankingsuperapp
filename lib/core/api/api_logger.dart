import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

/// Logs every API request, response, and error to the debug console.
class ApiLogger extends Interceptor {
  static const _tag = '[API]';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_api_start'] = DateTime.now();

    debugPrint('');
    debugPrint('$_tag ┌── REQUEST ─────────────────────────────────');
    debugPrint('$_tag │ ${options.method} ${options.uri}');
    debugPrint('$_tag │ Headers:');
    for (final line in _formatHeaders(options.headers)) {
      debugPrint('$_tag │   $line');
    }

    if (options.queryParameters.isNotEmpty) {
      debugPrint('$_tag │ Query: ${_prettyJson(options.queryParameters)}');
    }

    if (options.data != null) {
      debugPrint('$_tag │ Body:');
      for (final line in _formatBody(options.data).split('\n')) {
        debugPrint('$_tag │   $line');
      }
    }

    debugPrint('$_tag └────────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final started = response.requestOptions.extra['_api_start'] as DateTime?;
    final durationMs = started == null
        ? '?'
        : DateTime.now().difference(started).inMilliseconds.toString();

    debugPrint('');
    debugPrint(
      '$_tag ┌── RESPONSE (${response.statusCode}) ${durationMs}ms ──',
    );
    debugPrint(
      '$_tag │ ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    debugPrint('$_tag │ Body:');
    for (final line in _formatBody(response.data).split('\n')) {
      debugPrint('$_tag │   $line');
    }
    debugPrint('$_tag └────────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final started = err.requestOptions.extra['_api_start'] as DateTime?;
    final durationMs = started == null
        ? '?'
        : DateTime.now().difference(started).inMilliseconds.toString();

    debugPrint('');
    debugPrint('$_tag ┌── ERROR (${durationMs}ms) ───────────────────');
    debugPrint('$_tag │ Type: ${err.type}');
    debugPrint('$_tag │ ${err.requestOptions.method} ${err.requestOptions.uri}');

    if (err.response != null) {
      debugPrint('$_tag │ Status: ${err.response?.statusCode}');
      debugPrint('$_tag │ Body:');
      for (final line in _formatBody(err.response?.data).split('\n')) {
        debugPrint('$_tag │   $line');
      }
    } else {
      debugPrint('$_tag │ Message: ${err.message}');
    }

    debugPrint('$_tag └────────────────────────────────────────────');
    handler.next(err);
  }

  static void logContext(String label, Map<String, dynamic> data) {
    debugPrint('');
    debugPrint('$_tag ┌── $label ──');
    for (final line in _formatBody(data).split('\n')) {
      debugPrint('$_tag │   $line');
    }
    debugPrint('$_tag └────────────────────────────────────────────');
  }

  static void logException(ApiException exception) {
    debugPrint('');
    debugPrint('$_tag ┌── PARSED ERROR ────────────────────────────');
    debugPrint('$_tag │ Message: ${exception.message}');
    if (exception.code != null) {
      debugPrint('$_tag │ Code: ${exception.code}');
    }
    if (exception.statusCode != null) {
      debugPrint('$_tag │ Status: ${exception.statusCode}');
    }
    debugPrint('$_tag └────────────────────────────────────────────');
  }

  static List<String> _formatHeaders(Map<String, dynamic> headers) {
    return headers.entries.map((entry) {
      final key = entry.key;
      final value = entry.value?.toString() ?? '';
      if (key.toLowerCase() == 'authorization') {
        return '$key: ${_maskAuthorization(value)}';
      }
      return '$key: $value';
    }).toList();
  }

  static String _maskAuthorization(String value) {
    if (value.isEmpty) return '(empty)';
    if (value.length <= 12) return '***';
    return '${value.substring(0, 6)}***${value.substring(value.length - 4)}';
  }

  static String _formatBody(dynamic data) {
    if (data == null) return '(empty)';

    dynamic sanitized = data;
    if (data is Map) {
      sanitized = _sanitizeMap(Map<String, dynamic>.from(data));
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          sanitized = _sanitizeMap(Map<String, dynamic>.from(decoded));
        }
      } catch (_) {
        return data;
      }
    }

    return _prettyJson(sanitized);
  }

  static Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map) {
    const sensitiveKeys = {'password', 'pin', 'otp', 'token', 'secret'};
    return map.map((key, value) {
      if (sensitiveKeys.contains(key.toLowerCase())) {
        return MapEntry(key, '***');
      }
      if (value is Map) {
        return MapEntry(
          key,
          _sanitizeMap(Map<String, dynamic>.from(value)),
        );
      }
      return MapEntry(key, value);
    });
  }

  static String _prettyJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
