import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:meta/meta.dart';

/// Una progresión de acordes escrita en grados, lista para cualquier tono.
///
/// Cada elemento de [bars] es un compás; un compás con dos grados separados
/// por un espacio (`'V IV'`) se reparte a medias.
@immutable
class ChordProgression {
  /// Crea la progresión.
  const ChordProgression({
    required this.id,
    required this.genre,
    required this.bars,
    required this.tonic,
    required this.bpm,
    required this.strum,
    required this.scale,
    this.minor = false,
  });

  /// Identificador estable (rutas y traducciones).
  final String id;

  /// Género al que pertenece (identificador de `GenreGuide`).
  final String genre;

  /// Compases en grados.
  final List<String> bars;

  /// Tónica por defecto (0 = Do).
  final int tonic;

  /// `true` si la tónica es menor.
  final bool minor;

  /// Tempo recomendado en pulsos por minuto.
  final int bpm;

  /// Rasgueo recomendado.
  final StrumPattern strum;

  /// Escala recomendada para improvisar encima.
  final ScaleType scale;

  /// Los grados de cada compás.
  List<List<RomanChord>> get romanBars => <List<RomanChord>>[
    for (final String bar in bars)
      <RomanChord>[
        for (final String token in bar.split(' ')) RomanChord.parse(token),
      ],
  ];

  /// Los acordes concretos de cada compás con tónica [key].
  List<List<ChordSymbol>> barsIn(int key) => <List<ChordSymbol>>[
    for (final List<RomanChord> bar in romanBars)
      <ChordSymbol>[for (final RomanChord chord in bar) chord.inKey(key)],
  ];

  /// Resumen sin repetir compases seguidos (`I – V – vi – IV`).
  String get summary {
    final List<String> tokens = <String>[];
    for (final String bar in bars) {
      for (final String token in bar.split(' ')) {
        if (tokens.isEmpty || tokens.last != token) {
          tokens.add(token);
        }
      }
    }
    return tokens.join(' – ');
  }
}
