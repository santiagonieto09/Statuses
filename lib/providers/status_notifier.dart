import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/repositories/status_repository.dart';
import 'package:statuses/data/services/file_watcher_service.dart';

enum ViewMode { grid, list }

class StatusNotifier extends ChangeNotifier {
  final StatusRepository _repository;
  late final FileWatcherService _watcher;
  StreamSubscription? _subscription;

  List<StatusFile> _statuses = [];
  ViewMode _viewMode = ViewMode.grid;
  bool _isLoading = false;
  String? _errorMessage;

  List<StatusFile> get statuses => _statuses;
  ViewMode get viewMode => _viewMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  StatusNotifier(this._repository) {
    _watcher = FileWatcherService(_repository);
  }

  Future<void> loadStatuses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _statuses = await _repository.loadStatuses();
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
    } catch (e) {
      _errorMessage = 'Failed to load statuses: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void toggleViewMode() {
    _viewMode = _viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      _statuses = await _repository.loadStatuses();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Refresh failed: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _watcher.dispose();
    super.dispose();
  }
}
