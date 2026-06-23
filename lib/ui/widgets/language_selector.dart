import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/locale_notifier.dart';

class LanguageSelector extends StatelessWidget {
  final bool compact;

  const LanguageSelector({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final localeNotifier = context.watch<LocaleNotifier>();
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            DropdownButton<AppLocale>(
              value: localeNotifier.locale,
              underline: const SizedBox(),
              isDense: true,
              style: Theme.of(context).textTheme.bodyMedium,
              items: const [
                DropdownMenuItem(value: AppLocale.en, child: Text('English')),
                DropdownMenuItem(value: AppLocale.es, child: Text('Español')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  localeNotifier.setLocale(locale);
                }
              },
            ),
          ],
        ),
      );
    }
    return ListTile(
      leading: const Icon(Icons.translate_rounded),
      title: Text(t.settings.language),
      trailing: DropdownButton<AppLocale>(
        value: localeNotifier.locale,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: AppLocale.en, child: Text('English')),
          DropdownMenuItem(value: AppLocale.es, child: Text('Español')),
        ],
        onChanged: (locale) {
          if (locale != null) {
            localeNotifier.setLocale(locale);
          }
        },
      ),
    );
  }
}
