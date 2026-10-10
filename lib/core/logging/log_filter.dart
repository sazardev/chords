import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';

/// Decide si un evento de log debe procesarse.
///
/// Filtra por severidad mínima y, opcionalmente, por un conjunto de canales
/// habilitados. Es inmutable y puro: no depende de Flutter ni de I/O, por lo
/// que se puede verificar sin arrancar la app.
class LogFilter {
  /// Crea un filtro por severidad mínima y canales opcionales.
  const LogFilter({required this.minimum, this.channels});

  /// Crea un filtro que solo restringe por severidad mínima.
  const LogFilter.minimum(AppLogLevel minimum) : this(minimum: minimum);

  /// Severidad mínima admitida; los eventos por debajo se descartan.
  final AppLogLevel minimum;

  /// Canales habilitados; `null` admite todos los canales.
  final Set<LogChannel>? channels;

  /// `true` si un evento con ese nivel y canal debe registrarse.
  bool accepts(AppLogLevel level, LogChannel channel) {
    if (level.value < minimum.value) {
      return false;
    }
    final Set<LogChannel>? allowed = channels;
    return allowed == null || allowed.contains(channel);
  }
}
