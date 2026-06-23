import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/providers/notification_notifier.dart';
import 'package:statuses/providers/theme_notifier.dart';
import 'package:statuses/ui/widgets/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: _ResponsiveWrapper(
        child: ListView(
          children: [
            _SectionHeader(title: t.settings.appearance),
            const LanguageSelector(),
            _ThemeTile(),
            const Divider(),
            _SectionHeader(title: t.settings.notifications),
            _NotificationTile(),
            const Divider(),
            _SectionHeader(title: t.settings.auto_save),
            _AutoSaveTile(),
            const Divider(),
            _SectionHeader(title: t.settings.help),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              title: Text(t.settings.help_center),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).pushNamed('/help'),
            ),
            const Divider(),
            _SectionHeader(title: t.settings.about),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(t.settings.app_name),
              subtitle: Text(t.settings.app_description),
            ),
            ListTile(
              leading: const Icon(Icons.tag_rounded),
              title: Text(t.settings.version),
              trailing: const Text('1.0.0+1'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const _ResponsiveWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      );
    }
    return child;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final themeNotifier = context.watch<ThemeNotifier>();
    return SwitchListTile(
      secondary: Icon(
        themeNotifier.themeMode == ThemeMode.dark
            ? Icons.dark_mode_rounded
            : Icons.light_mode_rounded,
      ),
      title: Text(t.settings.theme),
      subtitle: Text(
        themeNotifier.themeMode == ThemeMode.dark
            ? t.settings.dark
            : t.settings.light,
      ),
      value: themeNotifier.themeMode == ThemeMode.dark,
      onChanged: (_) => themeNotifier.toggleTheme(),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final notifier = context.watch<NotificationNotifier>();
    return SwitchListTile(
      secondary: Icon(
        notifier.isEnabled
            ? Icons.notifications_active_rounded
            : Icons.notifications_off_outlined,
      ),
      title: Text(t.settings.notifications),
      subtitle: Text(
        notifier.errorMessage ??
            (notifier.isEnabled
                ? t.settings.notification_active
                : t.settings.notification_inactive),
      ),
      value: notifier.isEnabled,
      onChanged: (_) => notifier.toggle(),
    );
  }
}

class _AutoSaveTile extends StatefulWidget {
  @override
  State<_AutoSaveTile> createState() => _AutoSaveTileState();
}

class _AutoSaveTileState extends State<_AutoSaveTile> {
  bool _warningDialogOpen = false;

  Future<void> _onToggle(bool value, BuildContext context) async {
    final notifier = context.read<DownloadNotifier>();
    if (!value) {
      await notifier.toggleAutoSave(false);
      return;
    }
    if (notifier.autoSaveWarningDismissed) {
      await notifier.toggleAutoSave(true);
      return;
    }
    if (_warningDialogOpen) return;
    _warningDialogOpen = true;
    final result = await _showWarningDialog(context);
    _warningDialogOpen = false;
    if (result == true) {
      await notifier.toggleAutoSave(true);
    }
  }

  Future<bool?> _showWarningDialog(BuildContext context) async {
    final t = Translations.of(context);
    final notifier = context.read<DownloadNotifier>();
    final colorScheme = Theme.of(context).colorScheme;
    bool dontShowAgain = false;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            t.settings.auto_save_warning_title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.settings.auto_save_warning_message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: dontShowAgain,
                      onChanged: (v) =>
                          setDialogState(() => dontShowAgain = v ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    t.settings.auto_save_warning_dont_show_again,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                t.saved.cancel,
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(t.settings.enable),
            ),
          ],
        ),
      ),
    ).then((result) {
      if (result == true && dontShowAgain) {
        notifier.dismissAutoSaveWarning();
      }
      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final notifier = context.watch<DownloadNotifier>();
    return SwitchListTile(
      secondary: notifier.isSyncing
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Icon(
              notifier.autoSaveEnabled
                  ? Icons.save_alt_rounded
                  : Icons.save_outlined,
            ),
      title: Text(t.settings.auto_save),
      subtitle: Text(
        notifier.isSyncing
            ? t.settings.auto_save_syncing
            : notifier.autoSaveEnabled
                ? '${t.settings.auto_save_active} · ${notifier.autoSaveStorageInfo}'
                : t.settings.auto_save_inactive,
      ),
      value: notifier.autoSaveEnabled,
      onChanged: notifier.isSyncing ? null : (v) => _onToggle(v, context),
    );
  }
}
