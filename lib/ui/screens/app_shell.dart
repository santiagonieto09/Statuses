import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';
import 'package:statuses/ui/screens/saved_statuses_screen.dart';
import 'package:statuses/ui/screens/status_grid_screen.dart';
import 'package:statuses/ui/screens/status_list_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statuses'),
        actions: [
          Consumer<StatusNotifier>(
            builder: (context, notifier, _) => IconButton(
              icon: Icon(
                notifier.viewMode == ViewMode.grid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
              onPressed: () => notifier.toggleViewMode(),
              tooltip: 'Toggle view',
            ),
          ),
          Consumer<ThemeNotifier>(
            builder: (context, notifier, _) => IconButton(
              icon: Icon(
                notifier.themeMode == ThemeMode.dark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: () => notifier.toggleTheme(),
              tooltip: 'Toggle theme',
            ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt_rounded),
            label: 'Statuses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            activeIcon: Icon(Icons.download_rounded),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView();

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusNotifier>(
      builder: (context, notifier, _) {
        return notifier.viewMode == ViewMode.grid
            ? const StatusGridScreen()
            : const StatusListScreen();
      },
    );
  }
}
