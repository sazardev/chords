import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:meta/meta.dart';

AppLogger? _logger;

/// Logger global de la aplicación, listo para usar desde cualquier capa.
///
/// Antes de configurarse devuelve un logger silencioso (sin sinks) para que el
/// código pueda registrar con seguridad incluso en tests o antes del arranque.
AppLogger get appLogger => _logger ??= AppLogger(sinks: const <LogSink>[]);

/// Configura el logger global de la aplicación.
void configureAppLogger(AppLogger logger) => _logger = logger;

/// Restablece el logger global; solo para pruebas.
@visibleForTesting
void resetAppLogger() => _logger = null;

MemoryLogSink? _memorySink;

/// Sink en memoria del logger global, si está registrado.
///
/// Lo usa el visor de diagnóstico para mostrar los eventos en la app.
MemoryLogSink? get appMemoryLogSink => _memorySink;

/// Registra el sink en memoria asociado al logger global.
void registerAppMemorySink(MemoryLogSink sink) => _memorySink = sink;

bool _diagnosticsEnabled = false;

/// Si el visor de diagnóstico en la app está disponible.
///
/// Se activa por flavor (dev/staging) durante el arranque.
bool get appLogDiagnosticsEnabled => _diagnosticsEnabled;

/// Activa o desactiva la disponibilidad del visor de diagnóstico.
void setAppLogDiagnosticsEnabled({required bool enabled}) =>
    _diagnosticsEnabled = enabled;
