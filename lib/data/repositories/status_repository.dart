import 'dart:io';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/services/saf_service.dart';
import 'package:statuses/utils/file_utils.dart';

class StatusRepository {
  final SafService _safService;

  StatusRepository({SafService? safService})
      : _safService = safService ?? SafService();

  /// Descubre las rutas directas accesibles en el sistema de archivos.
  Future<List<String>> _discoverDirectories() async {
    final dirs = <String>[];
    for (final path in AppConstants.whatsappStatusPaths) {
      final dir = Directory(path);
      if (await dir.exists()) {
        dirs.add(path);
      }
    }
    return dirs;
  }

  /// Carga los estados disponibles.
  /// Primero intenta acceso directo por ruta; si no encuentra ningún
  /// directorio válido, usa el fallback SAF (si el usuario ya concedió acceso).
  Future<List<StatusFile>> loadStatuses() async {
    final dirs = await _discoverDirectories();

    if (dirs.isNotEmpty) {
      return _loadFromDirectories(dirs);
    }

    // Fallback: Storage Access Framework
    final safUri = await _safService.getGrantedUri();
    if (safUri != null) {
      return _safService.loadStatuses(safUri);
    }

    return [];
  }

  Future<List<StatusFile>> _loadFromDirectories(List<String> dirs) async {
    final files = <StatusFile>[];
    final seenNames = <String>{}; // deduplicación por nombre de archivo

    for (final dir in dirs) {
      final dirEntity = Directory(dir);
      if (!await dirEntity.exists()) continue;

      await for (final entity in dirEntity.list()) {
        if (entity is! File) continue;
        final file = entity;
        final name = file.uri.pathSegments.last;
        // Si ya procesamos un archivo con este nombre (otra ruta al mismo dir), saltar
        if (!seenNames.add(name.toLowerCase())) continue;

        final ext =
            name.contains('.') ? '.${name.split('.').last.toLowerCase()}' : '';

        final mediaType = FileUtils.detectMediaType(ext);
        // Solo procesar imagenes y videos
        if (mediaType != MediaType.image && mediaType != MediaType.video)
          continue;

        files.add(StatusFile(
          filePath: file.path,
          fileName: name,
          extension: ext,
          fileSize: await file.length(),
          lastModified: await file.lastModified(),
          mediaType: mediaType,
        ));
      }
    }

    files.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return files;
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
