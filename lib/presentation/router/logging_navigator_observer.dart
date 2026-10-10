import 'package:chords/core/logging/app_log.dart' show appLogger;
import 'package:chords/core/logging/log_channel.dart';
import 'package:flutter/widgets.dart' show NavigatorObserver, Route;

/// Observador de navegación que registra cada cambio de pila de rutas.
///
/// Deja rastro en el canal de navegación de los push, pop, replace y remove,
/// con el origen y destino de cada transición.
class LoggingNavigatorObserver extends NavigatorObserver {
  /// Crea el observador.
  LoggingNavigatorObserver();

  void _log(String action, Route<dynamic>? route, Route<dynamic>? previous) {
    appLogger.info(
      action,
      channel: LogChannel.router,
      context: <String, Object?>{
        'to': route?.settings.name ?? '?',
        'from': previous?.settings.name ?? '-',
      },
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('pop', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log('replace', newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('remove', route, previousRoute);
  }
}
