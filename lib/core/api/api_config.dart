import 'dart:convert';

/// Environment and shared API settings.
///
/// For endpoint paths, use [ApiEndpoints] instead.
class ApiConfig {
  ApiConfig._();

  /// Server host — change this when switching environments (dev/staging/prod).
  static const baseUrl = 'http://10.203.14.33:8182';

  static const bankType = 'LOCAL';
  static const bankId = 'USG';

  /// Gateway API key for Basic authentication.
  /// The server expects: Authorization: Basic base64("apiKey:apiSecret")
  static const apiKey = 'testPC';
  static const apiSecret = 'test_PC';

  /// Optional: use a backend-registered device IMEI instead of the auto-detected one.
  /// Leave empty in production — set only for testing on simulators/unregistered devices.
  static const deviceImeiOverride = '8901254';

  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  static String? get authorizationHeader {
    if (apiKey.isEmpty) return null;
    final credentials = '$apiKey:$apiSecret';
    final encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }
}
