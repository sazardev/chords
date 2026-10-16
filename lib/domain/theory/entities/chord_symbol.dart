import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/theory/entities/chord_suffixes.dart';
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
    final ChordQuality? quality = qualityOfSuffix(match.group(3)!);
    return quality == null ? null : ChordSymbol(root % 12, quality);
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
