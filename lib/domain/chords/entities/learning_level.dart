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
  factory LearningLevel.of(Chord chord) => _resolve(chord);

  static LearningLevel _resolve(Chord chord) {
    final int level = chord.difficulty.level;
    final ChordQuality quality = chord.quality;
    if (level <= 1 && _isBasic(quality)) {
      return LearningLevel.first;
    }
    if (level <= 2 && _isEasy(quality)) {
      return LearningLevel.second;
    }
    if (level == 3) {
      return LearningLevel.third;
    }
    return _isColor(quality) ? LearningLevel.fourth : LearningLevel.fifth;
  }

  static bool _isBasic(ChordQuality quality) =>
      quality == ChordQuality.major || quality == ChordQuality.minor;

  static bool _isEasy(ChordQuality quality) =>
      quality == ChordQuality.seven || quality == ChordQuality.power;

  static bool _isColor(ChordQuality quality) => switch (quality) {
    ChordQuality.minorSeven ||
    ChordQuality.majorSeven ||
    ChordQuality.suspendedSecond ||
    ChordQuality.suspendedFourth ||
    ChordQuality.sixth => true,
    _ => false,
  };

  /// Número de nivel (1-5).
  final int level;

  /// Título visible.
  final String title;

  /// Objetivo pedagógico.
  final String goal;

  /// Emoji decorativo.
  final String emoji;
}
