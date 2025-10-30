import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Detecta si es Flutter Web
    if (kIsWeb) {
      return "http://localhost:8080";
    }

    // Detecta según la plataforma nativa
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8080"; // Android Emulator
    } else if (Platform.isIOS) {
      return "http://127.0.0.1:8080"; // iOS Simulator
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return "http://127.0.0.1:8080"; // en lugar de localhost
    } else {
      // fallback para dispositivos físicos (usar IP local)
      return "http://192.168.1.7:8080"; // 👈 pon aquí tu IP local real
    }
  }
}