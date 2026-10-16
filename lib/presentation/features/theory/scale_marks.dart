import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/entities/scale_accents.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/scale_positions.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/organisms/scale_fretboard.dart';

/// Marcas del mástil para una escala.
///
/// Con [position] (desde 1) solo resalta esa caja y deja el resto atenuado;
/// con [degrees] etiqueta cada nota con su grado (`b3`) en vez de su nombre.
List<FretMark> scaleMarks(
  Translations t,
  ScaleType scale,
  int tonic, {
  int position = 0,
  bool degrees = false,
  int maxFret = kScaleMaxFret,
}) {
  final ScalePositions map = ScalePositions(scale, tonic);
  final List<ScalePosition> boxes = map.positions();
  final Set<FretPosition>? box = position == 0
      ? null
      : boxes[(position - 1) % boxes.length].notes;
  return <FretMark>[
    for (final FretPosition note in map.allNotes(maxFret: maxFret))
      FretMark(
        note,
        degrees
            ? degreeSymbol(tonic, note.pitchClass, scale: scale)
            : noteLabel(t, note.pitchClass),
        _style(scale, tonic, note, box),
      ),
  ];
}

FretMarkStyle _style(
  ScaleType scale,
  int tonic,
  FretPosition note,
  Set<FretPosition>? box,
) {
  if (box != null && !box.contains(note)) {
    return FretMarkStyle.faded;
  }
  if (note.pitchClass == tonic) {
    return FretMarkStyle.root;
  }
  final int interval = (note.pitchClass - tonic) % 12;
  return kScaleAccents[scale] == interval
      ? FretMarkStyle.accent
      : FretMarkStyle.scale;
}

/// Tramo de trastes de una posición (para resaltarla); `null` si es todo.
(int, int)? positionWindow(ScaleType scale, int tonic, int position) {
  if (position == 0) {
    return null;
  }
  final List<ScalePosition> boxes = ScalePositions(scale, tonic).positions();
  final ScalePosition box = boxes[(position - 1) % boxes.length];
  return (box.minFret, box.maxFret);
}
