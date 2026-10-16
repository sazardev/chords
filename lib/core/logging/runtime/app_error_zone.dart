import 'dart:ui' show PlatformDispatcher;

import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/runtime/global_error_handler.dart';
import 'package:flutter/material.dart'
    show FlutterError, FlutterErrorDetails, Widget, runApp;

/// Arranca la aplicación capturando cualquier error.
///
/// Instala los manejadores globales recomendados (framework y plataforma) para
/// que ningún error —de build, de render, de plugin o de un `Future` sin
/// esperar— se pierda sin traza. No usa `runZonedGuarded`: los enlaces de
/// Flutter ya se inicializan en la zona raíz (en `bootstrap`) y arrancar la app
/// en otra zona provoca el aviso "Zone mismatch"; los errores asíncronos sin
/// capturar llegan igualmente a `PlatformDispatcher.onError`.
void runAppGuarded(AppLogger logger, Widget app) {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportCapturedError(
      logger,
      origin: 'framework',
      error: details.exception,
      stackTrace: details.stack ?? StackTrace.empty,
    );
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    reportCapturedError(
      logger,
      origin: 'plataforma',
      error: error,
      stackTrace: stack,
    );
    return true;
  };
  runApp(app);
}
