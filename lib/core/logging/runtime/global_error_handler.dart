import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';

/// Convierte un error capturado por el framework o la plataforma en un log.
///
/// Centraliza el formato para que el manejador de `FlutterError.onError`, el de
/// `PlatformDispatcher.onError` y la zona asíncrona produzcan trazas homogéneas
/// en el canal de framework. Es puro, así que se testea sin widgets.
void reportCapturedError(
  AppLogger logger, {
  required String origin,
  required Object error,
  required StackTrace stackTrace,
}) {
  logger.error(
    'error capturado en $origin',
    channel: LogChannel.framework,
    error: error,
    stackTrace: stackTrace,
    context: <String, Object?>{'origin': origin},
  );
}
