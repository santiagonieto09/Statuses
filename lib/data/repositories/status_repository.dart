import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/services/saf_service.dart';
import 'package:statuses/utils/file_utils.dart';

class StatusRepository {
  final SafService _safService;

  StatusRepository({SafService? safService})
      : _safService = safService ?? SafService();

  List<StatusFile>? _metadataCache;
  DateTime? _cacheTime;
  static const _cacheTtl = Duration(seconds: 2);

  Future<List<String>> _discoverDirectories() async {
    final sw = Stopwatch()..start();
    final results = await Future.wait(
      AppConstants.whatsappStatusPaths.map((path) async {
        final exists = await Directory(path).exists();
        return (path: path, exists: exists);
      }),
    );
    final dirs = results.where((r) => r.exists).map((r) => r.path).toList();
    debugPrint('[PERF] StatusRepository._discoverDirectories: ${sw.elapsedMilliseconds}ms, '
        '${dirs.length} dirs encontrados de ${AppConstants.whatsappStatusPaths.length}');
    return dirs;
  }

  Future<List<StatusFile>> loadStatuses() async {
    final sw = Stopwatch()..start();

    if (_metadataCache != null && _cacheTime != null) {
      if (DateTime.now().difference(_cacheTime!) < _cacheTtl) {
        return _metadataCache!;
      }
    }

    final dirs = await _discoverDirectories();

    if (dirs.isNotEmpty) {
      final result = await Isolate.run(() => _loadFromDirectoriesSync(dirs));
      debugPrint('[PERF] StatusRepository.loadStatuses: ${sw.elapsedMilliseconds}ms (direct, ${result.length} files)');
      _metadataCache = result;
      _cacheTime = DateTime.now();
      return result;
    }

    final safUri = await _safService.getGrantedUri();
    if (safUri != null) {
      final result = await _safService.loadStatuses(safUri);
      debugPrint('[PERF] StatusRepository.loadStatuses: ${sw.elapsedMilliseconds}ms (SAF, ${result.length} files)');
      _metadataCache = result;
      _cacheTime = DateTime.now();
      return result;
    }

    debugPrint('[PERF] StatusRepository.loadStatuses: ${sw.elapsedMilliseconds}ms (no directories found)');
    return [];
  }

  Future<bool> hasStatusDirectory() async {
    final dirs = await _discoverDirectories();
    if (dirs.isNotEmpty) return true;
    final safUri = await _safService.getGrantedUri();
    return safUri != null;
  }

  Future<bool> needsSafFallback() async {
    final dirs = await _discoverDirectories();
    if (dirs.isNotEmpty) return false;
    final safUri = await _safService.getGrantedUri();
    return safUri == null;
  }

  Future<Uri?> requestSafPermission() => _safService.requestPermission();

  Future<void> copyToDirectory(StatusFile status, String destDir) async {
    final destFile = File('$destDir/${status.fileName}');
    final sourceFile = File(status.filePath);
    await sourceFile.copy(destFile.path);
  }
}

List<StatusFile> _loadFromDirectoriesSync(List<String> dirs) {
  final totalSw = Stopwatch()..start();
  final seenNames = <String>{};
  final statusFiles = <StatusFile>[];
  int statCount = 0;

  for (final dirPath in dirs) {
    final dirSw = Stopwatch()..start();
    int filesInDir = 0;

    try {
      final entities = Directory(dirPath).listSync(followLinks: false);
      final listTime = dirSw.elapsedMilliseconds;

      for (final entity in entities) {
        if (entity is! File) continue;
        final name = entity.uri.pathSegments.last;
        if (!seenNames.add(name.toLowerCase())) continue;

        final ext =
            name.contains('.') ? '.${name.split('.').last.toLowerCase()}' : '';
        final mediaType = FileUtils.detectMediaType(ext);
        if (mediaType != MediaType.image && mediaType != MediaType.video) {
          continue;
        }

        final stat = entity.statSync();
        statCount++;

        statusFiles.add(StatusFile(
          filePath: entity.path,
          fileName: name,
          extension: ext,
          fileSize: stat.size,
          lastModified: stat.modified,
          mediaType: mediaType,
        ));
        filesInDir++;
      }

      debugPrint('[PERF] StatusRepository._loadFromDirectories: dir=$dirPath '
          'listSync=${listTime}ms, files=$filesInDir');
    } catch (e) {
      debugPrint('[PERF] StatusRepository._loadFromDirectories: error en $dirPath: $e');
    }
  }

  statusFiles.sort((a, b) => b.lastModified.compareTo(a.lastModified));
  final total = totalSw.elapsedMilliseconds;
  debugPrint('[PERF] StatusRepository._loadFromDirectories: '
      'total=$total ms, '
      'statSync=$statCount archivos, '
      'media=${statusFiles.isNotEmpty ? (total / statusFiles.length).toStringAsFixed(1) : "0"}ms/archivo');
  return statusFiles;
}
