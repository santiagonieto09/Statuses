import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/services/download_service.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/utils/file_utils.dart';

class DownloadNotifier extends ChangeNotifier {
  static const String _autoSavePrefsKey = 'auto_save_enabled';
  static const String _autoSaveWarningKey = 'auto_save_warning_dismissed';

  final DownloadService _service = DownloadService();

  bool _isDownloading = false;
  String? _lastDownloadedPath;
  String? _error;

  List<StatusFile> _savedStatuses = [];
  Set<String> _cachedSavedFilePaths = {};
  final Set<String> _savedHashes = {};
  final Map<String, String> _hashCache = {};
  bool _isSavedLoading = false;

  bool _autoSaveEnabled = false;
  bool _autoSaveWarningDismissed = false;
  bool _isDeleting = false;
  bool _isSyncing = false;
  String _autoSaveStorageInfo = '';
  Timer? _autoSaveTimer;
  StatusNotifier? _statusNotifier;
  final Set<String> _processingPaths = {};
  final Set<String> _processedSourcePaths = {};

  bool get isDownloading => _isDownloading;
  String? get lastDownloadedPath => _lastDownloadedPath;
  String? get error => _error;

  List<StatusFile> get savedStatuses => _savedStatuses;
  int get savedCount => _savedStatuses.length;
  bool get isSavedLoading => _isSavedLoading;
  bool get hasSaved => _savedStatuses.isNotEmpty;
  Set<String> get savedFilePaths => _cachedSavedFilePaths;
  bool get isDeleting => _isDeleting;
  bool get isSyncing => _isSyncing;

  bool get autoSaveEnabled => _autoSaveEnabled;
  bool get autoSaveWarningDismissed => _autoSaveWarningDismissed;
  String get autoSaveStorageInfo => _autoSaveStorageInfo;

  DownloadNotifier();

  void attachStatusNotifier(StatusNotifier notifier) {
    _statusNotifier = notifier;
  }

  Future<void> _updateStorageInfo() async {
    _autoSaveStorageInfo = await _service.getStorageUsage();
  }

  Future<void> loadAutoSavePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _autoSaveEnabled = prefs.getBool(_autoSavePrefsKey) ?? false;
    _autoSaveWarningDismissed = prefs.getBool(_autoSaveWarningKey) ?? false;
    await _updateStorageInfo();
    if (_autoSaveEnabled) _startAutoSaveTimer();
    notifyListeners();
  }

  Future<void> dismissAutoSaveWarning() async {
    _autoSaveWarningDismissed = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSaveWarningKey, true);
  }

  Future<void> resetAutoSaveWarning() async {
    _autoSaveWarningDismissed = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSaveWarningKey, false);
  }

  Future<void> toggleAutoSave(bool enabled) async {
    if (_isSyncing) return;
    if (enabled) {
      _isSyncing = true;
      _autoSaveEnabled = true;
      notifyListeners();
      _processedSourcePaths.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoSavePrefsKey, true);
      await _syncOnAutoSaveEnable();
      _startAutoSaveTimer();
      _isSyncing = false;
      await _loadSaved();
      await _updateStorageInfo();
      notifyListeners();
    } else {
      _autoSaveEnabled = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoSavePrefsKey, false);
      _stopAutoSaveTimer();
      await _loadSaved();
      await _updateStorageInfo();
      notifyListeners();
    }
  }

  Future<void> _syncOnAutoSaveEnable() async {
    if (_statusNotifier == null) return;
    final statuses = _statusNotifier!.filteredStatuses;
    await _loadSaved();
    const batchSize = 5;
    for (int i = 0; i < statuses.length; i += batchSize) {
      final batch = statuses.skip(i).take(batchSize).toList();
      await Future.wait(batch.map((status) async {
        if (_processingPaths.contains(status.filePath)) return;
        if (_processedSourcePaths.contains(status.filePath)) return;
        if (_cachedSavedFilePaths.contains(status.fileName)) return;
        final alreadySaved = await _isAlreadySavedByHash(status);
        if (alreadySaved) {
          _processedSourcePaths.add(status.filePath);
          return;
        }
        _processingPaths.add(status.filePath);
        try {
          await _service.downloadStatus(status);
          _processedSourcePaths.add(status.filePath);
        } finally {
          _processingPaths.remove(status.filePath);
        }
      }));
    }
  }

  Future<bool> _isAlreadySavedByHash(StatusFile status) async {
    final sourceHash = await _getOrComputeHash(status.filePath);
    return _savedHashes.contains(sourceHash);
  }

  static const int _maxHashCacheSize = 500;
  final List<String> _hashCacheKeys = [];

  Future<String> _getOrComputeHash(String filePath) async {
    if (_hashCache.containsKey(filePath)) return _hashCache[filePath]!;
    final hash = await FileUtils.computeFileHash(filePath);
    _hashCache[filePath] = hash;
    _hashCacheKeys.add(filePath);
    if (_hashCacheKeys.length > _maxHashCacheSize) {
      final oldest = _hashCacheKeys.removeAt(0);
      _hashCache.remove(oldest);
    }
    return hash;
  }

  void _startAutoSaveTimer() {
    _stopAutoSaveTimer();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _checkAutoSave();
    });
  }

  void _stopAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }

  Future<void> _checkAutoSave() async {
    if (!_autoSaveEnabled || _statusNotifier == null || _isSyncing) return;
    await _loadSaved();
    const batchSize = 5;
    final statuses = _statusNotifier!.filteredStatuses;
    for (int i = 0; i < statuses.length; i += batchSize) {
      final batch = statuses.skip(i).take(batchSize).toList();
      await Future.wait(batch.map((status) async {
        if (_processingPaths.contains(status.filePath)) return;
        if (_processedSourcePaths.contains(status.filePath)) return;
        if (_cachedSavedFilePaths.contains(status.fileName)) return;
        final alreadySaved = await _isAlreadySavedByHash(status);
        if (alreadySaved) {
          _processedSourcePaths.add(status.filePath);
          return;
        }
        _processingPaths.add(status.filePath);
        try {
          await _service.downloadStatus(status);
          _processedSourcePaths.add(status.filePath);
        } finally {
          _processingPaths.remove(status.filePath);
        }
      }));
    }
    await _loadSaved();
    await _updateStorageInfo();
    notifyListeners();
  }

  Future<bool> isStatusSaved(String filePath) async {
    final fileName = filePath.split('/').last;
    if (_cachedSavedFilePaths.contains(fileName)) return true;
    try {
      final dir = await _service.getDownloadDirectory();
      final destFile = File('$dir/$fileName');
      if (await destFile.exists()) return true;
    } catch (_) {}
    return false;
  }

  Future<void> autoSaveStatus(StatusFile status) async {
    if (!_autoSaveEnabled || _isSyncing) return;
    if (_processingPaths.contains(status.filePath)) return;
    if (_processedSourcePaths.contains(status.filePath)) return;
    if (_cachedSavedFilePaths.contains(status.fileName)) return;
    _processingPaths.add(status.filePath);
    try {
      final alreadySaved = await _isAlreadySavedByHash(status);
      if (!alreadySaved) {
        await _service.downloadStatus(status);
      }
      _processedSourcePaths.add(status.filePath);
      await _updateStorageInfo();
    } catch (e) {
      debugPrint('Auto-save falló para ${status.fileName}: $e');
    } finally {
      _processingPaths.remove(status.filePath);
    }
  }

  Future<void> downloadStatus(StatusFile status) async {
    if (_cachedSavedFilePaths.contains(status.fileName)) {
      _error = 'El archivo ya está guardado';
      notifyListeners();
      return;
    }
    _isDownloading = true;
    _error = null;
    notifyListeners();

    try {
      _lastDownloadedPath = await _service.downloadStatus(status);
      await _loadSaved();
      await _updateStorageInfo();
    } catch (e) {
      _error = 'Download failed: $e';
    }

    _isDownloading = false;
    notifyListeners();
  }

  Future<void> loadSavedStatuses() async {
    _isSavedLoading = true;
    notifyListeners();
    await _loadSaved();
    _isSavedLoading = false;
    notifyListeners();
  }

  Future<void> _loadSaved() async {
    try {
      _savedStatuses = await _service.getSavedStatuses();
      _cachedSavedFilePaths = _savedStatuses.map((s) => s.fileName).toSet();
      _savedHashes.clear();
      for (final saved in _savedStatuses) {
        _savedHashes.add(await _getOrComputeHash(saved.filePath));
      }
    } catch (e) {
      _savedStatuses = [];
      _cachedSavedFilePaths = {};
      _savedHashes.clear();
    }
  }

  Future<void> shareStatus(StatusFile status) async {
    try {
      await _service.shareStatus(status);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Share failed: $e';
      notifyListeners();
    }
  }

  Future<String?> getDownloadDirectoryPath() async {
    try {
      return await _service.getDownloadDirectory();
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteSavedStatuses(List<String> paths) async {
    _isDeleting = true;
    notifyListeners();
    for (final path in paths) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
      _hashCache.remove(path);
      _hashCacheKeys.remove(path);
    }
    await _loadSaved();
    await _updateStorageInfo();
    _isDeleting = false;
    notifyListeners();
  }

  void clearState() {
    _lastDownloadedPath = null;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopAutoSaveTimer();
    super.dispose();
  }
}
