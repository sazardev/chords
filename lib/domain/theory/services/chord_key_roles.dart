import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/scale_harmony.dart';

/// El papel de un acorde dentro de una tonalidad: qué grado es.
class ChordKeyRole {
  /// Crea el papel.
  const ChordKeyRole({
    required this.tonic,
    required this.scale,
    required this.roman,
    required this.degree,
  });

  /// Tónica de la tonalidad (0 = Do).
  final int tonic;

  /// Escala de la tonalidad (mayor, menor natural, armónica o melódica).
  final ScaleType scale;

  /// Grado en romanos con su cifrado (`IVmaj7`, `V7`, `ii7`).
  final String roman;

  /// Número de grado (1-7).
  final int degree;
}

/// Escalas cuya armonía se considera una tonalidad.
const List<ScaleType> kKeyScales = <ScaleType>[
  ScaleType.major,
  ScaleType.naturalMinor,
  ScaleType.harmonicMinor,
  ScaleType.melodicMinor,
];

/// Tonalidades en las que [chord] es un acorde de la armonía (como tríada si
/// tiene tres notas y como cuatriada si tiene cuatro), de las más comunes a
/// las menos: primero la mayor, luego la menor natural y después las menores
/// con séptima o sexta alteradas.
List<ChordKeyRole> keyRolesOf(ChordSymbol chord) {
  final bool triad = chord.quality.intervals.length == 3;
  final List<ChordKeyRole> roles = <ChordKeyRole>[];
  for (final ScaleType scale in kKeyScales) {
    for (int tonic = 0; tonic < 12; tonic++) {
      final List<DiatonicChord> harmony = ScaleHarmony(
        scale,
        tonic,
      ).chords(sevenths: !triad);
      for (final DiatonicChord candidate in harmony) {
        // La menor armónica repite casi todos los acordes de la natural: solo
        // cuenta el primero de cada tonalidad y grado.
        final bool repeated = roles.any(
          (ChordKeyRole r) =>
              r.tonic == tonic &&
              r.degree == candidate.degree &&
              r.roman == candidate.roman &&
              r.scale.isMinor == scale.isMinor,
        );
        if (candidate.symbol == chord && !repeated) {
          roles.add(
            ChordKeyRole(
              tonic: tonic,
              scale: scale,
              roman: candidate.roman,
              degree: candidate.degree,
            ),
          );
        }
      }
    }
  }
  return roles;
}
