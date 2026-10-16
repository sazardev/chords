import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';

/// Acordes que nacen de apilar terceras sobre cada grado de una escala.
///
/// Solo las escalas de siete notas tienen armonía de tríadas y cuatriadas.
/// Los grados cuyo apilado no es un acorde conocido (p. ej. una séptima mayor
/// con quinta bemol) no aparecen.
class ScaleHarmony {
  /// Crea el cálculo para [scale] con tónica [tonic] (0 = Do).
  const ScaleHarmony(this.scale, this.tonic);

  /// Escala.
  final ScaleType scale;

  /// Tónica como clase de tono.
  final int tonic;

  /// `true` si la escala tiene siete notas y por tanto armonía de terceras.
  bool get hasHarmony => scale.length == 7;

  /// Tríadas (o cuatriadas con [sevenths]) de la escala, grado a grado.
  List<DiatonicChord> chords({bool sevenths = false}) {
    if (!hasHarmony) {
      return const <DiatonicChord>[];
    }
    return <DiatonicChord>[
      for (int degree = 0; degree < 7; degree++)
        ?_chordOn(degree, sevenths: sevenths),
    ];
  }

  DiatonicChord? _chordOn(int degree, {required bool sevenths}) {
    final List<int> semis = <int>[
      for (final int step in sevenths ? _seventhSteps : _triadSteps)
        _above(degree, step),
    ];
    final ChordQuality? quality = _qualityOf(semis);
    if (quality == null) {
      return null;
    }
    return (
      degree: degree + 1,
      roman: _roman(degree, quality),
      symbol: ChordSymbol((tonic + scale.intervals[degree]) % 12, quality),
    );
  }

  static const List<int> _triadSteps = <int>[0, 2, 4];
  static const List<int> _seventhSteps = <int>[0, 2, 4, 6];

  /// Semitonos entre el grado [degree] y la nota [steps] grados más arriba.
  int _above(int degree, int steps) =>
      (scale.intervals[(degree + steps) % 7] - scale.intervals[degree] + 12) %
      12;

  /// Calidad que forma el apilado [semis] (semitonos desde la raíz).
  ChordQuality? _qualityOf(List<int> semis) {
    for (final ChordQuality quality
        in semis.length == 3 ? _triadQualities : _seventhQualities) {
      if (_sameStack(quality.intervals, semis)) {
        return quality;
      }
    }
    return null;
  }

  bool _sameStack(List<int> intervals, List<int> semis) {
    if (intervals.length != semis.length) {
      return false;
    }
    for (int i = 0; i < semis.length; i++) {
      if (intervals[i] != semis[i]) {
        return false;
      }
    }
    return true;
  }

  static const List<ChordQuality> _triadQualities = <ChordQuality>[
    ChordQuality.major,
    ChordQuality.minor,
    ChordQuality.diminished,
    ChordQuality.augmented,
  ];

  static const List<ChordQuality> _seventhQualities = <ChordQuality>[
    ChordQuality.majorSeven,
    ChordQuality.seven,
    ChordQuality.minorSeven,
    ChordQuality.halfDiminished,
    ChordQuality.diminishedSeven,
    ChordQuality.minorMajorSeven,
    ChordQuality.majorSevenSharpFive,
    ChordQuality.sevenSharpFive,
    ChordQuality.sevenFlatFive,
  ];

  static const List<String> _numerals = <String>[
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
  ];

  static const List<int> _majorOffsets = <int>[0, 2, 4, 5, 7, 9, 11];
  static const List<int> _minorOffsets = <int>[0, 2, 3, 5, 7, 8, 10];

  static const Set<ChordQuality> _lowerCase = <ChordQuality>{
    ChordQuality.minor,
    ChordQuality.minorSeven,
    ChordQuality.minorMajorSeven,
    ChordQuality.diminished,
    ChordQuality.diminishedSeven,
    ChordQuality.halfDiminished,
  };

  /// Número romano del grado: minúscula si el acorde es menor o disminuido y
  /// con `b` o `#` si el grado no es el de la mayor (o la menor natural en las
  /// escalas menores).
  String _roman(int degree, ChordQuality quality) {
    final List<int> base = scale.isMinor ? _minorOffsets : _majorOffsets;
    final int shift = scale.intervals[degree] - base[degree];
    final bool raisedMinorTop = scale.isMinor && degree >= 5 && shift == 1;
    final String accidental = raisedMinorTop || shift == 0
        ? ''
        : (shift < 0 ? 'b' : '#') * shift.abs();
    final String numeral = _lowerCase.contains(quality)
        ? _numerals[degree].toLowerCase()
        : _numerals[degree];
    return '$accidental$numeral${_suffix(quality)}';
  }

  String _suffix(ChordQuality quality) => switch (quality) {
    ChordQuality.diminished => '°',
    ChordQuality.augmented => '+',
    ChordQuality.seven || ChordQuality.minorSeven => '7',
    ChordQuality.majorSeven || ChordQuality.minorMajorSeven => 'maj7',
    ChordQuality.halfDiminished => 'ø7',
    ChordQuality.diminishedSeven => '°7',
    ChordQuality.majorSevenSharpFive => 'maj7#5',
    ChordQuality.sevenSharpFive => '7#5',
    ChordQuality.sevenFlatFive => '7b5',
    _ => '',
  };
}
