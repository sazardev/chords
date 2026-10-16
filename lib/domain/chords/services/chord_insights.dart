import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_tone.dart';
import 'package:chords/domain/chords/services/chord_relatives.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/chord_key_roles.dart';
import 'package:chords/domain/theory/services/chord_progression_usage.dart';
import 'package:chords/domain/theory/services/chord_scale_suggestions.dart';
import 'package:meta/meta.dart';

/// Lo que la ficha cuenta de un acorde además de sus posiciones:
/// notas y grados, parientes, tonalidades, progresiones y escalas.
@immutable
class ChordInsights {
  const ChordInsights._({
    required this.tones,
    required this.relatives,
    required this.relative,
    required this.keyRoles,
    required this.progressions,
    required this.scales,
  });

  /// Calcula la información de [chord] con el banco [bank] para los parientes.
  factory ChordInsights.of(Chord chord, List<Chord> bank) {
    final ChordSymbol symbol = ChordSymbol(
      chord.root.pitchClass,
      chord.quality,
    );
    final ChordRelatives finder = ChordRelatives(bank);
    return ChordInsights._(
      tones: chordTones(chord.root, chord.quality),
      relatives: finder.sameRoot(chord),
      relative: finder.relative(chord),
      keyRoles: keyRolesOf(symbol),
      progressions: progressionsWith(symbol),
      scales: scalesForQuality(chord.quality),
    );
  }

  /// Notas del acorde con su grado, de la raíz hacia arriba.
  final List<ChordTone> tones;

  /// Acordes con la misma raíz y otro tipo, los más usados primero.
  final List<Chord> relatives;

  /// Relativa menor (de un mayor) o mayor (de un menor), si procede.
  final Chord? relative;

  /// Tonalidades en las que es un acorde de la armonía.
  final List<ChordKeyRole> keyRoles;

  /// Progresiones del catálogo que lo incluyen.
  final List<ProgressionUse> progressions;

  /// Escalas para improvisar encima, la mejor primero.
  final List<ScaleType> scales;
}
