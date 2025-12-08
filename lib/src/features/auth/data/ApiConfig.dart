import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // -------- WEB (Flutter Web) --------
    if (kIsWeb) {
      // Si se ejecuta en localhost → usa backend local
      if (Uri.base.host.contains("localhost") || Uri.base.host.contains("127.0.0.1")) {
        return "http://localhost:8080";
      }

      // Si está desplegado → usa Render
      return "https://fleetcare-backend-acsw.onrender.com";
    }

    // -------- APPS NATIVAS --------

    if (Platform.isAndroid) {
      return "http://10.0.2.2:8080"; // Emulador Android
    }

    if (Platform.isIOS) {
      return "http://127.0.0.1:8080"; // Simulador iOS
    }

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return "http://127.0.0.1:8080";
    }

    // Dispositivo físico → usar tu IP local
    return "http://192.168.1.7:8080";
  }
}