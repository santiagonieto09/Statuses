import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/status_notifier.dart';
import 'package:statuses/ui/theme/app_theme.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final cs = Theme.of(context).colorScheme;
    final filterMode = context.select<StatusNotifier, FilterMode>(
      (n) => n.filterMode,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          _chip(
            label: t.filter.all,
            icon: Icons.apps_rounded,
            isSelected: filterMode == FilterMode.all,
            onSelected: () => context.read<StatusNotifier>().setFilterMode(FilterMode.all),
            cs: cs,
          ),
          const SizedBox(width: 8),
          _chip(
            label: t.filter.photos,
            icon: Icons.image_rounded,
            isSelected: filterMode == FilterMode.photo,
            onSelected: () => context.read<StatusNotifier>().setFilterMode(FilterMode.photo),
            cs: cs,
          ),
          const SizedBox(width: 8),
          _chip(
            label: t.filter.videos,
            icon: Icons.videocam_rounded,
            isSelected: filterMode == FilterMode.video,
            onSelected: () => context.read<StatusNotifier>().setFilterMode(FilterMode.video),
            cs: cs,
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onSelected,
    required ColorScheme cs,
  }) {
    return ChoiceChip(
      label: AnimatedDefaultTextStyle(
        duration: kThemeChangeDuration,
        style: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
        child: Text(label),
      ),
      avatar: Icon(
        isSelected ? Icons.check_circle_rounded : icon,
        size: 16,
        color: isSelected ? Colors.white : null,
      ),
      selected: isSelected,
      selectedColor: AppColors.accentGreen,
      backgroundColor: cs.surfaceContainerHighest,
      side: isSelected ? const BorderSide(color: Colors.white, width: 1.5) : null,
      shape: isSelected
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          : null,
      onSelected: (_) => onSelected(),
      visualDensity: VisualDensity.compact,
      showCheckmark: false,
    );
  }
}
