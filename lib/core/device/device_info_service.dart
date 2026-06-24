import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_config.dart';

class DeviceInfoService {
  DeviceInfoService._();

  static const _deviceIdKey = 'agency_device_imei_id';

  /// Last IMEI/device ID sent to the API — useful for error messages.
  static String? lastResolvedImei;

  static Future<String> getImeiId() async {
    if (ApiConfig.deviceImeiOverride.isNotEmpty) {
      lastResolvedImei = ApiConfig.deviceImeiOverride;
      return lastResolvedImei!;
    }

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_deviceIdKey);
    if (cached != null && cached.isNotEmpty) {
      lastResolvedImei = cached;
      return cached;
    }

    final plugin = DeviceInfoPlugin();
    String deviceId;

    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      deviceId = info.id;
    } else if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      deviceId = info.identifierForVendor ?? 'ios-unknown';
    } else {
      deviceId = 'web-${DateTime.now().millisecondsSinceEpoch}';
    }

    await prefs.setString(_deviceIdKey, deviceId);
    lastResolvedImei = deviceId;
    return deviceId;
  }

  static Future<({String latitude, String longitude})> getCoordinates() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return (latitude: '0.0', longitude: '0.0');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );

      return (
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
    } catch (_) {
      return (latitude: '0.0', longitude: '0.0');
    }
  }
}
