import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/screens/status_detail_screen.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:statuses/ui/widgets/status_thumbnail_card.dart';

final _listBuildSw = Stopwatch();

class StatusListScreen extends StatelessWidget {
  final bool needsSafFallback;
  const StatusListScreen({super.key, this.needsSafFallback = false});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isLoading = context.select<StatusNotifier, bool>(
      (n) => n.isLoading,
    );
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final statuses = context.select<StatusNotifier, List<StatusFile>>(
      (n) => n.filteredStatuses,
    );
    final listTask = developer.TimelineTask();
    listTask.start('StatusListScreen.build');
    if (!_listBuildSw.isRunning) {
      _listBuildSw.start();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listBuildSw.stop();
        debugPrint('[PERF] StatusListScreen.build: ${_listBuildSw.elapsedMilliseconds}ms para ${statuses.length} items');
        listTask.finish();
        _listBuildSw.reset();
      });
    }
    if (statuses.isEmpty) {
      return EmptyState(
        title: t.empty.default_title,
        subtitle: t.empty.default_subtitle,
        onGrantSaf: needsSafFallback
            ? () => context.read<StatusNotifier>().grantSafPermission()
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<StatusNotifier>().refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          return StatusListItem(
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
      ),
    );
  }
}
