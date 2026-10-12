import 'package:chords/core/analytics/analytics_backend.dart';
import 'package:chords/core/analytics/analytics_events.dart';

/// Fachada de analíticas de la aplicación.
///
/// Es el único punto desde el que las capas registran telemetría remota.
/// Deduplica pantallas consecutivas, encadena la anterior de forma automática
/// y deriva los errores al backend con su contexto. Es pura: solo depende del
/// contrato [AnalyticsBackend], así que se prueba con un doble sin SDKs.
class AnalyticsService {
  /// Crea la fachada sobre el backend indicado.
  AnalyticsService(this._backend);

  final AnalyticsBackend _backend;
  String? _screen;

  /// Última pantalla registrada, si la hay.
  String? get currentScreen => _screen;

  /// Registra que la app se ha abierto con el flavor indicado.
  void appOpened({required String flavor}) => event(
    AnalyticsEventName.appOpen,
    parameters: <String, Object?>{AnalyticsParam.flavor: flavor},
  );

  /// Registra un evento con sus parámetros.
  void event(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  }) => _backend.logEvent(name, parameters: parameters);

  /// Registra la visita a [name], ignorando repeticiones consecutivas.
  ///
  /// La pantalla anterior se toma de [from] o, si no se indica, de la última
  /// visitada, de modo que el embudo de navegación quede encadenado.
  void screen(String name, {String? from}) {
    if (name == _screen) {
      return;
    }
    _backend.logScreen(name, previous: from ?? _screen);
    _screen = name;
  }

  /// Fija una propiedad de usuario; `null` la elimina.
  void setUserProperty(String name, String? value) =>
      _backend.setUserProperty(name, value);

  /// Registra un error, lo cuenta como evento y conserva el contexto.
  void recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? origin,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    final Map<String, Object?> data = <String, Object?>{
      ...context,
      AnalyticsParam.origin: ?origin,
    };
    _backend
      ..recordError(error, stackTrace, fatal: fatal, context: data)
      ..logEvent(AnalyticsEventName.appError, parameters: data);
  }

  /// Fuerza el envío de lo que quede pendiente.
  Future<void> flush() => _backend.flush();
}
