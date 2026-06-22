import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/ui/screens/status_detail_screen.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:statuses/ui/widgets/shimmer_loading.dart';
import 'package:statuses/ui/widgets/status_thumbnail_card.dart';
import 'package:statuses/constants/app_constants.dart';

class SavedStatusesScreen extends StatefulWidget {
  const SavedStatusesScreen({super.key});

  @override
  State<SavedStatusesScreen> createState() => _SavedStatusesScreenState();
}

class _SavedStatusesScreenState extends State<SavedStatusesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DownloadNotifier>().loadSavedStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<DownloadNotifier>(
      builder: (context, downloadNotifier, _) {
        if (downloadNotifier.isSavedLoading) {
          return const ShimmerLoading(isGrid: true);
        }

        if (!downloadNotifier.hasSaved) {
          return const EmptyState(
            title: 'No saved statuses',
            subtitle:
                'Los estados que descargues aparecerán aquí.',
            icon: Icons.download_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () => downloadNotifier.loadSavedStatuses(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverPadding(
                padding: const EdgeInsets.all(4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount(context),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final status = downloadNotifier.savedStatuses[index];
                      return StatusThumbnailCard(
                        status: status,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StatusDetailScreen(status: status),
                          ),
                        ),
                      );
                    },
                    childCount: downloadNotifier.savedStatuses.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final count = context.read<DownloadNotifier>().savedStatuses.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(Icons.folder_rounded,
              size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Pictures/${AppConstants.savedDirName}  ·  $count archivo${count != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  int _crossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? AppConstants.gridCrossAxisCountLandscape : AppConstants.gridCrossAxisCount;
  }
}
