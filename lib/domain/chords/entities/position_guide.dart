import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:meta/meta.dart';

/// Lo que hace un dedo: dónde se coloca y cuántas cuerdas cubre.
@immutable
class FingerStep {
  /// Crea el paso de un dedo.
  const FingerStep({
    required this.finger,
    required this.fret,
    required this.strings,
  });

  /// Dedo: 1 índice, 2 medio, 3 anular, 4 meñique.
  final int finger;

  /// Traste donde se coloca.
  final int fret;

  /// Números de cuerda que pisa, de la más grave (6) a la más aguda (1).
  final List<int> strings;

  /// Si el dedo se tiende sobre varias cuerdas (cejillo).
  bool get isBarre => strings.length > 1;
}

/// Explicación paso a paso de cómo colocar una posición de acorde.
///
/// Se deduce de los trastes y los dedos de la posición: qué dedo va en cada
/// traste y cuerda, qué cuerdas suenan al aire y cuáles no se tocan. Los
/// números de cuerda van de 6 (la más grave) a 1 (la más aguda).
@immutable
class PositionGuide {
  const PositionGuide._({
    required this.steps,
    required this.played,
    required this.open,
    required this.muted,
    required this.firstFret,
    required this.lastFret,
  });

  /// Deduce la guía de [variant].
  factory PositionGuide.of(ChordVariant variant) {
    final List<int> frets = variant.frets;
    final Map<int, List<int>> byFinger = <int, List<int>>{};
    for (int s = 0; s < frets.length; s++) {
      final int finger = variant.fingers[s];
      if (frets[s] > 0 && finger > 0) {
        byFinger.putIfAbsent(finger, () => <int>[]).add(frets.length - s);
      }
    }
    final List<int> pressed = <int>[
      for (final int fret in frets)
        if (fret > 0) fret,
    ]..sort();
    return PositionGuide._(
      steps: <FingerStep>[
        for (final int finger in byFinger.keys.toList()..sort())
          FingerStep(
            finger: finger,
            fret: frets[frets.length - byFinger[finger]!.first],
            strings: byFinger[finger]!,
          ),
      ],
      played: _stringsWhere(frets, (int fret) => fret >= 0),
      open: _stringsWhere(frets, (int fret) => fret == 0),
      muted: _stringsWhere(frets, (int fret) => fret < 0),
      firstFret: pressed.isEmpty ? 0 : pressed.first,
      lastFret: pressed.isEmpty ? 0 : pressed.last,
    );
  }

  /// Un paso por dedo, del índice al meñique.
  final List<FingerStep> steps;

  /// Cuerdas que suenan (al aire o pisadas), de la 6 a la 1.
  final List<int> played;

  /// Cuerdas que suenan al aire.
  final List<int> open;

  /// Cuerdas que no se tocan.
  final List<int> muted;

  /// Traste más bajo que se pisa (0 si todo es al aire).
  final int firstFret;

  /// Traste más alto que se pisa.
  final int lastFret;

  /// Si es una posición abierta: cuerdas al aire y todo junto a la cejuela.
  bool get isOpenPosition => open.isNotEmpty && lastFret <= 4;

  static List<int> _stringsWhere(List<int> frets, bool Function(int) test) =>
      <int>[
        for (int s = 0; s < frets.length; s++)
          if (test(frets[s])) frets.length - s,
      ];
}
