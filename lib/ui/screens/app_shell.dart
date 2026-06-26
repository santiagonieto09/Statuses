import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/screens/saved_statuses_screen.dart';
import 'package:statuses/ui/screens/status_grid_screen.dart';
import 'package:statuses/ui/screens/status_list_screen.dart';
import 'package:statuses/ui/theme/app_theme.dart';
import 'package:statuses/ui/widgets/filter_chips.dart';
import 'package:statuses/i18n/translations.g.dart';

final List<_FrameTiming> _frameTimings = [];
bool _timingCallbackRegistered = false;

class _FrameTiming {
  final int build;
  final int raster;
  final int total;
  _FrameTiming(this.build, this.raster, this.total);
}

void _registerFrameTiming() {
  if (_timingCallbackRegistered) return;
  _timingCallbackRegistered = true;
  WidgetsBinding.instance.addTimingsCallback((timings) {
    for (final t in timings) {
      final buildMs = t.buildDuration.inMicroseconds ~/ 1000;
      final rasterMs = t.rasterDuration.inMicroseconds ~/ 1000;
      final totalMs = (t.buildDuration.inMicroseconds + t.rasterDuration.inMicroseconds) ~/ 1000;
      _frameTimings.add(_FrameTiming(buildMs, rasterMs, totalMs));

      if (totalMs > 16) {
        var flag = '';
        if (totalMs > 100) { flag = ' <<<< CRITICO'; }
        else if (totalMs > 50) { flag = ' <<< ALTO'; }
        else if (totalMs > 33) { flag = ' << MEDIO'; }
        else if (totalMs > 16) { flag = ' < LEVE'; }
        debugPrint('[FRAME] build=${buildMs}ms raster=${rasterMs}ms total=${totalMs}ms$flag');
      }
    }
  });
}

void printFrameSummary() {
  if (_frameTimings.isEmpty) return;
  _frameTimings.sort((a, b) => b.total.compareTo(a.total));
  debugPrint('===== FRAME SUMMARY =====');
  debugPrint('Total frames capturados: ${_frameTimings.length}');
  debugPrint('Top 5 frames más lentos:');
  for (var i = 0; i < (_frameTimings.length > 5 ? 5 : _frameTimings.length); i++) {
    final f = _frameTimings[i];
    debugPrint('  #${i + 1}: build=${f.build}ms raster=${f.raster}ms total=${f.total}ms');
  }
  final over16 = _frameTimings.where((f) => f.total > 16).length;
  final over33 = _frameTimings.where((f) => f.total > 33).length;
  final over50 = _frameTimings.where((f) => f.total > 50).length;
  final over100 = _frameTimings.where((f) => f.total > 100).length;
  debugPrint('Frames >16ms: $over16  >33ms: $over33  >50ms: $over50  >100ms: $over100');
  debugPrint('=========================');
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _registerFrameTiming();
    debugPrint('[PERF] AppShell.initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[PERF] AppShell postFrameCallback: ejecutando loadStatuses');
      context.read<StatusNotifier>().loadStatuses().catchError((Object error) {
        debugPrint('Failed to load statuses: $error');
      });
    });
  }

  @override
  void dispose() {
    printFrameSummary();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buildSw = Stopwatch()..start();
    final t = Translations.of(context);
    final statusCount = context.select<StatusNotifier, int>(
      (n) => n.statusCount,
    );
    final savedCount = context.select<DownloadNotifier, int>(
      (n) => n.savedCount,
    );
    final result = Scaffold(
      appBar: AppBar(
        title: Text(
          t.app.title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: RepaintBoundary(
            child: const FilterChips(),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _StatusView(),
          SavedStatusesScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            Navigator.of(context).pushNamed('/settings');
            return;
          }
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Badge(
              isLabelVisible: statusCount > 0,
              label: Text(statusCount > 99 ? '99+' : '$statusCount'),
              child: const _StatusRingIcon(isActive: false),
            ),
            selectedIcon: Badge(
              isLabelVisible: statusCount > 0,
              label: Text(statusCount > 99 ? '99+' : '$statusCount'),
              child: const _StatusRingIcon(isActive: true),
            ),
            label: t.nav.statuses,
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: savedCount > 0,
              label: Text(savedCount > 99 ? '99+' : '$savedCount'),
              child: const Icon(Icons.download_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: savedCount > 0,
              label: Text(savedCount > 99 ? '99+' : '$savedCount'),
              child: const Icon(Icons.download_rounded),
            ),
            label: t.nav.saved,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: t.settings.title,
          ),
        ],
      ),
    );
    buildSw.stop();
    if (buildSw.elapsedMilliseconds > 5) {
      debugPrint('[PERF] AppShell.build: ${buildSw.elapsedMilliseconds}ms (statusCount=$statusCount)');
    }
    return result;
  }
}

class _StatusRingIcon extends StatelessWidget {
  final bool isActive;

  const _StatusRingIcon({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Stories',
      child: SizedBox(
        width: 28,
        height: 28,
        child: CustomPaint(
          painter: _StatusRingPainter(isActive: isActive),
        ),
      ),
    );
  }
}

class _StatusRingPainter extends CustomPainter {
  final bool isActive;

  _StatusRingPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 1;
    final innerRadius = outerRadius * 0.55;
    final strokeWidth = outerRadius - innerRadius;

    final color = isActive ? AppColors.accentGreen : AppColors.secondaryText;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final outerGap = 0.25 * math.pi;
    final innerGap = 0.35 * math.pi;
    final rotation = isActive ? 0.15 * math.pi : 0.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - strokeWidth / 2),
      rotation + outerGap * 0.5,
      2 * math.pi - outerGap,
      false,
      paint,
    );

    paint.strokeWidth = strokeWidth * 0.65;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      math.pi + rotation + innerGap * 0.3,
      2 * math.pi - innerGap,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_StatusRingPainter oldDelegate) =>
      oldDelegate.isActive != isActive;
}

class _StatusView extends StatelessWidget {
  const _StatusView();

  @override
  Widget build(BuildContext context) {
    final buildSw = Stopwatch()..start();
    final viewMode = context.select<StatusNotifier, ViewMode>(
      (n) => n.viewMode,
    );
    final needsSaf = context.select<StatusNotifier, bool>(
      (n) => n.needsSafFallback,
    );
    final result = RepaintBoundary(
      child: viewMode == ViewMode.grid
          ? StatusGridScreen(needsSafFallback: needsSaf)
          : StatusListScreen(needsSafFallback: needsSaf),
    );
    buildSw.stop();
    if (buildSw.elapsedMilliseconds > 2) {
      debugPrint('[PERF] _StatusView.build: ${buildSw.elapsedMilliseconds}ms');
    }
    return result;
  }
}
