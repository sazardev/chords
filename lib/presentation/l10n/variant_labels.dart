/// Nombre traducido de cada posición de un acorde.
///
/// El banco guarda el nombre de las formas en español (`Forma de Mi menor`) y
/// el resto (`Drop 2 · cuerdas 4-3-2-1 · 1ª inversión`) se deduce del
/// identificador; aquí se presenta todo en el idioma activo.
library;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_inversion.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:chords/domain/chords/entities/variant_label.dart';
import 'package:chords/domain/chords/services/note_name_parser.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';

/// Nombre de [variant] (una posición de [chord]) en el idioma de la interfaz.
String variantTitle(Translations t, Chord chord, ChordVariant variant) {
  final String id = variant.id.substring(chord.id.length + 1);
  final VariantIdentity identity = VariantIdentity.parse(id);
  if (identity.isShape) {
    return _shapeTitle(t, identity.key, variant);
  }
  final String strings = identity.strings.join('-');
  final String inversion = inversionName(
    t,
    inversionOf(chord.quality, identity.bassInterval),
    degree: degreeOf(chord.quality, identity.bassInterval),
  );
  return switch (identity.kind) {
    VariantKind.triad => t.chordTheory.variantTriad(
      strings: strings,
      inversion: inversion,
    ),
    VariantKind.shell => t.chordTheory.variantShell(
      degrees: shellDegrees(
        chord.quality,
        chord.root.pitchClass,
        variant.frets,
      ).join('-'),
      strings: strings,
    ),
    VariantKind.voicing => t.chordTheory.variantVoicing(
      strings: strings,
      inversion: inversion,
    ),
    VariantKind.drop2 => t.chordTheory.variantDrop2(
      strings: strings,
      inversion: inversion,
    ),
    VariantKind.drop3 => t.chordTheory.variantDrop3(
      strings: strings,
      inversion: inversion,
    ),
    VariantKind.shape => variant.positionLabel,
  };
}

/// Nombre de una inversión (`1ª inversión`, `9 en el bajo`).
String inversionName(
  Translations t,
  ChordInversion inversion, {
  required String degree,
}) => switch (inversion) {
  ChordInversion.root => t.chordTheory.inversionRoot,
  ChordInversion.first => t.chordTheory.inversionFirst,
  ChordInversion.second => t.chordTheory.inversionSecond,
  ChordInversion.third => t.chordTheory.inversionThird,
  ChordInversion.other => t.chordTheory.inversionOther(degree: degree),
};

final RegExp _fretSuffix = RegExp(r'^(.*) · traste (\d+)$');
final RegExp _regularShape = RegExp(r'^Forma de (\S+)(.*)$');

String _shapeTitle(Translations t, String key, ChordVariant variant) {
  final RegExpMatch? suffix = _fretSuffix.firstMatch(variant.positionLabel);
  final String base = suffix?.group(1) ?? variant.positionLabel;
  final String name = t.chordTheory.shapeNames[key] ?? _regularName(t, base);
  return suffix == null
      ? name
      : t.chordTheory.fretSuffix(name: name, n: suffix.group(2)!);
}

/// `Forma de Mi menor` → `Forma de Mi menor` / `E minor shape`.
String _regularName(Translations t, String base) {
  final RegExpMatch? match = _regularShape.firstMatch(base);
  final int? pitchClass = match == null
      ? null
      : parseWholeNote(match.group(1)!);
  if (match == null || pitchClass == null) {
    return base;
  }
  final String rest = match
      .group(2)!
      .split(' ')
      .map((String word) => t.chordTheory.shapeWords[word] ?? word)
      .join(' ');
  return t.chordTheory.shapeNameFormat(
    note: noteLabel(t, pitchClass),
    rest: rest,
  );
}
