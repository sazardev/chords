import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/logging/app_log.dart' show appLogger;
import 'package:chords/core/logging/log_channel.dart';
import 'package:flutter/widgets.dart' show NavigatorObserver, Route;

/// Observador de navegación que registra cada cambio de pila de rutas.
///
/// Deja rastro en el canal de navegación de los push, pop, replace y remove,
/// con el origen y destino de cada transición, y notifica la pantalla visible a
/// las analíticas para reconstruir el embudo de uso.
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

  void _screen(String? name, {String? from}) {
    if (name == null) {
      return;
    }
    analytics.screen(name, from: from);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('push', route, previousRoute);
    _screen(route.settings.name, from: previousRoute?.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('pop', route, previousRoute);
    _screen(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log('replace', newRoute, oldRoute);
    _screen(newRoute?.settings.name, from: oldRoute?.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('remove', route, previousRoute);
  }
}
