import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:meta/meta.dart';

/// Parte de una canción.
enum SongPart {
  /// Introducción.
  intro,

  /// Estrofa.
  verse,

  /// Estribillo.
  chorus,

  /// Puente.
  bridge,

  /// Final.
  outro,
}

/// Una línea de la canción: sus compases y el texto que se canta encima.
///
/// Cada compás es una cifra (`G`) o dos separadas por un espacio (`G D`)
/// que se reparten el compás a medias.
@immutable
class SongLine {
  /// Crea la línea.
  const SongLine(this.bars, [this.lyric = '']);

  /// Compases de la línea.
  final List<String> bars;

  /// Letra (vacía en los pasajes instrumentales).
  final String lyric;
}

/// Una sección de la canción (estrofa, estribillo…).
@immutable
class SongSection {
  /// Crea la sección.
  const SongSection(this.part, this.lines);

  /// Qué parte es.
  final SongPart part;

  /// Líneas de la sección.
  final List<SongLine> lines;
}

/// Una canción del cancionero, siempre de dominio público o tradicional.
@immutable
class Song {
  /// Crea la canción.
  const Song({
    required this.id,
    required this.title,
    required this.genre,
    required this.difficulty,
    required this.bpm,
    required this.strum,
    required this.sections,
    this.author,
  });

  /// Identificador estable.
  final String id;

  /// Título.
  final String title;

  /// Autoría y año (`Stephen Foster, 1848`); `null` si es tradicional.
  final String? author;

  /// Género (identificador de la guía de géneros).
  final String genre;

  /// Dificultad 1-3.
  final int difficulty;

  /// Tempo en pulsos por minuto.
  final int bpm;

  /// Rasgueo recomendado; marca también el compás (3/4 o 4/4).
  final StrumPattern strum;

  /// Secciones en orden de interpretación.
  final List<SongSection> sections;

  /// Todos los compases en orden, cada uno con sus cifras.
  List<List<ChordSymbol>> bars({int transpose = 0}) => <List<ChordSymbol>>[
    for (final SongSection section in sections)
      for (final SongLine line in section.lines)
        for (final String bar in line.bars)
          <ChordSymbol>[
            for (final String token in bar.split(' '))
              ChordSymbol.parse(token).transpose(transpose),
          ],
  ];

  /// Acordes distintos de la canción, en orden de aparición.
  List<ChordSymbol> chords({int transpose = 0}) {
    final List<ChordSymbol> result = <ChordSymbol>[];
    for (final List<ChordSymbol> bar in bars(transpose: transpose)) {
      for (final ChordSymbol chord in bar) {
        if (!result.contains(chord)) {
          result.add(chord);
        }
      }
    }
    return result;
  }
}
