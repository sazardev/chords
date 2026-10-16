import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/services/chord_formula.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';

/// Deletrea el acorde: qué notas lo forman.
///
/// En fácil y medio se elige el conjunto de notas correcto; en difícil se
/// tocan las notas, una a una, de la raíz hacia arriba.
class SpellChordGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const SpellChordGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ChordQuality> qualities = studyQualities(_repository, level);
    final Chord chord = pickChord(_repository, random, level, qualities);
    return level == MiniGameLevel.hard
        ? _ordered(random, chord)
        : _set(random, level, chord, qualities);
  }

  QuizQuestion _set(
    math.Random random,
    MiniGameLevel level,
    Chord chord,
    List<ChordQuality> qualities,
  ) {
    final List<List<int>> options = _spellings(
      random,
      chord,
      qualities,
      choiceCountFor(level) - 1,
    );
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      _setChoice(chordTones(chord.root.pitchClass, chord.quality)),
      options.map(_setChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.spellChord,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: chord.id,
      detail: 'set',
      params: <String, String>{'chord': chord.name},
    );
  }

  QuizQuestion _ordered(math.Random random, Chord chord) {
    final List<int> tones = chordTones(chord.root.pitchClass, chord.quality);
    final List<int> decoys = <int>{
      for (final int tone in tones)
        for (final int step in <int>[1, 11])
          if (!tones.contains((tone + step) % 12)) (tone + step) % 12,
    }.toList()..shuffle(random);
    final List<int> all = <int>[...tones, ...decoys.take(2)]..shuffle(random);
    return QuizQuestion(
      kind: MiniGameKind.spellChord,
      choices: <QuizChoice>[for (final int pc in all) noteChoice(pc)],
      answer: <int>[for (final int tone in tones) all.indexOf(tone)],
      chordId: chord.id,
      detail: 'order',
      params: <String, String>{'chord': chord.name},
    );
  }

  /// Notas de acordes parecidos al correcto, sin repetir ni coincidir con él.
  ///
  /// Mezcla la misma raíz con otra calidad (`Cmaj7` por `C7`) y la misma
  /// calidad en otra raíz; dos acordes con las mismas notas (`C6` y `Am7`) se
  /// cuentan como uno para que solo una opción sea correcta.
  List<List<int>> _spellings(
    math.Random random,
    Chord chord,
    List<ChordQuality> qualities,
    int count,
  ) {
    final int root = chord.root.pitchClass;
    final List<List<int>> sameRoot = <List<int>>[
      for (final ChordQuality q in nearestQualities(
        random,
        chord.quality,
        qualities,
        qualities.length,
      ))
        chordTones(root, q),
    ];
    final List<int> shifts = <int>[1, 2, 5, 7, 10, 11]..shuffle(random);
    final List<List<int>> sameQuality = <List<int>>[
      for (final int shift in shifts)
        chordTones((root + shift) % 12, chord.quality),
    ];
    final List<List<int>> merged = <List<int>>[];
    for (int i = 0; i < math.max(sameRoot.length, sameQuality.length); i++) {
      if (i < sameRoot.length) {
        merged.add(sameRoot[i]);
      }
      if (i < sameQuality.length) {
        merged.add(sameQuality[i]);
      }
    }
    final Set<String> seen = <String>{_key(chordTones(root, chord.quality))};
    return <List<int>>[
      for (final List<int> spelling in merged)
        if (seen.add(_key(spelling))) spelling,
    ].take(count).toList();
  }

  String _key(List<int> tones) => (tones.toSet().toList()..sort()).join(',');

  QuizChoice _setChoice(List<int> tones) =>
      QuizChoice(ChoiceType.noteSet, tones.join(','));
}

/// Fórmula del acorde: del acorde a sus intervalos y de la fórmula al acorde.
class ChordFormulaGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ChordFormulaGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ChordQuality> qualities = studyQualities(_repository, level);
    final Chord chord = pickChord(_repository, random, level, qualities);
    final List<ChordQuality> others = nearestQualities(
      random,
      chord.quality,
      qualities,
      choiceCountFor(level, hard: 5) - 1,
    );
    return random.nextBool()
        ? _toFormula(random, chord, others)
        : _toName(random, chord, others);
  }

  QuizQuestion _toFormula(
    math.Random random,
    Chord chord,
    List<ChordQuality> others,
  ) {
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      _formulaChoice(chord.quality),
      <QuizChoice>{for (final ChordQuality q in others) _formulaChoice(q)},
    );
    return QuizQuestion(
      kind: MiniGameKind.chordFormula,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: chord.id,
      detail: 'toFormula',
      params: <String, String>{'chord': chord.name},
    );
  }

  QuizQuestion _toName(
    math.Random random,
    Chord chord,
    List<ChordQuality> others,
  ) {
    final int root = chord.root.pitchClass;
    final List<Chord> options = <Chord>[
      for (final ChordQuality q in others)
        if (chordOfRoot(_repository, root, q) case final Chord other) other,
    ];
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      chordChoice(chord),
      options.map(chordChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.chordFormula,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: chord.id,
      note: noteNameOfPitchClass(root),
      detail: 'toName',
      params: <String, String>{'formula': formulaText(chord.quality.intervals)},
    );
  }

  QuizChoice _formulaChoice(ChordQuality quality) {
    final String text = formulaText(quality.intervals);
    return QuizChoice(ChoiceType.formula, text, label: text);
  }
}
