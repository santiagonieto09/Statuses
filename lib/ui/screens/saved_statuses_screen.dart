import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/ui/screens/status_detail_screen.dart';
import 'package:statuses/ui/widgets/empty_state.dart';
import 'package:statuses/ui/widgets/shimmer_loading.dart';
import 'package:statuses/ui/widgets/status_thumbnail_card.dart';

class SavedStatusesScreen extends StatefulWidget {
  const SavedStatusesScreen({super.key});

  @override
  State<SavedStatusesScreen> createState() => _SavedStatusesScreenState();
}

class _SavedStatusesScreenState extends State<SavedStatusesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Rutas de los archivos actualmente seleccionados
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
    final count = _selectedPaths.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.delete_forever_rounded,
          color: Theme.of(ctx).colorScheme.error,
          size: 36,
        ),
        title: const Text('Eliminar archivos'),
        content: Text(
          'Se ${count == 1 ? 'eliminara' : 'eliminaran'} $count '
          'archivo${count != 1 ? 's' : ''} permanentemente.\n'
          'Esta accion no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.delete_rounded),
            label: const Text('Eliminar'),
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
    super.build(context);
    return Column(
      children: [
        // Barra de selección — aparece solo cuando hay items seleccionados
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

        // Contenido principal
        Expanded(
          child: Consumer<DownloadNotifier>(
            builder: (context, notifier, _) {
              if (notifier.isSavedLoading) {
                return const ShimmerLoading(isGrid: true);
              }

              if (!notifier.hasSaved) {
                return const EmptyState(
                  title: 'No saved statuses',
                  subtitle:
                      'Los estados que descargues aparecerán aquí.\nSe guardan en Pictures/Statuses.',
                  icon: Icons.download_rounded,
                );
              }

              return RefreshIndicator(
                onRefresh: _isSelecting
                    ? () async {} // bloquea el pull-to-refresh en modo selección
                    : () => notifier.loadSavedStatuses(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(context, notifier)),
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
                            final status = notifier.savedStatuses[index];
                            final isSelected =
                                _selectedPaths.contains(status.filePath);

                            return StatusThumbnailCard(
                              status: status,
                              isSelected: isSelected,
                              onLongPress: () => _onLongPress(status.filePath),
                              onTap: _isSelecting
                                  ? () => _toggleSelection(status.filePath)
                                  : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => StatusDetailScreen(
                                            statuses: notifier.savedStatuses,
                                            initialIndex: index,
                                          ),
                                        ),
                                      ),
                            );
                          },
                          childCount: notifier.savedStatuses.length,
                        ),
                      ),
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

  // ──────────────────────────────────────────────────────────────
  // Widgets auxiliares
  // ──────────────────────────────────────────────────────────────

  Widget _buildSelectionBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      key: const ValueKey('selectionBar'),
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          // Botón cancelar selección
          IconButton(
            icon: const Icon(Icons.close_rounded),
            color: colorScheme.onPrimaryContainer,
            tooltip: 'Cancelar seleccion',
            onPressed: _clearSelection,
          ),
          // Contador de seleccionados
          Expanded(
            child: Text(
              '${_selectedPaths.length} '
              'seleccionado${_selectedPaths.length != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          // Botón eliminar
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            color: colorScheme.error,
            tooltip: 'Eliminar seleccionados',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DownloadNotifier notifier) {
    final count = notifier.savedStatuses.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(
            Icons.folder_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'Pictures/${AppConstants.savedDirName}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.circle,
            size: 4,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '$count archivo${count != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  int _crossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600
        ? AppConstants.gridCrossAxisCountLandscape
        : AppConstants.gridCrossAxisCount;
  }
}
