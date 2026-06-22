import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;

class MediaCacheService {
  static final MediaCacheService _instance = MediaCacheService._();
  static MediaCacheService get instance => _instance;
  MediaCacheService._();

  final BaseCacheManager _cacheManager = DefaultCacheManager();

  Future<File?> getThumbnail(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;

    final cacheKey = 'thumb_${p.basename(filePath)}';
    final cached = await _cacheManager.getFileFromCache(cacheKey);
    if (cached != null && await cached.file.exists()) {
      return cached.file;
    }
    return null;
  }

  Future<void> cacheFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    final bytes = await file.readAsBytes();
    if (bytes.length <= 100 * 1024 * 1024) {
      await _cacheManager.putFile(filePath, bytes);
    }
  }

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
