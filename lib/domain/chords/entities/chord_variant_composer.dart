import 'package:chords/domain/chords/entities/barre_info.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/fretted_notes.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:chords/domain/chords/entities/variant_label.dart';
import 'package:chords/domain/chords/entities/variant_tags.dart';

/// Compone una posición completa a partir de lo mínimo que guarda el banco:
/// identificador, trastes, dedos, dificultad y cejillo.
///
/// Las notas, las etiquetas y el nombre se deducen aquí, de modo que la app y
/// el generador del banco coinciden siempre.
ChordVariant composeVariant({
  required String chordId,
  required ChordRoot root,
  required ChordQuality quality,
  required String id,
  required List<int> frets,
  required List<int> fingers,
  required int difficulty,
  required Map<String, String> shapeLabels,
  BarreInfo? barre,
}) {
  final VariantIdentity identity = VariantIdentity.parse(id);
  return ChordVariant(
    id: '$chordId-$id',
    positionLabel: variantLabel(
      identity: identity,
      quality: quality,
      rootPitchClass: root.pitchClass,
      frets: frets,
      shapeLabels: shapeLabels,
    ),
    frets: frets,
    fingers: fingers,
    difficulty: Difficulty.fromLevel(difficulty) ?? Difficulty.medium,
    barre: barre,
    kind: identity.kind,
    notes: noteNamesOfFrets(frets),
    tags: variantTags(
      identity: identity,
      rootPitchClass: root.pitchClass,
      frets: frets,
      hasBarre: barre != null,
    ),
  );
}
