import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:flutter/foundation.dart';

enum PermissionState { granted, denied, permanentlyDenied }

class PermissionService {
  int? _cachedSdkVersion;

  PermissionState _checkPermissionState(ph.PermissionStatus status) {
    if (status.isGranted) return PermissionState.granted;
    if (status.isPermanentlyDenied) return PermissionState.permanentlyDenied;
    return PermissionState.denied;
  }

  Future<int> _androidSdkVersion() async {
    if (!Platform.isAndroid) return 0;
    if (_cachedSdkVersion != null) return _cachedSdkVersion!;
    final sw = Stopwatch()..start();
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    _cachedSdkVersion = androidInfo.version.sdkInt;
    debugPrint('[PERF] DeviceInfoPlugin.androidInfo: ${sw.elapsedMilliseconds}ms');
    return _cachedSdkVersion!;
  }

  Future<PermissionState> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final sdk = await _androidSdkVersion();

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
      final sdk = await _androidSdkVersion();

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
