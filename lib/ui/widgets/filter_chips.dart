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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentGreen : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle_rounded : icon,
                  size: 16,
                  color: isSelected ? Colors.white : null,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
