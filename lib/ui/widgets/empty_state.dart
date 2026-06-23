import 'package:flutter/material.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/ui/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onGrantSaf;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.hourglass_empty_rounded,
    this.onGrantSaf,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isDark
                  ? AppColors.secondaryText
                  : Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onGrantSaf != null) ..._buildSafSection(context, t),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSafSection(BuildContext context, Translations t) {
    return [
      const SizedBox(height: 28),
      const Divider(),
      const SizedBox(height: 16),
      Text(
        t.empty.saf_instructions,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.secondaryText,
            ),
      ),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: onGrantSaf,
        icon: const Icon(Icons.folder_open_rounded),
        label: Text(t.empty.saf_button),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
        ),
      ),
    ];
  }
}
