import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/minigames/build_chord_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:flutter/foundation.dart';

/// Controlador de "arma el acorde": poner los dedos de un acorde dado.
///
/// Responsabilidad única: llevar lo colocado en el tablero, compararlo con
/// las posiciones del acorde y puntuar. Una pista descubre la posición pero
/// en nivel medio el acierto deja de contar.
class BuildChordController extends ChangeNotifier {
  /// Crea el controlador con sus colaboradores.
  BuildChordController(
    this._chords,
    this._audio,
    this._progress, {
    BuildChordRoundsUseCase? buildRounds,
  }) : _buildRounds = buildRounds ?? BuildChordRoundsUseCase(_chords);

  final ChordRepository _chords;
  final AudioRepository _audio;
  final MiniGameProgressController _progress;
  final BuildChordRoundsUseCase _buildRounds;

  BuildChordState _state = const BuildChordState();

  /// Estado actual de la partida.
  BuildChordState get state => _state;

  /// Prepara la pantalla de bienvenida.
  ///
  /// No avisa a los oyentes: la pantalla que lo llama aún se está creando.
  void open() {
    _state = const BuildChordState();
  }

  /// Empieza una partida en la dificultad indicada.
  Future<void> start(MiniGameLevel level) async {
    if (!_chords.isLoaded) {
      await _chords.load();
    }
    _state = BuildChordState(
      level: level,
      phase: MiniGamePhase.asking,
      rounds: _buildRounds(level),
    );
    _progress.started(MiniGameKind.buildChord, level);
    notifyListeners();
  }

  /// Coloca un dedo en [fret] de la cuerda [stringIndex] (0 = sexta).
  ///
  /// Tocar el traste ya colocado deja la cuerda al aire.
  void tapCell(int stringIndex, int fret) {
    if (_state.phase != MiniGamePhase.asking) {
      return;
    }
    final List<int> placed = List<int>.of(_state.placed);
    placed[stringIndex] = placed[stringIndex] == fret ? 0 : fret;
    _state = _state.copyWith(placed: placed, wrong: const <int>[]);
    notifyListeners();
  }

  /// Alterna una cuerda entre silenciada y al aire.
  void toggleMark(int stringIndex) {
    if (_state.phase != MiniGamePhase.asking) {
      return;
    }
    final List<int> placed = List<int>.of(_state.placed);
    placed[stringIndex] = placed[stringIndex] == -1 ? 0 : -1;
    _state = _state.copyWith(placed: placed, wrong: const <int>[]);
    notifyListeners();
  }

  /// Deja el tablero vacío.
  void clear() {
    if (_state.phase != MiniGamePhase.asking) {
      return;
    }
    _state = _state.copyWith(
      placed: BuildChordState.kEmptyBoard,
      wrong: const <int>[],
    );
    notifyListeners();
  }

  /// Descubre la posición de referencia.
  void showHint() {
    if (_state.phase == MiniGamePhase.asking && _state.hintsAllowed) {
      _state = _state.copyWith(hinted: true);
      notifyListeners();
    }
  }

  /// Comprueba lo colocado: acierta con cualquier posición del acorde.
  void check() {
    final ChordRound? round = _state.round;
    final Chord? chord = round == null
        ? null
        : _chords.chordById(round.chordId);
    if (round == null ||
        chord == null ||
        _state.phase != MiniGamePhase.asking) {
      return;
    }
    final ChordVariant target = chord.variants[round.variantIndex];
    final bool matches = chord.variants.any(
      (ChordVariant variant) =>
          wrongStrings(_state.placed, variant.frets).isEmpty,
    );
    if (!matches) {
      _state = _state.copyWith(
        wrong: wrongStrings(_state.placed, target.frets),
      );
      notifyListeners();
      return;
    }
    final bool counts =
        !(_state.hinted && _state.level == MiniGameLevel.medium);
    _state = _state.copyWith(
      phase: MiniGamePhase.feedback,
      solved: true,
      wasCorrect: counts,
      score: _state.score.record(isCorrect: counts),
    );
    notifyListeners();
  }

  /// Rinde la ronda: se enseña la posición y no suma.
  void giveUp() {
    if (_state.phase != MiniGamePhase.asking) {
      return;
    }
    _state = _state.copyWith(
      phase: MiniGamePhase.feedback,
      hinted: true,
      solved: false,
      wasCorrect: false,
      score: _state.score.record(isCorrect: false),
    );
    notifyListeners();
  }

  /// Pasa a la ronda siguiente o termina la partida.
  Future<void> next() async {
    if (_state.phase != MiniGamePhase.feedback) {
      return;
    }
    if (_state.index + 1 >= _state.total) {
      final bool record = await _progress.finished(
        MiniGameKind.buildChord,
        _state.level,
        _state.score,
      );
      _state = _state.copyWith(
        phase: MiniGamePhase.finished,
        isNewBest: record,
      );
    } else {
      _state = _state.copyWith(
        phase: MiniGamePhase.asking,
        index: _state.index + 1,
        placed: BuildChordState.kEmptyBoard,
        wrong: const <int>[],
        hinted: false,
        solved: false,
      );
    }
    notifyListeners();
  }

  /// Suena el acorde de la ronda actual.
  Future<void> playTarget() async {
    final ChordRound? round = _state.round;
    final Chord? chord = round == null
        ? null
        : _chords.chordById(round.chordId);
    if (round != null && chord != null) {
      await _audio.playChord(chord, chord.variants[round.variantIndex]);
    }
  }

  /// Acorde del banco por identificador.
  Chord? chordOf(String chordId) => _chords.chordById(chordId);
}
