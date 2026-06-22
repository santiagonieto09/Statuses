class AppConstants {
  AppConstants._();

  static const String appName = 'Statuses';

  static const List<String> whatsappStatusPaths = [
    // WhatsApp — capitalizacion estandar
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses',
    // WhatsApp — todo en minusculas (algunos dispositivos/versiones)
    '/storage/emulated/0/android/media/com.whatsapp/whatsapp/media/.statuses',
    // WhatsApp — ruta legacy (Android < 10)
    '/storage/emulated/0/WhatsApp/Media/.Statuses',
    // WhatsApp Business — capitalizacion estandar
    '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
    // WhatsApp Business — todo en minusculas
    '/storage/emulated/0/android/media/com.whatsapp.w4b/whatsapp business/media/.statuses',
    // WhatsApp Business — ruta legacy
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses',
  ];

  static const String savedDirName = 'Statuses';

  static const Duration pollInterval = Duration(seconds: 15);

  static const int gridCrossAxisCount = 3;
  static const int gridCrossAxisCountLandscape = 5;

  static const double thumbnailSize = 120.0;
  static const double listThumbnailSize = 48.0;
}
