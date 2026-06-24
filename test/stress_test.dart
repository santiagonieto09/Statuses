import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/utils/file_utils.dart';
import 'mocks.dart';

void main() {
  group('Stress: 500+ archivos', () {
    late Directory tempDir;
    late List<StatusFile> statuses;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('stress_');
      statuses = List.generate(500, (i) {
        final fileName = 'status_$i.${i.isEven ? 'jpg' : 'mp4'}';
        final file = File('${tempDir.path}/$fileName');
        final content = [i >> 8, i & 0xFF, ...List.filled(1022, 42)];
        file.writeAsBytesSync(content);
        return StatusFile(
          filePath: file.path,
          fileName: fileName,
          extension: i.isEven ? '.jpg' : '.mp4',
          fileSize: 1024,
          lastModified: file.lastModifiedSync(),
          mediaType: i.isEven ? MediaType.image : MediaType.video,
        );
      });
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('hash 500 archivos secuencialmente', () async {
      final sw = Stopwatch()..start();
      for (final s in statuses) {
        await FileUtils.computeFileHash(s.filePath);
      }
      sw.stop();
      debugPrint('STRESS: hash 500 archivos secuencial = ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(30000));
    });

    test('hash 500 archivos en paralelo (Future.wait)', () async {
      final sw = Stopwatch()..start();
      await Future.wait(
        statuses.map((s) => FileUtils.computeFileHash(s.filePath)),
      );
      sw.stop();
      debugPrint('STRESS: hash 500 archivos paralelo = ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(20000));
    });

    test('hash con cache de 500 entradas (simula _hashCache)', () async {
      final cache = <String, String>{};
      final cacheKeys = <String>[];
      const maxSize = 500;

      final sw = Stopwatch()..start();
      for (final s in statuses) {
        if (!cache.containsKey(s.filePath)) {
          final hash = await FileUtils.computeFileHash(s.filePath);
          cache[s.filePath] = hash;
          cacheKeys.add(s.filePath);
          if (cacheKeys.length > maxSize) {
            cache.remove(cacheKeys.removeAt(0));
          }
        }
      }
      sw.stop();
      debugPrint('STRESS: hash cache 500 entradas = ${sw.elapsedMilliseconds}ms, '
          'cache size=${cache.length}');
      expect(cache.length, lessThanOrEqualTo(500));
    });

    test('Set de hashes con 500 archivos (simula _savedHashes)', () async {
      final savedHashes = <String>{};

      final sw = Stopwatch()..start();
      for (final s in statuses) {
        savedHashes.add(await FileUtils.computeFileHash(s.filePath));
      }
      sw.stop();
      debugPrint('STRESS: set de 500 hashes = ${sw.elapsedMilliseconds}ms');

      final lookupSw = Stopwatch()..start();
      for (final s in statuses) {
        final hash = await FileUtils.computeFileHash(s.filePath);
        expect(savedHashes.contains(hash), isTrue);
      }
      lookupSw.stop();
      debugPrint('STRESS: 500 lookups en set = ${lookupSw.elapsedMicroseconds}us');

      expect(savedHashes.length, 500);
    });

    test('500 archivos mixtos: filtrado por tipo', () async {
      final sw = Stopwatch()..start();
      final images = statuses.where((s) => s.mediaType == MediaType.image).toList();
      final videos = statuses.where((s) => s.mediaType == MediaType.video).toList();
      sw.stop();
      debugPrint('STRESS: filtrar 500 archivos = ${sw.elapsedMicroseconds}us, '
          'images=${images.length}, videos=${videos.length}');
      expect(images.length, 250);
      expect(videos.length, 250);
    });
  });

  group('Stress: 1000 archivos', () {
    late Directory tempDir;
    late List<StatusFile> statuses;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('stress_1k_');
      statuses = List.generate(1000, (i) {
        final fileName = 'status_$i.jpg';
        final file = File('${tempDir.path}/$fileName');
        final content = [i >> 8, i & 0xFF, ...List.filled(510, 42)];
        file.writeAsBytesSync(content);
        return StatusFile(
          filePath: file.path,
          fileName: fileName,
          extension: '.jpg',
          fileSize: 512,
          lastModified: file.lastModifiedSync(),
          mediaType: MediaType.image,
        );
      });
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('hash 1000 archivos con cache FIFO limit 500', () async {
      final cache = <String, String>{};
      final cacheKeys = <String>[];
      const maxSize = 500;

      final sw = Stopwatch()..start();
      for (final s in statuses) {
        if (!cache.containsKey(s.filePath)) {
          final hash = await FileUtils.computeFileHash(s.filePath);
          cache[s.filePath] = hash;
          cacheKeys.add(s.filePath);
          if (cacheKeys.length > maxSize) {
            cache.remove(cacheKeys.removeAt(0));
          }
        }
      }
      sw.stop();
      debugPrint('STRESS-1K: hash 1000 archivos con FIFO 500 = ${sw.elapsedMilliseconds}ms, '
          'cache size=${cache.length}');
      expect(cache.length, 500);
      expect(cacheKeys.length, 500);
    });
  });
}
