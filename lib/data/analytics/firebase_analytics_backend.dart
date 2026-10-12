import 'dart:async' show unawaited;

import 'package:chords/core/analytics/analytics_backend.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Backend de analíticas sobre Firebase (Analytics y Crashlytics).
///
/// Traduce las primitivas de [AnalyticsBackend] a los SDK de FlutterFire,
/// sanea nombres y valores a los límites de Firebase y jamás propaga un fallo
/// de telemetría: cualquier error del SDK se descarta para no afectar a la
/// aplicación. Crashlytics es opcional porque no está soportado en web.
class FirebaseAnalyticsBackend implements AnalyticsBackend {
  /// Crea el backend con los SDK ya inicializados.
  FirebaseAnalyticsBackend({required this._analytics, this._crashlytics});

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics? _crashlytics;

  static final RegExp _invalidKeyCharacters = RegExp('[^A-Za-z0-9_]');
  static final RegExp _validKeyStart = RegExp('^[A-Za-z]');

  @override
  void logEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  }) => unawaited(
    _guard(
      () => _analytics.logEvent(name: name, parameters: _sanitize(parameters)),
    ),
  );

  @override
  void logScreen(String name, {String? previous}) =>
      unawaited(_guard(() => _analytics.logScreenView(screenName: name)));

  @override
  void setUserProperty(String name, String? value) => unawaited(
    _guard(() => _analytics.setUserProperty(name: name, value: value)),
  );

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    final FirebaseCrashlytics? crashlytics = _crashlytics;
    if (crashlytics == null) {
      return;
    }
    unawaited(
      _guard(() async {
        await _applyContext(crashlytics, context);
        await crashlytics.recordError(error, stackTrace, fatal: fatal);
      }),
    );
  }

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
    final FirebaseCrashlytics? crashlytics = _crashlytics;
    if (crashlytics != null) {
      await crashlytics.setCrashlyticsCollectionEnabled(enabled);
    }
  }

  @override
  Future<void> flush() async {
    final FirebaseCrashlytics? crashlytics = _crashlytics;
    if (crashlytics != null) {
      await crashlytics.sendUnsentReports();
    }
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (_) {
      return;
    }
  }

  Future<void> _applyContext(
    FirebaseCrashlytics crashlytics,
    Map<String, Object?> context,
  ) async {
    for (final MapEntry<String, Object?> entry in context.entries) {
      final String? key = _keyOf(entry.key);
      final Object? value = entry.value;
      if (key == null || value == null) {
        continue;
      }
      await crashlytics.setCustomKey(key, _clip(value.toString()));
    }
  }

  Map<String, Object> _sanitize(Map<String, Object?> parameters) {
    final Map<String, Object> clean = <String, Object>{};
    for (final MapEntry<String, Object?> entry in parameters.entries) {
      final String? key = _keyOf(entry.key);
      final Object? value = entry.value;
      if (key == null || value == null) {
        continue;
      }
      clean[key] = _valueOf(value);
    }
    return clean;
  }

  Object _valueOf(Object value) => switch (value) {
    String() => _clip(value),
    num() => value,
    bool() => value ? 1 : 0,
    List<Object?>() => _clip(value.join(',')),
    _ => _clip(value.toString()),
  };

  String? _keyOf(String raw) {
    final String key = raw.replaceAll(_invalidKeyCharacters, '_');
    if (key.isEmpty || !_validKeyStart.hasMatch(key)) {
      return null;
    }
    return key.length <= 40 ? key : key.substring(0, 40);
  }

  String _clip(String value) =>
      value.length <= 100 ? value : value.substring(0, 100);
}
