import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/screens/status_detail_screen.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:statuses/ui/widgets/shimmer_loading.dart';
import 'package:statuses/ui/widgets/status_thumbnail_card.dart';

class StatusListScreen extends StatelessWidget {
  final bool needsSafFallback;
  const StatusListScreen({super.key, this.needsSafFallback = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusNotifier>(
      builder: (context, notifier, _) {
        if (notifier.isLoading) {
          return const ShimmerLoading(isGrid: false);
        }

        if (notifier.statuses.isEmpty) {
          return EmptyState(
            onGrantSaf: needsSafFallback
                ? () => context.read<StatusNotifier>().grantSafPermission()
                : null,
          );
        }

        return RefreshIndicator(
          onRefresh: () => notifier.refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: notifier.statuses.length,
            itemBuilder: (context, index) {
              final status = notifier.statuses[index];
              return StatusListItem(
                status: status,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StatusDetailScreen(status: status),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
