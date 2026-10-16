import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';

/// Tipo de error de un diagrama.
enum VoicingError {
  /// Una nota que no pertenece al acorde.
  alienNote,

  /// Una cuerda que debía ir muteada suena al aire.
  unmutedString,

  /// Falta una de las notas que definen el acorde.
  missingNote,
}

/// Un diagrama con un error, listo para mostrarlo entre los correctos.
class FlawedVoicing {
  /// Crea el diagrama con error.
  const FlawedVoicing({
    required this.frets,
    required this.error,
    required this.stringNumber,
    required this.pitchClass,
  });

  /// Trastes por cuerda (índice 0 = sexta) con el error ya aplicado.
  final List<int> frets;

  /// Qué error tiene.
  final VoicingError error;

  /// Cuerda (1-6) donde está el error; `null` si falta una nota.
  final int? stringNumber;

  /// Nota del error: la ajena, la que suena de más o la que falta.
  final int pitchClass;
}

/// Notas que definen el acorde: las que el banco no marca como opcionales
/// (casi siempre la quinta; en los extendidos también la novena o la oncena).
Set<int> requiredTones(Chord chord) => <int>{
  for (final int interval in chord.quality.requiredIntervals)
    (chord.root.pitchClass + interval) % 12,
};

/// `true` si [frets] suena solo notas del acorde y todas las que lo definen.
///
/// Es el criterio del validador del banco: no pide la raíz en el bajo ni la
/// 6ª cuerda, porque hay tríadas en cuerdas agudas, shells y drops.
bool isValidVoicing(Chord chord, List<int> frets) {
  final Set<int> sounding = soundingPitchClasses(frets).toSet();
  return sounding.difference(pitchClassesOfChord(chord)).isEmpty &&
      requiredTones(chord).difference(sounding).isEmpty;
}

/// Estropea [variant] con un error que un guitarrista reconocería.
///
/// Prueba los tres tipos de error en orden aleatorio y devuelve el primero
/// que de verdad deja de ser un acorde válido; `null` si ninguno vale.
FlawedVoicing? flawVoicing(
  math.Random random,
  Chord chord,
  ChordVariant variant,
) {
  final List<FlawedVoicing? Function()> attempts = <FlawedVoicing? Function()>[
    () => _alienNote(random, chord, variant.frets),
    () => _unmuted(random, chord, variant.frets),
    () => _missingNote(random, chord, variant.frets),
  ]..shuffle(random);
  for (final FlawedVoicing? Function() attempt in attempts) {
    final FlawedVoicing? flawed = attempt();
    if (flawed != null && !isValidVoicing(chord, flawed.frets)) {
      return flawed;
    }
  }
  return null;
}

FlawedVoicing? _alienNote(math.Random random, Chord chord, List<int> frets) {
  final Set<int> tones = pitchClassesOfChord(chord);
  final List<int> strings = soundingStrings(frets)
    ..shuffle(random)
    ..sort((int a, int b) => (frets[b] > 0 ? 1 : 0) - (frets[a] > 0 ? 1 : 0));
  for (final int s in strings) {
    final List<int> deltas = <int>[-2, -1, 1, 2]..shuffle(random);
    for (final int delta in deltas) {
      final int fret = frets[s] + delta;
      if (fret < 0 || fret > 15) {
        continue;
      }
      final int pitchClass = pitchClassAtString(s, fret);
      if (!tones.contains(pitchClass)) {
        return FlawedVoicing(
          frets: <int>[...frets]..[s] = fret,
          error: VoicingError.alienNote,
          stringNumber: 6 - s,
          pitchClass: pitchClass,
        );
      }
    }
  }
  return null;
}

FlawedVoicing? _unmuted(math.Random random, Chord chord, List<int> frets) {
  final Set<int> tones = pitchClassesOfChord(chord);
  final List<int> muted = <int>[
    for (int s = 0; s < frets.length; s++)
      if (frets[s] < 0 && !tones.contains(pitchClassAtString(s, 0))) s,
  ]..shuffle(random);
  if (muted.isEmpty) {
    return null;
  }
  final int s = muted.first;
  return FlawedVoicing(
    frets: <int>[...frets]..[s] = 0,
    error: VoicingError.unmutedString,
    stringNumber: 6 - s,
    pitchClass: pitchClassAtString(s, 0),
  );
}

FlawedVoicing? _missingNote(math.Random random, Chord chord, List<int> frets) {
  final List<int> strings = soundingStrings(frets)..shuffle(random);
  for (final int s in strings) {
    final List<int> muted = <int>[...frets]..[s] = -1;
    final Set<int> missing = requiredTones(chord)
        .difference(soundingPitchClasses(muted).toSet());
    if (missing.isNotEmpty && soundingStrings(muted).length >= 3) {
      return FlawedVoicing(
        frets: muted,
        error: VoicingError.missingNote,
        stringNumber: null,
        pitchClass: missing.first,
      );
    }
  }
  return null;
}
