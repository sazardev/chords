import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:meta/meta.dart';

/// Un acorde escrito como grado de la tonalidad (`I`, `vi`, `V7`, `bVII`).
///
/// Las mayúsculas son acordes mayores y las minúsculas menores; el sufijo
/// cambia la calidad (`7`, `maj7`, `5`, `sus4`, `°`…). Una alteración previa
/// (`b` o `#`) mueve el grado un semitono, como el `bVII` del rock.
@immutable
class RomanChord {
  /// Crea el grado a partir de su distancia a la tónica y su calidad.
  const RomanChord(this.offset, this.quality, this.label);

  /// Interpreta un grado como `bVII7`; lanza [FormatException] si no vale.
  factory RomanChord.parse(String text) {
    String rest = text.trim();
    int shift = 0;
    if (rest.startsWith('b') || rest.startsWith('#')) {
      shift = rest.startsWith('b') ? -1 : 1;
      rest = rest.substring(1);
    }
    for (final String numeral in _numerals) {
      final bool upper = rest.startsWith(numeral);
      if (upper || rest.startsWith(numeral.toLowerCase())) {
        final ChordQuality? quality = _quality(
          rest.substring(numeral.length),
          minor: !upper,
        );
        if (quality != null) {
          return RomanChord((_offsets[numeral]! + shift) % 12, quality, text);
        }
      }
    }
    throw FormatException('grado no válido', text);
  }

  /// Semitonos desde la tónica (0-11).
  final int offset;

  /// Calidad del acorde.
  final ChordQuality quality;

  /// Cómo se escribe (`bVII`).
  final String label;

  static const List<String> _numerals = <String>[
    'VII',
    'III',
    'IV',
    'VI',
    'II',
    'V',
    'I',
  ];

  static const Map<String, int> _offsets = <String, int>{
    'I': 0,
    'II': 2,
    'III': 4,
    'IV': 5,
    'V': 7,
    'VI': 9,
    'VII': 11,
  };

  static ChordQuality? _quality(String suffix, {required bool minor}) =>
      switch (suffix) {
        '' => minor ? ChordQuality.minor : ChordQuality.major,
        '7' => minor ? ChordQuality.minorSeven : ChordQuality.seven,
        '6' => minor ? ChordQuality.minorSixth : ChordQuality.sixth,
        '°' || 'dim' => ChordQuality.diminished,
        '+' || 'aug' => ChordQuality.augmented,
        _ => _extended(suffix),
      };

  static ChordQuality? _extended(String suffix) => switch (suffix) {
    'maj7' => ChordQuality.majorSeven,
    '5' => ChordQuality.power,
    'sus4' => ChordQuality.suspendedFourth,
    'sus2' => ChordQuality.suspendedSecond,
    '9' => ChordQuality.ninth,
    _ => null,
  };

  /// La cifra concreta en la tonalidad de [tonic] (0 = Do).
  ChordSymbol inKey(int tonic) => ChordSymbol((tonic + offset) % 12, quality);

  @override
  bool operator ==(Object other) =>
      other is RomanChord && other.offset == offset && other.quality == quality;

  @override
  int get hashCode => Object.hash(offset, quality);

  @override
  String toString() => label;
}
