import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

/// Plantilla de un acorde: qué peso tiene cada una de las 12 notas.
///
/// La raíz y las notas que definen la calidad (tercera, séptima, sus…) pesan
/// 1. La quinta es la nota que menos define el acorde y la que más se omite
/// al tocarlo, así que en acordes de cuatro o más notas pesa menos y no es
/// obligatoria; en un power chord, donde es la única nota además de la raíz,
/// sí lo es.
class ChordTemplate {
  /// Construye la plantilla de [root] con la [quality] indicada.
  ChordTemplate(this.root, this.quality) : weights = Float64List(12) {
    final Set<int> classes = <int>{
      for (final int interval in quality.intervals) interval % 12,
    };
    final bool fifthOptional = classes.length >= 4;
    for (final int interval in classes) {
      final bool isFifth = interval == 7;
      final int pitchClass = (root.pitchClass + interval) % 12;
      weights[pitchClass] = isFifth && fifthOptional ? _fifthWeight : 1;
      if (!(isFifth && fifthOptional)) {
        mandatory.add(pitchClass);
      }
      notes.add(pitchClass);
    }
    double squares = 0;
    for (final double weight in weights) {
      squares += weight * weight;
    }
    norm = math.sqrt(squares);
  }

  /// Peso de la quinta cuando el acorde es de cuatro notas o más.
  static const double _fifthWeight = 0.5;

  /// Raíz del acorde.
  final ChordRoot root;

  /// Calidad del acorde.
  final ChordQuality quality;

  /// Peso de cada nota (índice 0 = Do); 0 si no pertenece al acorde.
  final Float64List weights;

  /// Notas que el acorde debe tener para ser creíble.
  final List<int> mandatory = <int>[];

  /// Todas las notas del acorde.
  final List<int> notes = <int>[];

  /// Norma euclídea de [weights].
  late final double norm;

  /// Nota (0-11) de la raíz.
  int get rootPitchClass => root.pitchClass;

  /// `true` si [pitchClass] pertenece al acorde.
  bool contains(int pitchClass) => weights[pitchClass] > 0;
}
