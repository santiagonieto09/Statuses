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
  bool _needsSafFallback = false;

  List<StatusFile> get statuses => _statuses;
  ViewMode get viewMode => _viewMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// True cuando el acceso directo por ruta falla y no hay permiso SAF previo.
  /// En este caso la UI debe mostrar el botón "Seleccionar carpeta" (SAF).
  bool get needsSafFallback => _needsSafFallback;

  StatusNotifier(this._repository) {
    _watcher = FileWatcherService(_repository);
  }

  Future<void> loadStatuses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _statuses = await _repository.loadStatuses();
      _needsSafFallback = _statuses.isEmpty && await _repository.needsSafFallback();

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

  /// Abre el selector de carpeta SAF del sistema.
  /// Si el usuario selecciona una carpeta válida, recarga los estados.
  /// Retorna true si se concedió acceso, false si el usuario canceló.
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

  Future<void> refresh() async {
    try {
      _statuses = await _repository.loadStatuses();
      _needsSafFallback = _statuses.isEmpty && await _repository.needsSafFallback();
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
