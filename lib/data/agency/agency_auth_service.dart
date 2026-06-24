import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/api_logger.dart';
import '../../core/device/device_info_service.dart';
import '../../models/agency/agent_session.dart';

class AgencyAuthService {
  AgencyAuthService._();

  static const _sessionKey = 'agency_agent_session';

  static AgentSession? _currentSession;

  static AgentSession? get currentSession => _currentSession;

  static bool get isLoggedIn => _currentSession != null;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _currentSession = AgentSession.fromStoredJson(json);
    } catch (_) {
      await prefs.remove(_sessionKey);
    }
  }

  static Future<AgentSession> login({
    required String username,
    required String password,
  }) async {
    final imeiId = await DeviceInfoService.getImeiId();
    final coordinates = await DeviceInfoService.getCoordinates();

    ApiLogger.logContext(
      'Agency login payload context',
      {
        'username': username.trim(),
        'imei_id': imeiId,
        'latitude_v': coordinates.latitude,
        'longitude_v': coordinates.longitude,
      },
    );

    try {
      if (ApiConfig.apiKey.isEmpty) {
        throw const ApiException(
          message:
              'API key is not configured. Set ApiConfig.apiKey in lib/core/api/api_config.dart',
        );
      }

      final response = await ApiClient.dio.post<Map<String, dynamic>>(
        ApiEndpoints.agency.login,
        data: {
          'username': username.trim(),
          'password': password.trim(),
          'imei_id': imeiId,
          'latitude_v': coordinates.latitude,
          'longitude_v': coordinates.longitude,
          'X-BANK-ID': ApiConfig.bankId,
          'X-BANK-TYPE': ApiConfig.bankType,
        },
      );

      final body = ApiClient.parseResponseBody(response.data);
      if (body == null) {
        throw const ApiException(message: 'Empty response from server');
      }

      final success = body['success'] == true;
      if (!success) {
        throw ApiClient.parseResponseBodyError(
          body,
          statusCode: response.statusCode,
          fallback: 'Login failed',
        );
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw const ApiException(message: 'Invalid login response from server');
      }

      final session = AgentSession.fromJson(data, username: username.trim());
      await _saveSession(session);

      ApiLogger.logContext(
        'Agency login success',
        {
          'agent_name': session.agentName,
          'account_no': session.accountNo,
          'branch_name': session.branchName,
          'responsecode': session.responseCode,
        },
      );

      return session;
    } catch (error) {
      if (error is ApiException) {
        ApiLogger.logException(error);
        rethrow;
      }
      throw ApiClient.parseError(error);
    }
  }

  static Future<void> _saveSession(AgentSession session) async {
    _currentSession = session;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  static Future<void> signOut() async {
    _currentSession = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
