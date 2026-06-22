import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/services/download_service.dart';

class DownloadNotifier extends ChangeNotifier {
  final DownloadService _service = DownloadService();

  bool _isDownloading = false;
  String? _lastDownloadedPath;
  String? _error;

  List<StatusFile> _savedStatuses = [];
  bool _isSavedLoading = false;

  bool get isDownloading => _isDownloading;
  String? get lastDownloadedPath => _lastDownloadedPath;
  String? get error => _error;

  List<StatusFile> get savedStatuses => _savedStatuses;
  bool get isSavedLoading => _isSavedLoading;
  bool get hasSaved => _savedStatuses.isNotEmpty;

  /// Descarga (copia) un estado a Pictures/Statuses y recarga la lista guardada.
  Future<void> downloadStatus(StatusFile status) async {
    _isDownloading = true;
    _error = null;
    notifyListeners();

    try {
      _lastDownloadedPath = await _service.downloadStatus(status);
      // Recargar la lista para que aparezca de inmediato en "Saved"
      await _loadSaved();
    } catch (e) {
      _error = 'Download failed: $e';
    }

    _isDownloading = false;
    notifyListeners();
  }

  /// Carga (o recarga) la lista de archivos guardados en Pictures/Statuses.
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
    } catch (e) {
      _savedStatuses = [];
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

  /// Devuelve la ruta de la carpeta de descargas para mostrarla en la UI.
  Future<String?> getDownloadDirectoryPath() async {
    try {
      return await _service.getDownloadDirectory();
    } catch (_) {
      return null;
    }
  }

  /// Elimina los archivos guardados especificados del dispositivo y recarga la lista.
  /// Ignora errores individuales para no detener la eliminación del resto.
  Future<void> deleteSavedStatuses(List<String> paths) async {
    for (final path in paths) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {
        // Ignorar errores individuales, continuar con el resto
      }
    }
    await _loadSaved();
    notifyListeners();
  }

  void clearState() {
    _lastDownloadedPath = null;
    _error = null;
    notifyListeners();
  }
}
