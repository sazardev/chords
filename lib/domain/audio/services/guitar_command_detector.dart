import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/services/fretboard.dart';

/// Nota firme que se acaba de tocar: su clase de tono y si es muy aguda.
class GuitarNote {
  /// Crea la nota.
  const GuitarNote({required this.pitchClass, required this.high});

  /// Clase de tono (0 = Do … 11 = Si).
  final int pitchClass;

  /// Si suena por encima de [GuitarCommandDetector.wakeFrequency]: la nota
  /// «lejana» que abre y cierra el menú global.
  final bool high;
}

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
/// frecuencia; la única excepción son las notas muy agudas ([GuitarNote.high]),
/// que ningún juego pide y se reconocen por su frecuencia. No usa
/// temporizadores: el tiempo llega por parámetro.
class GuitarCommandDetector {
  /// Crea el detector.
  GuitarCommandDetector({
    this.requiredReadings = 3,
    this.silenceToArm = const Duration(milliseconds: 500),
    this.noteGap = const Duration(milliseconds: 450),
  });

  /// Frecuencia (Hz) desde la que una nota es «lejana»: el traste 14 de la 1ª
  /// cuerda. Los juegos piden como mucho el traste 12 (659 Hz).
  static const double wakeFrequency = 740;

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
    final GuitarNote? note = feedNote(reading, now);
    if (note == null || note.high) {
      return null;
    }
    final GuitarCommand? command = GuitarCommand.ofPitchClass(note.pitchClass);
    return command != null && enabled.contains(command) ? command : null;
  }

  /// Procesa una lectura; devuelve la nota cuando se confirma una nueva.
  ///
  /// Una nota aguda y la misma clase en octava normal cuentan como notas
  /// distintas, así que tocar una justo tras la otra no queda bloqueado.
  GuitarNote? feedNote(PitchReading reading, DateTime now) {
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
    final bool high = reading.frequency >= wakeFrequency;
    final int key = pitchClass + (high ? 12 : 0);
    _count = key == _candidate ? _count + 1 : 1;
    _candidate = key;
    if (_count < requiredReadings || key == _fired) {
      return null;
    }
    _fired = key;
    return GuitarNote(pitchClass: pitchClass, high: high);
  }

  void _forgetNote() {
    _candidate = null;
    _count = 0;
    _fired = null;
  }
}
