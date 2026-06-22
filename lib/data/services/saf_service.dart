import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/utils/file_utils.dart';

/// Servicio de Storage Access Framework (SAF) para acceder a directorios
/// de otras aplicaciones en Android 11+ cuando el acceso directo por ruta
/// falla debido a restricciones del sistema.
class SafService {
  static const _channel = MethodChannel('com.statuses.statuses/saf');
  static const String _safCacheDir = 'saf_statuses_cache';

  /// Busca entre los permisos URI persistidos si ya se concedió acceso
  /// a la carpeta de estados de WhatsApp o WhatsApp Business.
  Future<Uri?> getGrantedUri() async {
    try {
      final List<dynamic>? perms =
          await _channel.invokeMethod('getPersistedPermissions');
      if (perms == null || perms.isEmpty) return null;

      for (final perm in perms) {
        final uriStr = (perm['uri'] as String? ?? '').toLowerCase();
        final isRead = perm['isRead'] as bool? ?? false;
        if (isRead &&
            (uriStr.contains('com.whatsapp') ||
                uriStr.contains('.statuses'))) {
          return Uri.parse(perm['uri'] as String);
        }
      }
    } on PlatformException {
      // Puede fallar en plataformas no-Android; se ignora silenciosamente
    }
    return null;
  }

  /// Abre el selector de directorio SAF del sistema.
  /// El usuario debe navegar hasta la carpeta .Statuses de WhatsApp.
  /// Retorna el URI seleccionado o null si el usuario canceló.
  Future<Uri?> requestPermission() async {
    try {
      final String? uriString =
          await _channel.invokeMethod('openDocumentTree');
      if (uriString == null) return null;
      return Uri.parse(uriString);
    } on PlatformException {
      return null;
    }
  }

  /// Lista los StatusFile accesibles bajo el [treeUri] SAF concedido.
  /// Los archivos se copian al directorio de caché de la app mediante
  /// streaming nativo, evitando cargar archivos grandes en memoria RAM.
  Future<List<StatusFile>> loadStatuses(Uri treeUri) async {
    final List<dynamic>? rawFiles = await _channel.invokeMethod(
      'listFiles',
      {'uri': treeUri.toString()},
    );
    if (rawFiles == null || rawFiles.isEmpty) return [];

    final cacheDir = await _ensureCacheDir();
    final result = <StatusFile>[];

    for (final raw in rawFiles) {
      final name = raw['name'] as String? ?? '';
      if (name.isEmpty) continue;

      final ext = name.contains('.')
          ? '.${name.split('.').last.toLowerCase()}'
          : '';
      final mediaType = FileUtils.detectMediaType(ext);
      if (mediaType == MediaType.unknown) continue;

      final fileUri = raw['uri'] as String;
      final fileSize = (raw['size'] as num?)?.toInt() ?? 0;
      final lastModifiedMs = (raw['lastModified'] as num?)?.toInt() ?? 0;

      final cachedFile = File('${cacheDir.path}/$name');
      if (!cachedFile.existsSync()) {
        // Copia en streaming nativo (Kotlin) sin cargar el archivo en RAM
        try {
          await _channel.invokeMethod('copyFileToCache', {
            'uri': fileUri,
            'destPath': cachedFile.path,
          });
        } on PlatformException {
          continue; // Si falla la copia, se omite este archivo
        }
      }

      if (!cachedFile.existsSync()) continue;

      result.add(StatusFile(
        filePath: cachedFile.path,
        fileName: name,
        extension: ext,
        fileSize: fileSize > 0 ? fileSize : cachedFile.lengthSync(),
        lastModified: lastModifiedMs > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastModifiedMs)
            : cachedFile.lastModifiedSync(),
        mediaType: mediaType,
      ));
    }

    result.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return result;
  }

  /// Libera el permiso SAF persistido (si se quiere revocar el acceso).
  Future<void> releasePermission(Uri uri) async {
    try {
      await _channel.invokeMethod('releasePermission', {'uri': uri.toString()});
    } on PlatformException {
      // Se ignora si ya no existe el permiso
    }
  }

  /// Elimina los archivos copiados al caché SAF.
  Future<void> clearCache() async {
    final base = await getTemporaryDirectory();
    final dir = Directory('${base.path}/$_safCacheDir');
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  Future<Directory> _ensureCacheDir() async {
    final base = await getTemporaryDirectory();
    final dir = Directory('${base.path}/$_safCacheDir');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }
}
