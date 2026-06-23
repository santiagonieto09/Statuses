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

	/// en: 'Statuses'
	String get statuses => 'Statuses';

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
}

// Path: saved
class Translations$saved$en {
	Translations$saved$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No saved statuses'
	String get empty_title => 'No saved statuses';

	/// en: 'Statuses you download will appear here.'
	String get empty_subtitle => 'Statuses you download will appear here.';

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

	/// en: 'No statuses found'
	String get default_title => 'No statuses found';

	/// en: 'Open WhatsApp, view some statuses, then come back here.'
	String get default_subtitle => 'Open WhatsApp, view some statuses, then come back here.';

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

	/// en: 'Toggle theme'
	String get toggle_theme => 'Toggle theme';
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
			'nav.statuses' => 'Statuses',
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
			'saved.empty_title' => 'No saved statuses',
			'saved.empty_subtitle' => 'Statuses you download will appear here.',
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
			'permission.title' => 'Storage Access Required',
			'permission.description' => 'Statuses needs access to your storage to read WhatsApp status media files. Your files remain on your device.',
			'permission.grant_access' => 'Grant Access',
			'permission.permanently_denied' => 'Permission was permanently denied.\nPlease enable it in Settings.',
			'permission.open_settings' => 'Open Settings',
			'permission.privacy_note' => 'Your data stays on your device.\nStatuses does not collect any information.',
			'empty.default_title' => 'No statuses found',
			'empty.default_subtitle' => 'Open WhatsApp, view some statuses, then come back here.',
			'empty.saf_instructions' => 'If the problem persists, grant manual access to the folder:',
			'empty.saf_button' => 'Select .Statuses folder',
			'date.today' => 'Today',
			'date.yesterday' => 'Yesterday',
			'date.days_ago' => ({required Object count}) => '${count} days ago',
			'date.week_ago' => '1 week ago',
			'date.weeks_ago' => ({required Object count}) => '${count} weeks ago',
			'date.at' => 'at',
			'settings.language' => 'Language',
			'settings.theme' => 'Theme',
			'settings.light' => 'Light',
			'settings.dark' => 'Dark',
			'settings.toggle_view' => 'Toggle view',
			'settings.toggle_theme' => 'Toggle theme',
			_ => null,
		};
	}
}
