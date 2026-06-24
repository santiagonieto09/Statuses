import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/utils/file_utils.dart';
import 'package:statuses/data/repositories/status_repository.dart';
import 'package:statuses/data/services/file_watcher_service.dart';
import 'package:statuses/data/services/video_thumbnail_service.dart';

enum ViewMode { grid, list }

enum FilterMode { all, photo, video }

class StatusNotifier extends ChangeNotifier {
  final StatusRepository _repository;
  late final FileWatcherService _watcher;
  StreamSubscription? _subscription;

  List<StatusFile> _statuses = [];
  ViewMode _viewMode = ViewMode.grid;
  FilterMode _filterMode = FilterMode.all;
  bool _isLoading = false;
  String? _errorMessage;
  bool _needsSafFallback = false;

  List<StatusFile> get statuses => _statuses;
  int get statusCount => _statuses.length;
  ViewMode get viewMode => _viewMode;
  FilterMode get filterMode => _filterMode;

  List<StatusFile> get filteredStatuses {
    final sw = Stopwatch()..start();
    final result = () {
      switch (_filterMode) {
        case FilterMode.all:
          return _statuses;
        case FilterMode.photo:
          return _statuses.where((s) => s.mediaType == MediaType.image).toList();
        case FilterMode.video:
          return _statuses.where((s) => s.mediaType == MediaType.video).toList();
      }
    }();
    sw.stop();
    if (sw.elapsedMicroseconds > 200) {
      debugPrint('[PERF] filteredStatuses getter: ${sw.elapsedMicroseconds}us');
    }
    return result;
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get needsSafFallback => _needsSafFallback;

  StatusNotifier(this._repository) {
    final sw = Stopwatch()..start();
    _watcher = FileWatcherService();
    debugPrint('[PERF] StatusNotifier constructor + FileWatcherService: ${sw.elapsedMilliseconds}ms');
  }

  Future<void> loadStatuses() async {
    final task = developer.TimelineTask();
    task.start('loadStatuses');
    final totalSw = Stopwatch()..start();

    _isLoading = true;
    _errorMessage = null;

    final notifySw1 = Stopwatch()..start();
    notifyListeners();
    notifySw1.stop();
    debugPrint('[PERF] notifyListeners (isLoading=true): ${notifySw1.elapsedMicroseconds}us');

    try {
      final loadSw = Stopwatch()..start();
      final allStatuses = await _repository.loadStatuses();
      final loadTime = loadSw.elapsedMilliseconds;
      final videoCount = allStatuses.where((s) => s.mediaType == MediaType.video).length;
      final imageCount = allStatuses.where((s) => s.mediaType == MediaType.image).length;
      debugPrint(
        '[PERF] StatusNotifier.loadStatuses repository: ${loadTime}ms, '
        '${allStatuses.length} archivos '
        '($imageCount imágenes, $videoCount videos)',
      );

      final safSw = Stopwatch()..start();
      _needsSafFallback =
          allStatuses.isEmpty && await _repository.needsSafFallback();
      safSw.stop();
      debugPrint('[PERF] needsSafFallback: ${safSw.elapsedMilliseconds}ms');

      final watcherSw = Stopwatch()..start();
      _subscription?.cancel();
      _watcher.stop();
      _watcher.start();
      _subscription = _watcher.changes.listen((_) async {
        try {
          _statuses = await _repository.loadStatuses();
          notifyListeners();
        } catch (e) {
          _errorMessage = 'Watcher error: $e';
          notifyListeners();
        }
      });
      watcherSw.stop();
      debugPrint('[PERF] FileWatcher setup: ${watcherSw.elapsedMilliseconds}ms');

      _isLoading = false;
      _statuses = allStatuses.length > 20
          ? allStatuses.take(20).toList()
          : allStatuses;

      final notifySw2 = Stopwatch()..start();
      notifyListeners();
      notifySw2.stop();
      debugPrint('[PERF] notifyListeners (isLoading=false, ${_statuses.length} items): ${notifySw2.elapsedMicroseconds}us');

      if (allStatuses.length > 20) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final batchSw = Stopwatch()..start();
          _statuses = allStatuses;
          final notifySw3 = Stopwatch()..start();
          notifyListeners();
          notifySw3.stop();
          debugPrint('[PERF] notifyListeners (batch 2, ${_statuses.length} items): ${notifySw3.elapsedMicroseconds}us');
          debugPrint('[PERF] batch 2 setStatuses + notify: ${batchSw.elapsedMilliseconds}ms');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _precacheThumbnails();
          });
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _precacheThumbnails();
        });
      }
    } catch (e) {
      _errorMessage = 'Failed to load statuses: $e';
      _isLoading = false;
      notifyListeners();
    }

    final loadTotal = totalSw.elapsedMilliseconds;
    debugPrint('[PERF] StatusNotifier.loadStatuses total: ${loadTotal}ms');
    task.finish();
  }

  Future<bool> grantSafPermission() async {
    final uri = await _repository.requestSafPermission();
    if (uri != null) {
      _needsSafFallback = false;
      notifyListeners();
      await loadStatuses();
      return true;
    }
    return false;
  }

  void setViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void toggleViewMode() {
    _viewMode = _viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    notifyListeners();
  }

  void setFilterMode(FilterMode mode) {
    _filterMode = mode;
    notifyListeners();
  }

  Future<void> refresh() async {
    final sw = Stopwatch()..start();
    try {
      _statuses = await _repository.loadStatuses();
      _needsSafFallback =
          _statuses.isEmpty && await _repository.needsSafFallback();
      final notifySw = Stopwatch()..start();
      notifyListeners();
      notifySw.stop();
      debugPrint('[PERF] refresh notifyListeners: ${notifySw.elapsedMicroseconds}us');
      final elapsed = sw.elapsedMilliseconds;
      debugPrint('[PERF] StatusNotifier.refresh: ${elapsed}ms, ${_statuses.length} items');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _precacheThumbnails();
      });
    } catch (e) {
      _errorMessage = 'Refresh failed: $e';
      notifyListeners();
    }
  }

  void _precacheThumbnails() {
    final sw = Stopwatch()..start();
    final allVideos = _statuses
        .where((s) => s.mediaType == MediaType.video)
        .map((s) => s.filePath)
        .toList();
    if (allVideos.isEmpty) return;
    final previewCount = allVideos.length > 30 ? 30 : allVideos.length;
    VideoThumbnailService.instance.resetStats();
    VideoThumbnailService.instance.precache(allVideos, concurrency: 3);
    sw.stop();
    debugPrint(
      '[PERF] _precacheThumbnails lanzado: ${sw.elapsedMilliseconds}ms, '
      '$previewCount de ${allVideos.length} videos',
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _watcher.dispose();
    super.dispose();
  }
}
