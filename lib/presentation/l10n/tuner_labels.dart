/// Etiquetas traducidas del afinador y del modo práctica.
///
/// Convierten los resultados del dominio (zonas, direcciones, consejos) en
/// frases cortas y accionables en el idioma activo.
library;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';

/// Nombre de la nota de una cuerda (p. ej. `Mi` en español, `E` en inglés).
String openNoteName(Translations t, GuitarString string) =>
    switch (string.note) {
      'E' => t.tuner.noteE,
      'A' => t.tuner.noteA,
      'D' => t.tuner.noteD,
      'G' => t.tuner.noteG,
      'B' => t.tuner.noteB,
      _ => string.note,
    };

/// Título completo de una cuerda (p. ej. `6ª cuerda · Mi`).
String stringTitle(Translations t, GuitarString string) => t.tuner.stringTitle(
  ordinal: guitarStringLabel(t, string.number),
  note: openNoteName(t, string),
);

/// Cuerda dicha en corto (p. ej. `6ª cuerda`), para frases con artículo.
String stringShort(Translations t, int number) => t.tuner
    .stringTitle(ordinal: guitarStringLabel(t, number), note: '')
    .replaceAll(RegExp(r'\s*·\s*$'), '');

/// Instrucción principal del afinador para una lectura.
///
/// Devuelve el titular y, si la cuerda no está afinada, qué hacer con la
/// clavija.
({String headline, String? action}) tuningMessage(
  Translations t,
  StringTuningReading reading,
) {
  final bool up = reading.direction == TuneDirection.up;
  switch (reading.zone) {
    case TuningZone.inTune:
      return (headline: t.tuner.tuned, action: t.tuner.holdSteady);
    case TuningZone.near:
      return (
        headline: up ? t.tuner.upLittle : t.tuner.downLittle,
        action: up ? t.tuner.tightenPeg : t.tuner.loosenPeg,
      );
    case TuningZone.off:
      return (
        headline: up ? t.tuner.up : t.tuner.down,
        action: up ? t.tuner.tightenPeg : t.tuner.loosenPeg,
      );
    case TuningZone.far:
      return (
        headline: up ? t.tuner.upALot : t.tuner.downALot,
        action: up ? t.tuner.tightenPeg : t.tuner.loosenPeg,
      );
  }
}

/// Qué dedo mencionar en un consejo: `el dedo 2` o un genérico.
String fingerPhrase(Translations t, int finger) =>
    finger > 0 ? t.practice.fingerThe(n: finger) : t.practice.fingerAny;

/// Texto del consejo de práctica para una cuerda mal tocada.
String practiceTipText(Translations t, PracticeTip tip) {
  final String string = stringShort(t, tip.stringNumber);
  final String finger = fingerPhrase(t, tip.finger);
  return switch (tip.kind) {
    PracticeTipKind.soundsOpen => t.practice.tipSoundsOpen(
      string: string,
      fret: tip.fret,
      finger: finger,
    ),
    PracticeTipKind.moveUp => t.practice.tipMoveUp(
      n: tip.steps,
      finger: finger,
    ),
    PracticeTipKind.moveDown => t.practice.tipMoveDown(
      n: tip.steps,
      finger: finger,
    ),
    PracticeTipKind.tooFlat => t.practice.tipTooFlat(finger: finger),
    PracticeTipKind.tooSharp => t.practice.tipTooSharp,
    PracticeTipKind.retuneUp => t.practice.tipRetuneUp(string: string),
    PracticeTipKind.retuneDown => t.practice.tipRetuneDown(string: string),
    PracticeTipKind.unknown => t.practice.tipUnknown(string: string),
  };
}

/// Frase que dice qué tocar ahora en la práctica.
String practiceNextText(Translations t, PracticeString string) {
  final String name = stringShort(t, string.number);
  if (string.isOpen) {
    return t.practice.nextOpen(string: name);
  }
  if (string.finger <= 0) {
    return t.practice.nextFrettedAny(string: name, fret: string.fret);
  }
  return t.practice.nextFretted(
    string: name,
    fret: string.fret,
    finger: t.practice.fingerThe(n: string.finger),
  );
}

/// Descripción corta de lo que pide una cuerda del acorde.
String practiceStringDetail(Translations t, PracticeString string) {
  if (string.isMuted) {
    return t.practice.muted;
  }
  if (string.isOpen) {
    return t.practice.open;
  }
  final String fret = t.practice.fret(fret: string.fret);
  return string.finger > 0 ? '$fret · ${string.finger}' : fret;
}
