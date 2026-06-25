import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

enum PermissionState { granted, denied, permanentlyDenied }

int? _cachedSdkVersion;
DeviceInfoPlugin? _deviceInfo;

Future<int> get androidSdkVersion async {
  if (!Platform.isAndroid) return 0;
  if (_cachedSdkVersion != null) return _cachedSdkVersion!;

  final prefs = await SharedPreferences.getInstance();
  _cachedSdkVersion = prefs.getInt('cached_android_sdk_version');
  if (_cachedSdkVersion != null) {
    debugPrint('[PERF] androidSdkVersion (SharedPreferences): SDK $_cachedSdkVersion');
    return _cachedSdkVersion!;
  }

  final sw = Stopwatch()..start();
  _deviceInfo ??= DeviceInfoPlugin();
  final androidInfo = await _deviceInfo!.androidInfo;
  _cachedSdkVersion = androidInfo.version.sdkInt;
  unawaited(prefs.setInt('cached_android_sdk_version', _cachedSdkVersion!));
  debugPrint('[PERF] androidSdkVersion (DeviceInfoPlugin, cached): ${sw.elapsedMilliseconds}ms -> SDK $_cachedSdkVersion');
  return _cachedSdkVersion!;
}

class PermissionService {
  PermissionState _checkPermissionState(ph.PermissionStatus status) {
    if (status.isGranted) return PermissionState.granted;
    if (status.isPermanentlyDenied) return PermissionState.permanentlyDenied;
    return PermissionState.denied;
  }

  Future<PermissionState> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final sdk = await androidSdkVersion;

      if (sdk >= 30) {
        final sw = Stopwatch()..start();
        final manage = await ph.Permission.manageExternalStorage.request();
        debugPrint('[PERF] Permission.manageExternalStorage.request: ${sw.elapsedMilliseconds}ms');
        if (manage.isGranted) return PermissionState.granted;
        if (manage.isPermanentlyDenied) {
          return PermissionState.permanentlyDenied;
        }
        return PermissionState.denied;
      } else {
        final sw = Stopwatch()..start();
        final status = await ph.Permission.storage.request();
        debugPrint('[PERF] Permission.storage.request: ${sw.elapsedMilliseconds}ms');
        return _checkPermissionState(status);
      }
    }
    return PermissionState.granted;
  }

  Future<PermissionState> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final sdk = await androidSdkVersion;

      if (sdk >= 30) {
        final sw = Stopwatch()..start();
        final status = await ph.Permission.manageExternalStorage.status;
        debugPrint('[PERF] Permission.manageExternalStorage.status: ${sw.elapsedMilliseconds}ms');
        return _checkPermissionState(status);
      } else {
        final sw = Stopwatch()..start();
        final status = await ph.Permission.storage.status;
        debugPrint('[PERF] Permission.storage.status: ${sw.elapsedMilliseconds}ms');
        return _checkPermissionState(status);
      }
    }
    return PermissionState.granted;
  }

  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}
