import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';

/// Nivel de aprendizaje de un acorde.
///
/// Cada nivel agrupa acordes por dificultad y objetivo didáctico: primero los
/// abiertos esenciales, después séptimas fáciles, y así hasta los voicings de
/// jazz.
enum LearningLevel {
  /// Mayores y menores abiertos.
  first(1, 'Primeros acordes', 'Mayores y menores abiertos', '🌱'),

  /// Séptimas fáciles y power chords.
  second(2, 'Séptimas fáciles', 'Séptima de dominante sin cejilla', '🎵'),

  /// Formas con cejilla completo.
  third(3, 'Cejilla', 'Formas movibles completas', '💪'),

  /// Color: m7, maj7, sus2, sus4 y 6.
  fourth(4, 'Color y suspensión', 'm7, maj7, sus2, sus4, 6', '🎨'),

  /// Jazz: 9, dim, aug y posiciones altas.
  fifth(5, 'Jazz y voicings', '9, dim, aug y voicings avanzados', '🎷');

  /// Crea el nivel.
  const LearningLevel(this.level, this.title, this.goal, this.emoji);

  /// Nivel de aprendizaje de un acorde según su dificultad y su calidad.
  factory LearningLevel.of(Chord chord) {
    final bool basic =
        chord.quality == ChordQuality.major ||
        chord.quality == ChordQuality.minor;
    final bool easy =
        chord.quality == ChordQuality.seven ||
        chord.quality == ChordQuality.power;
    final bool color =
        chord.quality == ChordQuality.minorSeven ||
        chord.quality == ChordQuality.majorSeven ||
        chord.quality == ChordQuality.suspendedSecond ||
        chord.quality == ChordQuality.suspendedFourth ||
        chord.quality == ChordQuality.sixth;
    if (basic && chord.difficulty.level <= 1) {
      return LearningLevel.first;
    }
    if (easy && chord.difficulty.level <= 2) {
      return LearningLevel.second;
    }
    if (chord.difficulty.level == 3) {
      return LearningLevel.third;
    }
    if (color) {
      return LearningLevel.fourth;
    }
    return LearningLevel.fifth;
  }

  /// Número de nivel (1-5).
  final int level;

  /// Título visible.
  final String title;

  /// Objetivo pedagógico.
  final String goal;

  /// Emoji decorativo.
  final String emoji;
}
