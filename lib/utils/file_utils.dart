import 'dart:io';
import 'package:crypto/crypto.dart';

enum MediaType { image, video, unknown }

class FileUtils {
  static const Set<String> imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
  };

  static const Set<String> videoExtensions = {
    '.mp4',
    '.avi',
    '.mkv',
    '.mov',
    '.3gp',
    '.webm',
  };

  static const int _partialHashSize = 64 * 1024;

  static MediaType detectMediaType(String extension) {
    final ext = extension.toLowerCase();
    if (imageExtensions.contains(ext)) return MediaType.image;
    if (videoExtensions.contains(ext)) return MediaType.video;
    return MediaType.unknown;
  }

  static String mimeTypeFromExtension(String extension) {
    final ext = extension.toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.mp4':
        return 'video/mp4';
      case '.3gp':
        return 'video/3gpp';
      case '.mkv':
        return 'video/x-matroska';
      case '.avi':
        return 'video/x-msvideo';
      case '.mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<String> computeFileHash(String filePath) async {
    final file = File(filePath);
    final length = await file.length();
    if (length > 10 * 1024 * 1024) {
      return _computePartialHash(file, length);
    }
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  static String computeFileHashSync(String filePath) {
    final file = File(filePath);
    final length = file.lengthSync();
    if (length > 10 * 1024 * 1024) {
      return _computePartialHashSync(file, length);
    }
    final bytes = file.readAsBytesSync();
    return sha256.convert(bytes).toString();
  }

  static Future<String> _computePartialHash(File file, int length) async {
    final bytes = await file.readAsBytes();
    final chunk = bytes.take(_partialHashSize).toList();
    final hash = sha256.convert(chunk).toString();
    return '$hash|$length';
  }

  static String _computePartialHashSync(File file, int length) {
    final bytes = file.readAsBytesSync();
    final chunk = bytes.take(_partialHashSize).toList();
    final hash = sha256.convert(chunk).toString();
    return '$hash|$length';
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
