import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';

class DownloadService {
  Future<String> getDownloadDirectory() async {
    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      throw Exception('External storage not available');
    }
    final downloadDir = Directory('${dir.path}/${AppConstants.savedDirName}');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

  Future<String> downloadStatus(StatusFile status) async {
    final destDir = await getDownloadDirectory();
    final sourceFile = File(status.filePath);
    final destPath = '$destDir/${status.fileName}';
    final destFile = File(destPath);

    if (await destFile.exists()) {
      int counter = 1;
      String newPath;
      do {
        final nameWithoutExt = status.fileNameWithoutExtension;
        newPath = '$destDir/$nameWithoutExt($counter)${status.extension}';
        counter++;
      } while (await File(newPath).exists());
      await sourceFile.copy(newPath);
      return newPath;
    }

    await sourceFile.copy(destPath);
    return destPath;
  }

  Future<void> shareStatus(StatusFile status) async {
    final file = XFile(status.filePath);
    await Share.shareXFiles([file], text: 'Shared via Statuses');
  }

  Future<void> saveToGallery(StatusFile status) async {
    final destDir = await getDownloadDirectory();
    final sourceFile = File(status.filePath);
    final destPath = '$destDir/${status.fileName}';
    await sourceFile.copy(destPath);
  }
}
