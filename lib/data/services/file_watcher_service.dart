import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:statuses/constants/app_constants.dart';

class FileWatcherService {
  Timer? _timer;
  List<String> _lastSnapshot = [];
  final _controller = StreamController<List<String>>.broadcast();

  Stream<List<String>> get changes => _controller.stream;

  FileWatcherService(dynamic _);

  void start() {
    _timer = Timer.periodic(AppConstants.pollInterval, (_) async {
      final sw = Stopwatch()..start();
      final changedFiles = await _quickCheck();
      debugPrint('FileWatcherService: ${sw.elapsedMilliseconds}ms, dirs: ${AppConstants.whatsappStatusPaths.length}');
      if (changedFiles != null) {
        _lastSnapshot = changedFiles;
        _controller.add(changedFiles);
      }
    });
  }

  Future<List<String>?> _quickCheck() async {
    final currentFiles = <_FileSnapshot>{};

    for (final path in AppConstants.whatsappStatusPaths) {
      final dir = Directory(path);
      if (!await dir.exists()) continue;

      final entities = await dir.list().toList();
      for (final entity in entities) {
        if (entity is! File) continue;
        try {
          currentFiles.add(_FileSnapshot(
            path: entity.path,
            lastModified: await entity.lastModified(),
          ));
        } catch (_) {}
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
    _timer?.cancel();
    _timer = null;
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
