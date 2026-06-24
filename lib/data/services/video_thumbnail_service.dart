import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailService {
  static final VideoThumbnailService _instance = VideoThumbnailService._();
  static VideoThumbnailService get instance => _instance;
  VideoThumbnailService._();

  static const _cacheDir = 'video_thumbnails';

  final Map<String, String?> _memoryCache = {};
  final Map<String, Future<String?>> _pending = {};

  int _cacheHits = 0;
  int _generated = 0;
  int _errors = 0;
  int _diskHits = 0;

  Future<String?> getThumbnail(String videoPath) async {
    if (_memoryCache.containsKey(videoPath)) {
      _cacheHits++;
      return _memoryCache[videoPath];
    }
    if (_pending.containsKey(videoPath)) {
      return _pending[videoPath];
    }
    final future = _generate(videoPath);
    _pending[videoPath] = future;
    return future;
  }

  void precache(List<String> videoPaths, {int concurrency = 3}) {
    int index = 0;
    void processNext() {
      if (index >= videoPaths.length) {
        printStats();
        return;
      }
      final path = videoPaths[index++];
      getThumbnail(path).then((_) => processNext());
    }
    final count = concurrency < videoPaths.length
        ? concurrency
        : videoPaths.length;
    for (int i = 0; i < count; i++) {
      processNext();
    }
  }

  Future<String?> _generate(String videoPath) async {
    try {
      final base = await getTemporaryDirectory();
      final dir = Directory('${base.path}/$_cacheDir');
      if (!dir.existsSync()) dir.createSync(recursive: true);

      final name = '${p.basenameWithoutExtension(videoPath)}.jpg';
      final thumbFile = File('${dir.path}/$name');

      if (thumbFile.existsSync()) {
        final bytes = await thumbFile.readAsBytes();
        if (bytes.isNotEmpty) {
          _diskHits++;
          _memoryCache[videoPath] = thumbFile.path;
          debugPrint('VideoThumbnailService: miniatura en disco para $videoPath');
          return thumbFile.path;
        }
      }

      final sw = Stopwatch()..start();
      final bytes = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );
      sw.stop();

      if (bytes == null || bytes.isEmpty) {
        _errors++;
        debugPrint('VideoThumbnailService: sin datos para $videoPath');
        return null;
      }

      await thumbFile.writeAsBytes(bytes);
      _generated++;
      _memoryCache[videoPath] = thumbFile.path;
      debugPrint(
        'VideoThumbnailService: generada miniatura para $videoPath '
        'en ${sw.elapsedMilliseconds}ms',
      );
      return thumbFile.path;
    } catch (e, st) {
      _errors++;
      debugPrint('VideoThumbnailService: error para $videoPath: $e\n$st');
      return null;
    }
  }

  void printStats() {
    debugPrint(
      'VideoThumbnailService stats: '
      'cacheHits=$_cacheHits, '
      'diskHits=$_diskHits, '
      'generated=$_generated, '
      'errors=$_errors',
    );
  }

  void resetStats() {
    _cacheHits = 0;
    _diskHits = 0;
    _generated = 0;
    _errors = 0;
  }
}
