import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:meta/meta.dart';

/// Fase de una sesión de jam.
enum JamPhase {
  /// Eligiendo pista, tono y tempo.
  setup,

  /// Preparando los sonidos de la banda (síntesis y carga).
  loading,

  /// Cuenta atrás de un compás antes de empezar.
  countIn,

  /// Sonando.
  playing,

  /// En pausa.
  paused,

  /// Terminada: se ven los resultados.
  finished,
}

/// Cómo se toca: con acompañamiento o puntuando con el micrófono.
enum JamMode {
  /// La app toca los acordes con el rasgueo.
  backing,

  /// La persona toca y el micrófono puntúa; la app no suena.
  score,
}

/// Tempo mínimo y máximo del jam.
const int kJamMinBpm = 40;

/// Tempo máximo del jam.
const int kJamMaxBpm = 220;

/// Estado inmutable de una sesión de jam.
@immutable
class JamState {
  /// Crea el estado.
  const JamState({
    this.track,
    this.phase = JamPhase.setup,
    this.mode = JamMode.backing,
    this.loadProgress = 0,
    this.bar = 0,
    this.slot = 0,
    this.countdown = 0,
    this.score = const JamScore(),
    this.lastGrade,
    this.micProblem = false,
    this.isNewBest = false,
  });

  /// Pista cargada.
  final JamTrack? track;

  /// Fase.
  final JamPhase phase;

  /// Modo.
  final JamMode mode;

  /// Avance de la preparación de la banda (0-1) en [JamPhase.loading].
  final double loadProgress;

  /// Compás actual (desde 0).
  final int bar;

  /// Hueco de corchea actual dentro del compás.
  final int slot;

  /// Pulsos que faltan en la cuenta atrás.
  final int countdown;

  /// Marcador (solo en modo puntuar).
  final JamScore score;

  /// Nota del último compás evaluado.
  final BarGrade? lastGrade;

  /// `true` si no se pudo abrir el micrófono.
  final bool micProblem;

  /// `true` si la sesión terminada batió el récord.
  final bool isNewBest;

  /// `true` mientras la sesión está en marcha (sonando o en pausa).
  bool get isRunning =>
      phase == JamPhase.loading ||
      phase == JamPhase.countIn ||
      phase == JamPhase.playing ||
      phase == JamPhase.paused;

  /// Pulso actual dentro del compás (desde 0).
  int get beat => slot ~/ 2;

  /// Acorde que suena ahora.
  ChordSymbol? get currentChord => track?.chordAt(bar, slot);

  /// Siguiente acorde distinto del actual, o `null` al final.
  ChordSymbol? get nextChord {
    final JamTrack? current = track;
    final ChordSymbol? now = currentChord;
    if (current == null || now == null) {
      return null;
    }
    final int parts = current.bars[bar].chords.length;
    final int part = slot * parts ~/ current.slotsPerBar;
    final List<ChordSymbol> ahead = <ChordSymbol>[
      ...current.bars[bar].chords.skip(part + 1),
      for (int b = bar + 1; b < current.bars.length; b++)
        ...current.bars[b].chords,
    ];
    for (final ChordSymbol chord in ahead) {
      if (chord != now) {
        return chord;
      }
    }
    return null;
  }

  /// Progreso de la sesión (0-1).
  double get progress {
    final JamTrack? current = track;
    if (current == null || current.bars.isEmpty) {
      return 0;
    }
    return (bar + slot / current.slotsPerBar) / current.bars.length;
  }

  /// Copia con cambios.
  JamState copyWith({
    JamTrack? track,
    JamPhase? phase,
    JamMode? mode,
    double? loadProgress,
    int? bar,
    int? slot,
    int? countdown,
    JamScore? score,
    BarGrade? lastGrade,
    bool clearGrade = false,
    bool? micProblem,
    bool? isNewBest,
  }) => JamState(
    track: track ?? this.track,
    phase: phase ?? this.phase,
    mode: mode ?? this.mode,
    loadProgress: loadProgress ?? this.loadProgress,
    bar: bar ?? this.bar,
    slot: slot ?? this.slot,
    countdown: countdown ?? this.countdown,
    score: score ?? this.score,
    lastGrade: clearGrade ? null : (lastGrade ?? this.lastGrade),
    micProblem: micProblem ?? this.micProblem,
    isNewBest: isNewBest ?? this.isNewBest,
  );
}
