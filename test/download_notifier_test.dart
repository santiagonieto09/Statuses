import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'mocks.dart';

void main() {
  late DownloadNotifier notifier;
  late StatusNotifier statusNotifier;
  late FakeStatusRepository fakeRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fakeRepo = FakeStatusRepository();
    statusNotifier = StatusNotifier(fakeRepo);
    notifier = DownloadNotifier();
    notifier.attachStatusNotifier(statusNotifier);
  });

  group('DownloadNotifier', () {
    test('initial state', () {
      expect(notifier.isDownloading, false);
      expect(notifier.savedCount, 0);
      expect(notifier.error, isNull);
      expect(notifier.autoSaveEnabled, false);
      expect(notifier.isSyncing, false);
    });

    test('auto-save toggle saves preference', () async {
      expect(notifier.autoSaveEnabled, false);
      await notifier.toggleAutoSave(true);
      expect(notifier.autoSaveEnabled, true);
      await notifier.toggleAutoSave(false);
      expect(notifier.autoSaveEnabled, false);
    });

    test('isSyncing is true during auto-save activation', () async {
      expect(notifier.isSyncing, false);
      final future = notifier.toggleAutoSave(true);
      expect(notifier.isSyncing, true);
      await future;
      expect(notifier.isSyncing, false);
    });

    test('isSyncing blocks multiple toggles', () async {
      final first = notifier.toggleAutoSave(true);
      await notifier.toggleAutoSave(false);
      expect(notifier.autoSaveEnabled, true);
      await first;
    });

    test('downloadStatus catches error when path invalid', () async {
      final status = createTestStatus();
      await notifier.downloadStatus(status);
      expect(notifier.isDownloading, false);
    });

    test('loadSavedStatuses loads saved statuses', () async {
      await notifier.loadSavedStatuses();
      expect(notifier.isSavedLoading, false);
    });

    test('isStatusSaved returns false for unknown file', () async {
      final saved = await notifier.isStatusSaved('/fake/path/unknown.jpg');
      expect(saved, false);
    });

    test('clearState resets error and last path', () async {
      notifier.clearState();
      expect(notifier.lastDownloadedPath, isNull);
      expect(notifier.error, isNull);
    });

    test('savedFilePaths returns file names', () async {
      await notifier.loadSavedStatuses();
      expect(notifier.savedFilePaths, isA<Set<String>>());
    });

    test('savedCount returns zero initially', () {
      expect(notifier.savedCount, 0);
      expect(notifier.hasSaved, false);
    });
  });
}
