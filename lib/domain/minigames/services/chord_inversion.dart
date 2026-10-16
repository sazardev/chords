import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_inversion.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';

/// Inversión de [variant] como [chord] según la nota del bajo.
///
/// Usa la misma clasificación que el banco (`inversionOf` de la calidad).
/// Devuelve `null` si el acorde tiene menos de tres notas (un power chord no
/// se invierte) o si el bajo es otra nota (novena, oncena, cuarta…), que no
/// tiene nombre de inversión.
ChordInversion? variantInversion(Chord chord, ChordVariant variant) {
  final int? bass = bassPitchClass(variant);
  if (bass == null || chord.quality.intervals.length < 3) {
    return null;
  }
  final ChordInversion inversion = inversionOf(
    chord.quality,
    (bass - chord.root.pitchClass + 12) % 12,
  );
  return inversion == ChordInversion.other ? null : inversion;
}
