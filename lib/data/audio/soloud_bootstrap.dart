import 'package:flutter_soloud/flutter_soloud.dart';

/// Arranque en curso: dos repositorios que piden el motor a la vez no lo
/// inician dos veces.
Future<void>? _pending;

/// Arranca el motor de audio (SoLoud) si aún no lo está.
///
/// SoLoud es un singleton: iniciarlo otra vez lo reinicia y deja sin validez
/// cuanto se cargó, así que todos los que lo usen deben pasar por aquí.
Future<void> ensureSoLoudReady() async {
  if (SoLoud.instance.isInitialized) {
    return;
  }
  final Future<void> running = _pending ??= SoLoud.instance.init();
  try {
    await running;
  } finally {
    _pending = null;
  }
}
