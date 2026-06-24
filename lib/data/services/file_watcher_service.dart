import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:statuses/constants/app_constants.dart';

class FileWatcherService {
  Timer? _pollTimer;
  Timer? _nativeDebounce;
  final List<StreamSubscription> _watchSubs = [];
  List<String> _lastSnapshot = [];
  final _controller = StreamController<List<String>>.broadcast();

  Stream<List<String>> get changes => _controller.stream;

  FileWatcherService();

  void start() {
    if (Platform.environment['FLUTTER_TEST'] == 'true') return;
    _tryStartNativeWatcher();
    _startPollingFallback();
  }

  void _tryStartNativeWatcher() {
    for (final path in AppConstants.whatsappStatusPaths) {
      final dir = Directory(path);
      if (!dir.existsSync()) continue;
      try {
        final sub = dir.watch(
          events: FileSystemEvent.create |
              FileSystemEvent.modify |
              FileSystemEvent.delete,
        ).listen(
          (_) => _onNativeEvent(),
          onError: (Object e) =>
              debugPrint('FileWatcher: native watcher error en $path: $e'),
        );
        _watchSubs.add(sub);
      } catch (e) {
        debugPrint('FileWatcher: no se pudo iniciar watcher nativo en $path: $e');
      }
    }
  }

  void _onNativeEvent() {
    _nativeDebounce?.cancel();
    _nativeDebounce = Timer(const Duration(seconds: 1), _notifyChange);
  }

  void _startPollingFallback() {
    _pollTimer = Timer.periodic(
      AppConstants.pollInterval,
      (_) async {
        final sw = Stopwatch()..start();
        final changedFiles = await _quickCheck();
        debugPrint('FileWatcherService (poll): ${sw.elapsedMilliseconds}ms');
        if (changedFiles != null) {
          _lastSnapshot = changedFiles;
          _controller.add(changedFiles);
        }
      },
    );
  }

  Future<void> _notifyChange() async {
    final changedFiles = await _quickCheck();
    if (changedFiles != null) {
      _lastSnapshot = changedFiles;
      _controller.add(changedFiles);
    }
  }

  Future<List<String>?> _quickCheck() async {
    final currentFiles = <_FileSnapshot>{};

    for (final path in AppConstants.whatsappStatusPaths) {
      final dir = Directory(path);
      if (!await dir.exists()) continue;

      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        try {
          currentFiles.add(_FileSnapshot(
            path: entity.path,
            lastModified: await entity.lastModified(),
          ));
        } catch (e) {
          debugPrint('FileWatcher: error al leer ${entity.path}: $e');
        }
      }
    }

    final sorted = currentFiles.toList()
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
    final currentList = sorted
        .map((e) => '${e.path}|${e.lastModified.millisecondsSinceEpoch}')
        .toList();

    if (_hasChanged(currentList)) return currentList;
    return null;
  }

  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
    for (final sub in _watchSubs) {
      sub.cancel();
    }
    _watchSubs.clear();
    _nativeDebounce?.cancel();
    _nativeDebounce = null;
  }

  bool _hasChanged(List<String> current) {
    if (current.length != _lastSnapshot.length) return true;
    for (var i = 0; i < current.length; i++) {
      if (current[i] != _lastSnapshot[i]) return true;
    }
    return false;
  }

  void dispose() {
    stop();
    _controller.close();
  }
}

class _FileSnapshot {
  final String path;
  final DateTime lastModified;
  const _FileSnapshot({required this.path, required this.lastModified});
}
