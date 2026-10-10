import 'dart:async' show runZonedGuarded;
import 'dart:ui' show PlatformDispatcher;

import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/runtime/global_error_handler.dart';
import 'package:flutter/material.dart'
    show FlutterError, FlutterErrorDetails, Widget, runApp;

/// Arranca la aplicación bajo una zona que captura cualquier error.
///
/// Instala los tres manejadores globales recomendados (framework, plataforma y
/// zona asíncrona) para que ningún error —de build, de render, de plugin o de
/// un `Future` sin esperar— se pierda sin traza. Es la "capa protegida" que
/// envuelve toda la app.
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
  runZonedGuarded(
    () {
      runApp(app);
    },
    (Object error, StackTrace stack) => reportCapturedError(
      logger,
      origin: 'zona asíncrona',
      error: error,
      stackTrace: stack,
    ),
  );
}
