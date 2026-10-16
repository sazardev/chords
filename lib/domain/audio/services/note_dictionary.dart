import 'dart:math' as math;
import 'dart:typed_data';

/// Diccionario de notas de guitarra: qué picos produce cada nota al sonar.
///
/// El eje es logarítmico: [binsPerSemitone] casillas por semitono desde la
/// nota MIDI [firstBinMidi]. Cada nota (de [lowestMidi] a [highestMidi])
/// suena con sus [harmonics] primeros armónicos, cuya fuerza cae por un
/// factor [decay] en cada orden, y se coloca en su posición real (el 5.º
/// armónico queda 14 cents bajo la tercera mayor temperada, y el 7.º unos
/// 31 bajo la séptima menor), repartida linealmente entre dos casillas.
///
/// Cada nota tiene varias columnas, una por forma de timbre ([shapes]): una
/// guitarra brillante, una apagada y una con la fundamental débil no
/// reparten igual su energía entre armónicos, y dejar elegir la forma a la
/// regresión evita que lo que no encaja se explique con notas inventadas.
///
/// La fundamental de una cuerda grave es muy débil en un móvil (y en la
/// propia guitarra), pero sus armónicos 2 a 10 forman una serie reconocible:
/// el diccionario permite explicarla aunque falte el primero.
class NoteDictionary {
  /// Crea el diccionario con los parámetros indicados.
  NoteDictionary({
    this.lowestMidi = 40,
    this.highestMidi = 88,
    this.firstBinMidi = 36,
    this.lastBinMidi = 97,
    this.binsPerSemitone = 3,
    this.harmonics = 12,
    this.shapes = kDefaultShapes,
  }) : noteCount = highestMidi - lowestMidi + 1,
       binCount = (lastBinMidi - firstBinMidi) * binsPerSemitone + 1,
       stride = harmonics * 2,
       columnCount = (highestMidi - lowestMidi + 1) * shapes.length {
    bins = Int32List(columnCount * stride);
    weights = Float64List(columnCount * stride);
    for (int column = 0; column < columnCount; column++) {
      final HarmonicShape shape = shapes[column % shapes.length];
      if (lowestMidi + noteOfColumn(column) > shape.highestMidi) {
        continue;
      }
      for (int h = 1; h <= harmonics; h++) {
        final double weight = math.pow(shape.decay, h - 1).toDouble();
        _place(column, h, h == 1 ? weight * shape.fundamental : weight);
      }
    }
  }

  /// Formas de timbre por defecto: brillante, apagada y de fundamental débil.
  static const List<HarmonicShape> kDefaultShapes = <HarmonicShape>[
    HarmonicShape(decay: 0.9, fundamental: 1),
    HarmonicShape(decay: 0.75, fundamental: 1),
    HarmonicShape(decay: 0.9, fundamental: 0.25, highestMidi: 49),
  ];

  /// Nota MIDI más grave (40 = Mi 82 Hz, la sexta cuerda al aire).
  final int lowestMidi;

  /// Nota MIDI más aguda.
  final int highestMidi;

  /// Nota MIDI del borde inferior del eje.
  final int firstBinMidi;

  /// Nota MIDI del borde superior del eje.
  final int lastBinMidi;

  /// Casillas por semitono.
  final int binsPerSemitone;

  /// Armónicos que se modelan por nota.
  final int harmonics;

  /// Formas de timbre; cada nota tiene una columna por forma.
  final List<HarmonicShape> shapes;

  /// Número de notas del diccionario.
  final int noteCount;

  /// Número de columnas (notas por formas).
  final int columnCount;

  /// Número de casillas del eje.
  final int binCount;

  /// Entradas por columna (dos casillas por armónico).
  final int stride;

  /// Casilla de cada entrada (`columna * stride + k`).
  late final Int32List bins;

  /// Peso de cada entrada (0 si el armónico queda fuera del eje).
  late final Float64List weights;

  /// Nota (índice desde [lowestMidi]) a la que pertenece una columna.
  int noteOfColumn(int column) => column ~/ shapes.length;

  /// Clase de nota (0 = Do) de la nota número [note] del diccionario.
  int pitchClassOf(int note) => (lowestMidi + note) % 12;

  /// Posición (en casillas, con decimales) de una nota MIDI con decimales.
  double positionOf(double midi) => (midi - firstBinMidi) * binsPerSemitone;

  void _place(int column, int harmonic, double weight) {
    final double midi =
        lowestMidi + noteOfColumn(column) + 12 * math.log(harmonic) / math.ln2;
    final double position = positionOf(midi);
    final int base = column * stride + (harmonic - 1) * 2;
    if (position < 0 || position >= binCount - 1) {
      return;
    }
    final int lower = position.floor();
    final double fraction = position - lower;
    bins[base] = lower;
    weights[base] = weight * (1 - fraction);
    bins[base + 1] = lower + 1;
    weights[base + 1] = weight * fraction;
  }
}

/// Reparto de energía entre armónicos de un timbre de guitarra.
class HarmonicShape {
  /// Crea una forma: cada armónico pesa [decay] veces el anterior y la
  /// fundamental se multiplica además por [fundamental].
  const HarmonicShape({
    required this.decay,
    required this.fundamental,
    this.highestMidi = 127,
  });

  /// Caída de amplitud de un armónico al siguiente (0-1).
  final double decay;

  /// Factor extra de la fundamental (< 1 si suele ser débil).
  final double fundamental;

  /// Nota MIDI más aguda a la que se aplica la forma.
  ///
  /// Solo las cuerdas graves pierden la fundamental (el móvil recorta los
  /// graves). Permitirlo en notas más agudas dejaría explicar un acorde en
  /// posición cerrada como una sola nota grave de la que serían armónicos.
  final int highestMidi;
}
