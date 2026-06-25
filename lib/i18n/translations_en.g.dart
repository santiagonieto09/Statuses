///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$filter$en filter = Translations$filter$en.internal(_root);
	late final Translations$nav$en nav = Translations$nav$en.internal(_root);
	late final Translations$detail$en detail = Translations$detail$en.internal(_root);
	late final Translations$saved$en saved = Translations$saved$en.internal(_root);
	late final Translations$permission$en permission = Translations$permission$en.internal(_root);
	late final Translations$empty$en empty = Translations$empty$en.internal(_root);
	late final Translations$date$en date = Translations$date$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$help$en help = Translations$help$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Statuses'
	String get title => 'Statuses';
}

// Path: filter
class Translations$filter$en {
	Translations$filter$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All'
	String get all => 'All';

	/// en: 'Photos'
	String get photos => 'Photos';

	/// en: 'Videos'
	String get videos => 'Videos';
}

// Path: nav
class Translations$nav$en {
	Translations$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Stories'
	String get statuses => 'Stories';

	/// en: 'Saved'
	String get saved => 'Saved';
}

// Path: detail
class Translations$detail$en {
	Translations$detail$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Info'
	String get info => 'Info';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'File Info'
	String get file_info => 'File Info';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Size'
	String get size => 'Size';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'File not found'
	String get file_not_found => 'File not found';

	/// en: 'Unable to load image'
	String get unable_to_load_image => 'Unable to load image';

	/// en: 'Loading video...'
	String get loading_video => 'Loading video...';

	/// en: 'Unsupported file type'
	String get unsupported_file_type => 'Unsupported file type';

	/// en: 'File saved successfully'
	String get saved_successfully => 'File saved successfully';

	/// en: 'VIDEO'
	String get video_badge => 'VIDEO';

	/// en: 'Saved'
	String get saved_badge => 'Saved';

	/// en: '1 new status available'
	String get new_status_single => '1 new status available';

	/// en: '$count new statuses available'
	String new_status_plural({required Object count}) => '${count} new statuses available';
}

// Path: saved
class Translations$saved$en {
	Translations$saved$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No saved stories'
	String get empty_title => 'No saved stories';

	/// en: 'Stories you download will appear here.'
	String get empty_subtitle => 'Stories you download will appear here.';

	/// en: 'No results'
	String get empty_filtered_title => 'No results';

	/// en: 'No saved files of this type.'
	String get empty_filtered_subtitle => 'No saved files of this type.';

	/// en: 'Delete files'
	String get delete_title => 'Delete files';

	/// en: '$count file(s) will be permanently deleted. This action cannot be undone.'
	String delete_message({required Object count}) => '${count} file(s) will be permanently deleted.\nThis action cannot be undone.';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: '$count selected'
	String selected_count({required Object count}) => '${count} selected';

	/// en: 'Cancel selection'
	String get cancel_selection_tooltip => 'Cancel selection';

	/// en: 'Delete selected'
	String get delete_selected_tooltip => 'Delete selected';

	/// en: '$count file(s)'
	String file_count({required Object count}) => '${count} file(s)';

	/// en: 'Pictures/$dirName'
	String header_path({required Object dirName}) => 'Pictures/${dirName}';

	/// en: 'Select all'
	String get select_all => 'Select all';

	/// en: 'Deselect all'
	String get deselect_all => 'Deselect all';
}

// Path: permission
class Translations$permission$en {
	Translations$permission$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Storage Access Required'
	String get title => 'Storage Access Required';

	/// en: 'Statuses needs access to your storage to read WhatsApp status media files. Your files remain on your device.'
	String get description => 'Statuses needs access to your storage to read WhatsApp status media files. Your files remain on your device.';

	/// en: 'Grant Access'
	String get grant_access => 'Grant Access';

	/// en: 'Permission was permanently denied. Please enable it in Settings.'
	String get permanently_denied => 'Permission was permanently denied.\nPlease enable it in Settings.';

	/// en: 'Open Settings'
	String get open_settings => 'Open Settings';

	/// en: 'Your data stays on your device. Statuses does not collect any information.'
	String get privacy_note => 'Your data stays on your device.\nStatuses does not collect any information.';
}

// Path: empty
class Translations$empty$en {
	Translations$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No stories found'
	String get default_title => 'No stories found';

	/// en: 'Open WhatsApp, view some stories, then come back here.'
	String get default_subtitle => 'Open WhatsApp, view some stories, then come back here.';

	/// en: 'If the problem persists, grant manual access to the folder:'
	String get saf_instructions => 'If the problem persists, grant manual access to the folder:';

	/// en: 'Select .Statuses folder'
	String get saf_button => 'Select .Statuses folder';
}

// Path: date
class Translations$date$en {
	Translations$date$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';

	/// en: '$count days ago'
	String days_ago({required Object count}) => '${count} days ago';

	/// en: '1 week ago'
	String get week_ago => '1 week ago';

	/// en: '$count weeks ago'
	String weeks_ago({required Object count}) => '${count} weeks ago';

	/// en: 'at'
	String get at => 'at';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'Toggle view'
	String get toggle_view => 'Toggle view';

	/// en: 'Grid'
	String get view_mode_grid => 'Grid';

	/// en: 'List'
	String get view_mode_list => 'List';

	/// en: 'Toggle theme'
	String get toggle_theme => 'Toggle theme';

	/// en: 'Notification Service'
	String get notifications => 'Notification Service';

	/// en: 'Periodically monitor statuses and notify you when new content is available.'
	String get notifications_description => 'Periodically monitor statuses and notify you when new content is available.';

	/// en: 'Active'
	String get notification_active => 'Active';

	/// en: 'Inactive'
	String get notification_inactive => 'Inactive';

	/// en: 'Notification Permission'
	String get notification_permission_title => 'Notification Permission';

	/// en: 'Notifications will alert you when new statuses are available without opening the app.'
	String get notification_permission_body => 'Notifications will alert you when new statuses are available without opening the app.';

	/// en: 'Auto-save'
	String get auto_save => 'Auto-save';

	/// en: 'Automatically save detected statuses to the app's folder.'
	String get auto_save_description => 'Automatically save detected statuses to the app\'s folder.';

	/// en: 'Enabled'
	String get auto_save_active => 'Enabled';

	/// en: 'Disabled'
	String get auto_save_inactive => 'Disabled';

	/// en: 'Storage used: $usage'
	String auto_save_storage({required Object usage}) => 'Storage used: ${usage}';

	/// en: 'Help'
	String get help => 'Help';

	/// en: 'Help Center'
	String get help_center => 'Help Center';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Statuses'
	String get app_name => 'Statuses';

	/// en: 'View and manage WhatsApp story media files'
	String get app_description => 'View and manage WhatsApp story media files';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Enable'
	String get enable => 'Enable';

	/// en: 'Enable auto-save'
	String get auto_save_warning_title => 'Enable auto-save';

	/// en: 'When enabled, all currently visible statuses will be automatically saved to your device. The app will continuously monitor and save new statuses.'
	String get auto_save_warning_message => 'When enabled, all currently visible statuses will be automatically saved to your device. The app will continuously monitor and save new statuses.';

	/// en: 'Don't show again'
	String get auto_save_warning_dont_show_again => 'Don\'t show again';

	/// en: 'Syncing statuses...'
	String get auto_save_syncing => 'Syncing statuses...';
}

// Path: help
class Translations$help$en {
	Translations$help$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Help Center'
	String get title => 'Help Center';

	/// en: 'How to use'
	String get how_to_use_title => 'How to use';

	/// en: 'Grant permissions'
	String get grant_permissions_title => 'Grant permissions';

	/// en: 'On first launch, the app will ask for storage access. Tap "Grant Access" to allow reading WhatsApp status files. Your files stay on your device.'
	String get grant_permissions_body => 'On first launch, the app will ask for storage access. Tap "Grant Access" to allow reading WhatsApp status files. Your files stay on your device.';

	/// en: 'View stories'
	String get view_statuses_title => 'View stories';

	/// en: 'Open WhatsApp and view some stories. Then come back to Statuses and they will appear automatically. Use the filter chips to show all, photos, or videos.'
	String get view_statuses_body => 'Open WhatsApp and view some stories. Then come back to Statuses and they will appear automatically. Use the filter chips to show all, photos, or videos.';

	/// en: 'Save stories'
	String get save_statuses_title => 'Save stories';

	/// en: 'Tap a story to open it in full screen. Use the Download button or the menu to save it to your device.'
	String get save_statuses_body => 'Tap a story to open it in full screen. Use the Download button or the menu to save it to your device.';

	/// en: 'Share content'
	String get share_content_title => 'Share content';

	/// en: 'Open a story and tap the Share button or use the menu to share it with other apps.'
	String get share_content_body => 'Open a story and tap the Share button or use the menu to share it with other apps.';

	/// en: 'Switch between grid and list view'
	String get switch_view_title => 'Switch between grid and list view';

	/// en: 'Tap the grid/list icon in the app bar to toggle between a compact grid view and a detailed list view.'
	String get switch_view_body => 'Tap the grid/list icon in the app bar to toggle between a compact grid view and a detailed list view.';

	/// en: 'Dark mode'
	String get dark_mode_title => 'Dark mode';

	/// en: 'You can switch between light and dark mode in Settings. The app also follows your system theme automatically.'
	String get dark_mode_body => 'You can switch between light and dark mode in Settings. The app also follows your system theme automatically.';

	/// en: 'Notification System'
	String get notification_service_title => 'Notification System';

	/// en: 'Enable notifications to receive alerts when new statuses are available without opening the app. The system checks every 60 seconds and notifies you of new content.'
	String get notification_service_body => 'Enable notifications to receive alerts when new statuses are available without opening the app. The system checks every 60 seconds and notifies you of new content.';

	/// en: 'Auto-save'
	String get auto_save_title => 'Auto-save';

	/// en: 'When enabled, the app automatically saves all visible statuses to your device. It works in the background and avoids duplicates. You can see storage usage in Settings.'
	String get auto_save_body => 'When enabled, the app automatically saves all visible statuses to your device. It works in the background and avoids duplicates. You can see storage usage in Settings.';

	/// en: 'Saved Status Indicators'
	String get saved_indicator_title => 'Saved Status Indicators';

	/// en: 'Statuses that have already been saved show a green checkmark icon. In the detail view, the download button changes to "Saved" and is disabled to prevent duplicates.'
	String get saved_indicator_body => 'Statuses that have already been saved show a green checkmark icon. In the detail view, the download button changes to "Saved" and is disabled to prevent duplicates.';

	/// en: 'Automatic Synchronization'
	String get sync_title => 'Automatic Synchronization';

	/// en: 'The app automatically detects new statuses in WhatsApp folders. The file watcher checks for changes every 30 seconds. This works even when the app is in the background.'
	String get sync_body => 'The app automatically detects new statuses in WhatsApp folders. The file watcher checks for changes every 30 seconds. This works even when the app is in the background.';

	/// en: 'Storage Management'
	String get storage_title => 'Storage Management';

	/// en: 'Saved statuses are stored in Pictures/Statuses on your device. You can see exact usage in Settings. Delete unwanted files from the Saved tab by long-pressing to select.'
	String get storage_body => 'Saved statuses are stored in Pictures/Statuses on your device. You can see exact usage in Settings. Delete unwanted files from the Saved tab by long-pressing to select.';

	/// en: 'Troubleshooting'
	String get troubleshooting_title => 'Troubleshooting';

	/// en: 'If statuses don't appear: 1) Make sure you've viewed stories in WhatsApp recently. 2) Check that storage permissions are granted. 3) Try tapping "Grant Access" to manually select the .Statuses folder. 4) Restart the app.'
	String get troubleshooting_body => 'If statuses don\'t appear: 1) Make sure you\'ve viewed stories in WhatsApp recently. 2) Check that storage permissions are granted. 3) Try tapping "Grant Access" to manually select the .Statuses folder. 4) Restart the app.';

	/// en: 'Required Permissions'
	String get permissions_title => 'Required Permissions';

	/// en: 'The app needs storage access to read WhatsApp status files. On Android 13+ it also needs notification permission for alerts. No data leaves your device.'
	String get permissions_body => 'The app needs storage access to read WhatsApp status files. On Android 13+ it also needs notification permission for alerts. No data leaves your device.';

	/// en: 'How Stories Work'
	String get stories_explanation_title => 'How Stories Work';

	/// en: 'Statuses reads the .Statuses folder where WhatsApp temporarily stores viewed stories. Files have internal names generated by WhatsApp — this is normal and does not affect functionality.'
	String get stories_explanation_body => 'Statuses reads the .Statuses folder where WhatsApp temporarily stores viewed stories. Files have internal names generated by WhatsApp — this is normal and does not affect functionality.';

	/// en: 'Icons and Badges'
	String get icons_badges_title => 'Icons and Badges';

	/// en: 'The Stories tab shows a ring icon. Number badges on the bottom bar indicate how many stories or saved files are available. A green checkmark means a file is already saved.'
	String get icons_badges_body => 'The Stories tab shows a ring icon. Number badges on the bottom bar indicate how many stories or saved files are available. A green checkmark means a file is already saved.';

	/// en: 'Frequently asked questions'
	String get faq_title => 'Frequently asked questions';

	/// en: 'Why do files have strange names?'
	String get faq_encrypted_names_q => 'Why do files have strange names?';

	/// en: 'WhatsApp temporarily stores statuses using internal names automatically generated by the system. These names do not correspond to the original file name and are used by WhatsApp to optimize storage and content management. This is completely normal and does not affect the viewing or functioning of the statuses.'
	String get faq_encrypted_names_a => 'WhatsApp temporarily stores statuses using internal names automatically generated by the system. These names do not correspond to the original file name and are used by WhatsApp to optimize storage and content management. This is completely normal and does not affect the viewing or functioning of the statuses.';

	/// en: 'Why do I see duplicate statuses?'
	String get faq_duplicates_q => 'Why do I see duplicate statuses?';

	/// en: 'The app now prevents duplicates by checking file name, size, and content hash. If you see duplicates from before this update, they are existing files that were saved previously. You can delete them manually from the Saved tab.'
	String get faq_duplicates_a => 'The app now prevents duplicates by checking file name, size, and content hash. If you see duplicates from before this update, they are existing files that were saved previously. You can delete them manually from the Saved tab.';

	/// en: 'How do notifications work?'
	String get faq_notifications_q => 'How do notifications work?';

	/// en: 'When enabled in Settings, the app checks for new statuses every 60 seconds. If new content is found, a notification is shown. You can enable or disable this at any time.'
	String get faq_notifications_a => 'When enabled in Settings, the app checks for new statuses every 60 seconds. If new content is found, a notification is shown. You can enable or disable this at any time.';

	/// en: 'What does auto-save do exactly?'
	String get faq_auto_save_q => 'What does auto-save do exactly?';

	/// en: 'When enabled, the app immediately saves all currently visible stories. Then it continuously monitors for new stories and saves them automatically. Duplicates are prevented by content hash comparison.'
	String get faq_auto_save_a => 'When enabled, the app immediately saves all currently visible stories. Then it continuously monitors for new stories and saves them automatically. Duplicates are prevented by content hash comparison.';

	/// en: 'How do I change the language?'
	String get faq_language_q => 'How do I change the language?';

	/// en: 'Go to Settings and use the Language selector to switch between English and Spanish. The change takes effect immediately.'
	String get faq_language_a => 'Go to Settings and use the Language selector to switch between English and Spanish. The change takes effect immediately.';

	/// en: 'How much space am I using?'
	String get faq_storage_q => 'How much space am I using?';

	/// en: 'Go to Settings and look at the Auto-save section. It shows the total storage used by saved statuses. The Storage Management section in Help Center has more details.'
	String get faq_storage_a => 'Go to Settings and look at the Auto-save section. It shows the total storage used by saved statuses. The Storage Management section in Help Center has more details.';

	/// en: 'Does this work with WhatsApp Business?'
	String get faq_whatsapp_q => 'Does this work with WhatsApp Business?';

	/// en: 'Yes, Statuses supports both WhatsApp and WhatsApp Business. The app automatically detects status folders from both versions.'
	String get faq_whatsapp_a => 'Yes, Statuses supports both WhatsApp and WhatsApp Business. The app automatically detects status folders from both versions.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Statuses',
			'filter.all' => 'All',
			'filter.photos' => 'Photos',
			'filter.videos' => 'Videos',
			'nav.statuses' => 'Stories',
			'nav.saved' => 'Saved',
			'detail.download' => 'Download',
			'detail.share' => 'Share',
			'detail.info' => 'Info',
			'detail.close' => 'Close',
			'detail.file_info' => 'File Info',
			'detail.name' => 'Name',
			'detail.size' => 'Size',
			'detail.type' => 'Type',
			'detail.date' => 'Date',
			'detail.file_not_found' => 'File not found',
			'detail.unable_to_load_image' => 'Unable to load image',
			'detail.loading_video' => 'Loading video...',
			'detail.unsupported_file_type' => 'Unsupported file type',
			'detail.saved_successfully' => 'File saved successfully',
			'detail.video_badge' => 'VIDEO',
			'detail.saved_badge' => 'Saved',
			'detail.new_status_single' => '1 new status available',
			'detail.new_status_plural' => ({required Object count}) => '${count} new statuses available',
			'saved.empty_title' => 'No saved stories',
			'saved.empty_subtitle' => 'Stories you download will appear here.',
			'saved.empty_filtered_title' => 'No results',
			'saved.empty_filtered_subtitle' => 'No saved files of this type.',
			'saved.delete_title' => 'Delete files',
			'saved.delete_message' => ({required Object count}) => '${count} file(s) will be permanently deleted.\nThis action cannot be undone.',
			'saved.cancel' => 'Cancel',
			'saved.delete' => 'Delete',
			'saved.selected_count' => ({required Object count}) => '${count} selected',
			'saved.cancel_selection_tooltip' => 'Cancel selection',
			'saved.delete_selected_tooltip' => 'Delete selected',
			'saved.file_count' => ({required Object count}) => '${count} file(s)',
			'saved.header_path' => ({required Object dirName}) => 'Pictures/${dirName}',
			'saved.select_all' => 'Select all',
			'saved.deselect_all' => 'Deselect all',
			'permission.title' => 'Storage Access Required',
			'permission.description' => 'Statuses needs access to your storage to read WhatsApp status media files. Your files remain on your device.',
			'permission.grant_access' => 'Grant Access',
			'permission.permanently_denied' => 'Permission was permanently denied.\nPlease enable it in Settings.',
			'permission.open_settings' => 'Open Settings',
			'permission.privacy_note' => 'Your data stays on your device.\nStatuses does not collect any information.',
			'empty.default_title' => 'No stories found',
			'empty.default_subtitle' => 'Open WhatsApp, view some stories, then come back here.',
			'empty.saf_instructions' => 'If the problem persists, grant manual access to the folder:',
			'empty.saf_button' => 'Select .Statuses folder',
			'date.today' => 'Today',
			'date.yesterday' => 'Yesterday',
			'date.days_ago' => ({required Object count}) => '${count} days ago',
			'date.week_ago' => '1 week ago',
			'date.weeks_ago' => ({required Object count}) => '${count} weeks ago',
			'date.at' => 'at',
			'settings.title' => 'Settings',
			'settings.appearance' => 'Appearance',
			'settings.language' => 'Language',
			'settings.theme' => 'Theme',
			'settings.light' => 'Light',
			'settings.dark' => 'Dark',
			'settings.toggle_view' => 'Toggle view',
			'settings.view_mode_grid' => 'Grid',
			'settings.view_mode_list' => 'List',
			'settings.toggle_theme' => 'Toggle theme',
			'settings.notifications' => 'Notification Service',
			'settings.notifications_description' => 'Periodically monitor statuses and notify you when new content is available.',
			'settings.notification_active' => 'Active',
			'settings.notification_inactive' => 'Inactive',
			'settings.notification_permission_title' => 'Notification Permission',
			'settings.notification_permission_body' => 'Notifications will alert you when new statuses are available without opening the app.',
			'settings.auto_save' => 'Auto-save',
			'settings.auto_save_description' => 'Automatically save detected statuses to the app\'s folder.',
			'settings.auto_save_active' => 'Enabled',
			'settings.auto_save_inactive' => 'Disabled',
			'settings.auto_save_storage' => ({required Object usage}) => 'Storage used: ${usage}',
			'settings.help' => 'Help',
			'settings.help_center' => 'Help Center',
			'settings.about' => 'About',
			'settings.app_name' => 'Statuses',
			'settings.app_description' => 'View and manage WhatsApp story media files',
			'settings.version' => 'Version',
			'settings.enable' => 'Enable',
			'settings.auto_save_warning_title' => 'Enable auto-save',
			'settings.auto_save_warning_message' => 'When enabled, all currently visible statuses will be automatically saved to your device. The app will continuously monitor and save new statuses.',
			'settings.auto_save_warning_dont_show_again' => 'Don\'t show again',
			'settings.auto_save_syncing' => 'Syncing statuses...',
			'help.title' => 'Help Center',
			'help.how_to_use_title' => 'How to use',
			'help.grant_permissions_title' => 'Grant permissions',
			'help.grant_permissions_body' => 'On first launch, the app will ask for storage access. Tap "Grant Access" to allow reading WhatsApp status files. Your files stay on your device.',
			'help.view_statuses_title' => 'View stories',
			'help.view_statuses_body' => 'Open WhatsApp and view some stories. Then come back to Statuses and they will appear automatically. Use the filter chips to show all, photos, or videos.',
			'help.save_statuses_title' => 'Save stories',
			'help.save_statuses_body' => 'Tap a story to open it in full screen. Use the Download button or the menu to save it to your device.',
			'help.share_content_title' => 'Share content',
			'help.share_content_body' => 'Open a story and tap the Share button or use the menu to share it with other apps.',
			'help.switch_view_title' => 'Switch between grid and list view',
			'help.switch_view_body' => 'Tap the grid/list icon in the app bar to toggle between a compact grid view and a detailed list view.',
			'help.dark_mode_title' => 'Dark mode',
			'help.dark_mode_body' => 'You can switch between light and dark mode in Settings. The app also follows your system theme automatically.',
			'help.notification_service_title' => 'Notification System',
			'help.notification_service_body' => 'Enable notifications to receive alerts when new statuses are available without opening the app. The system checks every 60 seconds and notifies you of new content.',
			'help.auto_save_title' => 'Auto-save',
			'help.auto_save_body' => 'When enabled, the app automatically saves all visible statuses to your device. It works in the background and avoids duplicates. You can see storage usage in Settings.',
			'help.saved_indicator_title' => 'Saved Status Indicators',
			'help.saved_indicator_body' => 'Statuses that have already been saved show a green checkmark icon. In the detail view, the download button changes to "Saved" and is disabled to prevent duplicates.',
			'help.sync_title' => 'Automatic Synchronization',
			'help.sync_body' => 'The app automatically detects new statuses in WhatsApp folders. The file watcher checks for changes every 30 seconds. This works even when the app is in the background.',
			'help.storage_title' => 'Storage Management',
			'help.storage_body' => 'Saved statuses are stored in Pictures/Statuses on your device. You can see exact usage in Settings. Delete unwanted files from the Saved tab by long-pressing to select.',
			'help.troubleshooting_title' => 'Troubleshooting',
			'help.troubleshooting_body' => 'If statuses don\'t appear: 1) Make sure you\'ve viewed stories in WhatsApp recently. 2) Check that storage permissions are granted. 3) Try tapping "Grant Access" to manually select the .Statuses folder. 4) Restart the app.',
			'help.permissions_title' => 'Required Permissions',
			'help.permissions_body' => 'The app needs storage access to read WhatsApp status files. On Android 13+ it also needs notification permission for alerts. No data leaves your device.',
			'help.stories_explanation_title' => 'How Stories Work',
			'help.stories_explanation_body' => 'Statuses reads the .Statuses folder where WhatsApp temporarily stores viewed stories. Files have internal names generated by WhatsApp — this is normal and does not affect functionality.',
			'help.icons_badges_title' => 'Icons and Badges',
			'help.icons_badges_body' => 'The Stories tab shows a ring icon. Number badges on the bottom bar indicate how many stories or saved files are available. A green checkmark means a file is already saved.',
			'help.faq_title' => 'Frequently asked questions',
			'help.faq_encrypted_names_q' => 'Why do files have strange names?',
			'help.faq_encrypted_names_a' => 'WhatsApp temporarily stores statuses using internal names automatically generated by the system. These names do not correspond to the original file name and are used by WhatsApp to optimize storage and content management. This is completely normal and does not affect the viewing or functioning of the statuses.',
			'help.faq_duplicates_q' => 'Why do I see duplicate statuses?',
			'help.faq_duplicates_a' => 'The app now prevents duplicates by checking file name, size, and content hash. If you see duplicates from before this update, they are existing files that were saved previously. You can delete them manually from the Saved tab.',
			'help.faq_notifications_q' => 'How do notifications work?',
			'help.faq_notifications_a' => 'When enabled in Settings, the app checks for new statuses every 60 seconds. If new content is found, a notification is shown. You can enable or disable this at any time.',
			'help.faq_auto_save_q' => 'What does auto-save do exactly?',
			'help.faq_auto_save_a' => 'When enabled, the app immediately saves all currently visible stories. Then it continuously monitors for new stories and saves them automatically. Duplicates are prevented by content hash comparison.',
			'help.faq_language_q' => 'How do I change the language?',
			'help.faq_language_a' => 'Go to Settings and use the Language selector to switch between English and Spanish. The change takes effect immediately.',
			'help.faq_storage_q' => 'How much space am I using?',
			'help.faq_storage_a' => 'Go to Settings and look at the Auto-save section. It shows the total storage used by saved statuses. The Storage Management section in Help Center has more details.',
			'help.faq_whatsapp_q' => 'Does this work with WhatsApp Business?',
			'help.faq_whatsapp_a' => 'Yes, Statuses supports both WhatsApp and WhatsApp Business. The app automatically detects status folders from both versions.',
			_ => null,
		};
	}
}
