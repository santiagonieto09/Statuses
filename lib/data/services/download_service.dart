import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/utils/file_utils.dart';

class DownloadService {
  static const _channel = MethodChannel('com.statuses.statuses/saf');

  /// Devuelve la ruta del directorio público donde se guardan los estados.
  /// En Android usa Pictures/Statuses (visible en Galería y Archivos).
  /// Si el canal nativo falla, deriva la ruta desde el directorio privado de la app.
  Future<String> getDownloadDirectory() async {
    String basePath;
    try {
      final String? path = await _channel.invokeMethod('getPublicPicturesPath');
      basePath = path ?? _derivedPublicPath(await getExternalStorageDirectory());
    } on PlatformException {
      basePath = _derivedPublicPath(await getExternalStorageDirectory());
    }

    final dir = Directory('$basePath/${AppConstants.savedDirName}');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  /// Deriva /storage/emulated/0/Pictures desde la ruta privada de la app.
  String _derivedPublicPath(Directory? extDir) {
    if (extDir == null) return '/storage/emulated/0/Pictures';
    // extDir.path = /storage/emulated/0/Android/data/com.statuses.statuses/files
    return '${extDir.path.split('/Android/').first}/Pictures';
  }

  /// Descarga (copia) un estado a la carpeta pública Pictures/Statuses.
  /// Retorna la ruta completa donde se guardó el archivo.
  Future<String> downloadStatus(StatusFile status) async {
    final destDir = await getDownloadDirectory();
    final sourceFile = File(status.filePath);
    final destPath = '$destDir/${status.fileName}';
    final destFile = File(destPath);

    if (await destFile.exists()) {
      // Evitar sobreescribir: añade un contador al nombre
      int counter = 1;
      String newPath;
      do {
        newPath =
            '$destDir/${status.fileNameWithoutExtension}($counter)${status.extension}';
        counter++;
      } while (await File(newPath).exists());
      await sourceFile.copy(newPath);
      return newPath;
    }

    await sourceFile.copy(destPath);
    return destPath;
  }

  /// Escanea la carpeta de descargas y retorna la lista de archivos guardados.
  Future<List<StatusFile>> getSavedStatuses() async {
    final String destDir;
    try {
      destDir = await getDownloadDirectory();
    } catch (_) {
      return [];
    }

    final dir = Directory(destDir);
    if (!await dir.exists()) return [];

    final files = <StatusFile>[];
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      final file = entity;
      final name = file.uri.pathSegments.last;
      final ext =
          name.contains('.') ? '.${name.split('.').last.toLowerCase()}' : '';
      final mediaType = FileUtils.detectMediaType(ext);
      if (mediaType == MediaType.unknown) continue;

      files.add(StatusFile(
        filePath: file.path,
        fileName: name,
        extension: ext,
        fileSize: await file.length(),
        lastModified: await file.lastModified(),
        mediaType: mediaType,
      ));
    }

    files.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return files;
  }

  Future<void> shareStatus(StatusFile status) async {
    final file = XFile(status.filePath);
    await Share.shareXFiles([file], text: 'Shared via Statuses');
  }
}
