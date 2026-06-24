import 'package:dio/dio.dart';

import 'api_config.dart';
import 'api_exception.dart';
import 'api_logger.dart';
import '../device/device_info_service.dart';

class ApiClient {
  ApiClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      validateStatus: (status) => status != null && status < 600,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache',
        'X-BANK-TYPE': ApiConfig.bankType,
        'X-BANK-ID': ApiConfig.bankId,
        if (ApiConfig.authorizationHeader != null)
          'Authorization': ApiConfig.authorizationHeader,
      },
    ),
  )..interceptors.add(ApiLogger());

  static Dio get dio => _dio;

  static Map<String, dynamic>? parseResponseBody(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  static ApiException parseResponseBodyError(
    Map<String, dynamic> body, {
    int? statusCode,
    String fallback = 'Request failed',
  }) {
    final topMessage = body['message']?.toString();
    final errorBody = body['error'];

    if (errorBody is Map<String, dynamic>) {
      final technical = errorBody['technicalMessage']?.toString();
      final message = _humanizeErrorMessage(
        technicalMessage: technical,
        fallback: errorBody['message']?.toString() ??
            topMessage ??
            fallback,
      );

      return ApiException(
        message: message,
        code: errorBody['code']?.toString(),
        statusCode: statusCode,
      );
    }

    if (topMessage != null && topMessage.isNotEmpty) {
      return ApiException(message: topMessage, statusCode: statusCode);
    }

    return ApiException(message: fallback, statusCode: statusCode);
  }

  static ApiException parseError(Object error) {
    if (error is DioException) {
      final response = error.response;
      final body = parseResponseBody(response?.data);
      if (body != null) {
        return parseResponseBodyError(
          body,
          statusCode: response?.statusCode,
        );
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ApiException(
            message: 'Connection timed out. Please try again.',
          );
        case DioExceptionType.connectionError:
          return const ApiException(
            message:
                'Unable to reach the server. Check your network connection.',
          );
        default:
          break;
      }

      return ApiException(
        message: error.message ?? 'Network request failed',
        statusCode: response?.statusCode,
      );
    }

    return ApiException(message: error.toString());
  }

  static String _humanizeErrorMessage({
    String? technicalMessage,
    required String fallback,
  }) {
    final technical = technicalMessage?.trim();
    if (technical == null || technical.isEmpty) return fallback;

    if (technical.contains('Device not recognized')) {
      return 'This device is not registered for agency banking. '
          'Ask your administrator to register IMEI: '
          '${DeviceInfoService.lastResolvedImei ?? 'unknown'}';
    }

    final pipeParts = technical.split('|');
    if (pipeParts.length > 1) {
      final lastPart = pipeParts.last.trim();
      if (lastPart.isNotEmpty) return lastPart;
    }

    return technical;
  }
}
