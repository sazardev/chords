import 'package:chords/domain/chords/entities/chord_inversion.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/fretted_notes.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

/// Etiqueta en español de una posición (`Forma de Mi · traste 3`,
/// `Drop 2 · cuerdas 4-3-2-1 · 1ª inversión`).
///
/// El banco solo guarda el nombre de cada forma del catálogo
/// ([shapeLabels]); el resto se compone con lo que dicen el identificador y
/// los trastes.
String variantLabel({
  required VariantIdentity identity,
  required ChordQuality quality,
  required int rootPitchClass,
  required List<int> frets,
  required Map<String, String> shapeLabels,
}) {
  if (identity.isShape) {
    return _shapeLabel(shapeLabels[identity.key] ?? identity.key, frets);
  }
  final String strings = identity.strings.join('-');
  final String inversion = _inversionText(quality, identity.bassInterval);
  return switch (identity.kind) {
    VariantKind.triad => 'Tríada cuerdas $strings · $inversion',
    VariantKind.shell =>
      'Shell ${shellDegrees(quality, rootPitchClass, frets).join('-')}'
          ' · cuerdas $strings',
    VariantKind.voicing => 'Voicing · cuerdas $strings · $inversion',
    VariantKind.drop2 => 'Drop 2 · cuerdas $strings · $inversion',
    VariantKind.drop3 => 'Drop 3 · cuerdas $strings · $inversion',
    VariantKind.shape => identity.key,
  };
}

/// Grados que suenan de grave a agudo (`1`, `b7`, `3`) en un shell.
List<String> shellDegrees(
  ChordQuality quality,
  int rootPitchClass,
  List<int> frets,
) => <String>[
  for (final int s in soundingStrings(frets))
    degreeOf(quality, pitchClassOfFret(s, frets[s]) - rootPitchClass),
];

/// Nombre de la forma, con el traste si la posición no usa cuerdas al aire.
String _shapeLabel(String base, List<int> frets) {
  if (frets.any((int f) => f == 0)) {
    return base;
  }
  final List<int> pressed = <int>[
    for (final int fret in frets)
      if (fret > 0) fret,
  ];
  if (pressed.isEmpty) {
    return base;
  }
  return '$base · traste ${pressed.reduce((int a, int b) => a < b ? a : b)}';
}

String _inversionText(ChordQuality quality, int bassInterval) =>
    switch (inversionOf(quality, bassInterval)) {
      ChordInversion.root => 'posición fundamental',
      ChordInversion.first => '1ª inversión',
      ChordInversion.second => '2ª inversión',
      ChordInversion.third => '3ª inversión',
      ChordInversion.other => '${degreeOf(quality, bassInterval)} en el bajo',
    };
