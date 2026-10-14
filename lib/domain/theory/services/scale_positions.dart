/// Escalas sobre el mástil: todas sus notas y sus posiciones (cajas).
library;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:meta/meta.dart';

/// Último traste que dibuja el explorador de escalas.
const int kScaleMaxFret = 15;

/// Altura (semitonos desde el Do0) de cada cuerda al aire, de la 1ª a la 6ª.
const Map<int, int> _openPitch = <int, int>{
  1: 64,
  2: 59,
  3: 55,
  4: 50,
  5: 45,
  6: 40,
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

  /// Las posiciones de la escala, de la tónica hacia arriba del mástil.
  ///
  /// Las pentatónicas dan sus cinco cajas clásicas (dos notas por cuerda) y
  /// las de siete notas, siete posiciones de tres notas por cuerda. La escala
  /// de blues usa las cajas de la pentatónica menor más la *blue note*.
  List<ScalePosition> positions() {
    final ScaleType base = scale == ScaleType.blues
        ? ScaleType.minorPentatonic
        : scale;
    return <ScalePosition>[
      for (int i = 0; i < base.length; i++)
        ScalePosition(i + 1, _withBlueNotes(_walk(base, i))),
    ];
  }

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

  /// Añade la quinta disminuida dentro del tramo de cada cuerda (blues).
  Set<FretPosition> _withBlueNotes(Set<FretPosition> box) {
    if (scale != ScaleType.blues) {
      return box;
    }
    final int blue = (tonic + 6) % 12;
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
        if (fret >= 0 && FretPosition(string, fret).pitchClass == blue) {
          result.add(FretPosition(string, fret));
        }
      }
    }
    return result;
  }
}
