import 'package:flutter/material.dart';
import 'package:statuses/data/services/permission_service.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/ui/theme/app_theme.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key, this.initialState});

  final PermissionState? initialState;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  final PermissionService _permissionService = PermissionService();
  late PermissionState _state;
  late bool _isChecking;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final knownState = widget.initialState;
    if (knownState != null && knownState != PermissionState.granted) {
      _state = knownState;
      _isChecking = false;
    } else {
      _state = PermissionState.denied;
      _isChecking = true;
      _checkPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isChecking) {
      _checkPermission(showLoading: false);
    }
  }

  Future<void> _checkPermission({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() => _isChecking = true);
    }

    final state = await _permissionService.checkStoragePermission();
    if (!mounted) return;

    if (state == PermissionState.granted) {
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    }

    setState(() {
      _state = state;
      _isChecking = false;
    });
  }

  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);
    final state = await _permissionService.requestStoragePermission();
    if (mounted) {
      setState(() {
        _state = state;
        _isRequesting = false;
      });
      if (state == PermissionState.granted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  Future<void> _openSettings() async {
    await _permissionService.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _isChecking ? _buildChecking() : _buildContent(t),
      ),
    );
  }

  Widget _buildChecking() {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _buildContent(Translations t) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              size: 50,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            t.permission.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            t.permission.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const SizedBox(height: 32),
          if (_state == PermissionState.permanentlyDenied)
            _buildPermanentlyDenied(t)
          else
            _buildGrantButton(t),
          const Spacer(),
          Text(
            t.permission.privacy_note,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryText.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrantButton(Translations t) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: _isRequesting ? null : _requestPermission,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
          ),
        ),
        child: _isRequesting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                t.permission.grant_access,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildPermanentlyDenied(Translations t) {
    return Column(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
        const SizedBox(height: 16),
        Text(
          t.permission.permanently_denied,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: _openSettings,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
              ),
            ),
            child: Text(
              t.permission.open_settings,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
