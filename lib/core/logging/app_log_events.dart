import 'dart:async';

import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';

/// Helpers semánticos sobre [AppLogger] para los eventos frecuentes de la app.
///
/// Cubren las categorías que se quieren seguir de forma uniforme: navegación,
/// permisos y peticiones (solicitudes) cronometradas.
extension AppLogEvents on AppLogger {
  /// Registra un cambio de navegación hacia [to].
  void navigation({
    required String to,
    String? from,
    Map<String, Object?> extra = const <String, Object?>{},
  }) => info(
    'navegar a $to',
    channel: LogChannel.router,
    context: <String, Object?>{'from': ?from, ...extra},
  );

  /// Registra el resultado de una petición de permiso.
  void permission(
    String capability, {
    required bool granted,
    LogChannel channel = LogChannel.microphone,
    String? action,
    Object? reason,
  }) {
    if (granted) {
      info(
        'permiso $capability concedido',
        channel: channel,
        context: <String, Object?>{'action': ?action},
      );
    } else {
      warning(
        'permiso $capability denegado',
        channel: channel,
        error: reason,
        context: <String, Object?>{'action': ?action},
      );
    }
  }

  /// Cronometra una operación etiquetada como petición o solicitud.
  ///
  /// Envuelve [track] con un umbral de lentitud pensado para solicitudes de
  /// red/E/S, registrando objetivo, duración y resultado.
  Future<T> request<T>(
    String label, {
    required LogChannel channel,
    required Future<T> Function() run,
    AppLogLevel level = AppLogLevel.info,
    Duration slowThreshold = const Duration(milliseconds: 400),
  }) => track(
    run,
    name: label,
    channel: channel,
    level: level,
    slowThreshold: slowThreshold,
  );
}
