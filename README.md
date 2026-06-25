# Statuses

---

## Descripción general

**Statuses** es una aplicación nativa de Android desarrollada con Flutter que permite visualizar, descargar, compartir y gestionar los archivos multimedia de los estados de WhatsApp almacenados localmente en el dispositivo. La app organiza las imágenes y videos del directorio `.Statuses` de WhatsApp (y WhatsApp Business) en una interfaz moderna, con soporte para temas claro y oscuro, reproducción de video, zoom en imágenes, notificaciones de nuevos estados y respaldo automático con prevención de duplicados.

---

## Características principales

- 🔍 **Navegación de estados** — Explora imágenes y videos de WhatsApp y WhatsApp Business en modo cuadrícula o lista
- 🎬 **Reproducción de video** — Reproductor integrado con controles de play/pause y precarga de miniaturas
- 📥 **Descarga y respaldo** — Guarda estados en la carpeta `Pictures/Statuses` con detección de duplicados por hash SHA-256
- 📤 **Compartir** — Comparte cualquier estado directamente mediante el panel nativo de Android
- 🔔 **Notificaciones** — Recibe alertas cuando se detectan nuevos estados disponibles
- 💾 **Auto-guardado** — Sincronización automática periódica con control de almacenamiento y lotes optimizados
- 🎨 **Temas** — Soporte completo para modo claro, modo oscuro y modo sistema con persistencia
- 🌍 **Internacionalización** — Interfaz traducida al español e inglés mediante `slang`
- 📱 **Diseño responsivo** — Adaptación automática a orientación vertical y horizontal
- 🔄 **Actualización automática** — Detección de nuevos estados mediante `FileSystemEntity.watch` y polling de respaldo
- 🛡️ **SAF fallback** — Acceso alternativo mediante Storage Access Framework en dispositivos con restricciones de almacenamiento
- 🎯 **Filtros** — Filtrado por tipo de medio (todos, fotos, videos)
- 📊 **Información de archivo** — Visualización detallada de nombre, tamaño, tipo y fecha de modificación

---

## Arquitectura

El proyecto sigue un patrón **Repository + Service Layer** combinado con **ChangeNotifier / Provider** para la gestión de estado, garantizando separación de responsabilidades y testabilidad.

```
lib/
├── data/
│   ├── models/
│   │   └── status_file.dart              # Modelo de dominio para archivos de estado
│   ├── repositories/
│   │   └── status_repository.dart        # Orquestación de fuentes de datos (档案系统 + SAF)
│   └── services/
│       ├── download_service.dart         # Gestión de descargas y respaldo
│       ├── file_watcher_service.dart     # Monitoreo de cambios en tiempo real + polling
│       ├── media_cache_service.dart      # Caché de miniaturas mediante flutter_cache_manager
│       ├── notification_service.dart     # Notificaciones locales agrupadas
│       ├── permission_service.dart       # Permisos adaptativos por SDK
│       ├── saf_service.dart              # Integración con Storage Access Framework (MethodChannel)
│       ├── share_service.dart            # Compartición nativa via share_plus
│       └── video_thumbnail_service.dart  # Generación y caché de miniaturas de video
├── providers/
│   ├── download_notifier.dart            # Estado global de descargas, auto-guardado y selección
│   ├── locale_notifier.dart              # Gestión de idioma con persistencia
│   ├── notification_notifier.dart        # Estado del servicio de notificaciones
│   ├── status_notifier.dart              # Estado principal: lista, filtros, vista, precarga
│   └── theme_notifier.dart               # Tema claro/oscuro con persistencia
├── ui/
│   ├── screens/
│   │   ├── app_shell.dart                # Navegación principal (NavigationBar + IndexedStack)
│   │   ├── app_startup_screen.dart       # Resolución de ruta inicial según permisos
│   │   ├── help_screen.dart              # Centro de ayuda y FAQ
│   │   ├── permission_screen.dart        # Flujo de solicitud y verificación de permisos
│   │   ├── saved_statuses_screen.dart    # Galería de estados guardados con selección múltiple
│   │   ├── settings_screen.dart          # Configuración: tema, idioma, notificaciones, auto-guardado
│   │   ├── status_detail_screen.dart     # Visor detallado con paginación (PageView)
│   │   ├── status_grid_screen.dart       # Cuadrícula de miniaturas con Pull-to-Refresh
│   │   └── status_list_screen.dart       # Lista compacta de estados
│   ├── theme/
│   │   ├── app_theme.dart                # Tokens de diseño: colores, radios, duraciones
│   │   ├── dark_theme.dart               # Tema oscuro (inspirado en WhatsApp Dark)
│   │   └── light_theme.dart              # Tema claro (inspirado en WhatsApp Light)
│   └── widgets/
│       ├── bottom_nav_badge.dart         # Indicadores numerados en la barra de navegación
│       ├── empty_state.dart              # Estado vacío con soporte para SAF
│       ├── filter_chips.dart             # Filtros rápidos por tipo de medio
│       ├── language_selector.dart        # Selector de idioma
│       ├── shimmer_loading.dart           # Skeleton loaders
│       └── status_thumbnail_card.dart    # Tarjeta de miniatura con indicador de guardado
├── constants/
│   └── app_constants.dart                # Rutas de WhatsApp, constantes de UI y polling
├── i18n/
│   ├── en.i18n.json                      # Traducciones base (inglés)
│   ├── es.i18n.json                      # Traducciones (español)
│   └── translations.g.dart               # Código generado por slang_build_runner
└── utils/
    ├── date_formatter.dart               # Formateo relativo y absoluto de fechas
    └── file_utils.dart                   # Detección de tipos MIME, hashing SHA-256 y formateo de tamaños
```

---

## Stack tecnológico

<div align="center">

| Capa | Tecnología |
|------|-------------|
| Framework | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) Flutter **3.27+** |
| Lenguaje | ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) Dart **3.6+** |
| Estado | ![Provider](https://img.shields.io/badge/Provider-4FC08D?style=flat&logo=flutter&logoColor=white) Provider |
| Almacenamiento | ![Android](https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white) `shared_preferences` + `path_provider` |
| Permisos | `permission_handler` |
| Video | `video_player` + `video_thumbnail` |
| Caché | `flutter_cache_manager` |
| Compartir | `share_plus` |
| i18n | `slang` + `slang_flutter` |
| Notificaciones | `flutter_local_notifications` |
| Utilidades | `intl`, `path`, `crypto`, `device_info_plus`, `url_launcher` |
| Testing | `flutter_test`, `mockito` |
| Linting | `flutter_lints` |
| Build | `build_runner` + `slang_build_runner` |

</div>

---

## Estructura del proyecto

```
statuses/
├── android/                         # Módulo nativo Android (Kotlin + Gradle)
│   └── app/src/main/
│       ├── AndroidManifest.xml      # Permisos y configuración de actividades
│       ├── kotlin/.../MainActivity.kt
│       └── res/                     # Launcher iconos y estilos nativos
├── assets/
│   ├── fonts/                       # Montserrat Bold (familia tipográfica propia)
│   └── images/                      # Logo e imágenes de la app
├── lib/                             # Código fuente Dart
│   └── (ver árbol de arquitectura arriba)
├── test/                            # Suite de pruebas
│   ├── app_shell_test.dart
│   ├── benchmark_test.dart
│   ├── date_formatter_test.dart
│   ├── download_notifier_test.dart
│   ├── duplicate_prevention_test.dart
│   ├── file_utils_test.dart
│   ├── help_screen_test.dart
│   ├── mocks.dart
│   ├── notification_notifier_test.dart
│   ├── settings_screen_test.dart
│   ├── status_file_test.dart
│   ├── status_notifier_test.dart
│   ├── stress_test.dart              # Pruebas de estrés con datasets grandes
│   └── widget_test.dart
├── coverage/
│   └── lcov.info                     # Informe de cobertura de código
├── pubspec.yaml                     # Dependencias y metadatos del paquete
├── build.yaml                       # Configuración de slang_build_runner
├── analysis_options.yaml            # Lints recomendados de Flutter
└── README.md                        # Este documento
```

---

## Flujo de arranque

1. **Inicialización** (`main.dart`) — Se inicializa el binding de Flutter, se restaura la preferencia de idioma y se construye el árbol de providers.
2. **Resolución de ruta** (`AppStartupScreen`) — Verifica el estado de los permisos de almacenamiento:
   - Si están concedidos → navega a `/home`.
   - Si no → navega a `/permission` con el estado correspondiente.
3. **Carga de estados** (`StatusNotifier.loadStatuses`) — Descubre directorios de WhatsApp, lee archivos multimedia, aplica filtros y precarga miniaturas de video.
4. **Monitoreo** (`FileWatcherService`) — Inicia el watcher nativo del sistema de archivos y un polling de respaldo cada 30 segundos para detectar cambios.
5. **Notificaciones** (`NotificationNotifier`) — Si están activadas, consulta periódicamente si hay nuevos estados y muestra una notificación agrupada.

---

## Permisos

La aplicación requiere acceso al almacenamiento para leer los estados de WhatsApp. Los permisos se adaptan automáticamente según la versión de Android detectada en el dispositivo:

| SDK Android                        | Permiso solicitado                                                |
| ---------------------------------- | ----------------------------------------------------------------- |
| API 33+ (Android 13+)              | `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO` |
| API 30–32 (Android 11–12)        | `MANAGE_EXTERNAL_STORAGE`                                       |
| API < 30 (Android 10 y anteriores) | `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`             |

Además, se declara visibilidad explícita de los paquetes `com.whatsapp` y `com.whatsapp.w4b` paraAndroid 11+.

> Todos los datos permanecen en el dispositivo. Statuses no recopila, transmite ni modifica archivos fuera del almacenamiento local.

---

## Construcción

### Requisitos previos

- Flutter SDK `^3.6.2`
- Dart SDK `^3.6.2`
- Android SDK con `compileSdk` y `targetSdk` compatibles
- Kotlin `1.9+` (Gradle)

### Pasos

```bash
# Instalar dependencias
flutter pub get

# Generar código (traducciones y registros de plugins)
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar tests
flutter test

# Análisis estático
flutter analyze

# Build de depuración
flutter build apk --debug

# Build de release (firmado con clave de debug por defecto)
flutter build apk --release
```

El APK resultante se ubica en `build/app/outputs/flutter-apk/app-release.apk`.

---

## Pruebas

El proyecto incluye una suite completa de pruebas unitarias y de widgets:

- **`app_shell_test.dart`** — Validación de navegación y estructura del shell principal.
- **`benchmark_test.dart`** — Medición de rendimiento en escenarios de carga.
- **`date_formatter_test.dart`** — Formateo relativo y absoluto de fechas.
- **`download_notifier_test.dart`** — Flujos de descarga, auto-guardado y limpieza.
- **`duplicate_prevention_test.dart`** — Prevención de duplicados mediante hashing.
- **`file_utils_test.dart`** — Detección de tipos MIME y utilidades de archivo.
- **`help_screen_test.dart`** — Renderizado de la pantalla de ayuda.
- **`notification_notifier_test.dart`** — Habilitación y polling de notificaciones.
- **`settings_screen_test.dart`** — Interacciones en la pantalla de configuración.
- **`status_file_test.dart`** — Modelo de dominio e igualdad de archivos.
- **`status_notifier_test.dart`** — Carga, filtrado, refresco y modos de vista.
- **`stress_test.dart`** — Pruebas de estrés con volúmenes elevados de archivos.
- **`widget_test.dart`** — Prueba de humo de los widgets principales.

---

## Decisiones de diseño

- **Provider sobre BLoC/Riverpod** — Seleccionado por simplicidad y bajo boilerplate para el alcance del proyecto, suficiente para la complejidad de estado presente.
- **Repository Pattern** — Abstrae el origen de datos (sistema de archivos directo vs. SAF), permitiendo cambiar la estrategia de acceso sin modificar la capa de UI.
- **Hash parcial para archivos grandes** — Para videos mayores a 10 MB se calcula un hash de los primeros 64 KB combinado con la longitud del archivo, evitando lecturas completas costosas.
- **Precarga de miniaturas con límite de concurrencia** — Se generan miniaturas de video en segundo plano con un máximo de 3 operaciones simultáneas para preservar la fluidez de la UI.
- **Caché en dos niveles** — Memoria (`Map`) + disco (`video_thumbnails/` y `flutter_cache_manager`) para miniaturas y archivos descargados.
- **Polling como fallback** — El `FileWatcherService` combina eventos nativos del sistema de archivos con un polling periódico de 30 segundos para garantizar la detección en dispositivos donde el watcher nativo no es confiable.

---

## Internacionalización

Las traducciones se gestionan con **slang** mediante archivos JSON fuente:

- `lib/i18n/en.i18n.json` — Inglés (idioma base, `fallback_strategy: base_locale`)
- `lib/i18n/es.i18n.json` — Español

La generación de código se ejecuta automáticamente mediante `slang_build_runner` y produce `lib/i18n/translations.g.dart`, que expone la clase `Translations` y el enum `AppLocale`.

---

## Compatibilidad

| Aspecto       | Valor                                           |
| ------------- | ----------------------------------------------- |
| Min SDK       | API 24 (Android 7.0 Nougat)                     |
| Target SDK    | Definido por`flutter.targetSdkVersion`        |
| Arquitecturas | ARM64-v8a, armeabi-v7a (multi-APK configurable) |
| Orientaciones | Vertical y horizontal                           |
