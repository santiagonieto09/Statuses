import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/status_notifier.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final filterMode = context.select<StatusNotifier, FilterMode>(
      (n) => n.filterMode,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(t.filter.all),
            avatar: const Icon(Icons.apps_rounded, size: 16),
            selected: filterMode == FilterMode.all,
            onSelected: (_) => context.read<StatusNotifier>().setFilterMode(FilterMode.all),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: Text(t.filter.photos),
            avatar: const Icon(Icons.image_rounded, size: 16),
            selected: filterMode == FilterMode.photo,
            onSelected: (_) => context.read<StatusNotifier>().setFilterMode(FilterMode.photo),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: Text(t.filter.videos),
            avatar: const Icon(Icons.videocam_rounded, size: 16),
            selected: filterMode == FilterMode.video,
            onSelected: (_) => context.read<StatusNotifier>().setFilterMode(FilterMode.video),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
