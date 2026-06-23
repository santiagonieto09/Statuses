import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/providers/locale_notifier.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';
import 'package:statuses/ui/screens/saved_statuses_screen.dart';
import 'package:statuses/ui/screens/status_grid_screen.dart';
import 'package:statuses/ui/screens/status_list_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app.title),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Consumer<StatusNotifier>(
            builder: (context, notifier, _) => Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(t.filter.all),
                    avatar: const Icon(Icons.apps_rounded, size: 16),
                    selected: notifier.filterMode == FilterMode.all,
                    onSelected: (_) => notifier.setFilterMode(FilterMode.all),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(t.filter.photos),
                    avatar: const Icon(Icons.image_rounded, size: 16),
                    selected: notifier.filterMode == FilterMode.photo,
                    onSelected: (_) => notifier.setFilterMode(FilterMode.photo),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(t.filter.videos),
                    avatar: const Icon(Icons.videocam_rounded, size: 16),
                    selected: notifier.filterMode == FilterMode.video,
                    onSelected: (_) => notifier.setFilterMode(FilterMode.video),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Consumer<StatusNotifier>(
            builder: (context, notifier, _) => IconButton(
              icon: Icon(
                notifier.viewMode == ViewMode.grid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
              onPressed: () => notifier.toggleViewMode(),
              tooltip: t.settings.toggle_view,
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
              tooltip: t.settings.toggle_theme,
            ),
          ),
          _LanguageSelector(),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.camera_alt_outlined),
            activeIcon: const Icon(Icons.camera_alt_rounded),
            label: t.nav.statuses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.download_outlined),
            activeIcon: const Icon(Icons.download_rounded),
            label: t.nav.saved,
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final t = Translations.of(context);
    return PopupMenuButton<AppLocale>(
      icon: const Icon(Icons.translate_rounded),
      tooltip: t.settings.language,
      onSelected: (locale) => localeNotifier.setLocale(locale),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: AppLocale.en,
          child: Row(
            children: [
              if (localeNotifier.locale == AppLocale.en)
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppLocale.es,
          child: Row(
            children: [
              if (localeNotifier.locale == AppLocale.es)
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              const Text('Español'),
            ],
          ),
        ),
      ],
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
            ? StatusGridScreen(needsSafFallback: notifier.needsSafFallback)
            : StatusListScreen(needsSafFallback: notifier.needsSafFallback);
      },
    );
  }
}
