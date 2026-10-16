import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/presentation/features/jam/jam_mic_judge.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';

/// La parte de puntuación de la sesión: abre y cierra el micrófono, califica
/// cada compás y guarda el récord y la práctica al terminar.
///
/// Recibe el estado y devuelve el nuevo: el controlador del jam decide cuándo
/// avisar a la pantalla.
class JamScoreKeeper {
  /// Crea el puntuador sobre el audio (micrófono) y el progreso guardado.
  JamScoreKeeper(AudioRepository audio, this._progress)
    : _judge = JamMicJudge(audio);

  final JamMicJudge _judge;
  final StudioProgressController _progress;

  /// Abre el micrófono; `false` si no hay permiso o falla.
  Future<bool> open() => _judge.open();

  /// Empieza a contar lo que se oye (al arrancar el primer compás).
  void begin() => _judge
    ..reset()
    ..counting = true;

  /// Deja de contar lo que se oye (pausa).
  void hold() => _judge.counting = false;

  /// Vuelve a contar lo que se oye (reanudar).
  void resume() => _judge.counting = true;

  /// Cierra el micrófono.
  void close() => _judge.close();

  /// Califica el compás que acaba de sonar y lo anota en [state].
  JamState closeBar(JamState state) {
    if (state.mode != JamMode.score || state.micProblem) {
      return state;
    }
    final JamTrack track = state.track!;
    final ChordSymbol chord = track.chordAt(state.bar, track.slotsPerBar - 1);
    final BarGrade grade = _judge.grade(chord);
    return state.copyWith(score: state.score.record(grade), lastGrade: grade);
  }

  /// Cierra la sesión: guarda el récord (si se puntuó) o la práctica.
  Future<JamState> finish(JamState state) async {
    final bool scored = state.mode == JamMode.score && !state.micProblem;
    final bool record =
        scored && await _progress.saveJam(state.track!.key, state.score.points);
    if (!scored) {
      await _progress.markPracticed();
    }
    appLogger.info(
      'jam terminado: ${state.track!.key}',
      channel: LogChannel.learn,
      context: <String, Object?>{
        'mode': state.mode.name,
        'points': state.score.points,
      },
    );
    return state.copyWith(phase: JamPhase.finished, isNewBest: record);
  }
}
