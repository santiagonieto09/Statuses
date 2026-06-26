import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:statuses/data/services/permission_service.dart';
import 'package:statuses/ui/theme/app_theme.dart';

class AppStartupScreen extends StatefulWidget {
  const AppStartupScreen({super.key});

  @override
  State<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  final PermissionService _permissionService = PermissionService();
  late final developer.TimelineTask _startupTask;

  @override
  void initState() {
    super.initState();
    _startupTask = developer.TimelineTask()..start('AppStartupScreen');
    debugPrint('[PERF] AppStartupScreen.initState');
    final sw = Stopwatch()..start();
    _resolveInitialRoute();
    debugPrint('[PERF] AppStartupScreen._resolveInitialRoute lanzado: ${sw.elapsedMilliseconds}ms');
  }

  Future<void> _resolveInitialRoute() async {
    final sw = Stopwatch()..start();
    final state = await _permissionService.checkStoragePermission();
    final permTime = sw.elapsedMilliseconds;
    debugPrint('[PERF] checkStoragePermission completado: ${permTime}ms -> $state');

    if (!mounted) return;

    if (state == PermissionState.granted) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed(
        '/permission',
        arguments: state,
      );
    }

    final navTime = sw.elapsedMilliseconds;
    debugPrint('[PERF] startup completado: ${navTime}ms');
    _startupTask.finish();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[PERF] AppStartupScreen.build');
    return const Scaffold(
      backgroundColor: AppColors.accentGreen,
    );
  }
}
