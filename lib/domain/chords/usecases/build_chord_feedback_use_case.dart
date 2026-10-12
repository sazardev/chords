import 'package:chords/domain/chords/entities/chord_match_feedback.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';

/// Caso de uso: describe el objetivo del juego frente a lo escuchado.
///
/// Cruza las notas del acorde con las detectadas por el micrófono y, usando
/// los trastes de la posición, averigua en qué cuerdas vive cada nota para
/// señalar la que falla. También detecta las notas que suenan de más.
class BuildChordFeedbackUseCase {
  /// Crea el caso de uso.
  const BuildChordFeedbackUseCase();

  /// Clases de tono de las cuerdas al aire, de la sexta a la primera.
  static const List<int> _openPitchClasses = <int>[4, 9, 2, 7, 11, 4];

  /// Construye el feedback del objetivo para la posición indicada.
  ///
  /// [frets] son los trastes por cuerda (índice 0 = sexta; `-1` = muda) y
  /// [heardNotes] las notas detectadas, en orden.
  ChordMatchFeedback call({
    required List<int> frets,
    required List<String> targetNotes,
    required Set<String> heardNotes,
  }) {
    final Set<int> targetClasses = targetNotes.map(_pitchClassOf).toSet();
    final Set<int> heardClasses = heardNotes.map(_pitchClassOf).toSet();
    final Map<int, List<int>> stringsByClass = _stringsByPitchClass(frets);
    return ChordMatchFeedback(
      notes: <TargetNoteFeedback>[
        for (final String note in targetNotes)
          TargetNoteFeedback(
            note: note,
            heard: heardClasses.contains(_pitchClassOf(note)),
            strings: stringsByClass[_pitchClassOf(note)] ?? const <int>[],
          ),
      ],
      extraNotes: <String>[
        for (final String note in heardNotes)
          if (!targetClasses.contains(_pitchClassOf(note))) note,
      ],
    );
  }

  /// Estado de cada cuerda (de la sexta a la primera) frente a lo escuchado.
  ///
  /// Una cuerda queda reconocida si su nota está entre [heardNotes]; las
  /// mudas se marcan como tales. Alimenta el diagrama del juego.
  List<PracticeStringStatus> stringStatuses({
    required List<int> frets,
    required Set<String> heardNotes,
  }) {
    final Set<int> heard = heardNotes.map(_pitchClassOf).toSet();
    return <PracticeStringStatus>[
      for (int i = 0; i < _openPitchClasses.length; i++)
        _statusOf(i < frets.length ? frets[i] : -1, i, heard),
    ];
  }

  PracticeStringStatus _statusOf(int fret, int index, Set<int> heard) {
    if (fret < 0) {
      return PracticeStringStatus.muted;
    }
    final int pitchClass = (_openPitchClasses[index] + fret) % 12;
    return heard.contains(pitchClass)
        ? PracticeStringStatus.matched
        : PracticeStringStatus.pending;
  }

  Map<int, List<int>> _stringsByPitchClass(List<int> frets) {
    final Map<int, List<int>> result = <int, List<int>>{};
    for (int index = 0; index < frets.length; index++) {
      if (index >= _openPitchClasses.length) {
        break;
      }
      final int fret = frets[index];
      if (fret < 0) {
        continue;
      }
      final int pitchClass = (_openPitchClasses[index] + fret) % 12;
      result.putIfAbsent(pitchClass, () => <int>[]).add(6 - index);
    }
    return result;
  }

  int _pitchClassOf(String note) {
    const List<String> names = <String>[
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    return names.indexOf(note);
  }
}
