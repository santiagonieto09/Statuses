import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/screens/saved_statuses_screen.dart';
import 'package:statuses/ui/screens/status_grid_screen.dart';
import 'package:statuses/ui/screens/status_list_screen.dart';
import 'package:statuses/ui/widgets/bottom_nav_badge.dart';
import 'package:statuses/ui/widgets/filter_chips.dart';
import 'package:statuses/i18n/translations.g.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatusNotifier>().loadStatuses().catchError((Object error) {
        debugPrint('Failed to load statuses: $error');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final viewMode = context.select<StatusNotifier, ViewMode>(
      (n) => n.viewMode,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app.title),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: RepaintBoundary(
            child: const FilterChips(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              viewMode == ViewMode.grid
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
            ),
            onPressed: () => context.read<StatusNotifier>().toggleViewMode(),
            tooltip: t.settings.toggle_view,
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: t.settings.theme,
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _StatusView(),
          SavedStatusesScreen(),
        ],
      ),
      bottomNavigationBar: RepaintBoundary(
        child: Consumer2<StatusNotifier, DownloadNotifier>(
          builder: (context, statusNotifier, downloadNotifier, _) {
            final t = Translations.of(context);
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: BottomNavBadge(
                    count: statusNotifier.statusCount,
                    child: const Icon(Icons.camera_alt_outlined),
                  ),
                  activeIcon: BottomNavBadge(
                    count: statusNotifier.statusCount,
                    child: const Icon(Icons.camera_alt_rounded),
                  ),
                  label: t.nav.statuses,
                ),
                BottomNavigationBarItem(
                  icon: BottomNavBadge(
                    count: downloadNotifier.savedCount,
                    child: const Icon(Icons.download_outlined),
                  ),
                  activeIcon: BottomNavBadge(
                    count: downloadNotifier.savedCount,
                    child: const Icon(Icons.download_rounded),
                  ),
                  label: t.nav.saved,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView();

  @override
  Widget build(BuildContext context) {
    final viewMode = context.select<StatusNotifier, ViewMode>(
      (n) => n.viewMode,
    );
    final needsSaf = context.select<StatusNotifier, bool>(
      (n) => n.needsSafFallback,
    );
    return RepaintBoundary(
      child: viewMode == ViewMode.grid
          ? StatusGridScreen(needsSafFallback: needsSaf)
          : StatusListScreen(needsSafFallback: needsSaf),
    );
  }
}
