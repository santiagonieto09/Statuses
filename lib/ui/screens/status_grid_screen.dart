import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/screens/status_detail_screen.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:statuses/ui/widgets/shimmer_loading.dart';
import 'package:statuses/ui/widgets/status_thumbnail_card.dart';

final _gridBuildSw = Stopwatch();

class StatusGridScreen extends StatelessWidget {
  final bool needsSafFallback;
  const StatusGridScreen({super.key, this.needsSafFallback = false});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isLoading = context.select<StatusNotifier, bool>(
      (n) => n.isLoading,
    );
    if (isLoading) {
      return const ShimmerLoading(isGrid: true);
    }

    final statusCount = context.select<StatusNotifier, int>(
      (n) => n.statusCount,
    );
    if (statusCount == 0) {
      return EmptyState(
        title: t.empty.default_title,
        subtitle: t.empty.default_subtitle,
        onGrantSaf: needsSafFallback
            ? () => context.read<StatusNotifier>().grantSafPermission()
            : null,
      );
    }

    final statuses = context.select<StatusNotifier, List<StatusFile>>(
      (n) => n.filteredStatuses,
    );
    final gridTask = developer.TimelineTask();
    gridTask.start('StatusGridScreen.build');
    if (!_gridBuildSw.isRunning) {
      _gridBuildSw.start();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _gridBuildSw.stop();
        debugPrint('[PERF] StatusGridScreen.build: ${_gridBuildSw.elapsedMilliseconds}ms para ${statuses.length} items');
        gridTask.finish();
        _gridBuildSw.reset();
      });
    }
    return RefreshIndicator(
      onRefresh: () => context.read<StatusNotifier>().refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          return GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isLandscape ? 5 : 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              return StatusThumbnailCard(
                status: status,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StatusDetailScreen(
                      statuses: statuses,
                      initialIndex: index,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
