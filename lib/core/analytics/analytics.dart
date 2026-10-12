import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/noop_analytics_backend.dart';
import 'package:meta/meta.dart';

AnalyticsService? _service;

/// Servicio de analíticas global de la aplicación, listo para usar.
///
/// Antes de configurarse devuelve un servicio silencioso para que cualquier
/// capa pueda registrar con seguridad incluso en tests o antes del arranque.
AnalyticsService get analytics =>
    _service ??= AnalyticsService(const NoopAnalyticsBackend());

/// Configura el servicio de analíticas global.
void configureAnalytics(AnalyticsService service) => _service = service;

/// Restablece el servicio global; solo para pruebas.
@visibleForTesting
void resetAnalytics() => _service = null;
