import 'package:chords/domain/chords/entities/fretted_notes.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

/// Etiquetas descriptivas de una posición, deducidas de lo que ya se sabe de
/// ella (identificador, trastes y cejillo), en lugar de guardarlas.
///
/// - `open`: cuerdas al aire cerca de la cejuela y sin cejillo.
/// - `barre`: el índice cubre dos o más cuerdas.
/// - `movable`: sin cuerdas al aire; se desliza por el mástil.
/// - `high-position`: el traste más bajo pulsado es el 7 o más.
/// - `triad`, `shell`, `voicing`, `drop2`, `drop3`: cómo se construyó.
/// - `inversion`: el bajo no es la raíz.
/// - `upper`: solo suenan las cuerdas agudas (de la 3ª para arriba).
List<String> variantTags({
  required VariantIdentity identity,
  required int rootPitchClass,
  required List<int> frets,
  required bool hasBarre,
}) {
  final List<int> sounding = soundingStrings(frets);
  final List<int> pressed = <int>[
    for (final int fret in frets)
      if (fret > 0) fret,
  ];
  final int lowest = pressed.isEmpty
      ? 0
      : pressed.reduce((int a, int b) => a < b ? a : b);
  final bool hasOpen = frets.any((int f) => f == 0);
  final bool inversion =
      sounding.isNotEmpty &&
      pitchClassOfFret(sounding.first, frets[sounding.first]) != rootPitchClass;
  return <String>[
    ..._kindTags(identity.kind),
    if (inversion) 'inversion',
    if (sounding.isNotEmpty && sounding.first >= 3) 'upper',
    if (!hasBarre && hasOpen && lowest <= 4) 'open',
    if (hasBarre) 'barre',
    if (!hasOpen) 'movable',
    if (lowest >= 7) 'high-position',
  ];
}

List<String> _kindTags(VariantKind kind) => switch (kind) {
  VariantKind.shape => const <String>[],
  VariantKind.triad => const <String>['triad'],
  VariantKind.shell => const <String>['shell'],
  VariantKind.voicing => const <String>['voicing'],
  VariantKind.drop2 => const <String>['voicing', 'drop2'],
  VariantKind.drop3 => const <String>['voicing', 'drop3'],
};
