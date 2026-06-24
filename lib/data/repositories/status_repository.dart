import 'dart:io';
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

  /// Descubre las rutas directas accesibles en el sistema de archivos.
  Future<List<String>> _discoverDirectories() async {
    final sw = Stopwatch()..start();
    final results = await Future.wait(
      AppConstants.whatsappStatusPaths.map((path) async {
        final exists = await Directory(path).exists();
        return (path: path, exists: exists);
      }),
    );
    final dirs = results.where((r) => r.exists).map((r) => r.path).toList();
    debugPrint('StatusRepository._discoverDirectories: ${sw.elapsedMilliseconds}ms, '
        '${dirs.length} dirs encontrados de ${AppConstants.whatsappStatusPaths.length}');
    return dirs;
  }

  /// Carga los estados disponibles.
  /// Primero intenta acceso directo por ruta; si no encuentra ningún
  /// directorio válido, usa el fallback SAF (si el usuario ya concedió acceso).
  Future<List<StatusFile>> loadStatuses() async {
    final sw = Stopwatch()..start();

    if (_metadataCache != null && _cacheTime != null) {
      if (DateTime.now().difference(_cacheTime!) < _cacheTtl) {
        return _metadataCache!;
      }
    }

    final dirs = await _discoverDirectories();

    if (dirs.isNotEmpty) {
      final result = await _loadFromDirectories(dirs);
      debugPrint('StatusRepository.loadStatuses: ${sw.elapsedMilliseconds}ms (direct, ${result.length} files)');
      _metadataCache = result;
      _cacheTime = DateTime.now();
      return result;
    }

    // Fallback: Storage Access Framework
    final safUri = await _safService.getGrantedUri();
    if (safUri != null) {
      final result = await _safService.loadStatuses(safUri);
      debugPrint('StatusRepository.loadStatuses: ${sw.elapsedMilliseconds}ms (SAF, ${result.length} files)');
      _metadataCache = result;
      _cacheTime = DateTime.now();
      return result;
    }

    debugPrint('StatusRepository.loadStatuses: ${sw.elapsedMilliseconds}ms (no directories found)');
    return [];
  }

  Future<List<StatusFile>> _loadFromDirectories(List<String> dirs) async {
    final totalSw = Stopwatch()..start();
    final seenNames = <String>{};
    final allFiles = <_FileEntry>[];

    for (final dir in dirs) {
      final dirSw = Stopwatch()..start();

      try {
        final entities = await Directory(dir).list().toList();
        final listTime = dirSw.elapsedMilliseconds;
        int filesInDir = 0;

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

          allFiles.add(_FileEntry(
            file: entity,
            name: name,
            ext: ext,
            mediaType: mediaType,
          ));
          filesInDir++;
        }

        debugPrint('StatusRepository._loadFromDirectories: dir=$dir '
            'list=${listTime}ms, files=$filesInDir');
      } catch (e) {
        debugPrint('StatusRepository._loadFromDirectories: error en $dir: $e');
      }
    }

    final statSw = Stopwatch()..start();
    final statusFiles = await Future.wait(
      allFiles.map((e) => _buildStatusFile(e)),
    );
    final statTime = statSw.elapsedMilliseconds;

    statusFiles.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    debugPrint('StatusRepository._loadFromDirectories: '
        'total=${totalSw.elapsedMilliseconds}ms, '
        'stat=${statTime}ms para ${statusFiles.length} archivos, '
        'media=${statusFiles.isNotEmpty ? (statTime / statusFiles.length).toStringAsFixed(1) : "0"}ms/archivo');
    return statusFiles;
  }

  Future<StatusFile> _buildStatusFile(_FileEntry entry) async {
    final stat = await entry.file.stat();
    return StatusFile(
      filePath: entry.file.path,
      fileName: entry.name,
      extension: entry.ext,
      fileSize: stat.size,
      lastModified: stat.modified,
      mediaType: entry.mediaType,
    );
  }

  /// Retorna true si hay algún directorio accesible (directo o vía SAF).
  Future<bool> hasStatusDirectory() async {
    final dirs = await _discoverDirectories();
    if (dirs.isNotEmpty) return true;
    final safUri = await _safService.getGrantedUri();
    return safUri != null;
  }

  /// Indica si el acceso directo falla Y tampoco hay permiso SAF concedido,
  /// es decir, si se debe mostrar al usuario la opción de conceder acceso SAF.
  Future<bool> needsSafFallback() async {
    final dirs = await _discoverDirectories();
    if (dirs.isNotEmpty) return false;
    final safUri = await _safService.getGrantedUri();
    return safUri == null;
  }

  /// Solicita al usuario que seleccione la carpeta .Statuses mediante SAF.
  Future<Uri?> requestSafPermission() => _safService.requestPermission();

  /// Copia un archivo de estado al directorio de destino.
  Future<void> copyToDirectory(StatusFile status, String destDir) async {
    final destFile = File('$destDir/${status.fileName}');
    final sourceFile = File(status.filePath);
    await sourceFile.copy(destFile.path);
  }
}

class _FileEntry {
  final File file;
  final String name;
  final String ext;
  final MediaType mediaType;

  const _FileEntry({
    required this.file,
    required this.name,
    required this.ext,
    required this.mediaType,
  });
}
