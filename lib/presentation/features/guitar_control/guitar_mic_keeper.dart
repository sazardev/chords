import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';

/// Mantiene abierto el micrófono mientras el modo guitarra está encendido.
///
/// Las pantallas de juego, práctica y afinador abren y cierran el micrófono
/// por su cuenta, así que al salir de ellas puede haberse cerrado. Mientras
/// esté abierto con [open], el guardián lo reabre si ve que ya no llega
/// sonido y el oyente de la guitarra está escuchando; [close] lo cierra.
class GuitarMicKeeper {
  /// Crea el guardián sobre [_audio] y mira el estado de [_listener].
  GuitarMicKeeper(this._audio, this._listener);

  final AudioRepository _audio;
  final GuitarCommandListener _listener;

  static const Duration _healEvery = Duration(seconds: 2);

  Timer? _timer;
  bool _denied = false;

  /// Abre el micrófono y lo mantiene abierto. Idempotente.
  ///
  /// Si el permiso se niega no se vuelve a pedir solo: así no salta el
  /// diálogo cada pocos segundos; se pedirá de nuevo al volver a llamar aquí.
  Future<void> open() async {
    _timer ??= Timer.periodic(_healEvery, (Timer _) => _heal());
    _denied = false;
    await _request();
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

  Future<void> _request() async {
    final MicStatus status = await _audio.requestAccess();
    _denied = status == MicStatus.permissionDenied;
  }

  void _heal() {
    if (!_denied && _listener.state.listening && !_listener.state.hearing) {
      unawaited(_request());
    }
  }
}
