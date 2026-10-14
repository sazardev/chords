import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:meta/meta.dart';

/// Un acorde de la tonalidad con su grado (`IV`) y su cifra (`F`).
typedef DiatonicChord = ({int degree, String roman, ChordSymbol symbol});

/// Una tonalidad: una tónica y su modo (mayor o menor).
///
/// Responde a las preguntas de armonía básicas: qué notas tiene, qué
/// acordes nacen de cada grado y cuál es su relativa.
@immutable
class MusicalKey {
  /// Crea la tonalidad de tónica [tonic] (0 = Do).
  const MusicalKey(this.tonic, {this.minor = false});

  /// Tónica como clase de tono.
  final int tonic;

  /// `true` si es una tonalidad menor.
  final bool minor;

  static const List<String> _romans = <String>[
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
  ];

  /// Escala de la tonalidad.
  ScaleType get scale => minor ? ScaleType.naturalMinor : ScaleType.major;

  /// Las siete notas de la tonalidad, empezando por la tónica.
  List<int> get pitchClasses => scale.pitchClasses(tonic);

  /// Tonalidad relativa: comparte notas (Do mayor ↔ La menor).
  MusicalKey get relative => minor
      ? MusicalKey((tonic + 3) % 12)
      : MusicalKey((tonic + 9) % 12, minor: true);

  /// Los siete acordes de la tonalidad (triadas o cuatriadas).
  List<DiatonicChord> harmony({bool sevenths = false}) => <DiatonicChord>[
    for (int degree = 0; degree < 7; degree++) _chordOn(degree, sevenths),
  ];

  DiatonicChord _chordOn(int degree, bool sevenths) {
    final List<int> notes = pitchClasses;
    int above(int steps) =>
        (notes[(degree + steps) % 7] - notes[degree] + 12) % 12;
    final ChordQuality quality = _qualityOf(
      third: above(2),
      fifth: above(4),
      seventh: sevenths ? above(6) : null,
    );
    final bool lower =
        quality == ChordQuality.minor ||
        quality == ChordQuality.minorSeven ||
        quality == ChordQuality.diminished;
    final String numeral = lower
        ? _romans[degree].toLowerCase()
        : _romans[degree];
    return (
      degree: degree + 1,
      roman: '$numeral${_romanSuffix(quality)}',
      symbol: ChordSymbol(notes[degree], quality),
    );
  }

  static ChordQuality _qualityOf({
    required int third,
    required int fifth,
    int? seventh,
  }) {
    if (fifth == 6) {
      return ChordQuality.diminished;
    }
    if (fifth == 8) {
      return ChordQuality.augmented;
    }
    final bool major = third == 4;
    return switch (seventh) {
      null => major ? ChordQuality.major : ChordQuality.minor,
      11 => major ? ChordQuality.majorSeven : ChordQuality.minorSeven,
      _ => major ? ChordQuality.seven : ChordQuality.minorSeven,
    };
  }

  static String _romanSuffix(ChordQuality quality) => switch (quality) {
    ChordQuality.diminished => '°',
    ChordQuality.augmented => '+',
    ChordQuality.seven || ChordQuality.minorSeven => '7',
    ChordQuality.majorSeven => 'maj7',
    _ => '',
  };

  @override
  bool operator ==(Object other) =>
      other is MusicalKey && other.tonic == tonic && other.minor == minor;

  @override
  int get hashCode => Object.hash(tonic, minor);

  @override
  String toString() => 'MusicalKey($tonic${minor ? 'm' : ''})';
}
