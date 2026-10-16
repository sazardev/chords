/// Nombres de notas y de acordes en el idioma activo de la interfaz.
library;

import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:flutter/widgets.dart';

/// Nombre de la nota [pitchClass] (0 = Do): solfeo en español y letras (C, D…)
/// en los demás idiomas.
String noteLabel(BuildContext context, int pitchClass) {
  final ChordRoot root = ChordRoot.values[pitchClass % 12];
  return TranslationProvider.of(context).locale == AppLocale.es
      ? root.displayName
      : root.name;
}

/// Nombre largo de un acorde reconocido (p. ej. `Do Séptima menor`).
String chordLongName(BuildContext context, ChordCandidate chord) {
  final Translations t = context.t;
  return '${noteLabel(context, chord.root.pitchClass)} '
      '${qualityLabel(t, chord.quality)}';
}
