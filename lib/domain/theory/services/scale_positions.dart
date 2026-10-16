/// Escalas sobre el mástil: todas sus notas y sus posiciones (cajas).
library;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:meta/meta.dart';

/// Último traste que dibuja el explorador de escalas.
const int kScaleMaxFret = 17;

/// Altura (semitonos desde el Do0) de cada cuerda al aire, de la 1ª a la 6ª.
const Map<int, int> _openPitch = <int, int>{
  1: 64,
  2: 59,
  3: 55,
  4: 50,
  5: 45,
  6: 40,
};

/// Escalas de seis u ocho notas que se tocan con las cajas de otra más corta
/// más sus notas de paso: la blue note, la novena, la séptima del bebop…
const Map<ScaleType, ScaleType> _boxBase = <ScaleType, ScaleType>{
  ScaleType.blues: ScaleType.minorPentatonic,
  ScaleType.majorBlues: ScaleType.majorPentatonic,
  ScaleType.minorHexatonic: ScaleType.minorPentatonic,
  ScaleType.bebopDominant: ScaleType.mixolydian,
  ScaleType.bebopMajor: ScaleType.major,
};

/// Una posición (caja) de una escala: las notas que se tocan sin mover la mano.
@immutable
class ScalePosition {
  /// Crea la posición número [number] (desde 1) con sus [notes].
  const ScalePosition(this.number, this.notes);

  /// Número de la posición (1 = la que empieza en la tónica de la 6ª).
  final int number;

  /// Notas de la posición.
  final Set<FretPosition> notes;

  /// Traste más bajo de la posición.
  int get minFret => notes
      .map((FretPosition p) => p.fret)
      .reduce((int a, int b) => a < b ? a : b);

  /// Traste más alto de la posición.
  int get maxFret => notes
      .map((FretPosition p) => p.fret)
      .reduce((int a, int b) => a > b ? a : b);
}

/// Calcula dónde caen las notas de una escala en la guitarra.
///
/// Cada tipo de escala tiene su forma de partir el mástil:
///
/// - **Pentatónicas** (5 notas): 5 cajas de dos notas por cuerda.
/// - **Heptatónicas** (7 notas): 7 posiciones de tres notas por cuerda.
/// - **Blues, hexatónicas y bebop**: las cajas de su escala base más las notas
///   de paso que caen dentro (la blue note, la novena, la séptima mayor…).
/// - **Simétricas** (tonos enteros, disminuida, aumentada): una ventana de
///   trastes por cada nota de la escala en la sexta cuerda.
class ScalePositions {
  /// Crea el cálculo para [scale] con tónica [tonic] (0 = Do).
  const ScalePositions(this.scale, this.tonic);

  /// Escala.
  final ScaleType scale;

  /// Tónica como clase de tono.
  final int tonic;

  /// Todas las notas de la escala hasta el traste [maxFret], cuerda a cuerda.
  List<FretPosition> allNotes({int maxFret = kScaleMaxFret}) => <FretPosition>[
    for (int string = 1; string <= 6; string++)
      for (int fret = 0; fret <= maxFret; fret++)
        if (scale.contains(tonic, FretPosition(string, fret).pitchClass))
          FretPosition(string, fret),
  ];

  /// Número de posiciones de la escala.
  int get positionCount => (_boxBase[scale] ?? scale).length;

  /// Las posiciones de la escala, de la tónica hacia arriba del mástil.
  List<ScalePosition> positions() {
    final ScaleType? base = _boxBase[scale];
    if (base != null) {
      return <ScalePosition>[
        for (int i = 0; i < base.length; i++)
          ScalePosition(i + 1, _withExtraNotes(_walk(base, i), base)),
      ];
    }
    return <ScalePosition>[
      for (int i = 0; i < scale.length; i++)
        ScalePosition(i + 1, _usesBoxes(scale) ? _walk(scale, i) : _window(i)),
    ];
  }

  /// `true` si la escala se reparte en cajas de 2 o 3 notas por cuerda.
  bool _usesBoxes(ScaleType type) => type.length == 5 || type.length == 7;

  /// Recorre la escala desde su grado [startDegree] en la 6ª cuerda.
  Set<FretPosition> _walk(ScaleType base, int startDegree) {
    final int perString = base.length <= 5 ? 2 : 3;
    final List<int> pcs = base.pitchClasses(tonic);
    final int rootFret = (pcs[startDegree] - 4 + 12) % 12;
    int pitch = _openPitch[6]! + rootFret;
    int degree = startDegree;
    final List<FretPosition> notes = <FretPosition>[];
    for (int string = 6; string >= 1; string--) {
      for (int n = 0; n < perString; n++) {
        notes.add(FretPosition(string, pitch - _openPitch[string]!));
        final int next = (degree + 1) % base.length;
        pitch += (base.intervals[next] - base.intervals[degree] + 12) % 12;
        degree = next;
      }
    }
    return _normalize(notes);
  }

  /// Todas las notas de la escala dentro de una ventana de trastes que
  /// empieza en la nota [startDegree] de la 6ª cuerda.
  Set<FretPosition> _window(int startDegree) {
    final int first = (scale.pitchClasses(tonic)[startDegree] - 4 + 12) % 12;
    final int span = scale.length >= 8 ? 4 : 3;
    return <FretPosition>{
      for (int string = 1; string <= 6; string++)
        for (int fret = first; fret <= first + span; fret++)
          if (scale.contains(tonic, FretPosition(string, fret).pitchClass))
            FretPosition(string, fret),
    };
  }

  /// Sube o baja una octava la caja para que quede dentro del mástil.
  Set<FretPosition> _normalize(List<FretPosition> notes) {
    final int lowest = notes
        .map((FretPosition p) => p.fret)
        .reduce((int a, int b) => a < b ? a : b);
    final int shift = lowest < 0 ? 12 : (lowest >= 12 ? -12 : 0);
    return <FretPosition>{
      for (final FretPosition p in notes)
        FretPosition(p.stringNumber, p.fret + shift),
    };
  }

  /// Añade las notas que la escala tiene de más sobre su [base] dentro del
  /// tramo de cada cuerda de la caja (blue note, novena, séptima de paso…).
  Set<FretPosition> _withExtraNotes(Set<FretPosition> box, ScaleType base) {
    final Set<int> extras = <int>{
      for (final int interval in scale.intervals)
        if (!base.intervals.contains(interval)) (tonic + interval) % 12,
    };
    final Set<FretPosition> result = <FretPosition>{...box};
    for (int string = 1; string <= 6; string++) {
      final List<int> frets = <int>[
        for (final FretPosition p in box)
          if (p.stringNumber == string) p.fret,
      ];
      if (frets.isEmpty) {
        continue;
      }
      frets.sort();
      for (int fret = frets.first - 1; fret <= frets.last + 1; fret++) {
        if (fret >= 0 &&
            extras.contains(FretPosition(string, fret).pitchClass)) {
          result.add(FretPosition(string, fret));
        }
      }
    }
    return result;
  }
}
