import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';

/// Inversión de una posición según la nota que lleva el bajo.
enum ChordInversion {
  /// La raíz en el bajo.
  root,

  /// La tercera en el bajo.
  first,

  /// La quinta en el bajo.
  second,

  /// La séptima en el bajo.
  third;

  /// Identificador estable.
  String get id => name;

  /// Resuelve una inversión por su identificador.
  static ChordInversion? fromId(String id) {
    for (final ChordInversion inversion in ChordInversion.values) {
      if (inversion.id == id) {
        return inversion;
      }
    }
    return null;
  }
}

/// Inversión de [variant] como [chord]; `null` si el bajo no es una de las
/// cuatro primeras notas del acorde o el acorde tiene menos de tres notas.
ChordInversion? inversionOf(Chord chord, ChordVariant variant) {
  final int? bass = bassPitchClass(variant);
  final List<int> tones = chordTones(chord.root.pitchClass, chord.quality);
  if (bass == null || tones.length < 3) {
    return null;
  }
  final int index = tones.indexOf(bass);
  return index < 0 || index >= ChordInversion.values.length
      ? null
      : ChordInversion.values[index];
}
