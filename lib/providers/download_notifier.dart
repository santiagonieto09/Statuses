import 'package:flutter/foundation.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/services/download_service.dart';

class DownloadNotifier extends ChangeNotifier {
  final DownloadService _service = DownloadService();
  bool _isDownloading = false;
  String? _lastDownloadedPath;
  String? _error;

  bool get isDownloading => _isDownloading;
  String? get lastDownloadedPath => _lastDownloadedPath;
  String? get error => _error;

  Future<void> downloadStatus(StatusFile status) async {
    _isDownloading = true;
    _error = null;
    notifyListeners();

    try {
      _lastDownloadedPath = await _service.downloadStatus(status);
    } catch (e) {
      _error = 'Download failed: $e';
    }

    _isDownloading = false;
    notifyListeners();
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

  Future<void> saveToGallery(StatusFile status) async {
    _isDownloading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.saveToGallery(status);
      _lastDownloadedPath = 'Saved to gallery';
    } catch (e) {
      _error = 'Save failed: $e';
    }

    _isDownloading = false;
    notifyListeners();
  }

  void clearState() {
    _lastDownloadedPath = null;
    _error = null;
    notifyListeners();
  }
}
