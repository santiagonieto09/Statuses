# Changelog

## [1.8.0] - 2026-06-27

### Added
- Splash: splash nativo Android 12+ con fondo #00A884 y logo centrado
- Splash: generación automática con flutter_native_splash (Android <12 compat)
- Icono: icono adaptativo generado desde el mismo logo (#00A884 background)
- Assets: logo statuses.png (1254x1254) para splash e icono

### Removed
- Assets: logo.svg antiguo (reemplazado por statuses.png)

---

## [1.7.0] - 2026-06-27

### Added
- UI: versión dinámica desde la plataforma con package_info_plus (Settings)
- UI: filtros con check verde relleno (AppColors.accentGreen) y check/borde blanco

### Fixed
- Versión hardcodeada en Settings ahora se lee automáticamente del pubspec.yaml

---

## [1.6.0] - 2026-06-26

### Added
- Navigation: mover botón de Configuración del AppBar a la NavigationBar M3 (extrema derecha)
- UI: transición WhatsApp-style Slide right con easeOut en ambos sentidos
- UI: vista de rejilla/lista configurable desde Settings > Apariencia
- UI: fuente Montserrat Bold para el título de la app (estilo WhatsApp)
- UI: thumbnail precacheado como placeholder en status_detail_screen (reemplaza spinner)
- Rendimiento: migrar _loadFromDirectories a Isolate.run (status_repository)
- Rendimiento: migrar computeFileHash a Isolate.run con RandomAccessFile (file_utils)
- Rendimiento: pre-warm androidSdkVersion cache inmediatamente tras SharedPreferences.init
- Cache: androidSdkVersion en SharedPreferences para evitar DeviceInfoPlugin
- Cache: Future compartido para androidSdkVersion elimina race condition

### Changed
- Transición de navegación de Fade a Slide right completo

### Fixed
- Tooltip de settings cambiado de "Tema" a "Configuración"
- androidSdkVersion race condition con DeviceInfoPlugin duplicado

### Removed
- Botón redundante de cambio de vista del AppBar

---

## [1.5.0] - 2026-06-25

### Added
- Notificaciones: sistema de notificaciones para nuevos estados (flutter_local_notifications)
- Auto-save: guardado automático de estados con diálogo de advertencia
- Auto-save: indicador visual de estados guardados
- Auto-save: botones "Seleccionar todo" / "Deseleccionar todo" en multi-selección
- UI: diálogo de advertencia al activar guardado automático con "No mostrar de nuevo"
- Función para volver a publicar en WhatsApp (luego eliminada)
- Dependencias: flutter_local_notifications y url_launcher

### Performance
- Cache de metadatos con TTL de 2s en StatusRepository
- Límite de 500 entradas en cachés hash con evicción FIFO
- Set de hashes para detección O(1) de duplicados
- Auto-save paralelo por lotes de 5 archivos
- Precarga de thumbnails de video al cargar estados
- FileSystemEntity.watch() nativo con fallback a polling
- Eliminar compute() en VideoThumbnailService, miniaturas en main isolate con caché en memoria

### Fixed
- Prevenir duplicados en auto-save con guardas _processingPaths y _processedSourcePaths
- Eliminar fallbacks rotos de whatsapp://send, priorizar MethodChannel nativo
- Opacidad 0.6 en thumbnails de estados guardados
- Zone mismatch entre WidgetsFlutterBinding.ensureInitialized y runApp

### Removed
- Funcionalidad "volver a publicar" (feat 973ba25)

---

## [1.4.0] - 2026-06-20

### Added
- Fase 1-6 de optimización de rendimiento:
  - Medición con Stopwatch y debugPrint
  - Escaneo paralelo, caché de metadatos, polling ligero
  - Thumbnails con cacheWidth/Height, RepaintBoundary, generación en isolate
  - Providers con context.select, filtros extraídos a widget separado
  - Precarga de videos adyacentes en StatusDetailScreen
  - runZonedGuarded para captura de errores globales
- Pantalla de carga (splash)
- Sistema de idiomas es/en con slang
- Badges de contadores en navegación
- Pantalla de configuración y centro de ayuda
- Animaciones de transición y diseño responsive
- Selector de idioma en onboarding
- Skeletons de carga en secciones multimedia

### Changed
- Migración a NavigationBar M3
- Iconografía actualizada
- Español como idioma predeterminado con persistencia entre sesiones
- Etiquetas internas de "Statuses" a "Stories"

### Fixed
- Contraste de badges en modo oscuro
- Traducciones y textos en español
- Título centrado en pantalla de permisos
- Import faltante de MediaType en saved_statuses_screen

---

## [1.3.0] - 2026-06-15

### Added
- SAF fallback via native Kotlin MethodChannel para dispositivos restringidos
- Descargas a carpeta pública Pictures/Statuses
- Pantalla de estados guardados (Saved)
- Generación y caché de video thumbnails para grid y list views
- Swipe navigation entre estados con PageView
- Long-press multi-select con barra de selección animada y confirmación de borrado
- Filtro de medios (video/imagen)
- Sincronización de vista grid/list a sección Saved

### Fixed
- Deduplicación de directorios por canonical path (case-insensitive)
- Deduplicación de estados por filename
- Sincronización de view mode entre pantallas

---

## [1.2.0] - 2026-06-10

### Added
- Soporte para rutas de WhatsApp Business
- Permiso MANAGE_EXTERNAL_STORAGE para Android 11+ (SDK >= 30)
- Actualización de plugins a versiones con soporte Kotlin built-in

### Fixed
- Lowercase paths en descubrimiento de estados
- Limpieza de permisos en AndroidManifest
- API Share.shareXFiles() deprecada migrada a SharePlus.instance.share

---

## [1.1.0] - 2026-06-08

### Fixed
- Reducción de tema a 2 estados (dark/light), migración system theme a light
- Eliminación de caracteres unicode/special chars, reemplazo con Material icons
- Estilo de llaves según lint de Dart
- Preview de video

---

## [1.0.0] - 2026-06-05

### Added
- Base app con Flutter
- Escaneo de directorios de estados de WhatsApp
- Visualización en grid y lista
- Reproducción de video
- Permisos para Android
