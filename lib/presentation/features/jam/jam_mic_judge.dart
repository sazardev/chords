import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Juez del modo puntuar: escucha el micrófono y califica cada compás.
///
/// Responsabilidad única: abrir y cerrar el micrófono, contar las notas que
/// se oyen mientras está abierto el compás y decir qué tal fue.
class JamMicJudge {
  /// Crea el juez sobre [_audio].
  JamMicJudge(this._audio);

  final AudioRepository _audio;
  final Map<int, int> _heard = <int, int>{};
  StreamSubscription<PitchReading>? _readings;

  /// `true` mientras cuenta notas (solo durante los compases).
  bool counting = false;

  /// Abre el micrófono; `false` si no hay permiso o falla.
  Future<bool> open() async {
    final MicStatus status = await _audio.requestAccess();
    if (status != MicStatus.listening) {
      return false;
    }
    await _readings?.cancel();
    _readings = _audio.readings.listen(_onReading);
    return true;
  }

  /// Olvida lo oído (al empezar un compás).
  void reset() => _heard.clear();

  /// Califica el compás contra [chord] y empieza uno nuevo.
  BarGrade grade(ChordSymbol chord) {
    final BarGrade result = gradeBar(chord, Map<int, int>.of(_heard));
    _heard.clear();
    return result;
  }

  /// Cierra el micrófono si lo abrió.
  void close() {
    counting = false;
    final StreamSubscription<PitchReading>? readings = _readings;
    _readings = null;
    if (readings != null) {
      unawaited(readings.cancel());
      unawaited(_audio.stopListening());
    }
  }

  void _onReading(PitchReading reading) {
    if (!counting || !reading.isReliable) {
      return;
    }
    final int pitchClass = pitchClassOfLabel(reading.note);
    if (pitchClass >= 0) {
      _heard[pitchClass] = (_heard[pitchClass] ?? 0) + 1;
    }
  }
}
