import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/i18n/translations.g.dart';
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
    final t = Translations.of(context);
    return Consumer<StatusNotifier>(
      builder: (context, notifier, _) {
        if (notifier.isLoading) {
          return const ShimmerLoading(isGrid: false);
        }

        final statuses = notifier.filteredStatuses;
        if (statuses.isEmpty) {
          return EmptyState(
            title: t.empty.default_title,
            subtitle: t.empty.default_subtitle,
            icon: Icons.hourglass_empty_rounded,
            onGrantSaf: needsSafFallback
                ? () => context.read<StatusNotifier>().grantSafPermission()
                : null,
          );
        }

        return RefreshIndicator(
          onRefresh: () => notifier.refresh(),
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
      },
    );
  }
}
