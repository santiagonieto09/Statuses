import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/i18n/translations.g.dart';
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
