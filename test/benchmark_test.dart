import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/repositories/status_repository.dart';
import 'package:statuses/utils/file_utils.dart';
import 'mocks.dart';

void main() {
  group('Benchmark: FileUtils.computeFileHash', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('bench_hash_');
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('hash 1KB file', () async {
      final file = File('${tempDir.path}/small.jpg');
      await file.writeAsBytes(List.filled(1024, 65));

      final sw = Stopwatch()..start();
      await FileUtils.computeFileHash(file.path);
      sw.stop();

      debugPrint('BENCH: hash 1KB = ${sw.elapsedMicroseconds}us');
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });

    test('hash 1MB file', () async {
      final file = File('${tempDir.path}/medium.jpg');
      await file.writeAsBytes(List.filled(1024 * 1024, 65));

      final sw = Stopwatch()..start();
      await FileUtils.computeFileHash(file.path);
      sw.stop();

      debugPrint('BENCH: hash 1MB = ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(2000));
    });

    test('hash 15MB file (partial hash)', () async {
      final file = File('${tempDir.path}/large.mp4');
      await file.writeAsBytes(List.filled(15 * 1024 * 1024, 65));

      final sw = Stopwatch()..start();
      await FileUtils.computeFileHash(file.path);
      sw.stop();

      debugPrint('BENCH: hash 15MB (partial) = ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(500));
    });
  });

  group('Benchmark: File.stat()', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('bench_stat_');
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('stat 10 files', () async {
      final files = List.generate(10, (i) {
        final f = File('${tempDir.path}/file_$i.jpg');
        f.writeAsBytesSync([1, 2, 3]);
        return f;
      });

      final sw = Stopwatch()..start();
      for (final f in files) {
        await f.stat();
      }
      sw.stop();

      debugPrint('BENCH: stat 10 files = ${sw.elapsedMicroseconds}us');
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });

    test('stat vs length+lastModified 100 files', () async {
      final files = List.generate(100, (i) {
        final f = File('${tempDir.path}/file_$i.jpg');
        f.writeAsBytesSync([1, 2, 3]);
        return f;
      });

      final sw1 = Stopwatch()..start();
      for (final f in files) {
        await f.stat();
      }
      sw1.stop();

      final sw2 = Stopwatch()..start();
      for (final f in files) {
        await f.length();
        await f.lastModified();
      }
      sw2.stop();

      debugPrint('BENCH: stat 100 files = ${sw1.elapsedMicroseconds}us');
      debugPrint('BENCH: length+modified 100 files = ${sw2.elapsedMicroseconds}us');
    });
  });

  group('Benchmark: StatusRepository', () {
    test('load 100 simulated statuses', () async {
      final repo = FakeStatusRepository();
      final statuses = List.generate(100, (i) => createTestStatus(
        filePath: '/status/file_$i.mp4',
        fileName: 'file_$i.mp4',
        extension: '.mp4',
        mediaType: MediaType.video,
      ));
      repo.setStatuses(statuses);

      final sw = Stopwatch()..start();
      final result = await repo.loadStatuses();
      sw.stop();

      debugPrint('BENCH: load 100 simulated statuses = ${sw.elapsedMicroseconds}us');
      expect(result.length, 100);
    });
  });

  group('Benchmark: hashing throughput', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('bench_throughput_');
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('hash 50 small files (sequential vs parallel)', () async {
      final files = List.generate(50, (i) {
        final f = File('${tempDir.path}/file_$i.jpg');
        final content = [i >> 8, i & 0xFF, ...List.filled(1022, 42)];
        f.writeAsBytesSync(content);
        return f;
      });

      final sw1 = Stopwatch()..start();
      for (final f in files) {
        await FileUtils.computeFileHash(f.path);
      }
      sw1.stop();
      debugPrint('BENCH: hash 50 files sequential = ${sw1.elapsedMilliseconds}ms');

      final sw2 = Stopwatch()..start();
      await Future.wait(files.map((f) => FileUtils.computeFileHash(f.path)));
      sw2.stop();
      debugPrint('BENCH: hash 50 files parallel = ${sw2.elapsedMilliseconds}ms');
    });
  });
}
