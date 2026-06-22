package com.statuses.statuses

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Environment
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.statuses.statuses/saf"
    private val SAF_REQUEST_CODE = 42
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    // Abre el selector de directorio SAF y persiste el permiso de lectura
                    "openDocumentTree" -> {
                        pendingResult = result
                        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                            addFlags(
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                            )
                        }
                        startActivityForResult(intent, SAF_REQUEST_CODE)
                    }

                    // Lista los archivos en un directorio SAF (sin subdirectorios)
                    "listFiles" -> {
                        val uriString = call.argument<String>("uri")
                        if (uriString == null) {
                            result.error("INVALID_ARGS", "Se requiere el argumento 'uri'", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val uri = Uri.parse(uriString)
                            val docFile = DocumentFile.fromTreeUri(this, uri)
                            val files = docFile?.listFiles()
                                ?.filter { it.isFile }
                                ?.map { file ->
                                    mapOf(
                                        "uri" to file.uri.toString(),
                                        "name" to (file.name ?: ""),
                                        "size" to file.length(),
                                        "lastModified" to file.lastModified(),
                                        "type" to (file.type ?: ""),
                                    )
                                } ?: emptyList()
                            result.success(files)
                        } catch (e: Exception) {
                            result.error("SAF_ERROR", e.message, null)
                        }
                    }

                    // Copia un archivo SAF a una ruta local del cache (streaming, sin cargar en RAM)
                    "copyFileToCache" -> {
                        val uriString = call.argument<String>("uri")
                        val destPath = call.argument<String>("destPath")
                        if (uriString == null || destPath == null) {
                            result.error("INVALID_ARGS", "Se requieren 'uri' y 'destPath'", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val uri = Uri.parse(uriString)
                            contentResolver.openInputStream(uri)?.use { input ->
                                java.io.File(destPath).outputStream().use { output ->
                                    input.copyTo(output)
                                }
                            }
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("SAF_ERROR", e.message, null)
                        }
                    }

                    // Devuelve los permisos URI persistidos en el dispositivo
                    "getPersistedPermissions" -> {
                        val perms = contentResolver.persistedUriPermissions.map {
                            mapOf(
                                "uri" to it.uri.toString(),
                                "isRead" to it.isReadPermission,
                                "isWrite" to it.isWritePermission,
                            )
                        }
                        result.success(perms)
                    }

                    // Libera un permiso URI persistido previamente
                    "releasePermission" -> {
                        val uriString = call.argument<String>("uri")
                        if (uriString == null) {
                            result.error("INVALID_ARGS", "Se requiere el argumento 'uri'", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val uri = Uri.parse(uriString)
                            contentResolver.releasePersistableUriPermission(
                                uri,
                                Intent.FLAG_GRANT_READ_URI_PERMISSION
                            )
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("SAF_ERROR", e.message, null)
                        }
                    }

                    // Devuelve la ruta del directorio publico Pictures del almacenamiento primario
                    "getPublicPicturesPath" -> {
                        val dir = Environment.getExternalStoragePublicDirectory(
                            Environment.DIRECTORY_PICTURES
                        )
                        result.success(dir.absolutePath)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SAF_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && data?.data != null) {
                val uri = data.data!!
                // Persiste el permiso de lectura para uso futuro
                contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
                pendingResult?.success(uri.toString())
            } else {
                pendingResult?.success(null)
            }
            pendingResult = null
        }
    }
}
