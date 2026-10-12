import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/services/pitch_math.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/domain/chords/usecases/analyze_fretted_note_use_case.dart';

/// Qué ocurrió al procesar una nota en la sesión de práctica.
enum PracticeFeedResult {
  /// Se reconoció una cuerda del acorde.
  matched,

  /// La nota no era la esperada; hay un consejo disponible.
  tip,

  /// La nota no aporta nada (cuerda ya reconocida o acorde completo).
  ignored,
}

/// Sesión de práctica de una posición de acorde, cuerda a cuerda.
///
/// El guitarrista toca las cuerdas una a una, en el orden que quiera: cada
/// nota se atribuye a la cuerda del acorde que la produce. Si no encaja con
/// ninguna, se aconseja sobre la primera cuerda pendiente (la que toca ahora).
class ChordPracticeSession {
  /// Crea la sesión para una posición.
  ///
  /// [frets] y [fingers] tienen una entrada por cuerda, de la sexta a la
  /// primera; `-1` en [frets] marca una cuerda muda.
  ChordPracticeSession({required List<int> frets, required List<int> fingers})
    : _strings = _build(frets, fingers);

  final AnalyzeFrettedNoteUseCase _analyzer = const AnalyzeFrettedNoteUseCase();
  List<PracticeString> _strings;
  PracticeTip? _tip;
  int? _lastMatched;

  /// Cuerdas de la sexta a la primera.
  List<PracticeString> get strings =>
      List<PracticeString>.unmodifiable(_strings);

  /// Consejo vigente para la cuerda en foco, si la última nota falló.
  PracticeTip? get tip => _tip;

  /// Última cuerda reconocida (para animarla).
  int? get lastMatched => _lastMatched;

  /// Cuerdas que el acorde usa.
  int get total => _strings.where((PracticeString s) => !s.isMuted).length;

  /// Cuerdas ya reconocidas.
  int get matchedCount =>
      _strings.where((PracticeString s) => s.isMatched).length;

  /// `true` si todas las cuerdas del acorde se reconocieron.
  bool get isComplete => total > 0 && matchedCount == total;

  /// Primera cuerda pendiente (de la sexta a la primera), o `null`.
  PracticeString? get focus {
    for (final PracticeString string in _strings) {
      if (string.status == PracticeStringStatus.pending) {
        return string;
      }
    }
    return null;
  }

  /// Vuelve a empezar: todas las cuerdas quedan pendientes.
  void reset() {
    _strings = <PracticeString>[
      for (final PracticeString s in _strings)
        if (s.isMuted) s else s.withStatus(PracticeStringStatus.pending),
    ];
    _tip = null;
    _lastMatched = null;
  }

  /// Procesa una nota detectada.
  PracticeFeedResult feed(double frequency) {
    final PracticeString? current = focus;
    if (current == null) {
      return PracticeFeedResult.ignored;
    }
    final List<PracticeString> hits = _strings
        .where(
          (PracticeString s) => !s.isMuted && _analyzer.matches(s, frequency),
        )
        .toList();
    if (hits.isNotEmpty) {
      return _acceptHits(hits);
    }
    final PracticeString? octaveHit = _octaveGlitchMatch(frequency);
    if (octaveHit != null) {
      _markMatched(octaveHit);
      return PracticeFeedResult.matched;
    }
    _tip = _analyzer.tipFor(current, frequency);
    return PracticeFeedResult.tip;
  }

  PracticeFeedResult _acceptHits(List<PracticeString> hits) {
    for (final PracticeString hit in hits) {
      if (!hit.isMatched) {
        _markMatched(hit);
        return PracticeFeedResult.matched;
      }
    }
    return PracticeFeedResult.ignored;
  }

  /// Cuerda pendiente que encajaría si el detector se pasó una octava arriba.
  PracticeString? _octaveGlitchMatch(double frequency) {
    final double lowered = frequency / 2;
    for (final PracticeString s in _strings) {
      if (s.status == PracticeStringStatus.pending &&
          _analyzer.matches(s, lowered)) {
        return s;
      }
    }
    return null;
  }

  void _markMatched(PracticeString target) {
    _strings = <PracticeString>[
      for (final PracticeString s in _strings)
        if (s.number == target.number)
          s.withStatus(PracticeStringStatus.matched)
        else
          s,
    ];
    _lastMatched = target.number;
    _tip = null;
  }

  static List<PracticeString> _build(List<int> frets, List<int> fingers) =>
      <PracticeString>[
        for (int i = 0; i < kStandardTuning.length; i++)
          _stringAt(i, i < frets.length ? frets[i] : -1, fingers),
      ];

  static PracticeString _stringAt(int index, int fret, List<int> fingers) {
    final GuitarString string = kStandardTuning[index];
    return PracticeString(
      string: string,
      fret: fret,
      finger: index < fingers.length ? fingers[index] : 0,
      frequency: fret < 0
          ? string.frequency
          : shiftBySemitones(string.frequency, fret),
      status: fret < 0
          ? PracticeStringStatus.muted
          : PracticeStringStatus.pending,
    );
  }
}
