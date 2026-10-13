import 'dart:async';

import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';

/// Mantiene abierto el micrófono en una pantalla de navegación con guitarra.
///
/// Las pantallas de juego abren y cierran el micrófono por su cuenta, así que
/// al volver al catálogo puede haberse cerrado. Mientras el catálogo lo tenga
/// abierto con [open], el guardián lo reabre si ve que ya no llega sonido y
/// hay una barra de órdenes a la vista; [close] lo cierra.
class GuitarMicKeeper {
  /// Crea el guardián sobre [_audio] y mira el estado de [_listener].
  GuitarMicKeeper(this._audio, this._listener);

  final AudioRepository _audio;
  final GuitarCommandListener _listener;

  static const Duration _healEvery = Duration(seconds: 2);

  Timer? _timer;

  /// Abre el micrófono y lo mantiene abierto. Idempotente.
  Future<void> open() async {
    _timer ??= Timer.periodic(_healEvery, (Timer _) => _heal());
    await _audio.requestAccess();
  }

  /// Cierra el micrófono que abrió [open]; no hace nada si no se abrió.
  Future<void> close() async {
    if (_timer == null) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    await _audio.stopListening();
  }

  void _heal() {
    if (_listener.actions.isNotEmpty &&
        _listener.enabled &&
        !_listener.state.hearing) {
      unawaited(_audio.requestAccess());
    }
  }
}
