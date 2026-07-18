///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$es app = _Translations$app$es._(_root);
	@override late final _Translations$filter$es filter = _Translations$filter$es._(_root);
	@override late final _Translations$nav$es nav = _Translations$nav$es._(_root);
	@override late final _Translations$detail$es detail = _Translations$detail$es._(_root);
	@override late final _Translations$saved$es saved = _Translations$saved$es._(_root);
	@override late final _Translations$permission$es permission = _Translations$permission$es._(_root);
	@override late final _Translations$empty$es empty = _Translations$empty$es._(_root);
	@override late final _Translations$date$es date = _Translations$date$es._(_root);
	@override late final _Translations$settings$es settings = _Translations$settings$es._(_root);
	@override late final _Translations$help$es help = _Translations$help$es._(_root);
}

// Path: app
class _Translations$app$es extends Translations$app$en {
	_Translations$app$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Statuses';
}

// Path: filter
class _Translations$filter$es extends Translations$filter$en {
	_Translations$filter$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get all => 'Todo';
	@override String get photos => 'Fotos';
	@override String get videos => 'Videos';
}

// Path: nav
class _Translations$nav$es extends Translations$nav$en {
	_Translations$nav$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get statuses => 'Historias';
	@override String get saved => 'Guardados';
}

// Path: detail
class _Translations$detail$es extends Translations$detail$en {
	_Translations$detail$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get download => 'Descargar';
	@override String get share => 'Compartir';
	@override String get info => 'Información';
	@override String get close => 'Cerrar';
	@override String get file_info => 'Información del archivo';
	@override String get name => 'Nombre';
	@override String get size => 'Tamaño';
	@override String get type => 'Tipo';
	@override String get date => 'Fecha';
	@override String get file_not_found => 'Archivo no encontrado';
	@override String get unable_to_load_image => 'No se pudo cargar la imagen';
	@override String get loading_video => 'Cargando video...';
	@override String get unsupported_file_type => 'Tipo de archivo no soportado';
	@override String get saved_successfully => 'Archivo guardado correctamente';
	@override String get video_badge => 'VIDEO';
	@override String get saved_badge => 'Guardado';
	@override String get new_status_single => '1 nuevo estado disponible';
	@override String new_status_plural({required Object count}) => '${count} nuevos estados disponibles';
}

// Path: saved
class _Translations$saved$es extends Translations$saved$en {
	_Translations$saved$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get empty_title => 'Sin historias guardadas';
	@override String get empty_subtitle => 'Las historias que descargues aparecerán aquí.';
	@override String get empty_filtered_title => 'Sin resultados';
	@override String get empty_filtered_subtitle => 'No hay archivos guardados de este tipo.';
	@override String get delete_title => 'Eliminar archivos';
	@override String delete_message({required Object count}) => 'Se eliminará(n) ${count} archivo(s) permanentemente.\nEsta acción no se puede deshacer.';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String selected_count({required Object count}) => '${count} seleccionado(s)';
	@override String get cancel_selection_tooltip => 'Cancelar selección';
	@override String get delete_selected_tooltip => 'Eliminar seleccionados';
	@override String file_count({required Object count}) => '${count} archivo(s)';
	@override String header_path({required Object dirName}) => 'Pictures/${dirName}';
	@override String get select_all => 'Seleccionar todo';
	@override String get deselect_all => 'Deseleccionar todo';
}

// Path: permission
class _Translations$permission$es extends Translations$permission$en {
	_Translations$permission$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Permitir acceso al almacenamiento';
	@override String get description => 'Statuses necesita acceso al almacenamiento para localizar y mostrar los estados multimedia disponibles en tu dispositivo.';
	@override String get grant_access => 'Conceder acceso';
	@override String get permanently_denied => 'El permiso fue denegado permanentemente.\nActívalo en Ajustes.';
	@override String get open_settings => 'Abrir Ajustes';
	@override String get privacy_note => 'Tus datos permanecen en tu dispositivo.\nStatuses no recopila ninguna información.';
}

// Path: empty
class _Translations$empty$es extends Translations$empty$en {
	_Translations$empty$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get default_title => 'No se encontraron historias';
	@override String get default_subtitle => 'Abre WhatsApp, ve algunas historias y vuelve aquí.';
	@override String get saf_instructions => 'Si el problema persiste, concede acceso manual a la carpeta:';
	@override String get saf_button => 'Seleccionar carpeta .Statuses';
}

// Path: date
class _Translations$date$es extends Translations$date$en {
	_Translations$date$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get today => 'Hoy';
	@override String get yesterday => 'Ayer';
	@override String days_ago({required Object count}) => 'hace ${count} días';
	@override String get week_ago => 'hace 1 semana';
	@override String weeks_ago({required Object count}) => 'hace ${count} semanas';
	@override String get at => 'a las';
}

// Path: settings
class _Translations$settings$es extends Translations$settings$en {
	_Translations$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuración';
	@override String get appearance => 'Apariencia';
	@override String get language => 'Idioma';
	@override String get theme => 'Tema';
	@override String get light => 'Claro';
	@override String get dark => 'Oscuro';
	@override String get toggle_view => 'Cambiar vista';
	@override String get view_mode_grid => 'Cuadrícula';
	@override String get view_mode_list => 'Lista';
	@override String get toggle_theme => 'Cambiar tema';
	@override String get notifications => 'Servicio de notificaciones';
	@override String get notifications_description => 'Monitorear periódicamente los estados y notificar cuando existan nuevos contenidos.';
	@override String get notification_active => 'Activo';
	@override String get notification_inactive => 'Inactivo';
	@override String get notification_permission_title => 'Permiso de notificaciones';
	@override String get notification_permission_body => 'Las notificaciones te avisarán cuando haya nuevos estados disponibles sin necesidad de abrir la aplicación.';
	@override String get auto_save => 'Guardado automático';
	@override String get auto_save_description => 'Guardar automáticamente los estados detectados en la carpeta de la aplicación.';
	@override String get auto_save_active => 'Activado';
	@override String get auto_save_inactive => 'Desactivado';
	@override String auto_save_storage({required Object usage}) => 'Espacio utilizado: ${usage}';
	@override String get help => 'Ayuda';
	@override String get help_center => 'Centro de ayuda';
	@override String get about => 'Acerca de';
	@override String get app_name => 'Statuses';
	@override String get app_description => 'Visualiza y gestiona archivos multimedia de historias de WhatsApp';
	@override String get version => 'Versión';
	@override String get enable => 'Activar';
	@override String get auto_save_warning_title => 'Activar guardado automático';
	@override String get auto_save_warning_message => 'Al activar esta opción, todos los estados visibles actualmente se guardarán automáticamente en tu dispositivo. La app monitoreará continuamente y guardará nuevos estados.';
	@override String get auto_save_warning_dont_show_again => 'No mostrar de nuevo';
	@override String get auto_save_syncing => 'Sincronizando estados...';
}

// Path: help
class _Translations$help$es extends Translations$help$en {
	_Translations$help$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Centro de ayuda';
	@override String get how_to_use_title => 'Cómo usar';
	@override String get grant_permissions_title => 'Conceder permisos';
	@override String get grant_permissions_body => 'Al abrir la app por primera vez, se solicitará acceso al almacenamiento. Toca "Conceder acceso" para permitir la lectura de los estados de WhatsApp. Tus archivos permanecen en tu dispositivo.';
	@override String get view_statuses_title => 'Ver historias';
	@override String get view_statuses_body => 'Abre WhatsApp y visualiza algunas historias. Luego vuelve a Statuses y aparecerán automáticamente. Usa los filtros para mostrar todo, fotos o videos.';
	@override String get save_statuses_title => 'Guardar historias';
	@override String get save_statuses_body => 'Toca una historia para abrirla en pantalla completa. Usa el botón de descarga o el menú para guardarla en tu dispositivo.';
	@override String get share_content_title => 'Compartir contenido';
	@override String get share_content_body => 'Abre una historia y toca el botón de compartir o usa el menú para compartirla con otras aplicaciones.';
	@override String get switch_view_title => 'Cambiar entre vista de cuadrícula y lista';
	@override String get switch_view_body => 'Desde Ajustes puedes alternar entre la vista de cuadrícula y la vista de lista para navegar los estados.';
	@override String get dark_mode_title => 'Modo oscuro';
	@override String get dark_mode_body => 'Puedes cambiar entre modo claro y oscuro en Configuración. La app también sigue el tema del sistema automáticamente.';
	@override String get notification_service_title => 'Sistema de notificaciones';
	@override String get notification_service_body => 'Activa las notificaciones para recibir alertas cuando haya nuevos estados disponibles sin abrir la app. El sistema verifica cada 60 segundos y te notifica de nuevo contenido.';
	@override String get auto_save_title => 'Guardado automático';
	@override String get auto_save_body => 'Al activarlo, la app guarda automáticamente todos los estados visibles en tu dispositivo. Funciona en segundo plano y evita duplicados. Puedes ver el uso de almacenamiento en Configuración.';
	@override String get saved_indicator_title => 'Indicadores de estados guardados';
	@override String get saved_indicator_body => 'Los estados ya guardados muestran un icono de check verde. En la vista de detalle, el botón de descarga cambia a "Guardado" y se desactiva para evitar duplicados.';
	@override String get sync_title => 'Sincronización automática';
	@override String get sync_body => 'La app detecta automáticamente nuevos estados en las carpetas de WhatsApp. El vigilador de archivos verifica cambios cada 30 segundos. Esto funciona incluso con la app en segundo plano.';
	@override String get storage_title => 'Gestión de almacenamiento';
	@override String get storage_body => 'Los estados guardados se almacenan en Pictures/Statuses de tu dispositivo. Puedes ver el uso exacto en Configuración. Elimina archivos no deseados desde la pestaña Guardados manteniendo presionado para seleccionar.';
	@override String get troubleshooting_title => 'Solución de problemas';
	@override String get troubleshooting_body => 'Si los estados no aparecen: 1) Asegúrate de haber visto historias en WhatsApp recientemente. 2) Verifica que los permisos de almacenamiento estén concedidos. 3) Intenta tocar "Conceder acceso" para seleccionar manualmente la carpeta .Statuses. 4) Reinicia la app.';
	@override String get permissions_title => 'Permisos requeridos';
	@override String get permissions_body => 'La app necesita acceso al almacenamiento para leer los archivos de estado de WhatsApp. En Android 13+ también necesita permiso de notificaciones para las alertas. Ningún dato sale de tu dispositivo.';
	@override String get stories_explanation_title => 'Cómo funcionan las Historias';
	@override String get stories_explanation_body => 'Statuses lee la carpeta .Statuses donde WhatsApp almacena temporalmente las historias vistas. Los archivos tienen nombres internos generados por WhatsApp — esto es normal y no afecta la funcionalidad.';
	@override String get icons_badges_title => 'Iconos y badges';
	@override String get icons_badges_body => 'La pestaña de Historias muestra un icono de anillo. Los badges numéricos en la barra inferior indican cuántas historias o archivos guardados hay disponibles. Un check verde significa que el archivo ya está guardado.';
	@override String get faq_title => 'Preguntas frecuentes';
	@override String get faq_encrypted_names_q => '¿Por qué los archivos tienen nombres extraños?';
	@override String get faq_encrypted_names_a => 'WhatsApp almacena temporalmente los estados utilizando nombres internos generados automáticamente por el sistema. Estos nombres no corresponden al nombre original del archivo y son utilizados por WhatsApp para optimizar el almacenamiento y la gestión del contenido. Esto es completamente normal y no afecta la visualización ni el funcionamiento de los estados.';
	@override String get faq_duplicates_q => '¿Por qué veo estados duplicados?';
	@override String get faq_duplicates_a => 'A veces aparecen archivos que parecen duplicados porque varios contactos han publicado o compartido el mismo estado. La aplicación guarda cada copia que recibe, por eso verás varias entradas idénticas aunque provengan del mismo contenido. Puedes eliminar copias no deseadas desde la pestaña Guardados.';
	@override String get faq_notifications_q => '¿Cómo funcionan las notificaciones?';
	@override String get faq_notifications_a => 'Al activarlas en Configuración, la app verifica nuevos estados cada 60 segundos. Si encuentra contenido nuevo, muestra una notificación. Puedes activarlas o desactivarlas en cualquier momento.';
	@override String get faq_auto_save_q => '¿Qué hace exactamente el guardado automático?';
	@override String get faq_auto_save_a => 'Al activarlo, la app guarda inmediatamente todas las historias visibles actualmente. Luego monitorea continuamente nuevas historias y las guarda automáticamente. Los duplicados se previenen mediante comparación de hash de contenido.';
	@override String get faq_language_q => '¿Cómo cambio el idioma?';
	@override String get faq_language_a => 'Ve a Configuración y usa el selector de Idioma para cambiar entre Inglés y Español. El cambio se aplica inmediatamente.';
	@override String get faq_storage_q => '¿Cuánto espacio estoy usando?';
	@override String get faq_storage_a => 'Ve a Configuración y mira la sección de Guardado automático. Muestra el almacenamiento total usado por los estados guardados. La sección Gestión de almacenamiento en el Centro de ayuda tiene más detalles.';
	@override String get faq_whatsapp_q => '¿Funciona con WhatsApp Business?';
	@override String get faq_whatsapp_a => 'Sí, Statuses soporta tanto WhatsApp como WhatsApp Business. La app detecta automáticamente las carpetas de estados de ambas versiones.';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Statuses',
			'filter.all' => 'Todo',
			'filter.photos' => 'Fotos',
			'filter.videos' => 'Videos',
			'nav.statuses' => 'Historias',
			'nav.saved' => 'Guardados',
			'detail.download' => 'Descargar',
			'detail.share' => 'Compartir',
			'detail.info' => 'Información',
			'detail.close' => 'Cerrar',
			'detail.file_info' => 'Información del archivo',
			'detail.name' => 'Nombre',
			'detail.size' => 'Tamaño',
			'detail.type' => 'Tipo',
			'detail.date' => 'Fecha',
			'detail.file_not_found' => 'Archivo no encontrado',
			'detail.unable_to_load_image' => 'No se pudo cargar la imagen',
			'detail.loading_video' => 'Cargando video...',
			'detail.unsupported_file_type' => 'Tipo de archivo no soportado',
			'detail.saved_successfully' => 'Archivo guardado correctamente',
			'detail.video_badge' => 'VIDEO',
			'detail.saved_badge' => 'Guardado',
			'detail.new_status_single' => '1 nuevo estado disponible',
			'detail.new_status_plural' => ({required Object count}) => '${count} nuevos estados disponibles',
			'saved.empty_title' => 'Sin historias guardadas',
			'saved.empty_subtitle' => 'Las historias que descargues aparecerán aquí.',
			'saved.empty_filtered_title' => 'Sin resultados',
			'saved.empty_filtered_subtitle' => 'No hay archivos guardados de este tipo.',
			'saved.delete_title' => 'Eliminar archivos',
			'saved.delete_message' => ({required Object count}) => 'Se eliminará(n) ${count} archivo(s) permanentemente.\nEsta acción no se puede deshacer.',
			'saved.cancel' => 'Cancelar',
			'saved.delete' => 'Eliminar',
			'saved.selected_count' => ({required Object count}) => '${count} seleccionado(s)',
			'saved.cancel_selection_tooltip' => 'Cancelar selección',
			'saved.delete_selected_tooltip' => 'Eliminar seleccionados',
			'saved.file_count' => ({required Object count}) => '${count} archivo(s)',
			'saved.header_path' => ({required Object dirName}) => 'Pictures/${dirName}',
			'saved.select_all' => 'Seleccionar todo',
			'saved.deselect_all' => 'Deseleccionar todo',
			'permission.title' => 'Permitir acceso al almacenamiento',
			'permission.description' => 'Statuses necesita acceso al almacenamiento para localizar y mostrar los estados multimedia disponibles en tu dispositivo.',
			'permission.grant_access' => 'Conceder acceso',
			'permission.permanently_denied' => 'El permiso fue denegado permanentemente.\nActívalo en Ajustes.',
			'permission.open_settings' => 'Abrir Ajustes',
			'permission.privacy_note' => 'Tus datos permanecen en tu dispositivo.\nStatuses no recopila ninguna información.',
			'empty.default_title' => 'No se encontraron historias',
			'empty.default_subtitle' => 'Abre WhatsApp, ve algunas historias y vuelve aquí.',
			'empty.saf_instructions' => 'Si el problema persiste, concede acceso manual a la carpeta:',
			'empty.saf_button' => 'Seleccionar carpeta .Statuses',
			'date.today' => 'Hoy',
			'date.yesterday' => 'Ayer',
			'date.days_ago' => ({required Object count}) => 'hace ${count} días',
			'date.week_ago' => 'hace 1 semana',
			'date.weeks_ago' => ({required Object count}) => 'hace ${count} semanas',
			'date.at' => 'a las',
			'settings.title' => 'Configuración',
			'settings.appearance' => 'Apariencia',
			'settings.language' => 'Idioma',
			'settings.theme' => 'Tema',
			'settings.light' => 'Claro',
			'settings.dark' => 'Oscuro',
			'settings.toggle_view' => 'Cambiar vista',
			'settings.view_mode_grid' => 'Cuadrícula',
			'settings.view_mode_list' => 'Lista',
			'settings.toggle_theme' => 'Cambiar tema',
			'settings.notifications' => 'Servicio de notificaciones',
			'settings.notifications_description' => 'Monitorear periódicamente los estados y notificar cuando existan nuevos contenidos.',
			'settings.notification_active' => 'Activo',
			'settings.notification_inactive' => 'Inactivo',
			'settings.notification_permission_title' => 'Permiso de notificaciones',
			'settings.notification_permission_body' => 'Las notificaciones te avisarán cuando haya nuevos estados disponibles sin necesidad de abrir la aplicación.',
			'settings.auto_save' => 'Guardado automático',
			'settings.auto_save_description' => 'Guardar automáticamente los estados detectados en la carpeta de la aplicación.',
			'settings.auto_save_active' => 'Activado',
			'settings.auto_save_inactive' => 'Desactivado',
			'settings.auto_save_storage' => ({required Object usage}) => 'Espacio utilizado: ${usage}',
			'settings.help' => 'Ayuda',
			'settings.help_center' => 'Centro de ayuda',
			'settings.about' => 'Acerca de',
			'settings.app_name' => 'Statuses',
			'settings.app_description' => 'Visualiza y gestiona archivos multimedia de historias de WhatsApp',
			'settings.version' => 'Versión',
			'settings.enable' => 'Activar',
			'settings.auto_save_warning_title' => 'Activar guardado automático',
			'settings.auto_save_warning_message' => 'Al activar esta opción, todos los estados visibles actualmente se guardarán automáticamente en tu dispositivo. La app monitoreará continuamente y guardará nuevos estados.',
			'settings.auto_save_warning_dont_show_again' => 'No mostrar de nuevo',
			'settings.auto_save_syncing' => 'Sincronizando estados...',
			'help.title' => 'Centro de ayuda',
			'help.how_to_use_title' => 'Cómo usar',
			'help.grant_permissions_title' => 'Conceder permisos',
			'help.grant_permissions_body' => 'Al abrir la app por primera vez, se solicitará acceso al almacenamiento. Toca "Conceder acceso" para permitir la lectura de los estados de WhatsApp. Tus archivos permanecen en tu dispositivo.',
			'help.view_statuses_title' => 'Ver historias',
			'help.view_statuses_body' => 'Abre WhatsApp y visualiza algunas historias. Luego vuelve a Statuses y aparecerán automáticamente. Usa los filtros para mostrar todo, fotos o videos.',
			'help.save_statuses_title' => 'Guardar historias',
			'help.save_statuses_body' => 'Toca una historia para abrirla en pantalla completa. Usa el botón de descarga o el menú para guardarla en tu dispositivo.',
			'help.share_content_title' => 'Compartir contenido',
			'help.share_content_body' => 'Abre una historia y toca el botón de compartir o usa el menú para compartirla con otras aplicaciones.',
			'help.switch_view_title' => 'Cambiar entre vista de cuadrícula y lista',
			'help.switch_view_body' => 'Desde Ajustes puedes alternar entre la vista de cuadrícula y la vista de lista para navegar los estados.',
			'help.dark_mode_title' => 'Modo oscuro',
			'help.dark_mode_body' => 'Puedes cambiar entre modo claro y oscuro en Configuración. La app también sigue el tema del sistema automáticamente.',
			'help.notification_service_title' => 'Sistema de notificaciones',
			'help.notification_service_body' => 'Activa las notificaciones para recibir alertas cuando haya nuevos estados disponibles sin abrir la app. El sistema verifica cada 60 segundos y te notifica de nuevo contenido.',
			'help.auto_save_title' => 'Guardado automático',
			'help.auto_save_body' => 'Al activarlo, la app guarda automáticamente todos los estados visibles en tu dispositivo. Funciona en segundo plano y evita duplicados. Puedes ver el uso de almacenamiento en Configuración.',
			'help.saved_indicator_title' => 'Indicadores de estados guardados',
			'help.saved_indicator_body' => 'Los estados ya guardados muestran un icono de check verde. En la vista de detalle, el botón de descarga cambia a "Guardado" y se desactiva para evitar duplicados.',
			'help.sync_title' => 'Sincronización automática',
			'help.sync_body' => 'La app detecta automáticamente nuevos estados en las carpetas de WhatsApp. El vigilador de archivos verifica cambios cada 30 segundos. Esto funciona incluso con la app en segundo plano.',
			'help.storage_title' => 'Gestión de almacenamiento',
			'help.storage_body' => 'Los estados guardados se almacenan en Pictures/Statuses de tu dispositivo. Puedes ver el uso exacto en Configuración. Elimina archivos no deseados desde la pestaña Guardados manteniendo presionado para seleccionar.',
			'help.troubleshooting_title' => 'Solución de problemas',
			'help.troubleshooting_body' => 'Si los estados no aparecen: 1) Asegúrate de haber visto historias en WhatsApp recientemente. 2) Verifica que los permisos de almacenamiento estén concedidos. 3) Intenta tocar "Conceder acceso" para seleccionar manualmente la carpeta .Statuses. 4) Reinicia la app.',
			'help.permissions_title' => 'Permisos requeridos',
			'help.permissions_body' => 'La app necesita acceso al almacenamiento para leer los archivos de estado de WhatsApp. En Android 13+ también necesita permiso de notificaciones para las alertas. Ningún dato sale de tu dispositivo.',
			'help.stories_explanation_title' => 'Cómo funcionan las Historias',
			'help.stories_explanation_body' => 'Statuses lee la carpeta .Statuses donde WhatsApp almacena temporalmente las historias vistas. Los archivos tienen nombres internos generados por WhatsApp — esto es normal y no afecta la funcionalidad.',
			'help.icons_badges_title' => 'Iconos y badges',
			'help.icons_badges_body' => 'La pestaña de Historias muestra un icono de anillo. Los badges numéricos en la barra inferior indican cuántas historias o archivos guardados hay disponibles. Un check verde significa que el archivo ya está guardado.',
			'help.faq_title' => 'Preguntas frecuentes',
			'help.faq_encrypted_names_q' => '¿Por qué los archivos tienen nombres extraños?',
			'help.faq_encrypted_names_a' => 'WhatsApp almacena temporalmente los estados utilizando nombres internos generados automáticamente por el sistema. Estos nombres no corresponden al nombre original del archivo y son utilizados por WhatsApp para optimizar el almacenamiento y la gestión del contenido. Esto es completamente normal y no afecta la visualización ni el funcionamiento de los estados.',
			'help.faq_duplicates_q' => '¿Por qué veo estados duplicados?',
			'help.faq_duplicates_a' => 'La app ahora previene duplicados verificando nombre, tamaño y hash de contenido. Si ves duplicados de antes de esta actualización, son archivos existentes guardados previamente. Puedes eliminarlos manualmente desde la pestaña Guardados.',
			'help.faq_notifications_q' => '¿Cómo funcionan las notificaciones?',
			'help.faq_notifications_a' => 'Al activarlas en Configuración, la app verifica nuevos estados cada 60 segundos. Si encuentra contenido nuevo, muestra una notificación. Puedes activarlas o desactivarlas en cualquier momento.',
			'help.faq_auto_save_q' => '¿Qué hace exactamente el guardado automático?',
			'help.faq_auto_save_a' => 'Al activarlo, la app guarda inmediatamente todas las historias visibles actualmente. Luego monitorea continuamente nuevas historias y las guarda automáticamente. Los duplicados se previenen mediante comparación de hash de contenido.',
			'help.faq_language_q' => '¿Cómo cambio el idioma?',
			'help.faq_language_a' => 'Ve a Configuración y usa el selector de Idioma para cambiar entre Inglés y Español. El cambio se aplica inmediatamente.',
			'help.faq_storage_q' => '¿Cuánto espacio estoy usando?',
			'help.faq_storage_a' => 'Ve a Configuración y mira la sección de Guardado automático. Muestra el almacenamiento total usado por los estados guardados. La sección Gestión de almacenamiento en el Centro de ayuda tiene más detalles.',
			'help.faq_whatsapp_q' => '¿Funciona con WhatsApp Business?',
			'help.faq_whatsapp_a' => 'Sí, Statuses soporta tanto WhatsApp como WhatsApp Business. La app detecta automáticamente las carpetas de estados de ambas versiones.',
			_ => null,
		};
	}
}
