import 'dart:math' as math;

import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/generators/theory_quiz_generators.dart';
import 'package:chords/domain/minigames/services/strum_cues.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';

/// Golpes máximos que suenan en una pregunta (para no alargarla en exceso).
const int _maxHits = 24;

/// Compases que se tocan de [progression] en la pregunta (2 a 4).
int barsPlayed(ChordProgression progression) =>
    (_maxHits ~/ hitsPerBar(progression.strum)).clamp(2, 4);

/// Cómo suena una progresión: sus primeros compases y su rasgueo.
///
/// Dos progresiones con la misma huella suenan igual, así que ninguna de las
/// dos géneros distintos puede ser la respuesta de la otra.
String soundSignature(ChordProgression progression) =>
    '${progression.bars.take(barsPlayed(progression)).join(' ')}|'
    '${progression.strum.name}';

/// Duelo de estilos: suenan los primeros compases de una progresión del
/// catálogo con su rasgueo y hay que decir de qué género es.
///
/// Los géneros de las opciones se eligen entre los que no tienen una
/// progresión que suene igual, para que solo una respuesta sea correcta.
class StyleDuelGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const StyleDuelGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final ChordProgression answer =
        kProgressions[random.nextInt(kProgressions.length)];
    final int tonic = randomTonic(random, MiniGameLevel.easy);
    final int bars = barsPlayed(answer);
    final List<ChordSymbol> chords = <ChordSymbol>[
      for (final String bar in answer.bars.take(bars))
        RomanChord.parse(bar.split(' ').first).inKey(tonic),
    ];
    final List<String> genres = _distractorGenres(random, level, answer);
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      _genreChoice(answer.genre),
      genres.map(_genreChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.styleDuel,
      cues: strumCues(_repository, chords, answer.strum, answer.bpm),
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      keyTonic: tonic,
      params: <String, String>{'strum': answer.strum.name},
    );
  }

  /// Géneros que no tienen una progresión idéntica en sonido a [answer].
  ///
  /// En fácil prefieren los de rasgueo distinto (más fáciles de separar); en
  /// difícil, los del mismo rasgueo.
  List<String> _distractorGenres(
    math.Random random,
    MiniGameLevel level,
    ChordProgression answer,
  ) {
    // Firmas de todas las progresiones del género de la respuesta con ese
    // mismo rasgueo: ninguna opción puede sonar igual que alguna de ellas.
    final Set<String> signatures = <String>{
      for (final ChordProgression p in kProgressions)
        if (p.genre == answer.genre && p.strum == answer.strum)
          soundSignature(p),
    };
    final List<String> candidates = <String>[
      for (final GenreGuide guide in kGenreGuides)
        if (guide.id != answer.genre &&
            !kProgressions.any(
              (ChordProgression p) =>
                  p.genre == guide.id && signatures.contains(soundSignature(p)),
            ))
          guide.id,
    ]..shuffle(random);
    final bool similarFirst = level == MiniGameLevel.hard;
    candidates.sort((String a, String b) {
      final int left = _sharesStrum(a, answer) ? 1 : 0;
      final int right = _sharesStrum(b, answer) ? 1 : 0;
      return similarFirst ? right - left : left - right;
    });
    return candidates.take(choiceCountFor(level) - 1).toList();
  }

  bool _sharesStrum(String genre, ChordProgression answer) => kProgressions.any(
    (ChordProgression p) => p.genre == genre && p.strum == answer.strum,
  );

  QuizChoice _genreChoice(String genre) => QuizChoice(ChoiceType.genre, genre);
}
