import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/services/fretboard.dart';

/// Convierte las lecturas del micrófono en órdenes de guitarra.
///
/// Dos protecciones evitan disparos por error:
///
/// * **Silencio previo**: tras [arm] hay que dejar de sonar durante
///   [silenceToArm] antes de aceptar nada, así la última nota tocada (que
///   sigue sonando) no se confunde con una orden.
/// * **Nota firme**: la orden solo vale tras [requiredReadings] lecturas
///   fiables seguidas de la misma clase de tono, y no se repite mientras la
///   nota siga sonando.
///
/// Solo mira la clase de tono, porque el detector se equivoca de octava con
/// frecuencia. No usa temporizadores: el tiempo llega por parámetro.
class GuitarCommandDetector {
  /// Crea el detector.
  GuitarCommandDetector({
    this.requiredReadings = 3,
    this.silenceToArm = const Duration(milliseconds: 500),
    this.noteGap = const Duration(milliseconds: 450),
  });

  /// Lecturas fiables seguidas de una misma nota para darla por tocada.
  final int requiredReadings;

  /// Silencio necesario tras [arm] para empezar a aceptar órdenes.
  final Duration silenceToArm;

  /// Silencio que separa una nota de la siguiente (rearma la misma nota).
  final Duration noteGap;

  bool _armed = false;
  DateTime? _lastSound;
  DateTime? _since;
  int? _candidate;
  int _count = 0;
  int? _fired;

  /// `true` cuando ya se aceptan órdenes.
  bool get isArmed => _armed;

  /// Empieza a esperar el silencio previo; llamar al cambiar de pantalla.
  void arm(DateTime now) {
    _armed = false;
    _since = now;
    _lastSound = null;
    _forgetNote();
  }

  /// Deja de aceptar órdenes hasta el siguiente [arm].
  void disarm() {
    _armed = false;
    _since = null;
    _lastSound = null;
    _forgetNote();
  }

  /// Avanza el reloj: arma el detector si ya hubo silencio suficiente.
  void poll(DateTime now) {
    if (_armed || _since == null) {
      return;
    }
    final DateTime quietFrom = _lastSound ?? _since!;
    if (now.difference(quietFrom) >= silenceToArm) {
      _armed = true;
    }
  }

  /// Procesa una lectura; devuelve la orden cuando se toca una de [enabled].
  GuitarCommand? feed(
    PitchReading reading,
    DateTime now,
    Set<GuitarCommand> enabled,
  ) {
    if (_since == null || !reading.isReliable) {
      return null;
    }
    poll(now);
    final DateTime? last = _lastSound;
    _lastSound = now;
    if (!_armed) {
      return null;
    }
    if (last != null && now.difference(last) > noteGap) {
      _forgetNote();
    }
    final int pitchClass = pitchClassOfLabel(reading.note);
    if (pitchClass < 0) {
      return null;
    }
    _count = pitchClass == _candidate ? _count + 1 : 1;
    _candidate = pitchClass;
    if (_count < requiredReadings || pitchClass == _fired) {
      return null;
    }
    _fired = pitchClass;
    final GuitarCommand? command = GuitarCommand.ofPitchClass(pitchClass);
    return command != null && enabled.contains(command) ? command : null;
  }

  void _forgetNote() {
    _candidate = null;
    _count = 0;
    _fired = null;
  }
}
