import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/screens/status_detail_screen.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:statuses/ui/widgets/shimmer_loading.dart';
import 'package:statuses/ui/widgets/status_thumbnail_card.dart';
import 'package:statuses/utils/file_utils.dart';

class SavedStatusesScreen extends StatefulWidget {
  const SavedStatusesScreen({super.key});

  @override
  State<SavedStatusesScreen> createState() => _SavedStatusesScreenState();
}

class _SavedStatusesScreenState extends State<SavedStatusesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Set<String> _selectedPaths = {};

  bool get _isSelecting => _selectedPaths.isNotEmpty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DownloadNotifier>().loadSavedStatuses();
    });
  }

  void _onLongPress(String path) {
    setState(() => _selectedPaths.add(path));
  }

  void _toggleSelection(String path) {
    setState(() {
      if (_selectedPaths.contains(path)) {
        _selectedPaths.remove(path);
      } else {
        _selectedPaths.add(path);
      }
    });
  }

  void _clearSelection() => setState(() => _selectedPaths.clear());

  Future<void> _confirmDelete(BuildContext context) async {
    final t = Translations.of(context);
    final count = _selectedPaths.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.delete_forever_rounded,
          color: Theme.of(ctx).colorScheme.error,
          size: 36,
        ),
        title: Text(t.saved.delete_title),
        content: Text(t.saved.delete_message(count: count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.saved.cancel),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.delete_rounded),
            label: Text(t.saved.delete),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context
          .read<DownloadNotifier>()
          .deleteSavedStatuses(_selectedPaths.toList());
      _clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    super.build(context);
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
          child: _isSelecting
              ? _buildSelectionBar(context)
              : const SizedBox.shrink(),
        ),

        Expanded(
          child: Consumer2<StatusNotifier, DownloadNotifier>(
            builder: (context, statusNotifier, downloadNotifier, _) {
              final isGrid = statusNotifier.viewMode == ViewMode.grid;
              final filterMode = statusNotifier.filterMode;
              final filtered = filterMode == FilterMode.all
                  ? downloadNotifier.savedStatuses
                  : downloadNotifier.savedStatuses
                      .where((s) => filterMode == FilterMode.photo
                          ? s.mediaType == MediaType.image
                          : s.mediaType == MediaType.video)
                      .toList();

              if (downloadNotifier.isSavedLoading) {
                return ShimmerLoading(isGrid: isGrid);
              }

              if (filtered.isEmpty) {
                return EmptyState(
                  title: downloadNotifier.hasSaved
                      ? t.saved.empty_filtered_title
                      : t.saved.empty_title,
                  subtitle: downloadNotifier.hasSaved
                      ? t.saved.empty_filtered_subtitle
                      : t.saved.empty_subtitle,
                  icon: downloadNotifier.hasSaved
                      ? Icons.filter_list_off_rounded
                      : Icons.download_rounded,
                );
              }

              return RefreshIndicator(
                onRefresh: _isSelecting
                    ? () async {}
                    : () => downloadNotifier.loadSavedStatuses(),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(4),
                      sliver: isGrid
                          ? _buildGrid(context, filtered)
                          : _buildList(context, filtered),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectAll(List<StatusFile> statuses) {
    setState(() {
      _selectedPaths.addAll(statuses.map((s) => s.filePath));
    });
  }

  void _deselectAll() {
    setState(() => _selectedPaths.clear());
  }

  Widget _buildSelectionBar(BuildContext context) {
    final t = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      key: const ValueKey('selectionBar'),
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded),
                color: colorScheme.onPrimaryContainer,
                tooltip: t.saved.cancel_selection_tooltip,
                onPressed: _clearSelection,
              ),
              Expanded(
                child: Text(
                  t.saved.selected_count(count: _selectedPaths.length),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                color: colorScheme.error,
                tooltip: t.saved.delete_selected_tooltip,
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => _deselectAll(),
                icon: const Icon(Icons.deselect_rounded, size: 18),
                label: Text(t.saved.deselect_all),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  final statuses =
                      context.read<DownloadNotifier>().savedStatuses;
                  _selectAll(statuses);
                },
                icon: const Icon(Icons.select_all_rounded, size: 18),
                label: Text(t.saved.select_all),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverChildBuilderDelegate _itemDelegate(
    BuildContext context,
    List<StatusFile> statuses, {
    required bool isList,
  }) {
    return SliverChildBuilderDelegate(
      (context, index) {
        final status = statuses[index];
        final isSelected = _selectedPaths.contains(status.filePath);

        void onTap() {
          if (_isSelecting) {
            _toggleSelection(status.filePath);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StatusDetailScreen(
                  statuses: statuses,
                  initialIndex: index,
                ),
              ),
            );
          }
        }

        void onLongPress() => _onLongPress(status.filePath);

        return isList
            ? StatusListItem(
                status: status,
                isSelected: isSelected,
                showSavedIndicator: false,
                onLongPress: onLongPress,
                onTap: onTap,
              )
            : StatusThumbnailCard(
                status: status,
                isSelected: isSelected,
                showSavedIndicator: false,
                onLongPress: onLongPress,
                onTap: onTap,
              );
      },
      childCount: statuses.length,
    );
  }

  Widget _buildGrid(BuildContext context, List<StatusFile> statuses) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount(context),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      delegate: _itemDelegate(context, statuses, isList: false),
    );
  }

  Widget _buildList(BuildContext context, List<StatusFile> statuses) {
    return SliverList(
      delegate: _itemDelegate(context, statuses, isList: true),
    );
  }

  int _crossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600
        ? AppConstants.gridCrossAxisCountLandscape
        : AppConstants.gridCrossAxisCount;
  }
}
