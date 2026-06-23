import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/utils/file_utils.dart';

class DownloadService {
  final Map<String, String> _hashCache = {};

  Future<String> getDownloadDirectory() async {
    final basePath = _derivedPublicPath(await getExternalStorageDirectory());
    final dir = Directory('$basePath/${AppConstants.savedDirName}');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  String _derivedPublicPath(Directory? extDir) {
    if (extDir == null) return '/storage/emulated/0/Pictures';
    return '${extDir.path.split('/Android/').first}/Pictures';
  }

  Future<String> downloadStatus(StatusFile status) async {
    final destDir = await getDownloadDirectory();
    final sourceFile = File(status.filePath);
    final destPath = '$destDir/${status.fileName}';

    final sourceHash = await _getOrComputeHash(status.filePath);

    final existingFiles = await _listSavedFiles(destDir);
    for (final existing in existingFiles) {
      final existingHash = await _getOrComputeHash(existing.path);
      if (existingHash == sourceHash) {
        return existing.path;
      }
    }

    final destFile = File(destPath);
    if (await destFile.exists()) {
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

  String downloadStatusSync(StatusFile status) {
    final basePath = '/storage/emulated/0/Pictures';
    final destDir = '$basePath/${AppConstants.savedDirName}';
    final dir = Directory(destDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final sourceFile = File(status.filePath);
    final destPath = '$destDir/${status.fileName}';

    final destFile = File(destPath);
    if (!destFile.existsSync()) {
      sourceFile.copySync(destPath);
    }
    return destPath;
  }

  List<StatusFile> getSavedStatusesSync() {
    const basePath = '/storage/emulated/0/Pictures';
    final destDir = '$basePath/${AppConstants.savedDirName}';
    final dir = Directory(destDir);
    if (!dir.existsSync()) return [];

    final files = <StatusFile>[];
    for (final entity in dir.listSync()) {
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
        fileSize: file.lengthSync(),
        lastModified: file.lastModifiedSync(),
        mediaType: mediaType,
      ));
    }

    files.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return files;
  }

  Future<String> _getOrComputeHash(String filePath) async {
    if (_hashCache.containsKey(filePath)) return _hashCache[filePath]!;
    final hash = await FileUtils.computeFileHash(filePath);
    _hashCache[filePath] = hash;
    return hash;
  }

  Future<List<File>> _listSavedFiles(String destDir) async {
    final dir = Directory(destDir);
    if (!await dir.exists()) return [];
    final files = <File>[];
    await for (final entity in dir.list()) {
      if (entity is File) files.add(entity);
    }
    return files;
  }

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

  Future<String> getStorageUsage() async {
    try {
      final dir = await getDownloadDirectory();
      final directory = Directory(dir);
      if (!await directory.exists()) return '0 B';
      int total = 0;
      await for (final entity in directory.list()) {
        if (entity is File) {
          total += await entity.length();
        }
      }
      return FileUtils.formatFileSize(total);
    } catch (_) {
      return '0 B';
    }
  }

  Future<void> shareStatus(StatusFile status) async {
    final file = XFile(status.filePath);
    await SharePlus.instance.share(
      ShareParams(files: [file], text: 'Compartido desde la app Statuses'),
    );
  }
}
