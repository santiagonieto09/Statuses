import 'package:flutter/material.dart';
import 'package:statuses/i18n/translations.g.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.help.title)),
      body: _ResponsiveWrapper(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              t.help.how_to_use_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _HelpCard(
              icon: Icons.folder_open_rounded,
              title: t.help.grant_permissions_title,
              body: t.help.grant_permissions_body,
            ),
            _HelpCard(
              icon: Icons.visibility_rounded,
              title: t.help.view_statuses_title,
              body: t.help.view_statuses_body,
            ),
            _HelpCard(
              icon: Icons.download_rounded,
              title: t.help.save_statuses_title,
              body: t.help.save_statuses_body,
            ),
            _HelpCard(
              icon: Icons.share_rounded,
              title: t.help.share_content_title,
              body: t.help.share_content_body,
            ),
            _HelpCard(
              icon: Icons.grid_view_rounded,
              title: t.help.switch_view_title,
              body: t.help.switch_view_body,
            ),
            _HelpCard(
              icon: Icons.dark_mode_rounded,
              title: t.help.dark_mode_title,
              body: t.help.dark_mode_body,
            ),
            _HelpCard(
              icon: Icons.notifications_active_rounded,
              title: t.help.notification_service_title,
              body: t.help.notification_service_body,
            ),
            _HelpCard(
              icon: Icons.save_alt_rounded,
              title: t.help.auto_save_title,
              body: t.help.auto_save_body,
            ),
            _HelpCard(
              icon: Icons.check_circle_rounded,
              title: t.help.saved_indicator_title,
              body: t.help.saved_indicator_body,
            ),
            _HelpCard(
              icon: Icons.sync_rounded,
              title: t.help.sync_title,
              body: t.help.sync_body,
            ),
            _HelpCard(
              icon: Icons.storage_rounded,
              title: t.help.storage_title,
              body: t.help.storage_body,
            ),
            _HelpCard(
              icon: Icons.build_rounded,
              title: t.help.troubleshooting_title,
              body: t.help.troubleshooting_body,
            ),
            _HelpCard(
              icon: Icons.security_rounded,
              title: t.help.permissions_title,
              body: t.help.permissions_body,
            ),
            _HelpCard(
              icon: Icons.explore_rounded,
              title: t.help.stories_explanation_title,
              body: t.help.stories_explanation_body,
            ),
            _HelpCard(
              icon: Icons.dashboard_rounded,
              title: t.help.icons_badges_title,
              body: t.help.icons_badges_body,
            ),
            const SizedBox(height: 24),
            Text(
              t.help.faq_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _FaqTile(
              icon: Icons.help_outline_rounded,
              question: t.help.faq_encrypted_names_q,
              answer: t.help.faq_encrypted_names_a,
            ),
            _FaqTile(
              icon: Icons.content_copy_rounded,
              question: t.help.faq_duplicates_q,
              answer: t.help.faq_duplicates_a,
            ),
            _FaqTile(
              icon: Icons.notifications_rounded,
              question: t.help.faq_notifications_q,
              answer: t.help.faq_notifications_a,
            ),
            _FaqTile(
              icon: Icons.save_rounded,
              question: t.help.faq_auto_save_q,
              answer: t.help.faq_auto_save_a,
            ),
            _FaqTile(
              icon: Icons.translate_rounded,
              question: t.help.faq_language_q,
              answer: t.help.faq_language_a,
            ),
            _FaqTile(
              icon: Icons.storage_rounded,
              question: t.help.faq_storage_q,
              answer: t.help.faq_storage_a,
            ),
            _FaqTile(
              icon: Icons.business_rounded,
              question: t.help.faq_whatsapp_q,
              answer: t.help.faq_whatsapp_a,
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final IconData icon;
  final String question;
  final String answer;

  const _FaqTile({
    required this.icon,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
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
