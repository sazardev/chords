import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:meta/meta.dart';

/// Un acorde escrito como cifra (`G`, `Em`, `Bb7`), independiente del banco.
///
/// Sirve para las progresiones y el cancionero: se transporta sumando
/// semitonos y se traduce al identificador del banco (`A#-7`), que usa
/// siempre sostenidos.
@immutable
class ChordSymbol {
  /// Crea la cifra a partir de su raíz (0 = Do) y su calidad.
  const ChordSymbol(this.root, this.quality);

  /// Interpreta una cifra; lanza [FormatException] si no es válida.
  factory ChordSymbol.parse(String text) =>
      tryParse(text) ?? (throw FormatException('cifra no válida', text));

  /// Raíz como clase de tono (0-11).
  final int root;

  /// Calidad del acorde.
  final ChordQuality quality;

  /// Sufijos admitidos de mayor a menor longitud (`maj7` antes que `m`).
  static const List<(String, ChordQuality)> _suffixes =
      <(String, ChordQuality)>[
        ('maj7', ChordQuality.majorSeven),
        ('sus4', ChordQuality.suspendedFourth),
        ('sus2', ChordQuality.suspendedSecond),
        ('dim', ChordQuality.diminished),
        ('aug', ChordQuality.augmented),
        ('m7', ChordQuality.minorSeven),
        ('m6', ChordQuality.minorSixth),
        ('7', ChordQuality.seven),
        ('9', ChordQuality.ninth),
        ('6', ChordQuality.sixth),
        ('5', ChordQuality.power),
        ('m', ChordQuality.minor),
        ('', ChordQuality.major),
      ];

  /// Interpreta una cifra como `F#m7` o `Bb`; `null` si no es válida.
  static ChordSymbol? tryParse(String text) {
    final RegExpMatch? match = RegExp(r'^([A-G])([#b]?)(.*)$')
        .firstMatch(text.trim());
    if (match == null) {
      return null;
    }
    int root = pitchClassOfNote(match.group(1)!);
    root += switch (match.group(2)) {
      '#' => 1,
      'b' => -1,
      _ => 0,
    };
    final String suffix = match.group(3)!;
    for (final (String text, ChordQuality quality) in _suffixes) {
      if (text == suffix) {
        return ChordSymbol(root % 12, quality);
      }
    }
    return null;
  }

  /// Identificador del acorde en el banco (`A#-m7`).
  String get chordId => '${noteNameOfPitchClass(root)}-${quality.id}';

  /// Nombre estándar con sostenidos (`A#m7`).
  String get name => '${noteNameOfPitchClass(root)}${quality.suffix}';

  /// Clases de tono que suenan en el acorde.
  Set<int> get pitchClasses => <int>{
    for (final int interval in quality.intervals) (root + interval) % 12,
  };

  /// La misma cifra [semitones] semitonos más arriba (o abajo si es negativo).
  ChordSymbol transpose(int semitones) =>
      ChordSymbol((root + semitones) % 12, quality);

  @override
  bool operator ==(Object other) =>
      other is ChordSymbol && other.root == root && other.quality == quality;

  @override
  int get hashCode => Object.hash(root, quality);

  @override
  String toString() => name;
}
