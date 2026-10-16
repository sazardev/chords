import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/generators/theory_ear_generators.dart';
import 'package:chords/domain/minigames/generators/theory_quiz_generators.dart';
import 'package:chords/domain/minigames/services/progression_tokens.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';

/// Grado romano listo para mostrar (`bVII` → `♭VII`).
String romanLabel(String token) {
  if (token.startsWith('b')) {
    return '♭${token.substring(1)}';
  }
  return token.startsWith('#') ? '♯${token.substring(1)}' : token;
}

/// Opción de respuesta que nombra un grado romano.
QuizChoice romanChoice(String token) =>
    QuizChoice(ChoiceType.roman, token, label: romanLabel(token));

/// Grados con los que se confunde un grado en una tonalidad mayor.
const List<String> kMajorRomans = <String>[
  'I',
  'ii',
  'iii',
  'IV',
  'V',
  'vi',
  'vii°',
  'bVII',
  'bVI',
  'V7',
  'IV7',
  'I7',
];

/// Grados con los que se confunde un grado en una tonalidad menor.
const List<String> kMinorRomans = <String>[
  'i',
  'ii°',
  'bIII',
  'iv',
  'v',
  'bVI',
  'bVII',
  'V',
  'V7',
  'i7',
];

/// Numerales con los que se confunde un grado, sin sufijo.
const List<String> _confusableNumerals = <String>[
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'bVII',
  'bVI',
  'bIII',
];

/// Grados parecidos a [token] para usar como distractores: los mismos
/// numerales con su mismo sufijo (`IV5` junto a `V5` y `bVII5`), de modo que
/// el estilo de la opción no delate la respuesta.
List<String> romanLookalikes(String token, {required bool minor}) {
  final RegExpMatch match = RegExp(r'^([b#]?)([ivIV]+)(.*)$')
      .firstMatch(token)!;
  final String suffix = match.group(3)!;
  if (suffix.isEmpty || suffix == '°') {
    return <String>[
      for (final String t in minor ? kMinorRomans : kMajorRomans)
        if (RegExp(r'^[b#]?[ivIV]+°?$').hasMatch(t)) t,
    ];
  }
  final String numeral = match.group(2)!;
  final bool lower = numeral == numeral.toLowerCase();
  return <String>[
    for (final String base in _confusableNumerals)
      _withCase(base, lower: lower) + suffix,
  ];
}

String _withCase(String base, {required bool lower}) {
  final bool flat = base.startsWith('b');
  final String numeral = flat ? base.substring(1) : base;
  return '${flat ? 'b' : ''}${lower ? numeral.toLowerCase() : numeral}';
}

/// Completa la progresión: una de las progresiones del catálogo con un acorde
/// oculto, en cualquier tono.
///
/// Fácil y medio: se elige el acorde que falta (se oye el resto). Difícil: se
/// elige su grado romano.
class FillProgressionGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const FillProgressionGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ChordProgression> pool = <ChordProgression>[
      for (final ChordProgression p in kProgressions)
        if (_fits(p, level)) p,
    ];
    final List<ChordProgression> source = pool.isEmpty ? kProgressions : pool;
    for (int attempt = 0; attempt < 30; attempt++) {
      final QuizQuestion? question = _build(
        random,
        level,
        source[random.nextInt(source.length)],
      );
      if (question != null) {
        return question;
      }
    }
    return _build(random, MiniGameLevel.easy, kProgressions.first) ??
        (throw StateError('El banco no tiene los acordes de las progresiones'));
  }

  bool _fits(ChordProgression progression, MiniGameLevel level) {
    final List<String> tokens = progressionTokens(progression);
    if (tokens.length < 3 ||
        tokens.length > (level == MiniGameLevel.hard ? 12 : 8)) {
      return false;
    }
    return tokens.every((String token) {
      final ChordQuality quality = RomanChord.parse(token).quality;
      return switch (level) {
        MiniGameLevel.easy =>
          quality == ChordQuality.major || quality == ChordQuality.minor,
        MiniGameLevel.medium => quality.intervals.length <= 4,
        MiniGameLevel.hard => true,
      };
    });
  }

  QuizQuestion? _build(
    math.Random random,
    MiniGameLevel level,
    ChordProgression progression,
  ) {
    final List<String> tokens = progressionTokens(progression);
    final int tonic = randomTonic(random, level);
    final List<ChordSymbol> symbols = <ChordSymbol>[
      for (final String token in tokens) RomanChord.parse(token).inKey(tonic),
    ];
    if (symbols.any(
      (ChordSymbol s) => _repository.chordById(s.chordId) == null,
    )) {
      return null;
    }
    final int hidden =
        (level == MiniGameLevel.hard ? 0 : 1) +
        random.nextInt(tokens.length - (level == MiniGameLevel.hard ? 0 : 1));
    final bool roman = level == MiniGameLevel.hard;
    final ShuffledChoices shuffled = roman
        ? _romanChoices(random, level, progression, tokens[hidden])
        : _chordChoices(random, level, progression, symbols[hidden], tonic);
    return QuizQuestion(
      kind: MiniGameKind.fillProgression,
      cues: roman
          ? const <SoundCue>[]
          : chordCues(_repository, <ChordSymbol>[
              for (int i = 0; i < symbols.length; i++)
                if (i != hidden) symbols[i],
            ]),
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      keyTonic: tonic,
      scaleId:
          (progression.minor ? ScaleType.naturalMinor : ScaleType.major).id,
      bars: <String>[
        for (int i = 0; i < symbols.length; i++)
          if (i == hidden) '?' else symbols[i].name,
      ],
      detail: roman ? 'roman' : 'chord',
      params: <String, String>{'genre': progression.genre},
    );
  }

  ShuffledChoices _chordChoices(
    math.Random random,
    MiniGameLevel level,
    ChordProgression progression,
    ChordSymbol answer,
    int tonic,
  ) {
    final List<ChordSymbol> candidates = <ChordSymbol>[
      for (final DiatonicChord d in MusicalKey(
        tonic,
        minor: progression.minor,
      ).harmony())
        d.symbol,
      RomanChord.parse('bVII').inKey(tonic),
    ]..shuffle(random);
    return shuffleChoices(
      random,
      symbolChoice(answer),
      distractorSymbols(
        answer,
        candidates,
        choiceCountFor(level, hard: 5) - 1,
      ).map(symbolChoice),
    );
  }

  ShuffledChoices _romanChoices(
    math.Random random,
    MiniGameLevel level,
    ChordProgression progression,
    String answer,
  ) {
    final List<String> pool = romanLookalikes(answer, minor: progression.minor)
      ..shuffle(random);
    final ChordSymbol target = RomanChord.parse(answer).inKey(0);
    final List<String> others = <String>[
      for (final String token in pool)
        if (token != answer &&
            !sameNotes(target, RomanChord.parse(token).inKey(0)))
          token,
    ];
    return shuffleChoices(
      random,
      romanChoice(answer),
      others.take(choiceCountFor(level, hard: 5) - 1).map(romanChoice),
    );
  }
}

/// Grados romanos: del grado al acorde y del acorde al grado.
///
/// Más allá de los acordes de la escala: sétimas, el `V7` y los prestados
/// del modo paralelo (`bVII`, `bVI`, `iv`).
class RomanDegreeGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const RomanDegreeGenerator(this._repository);

  final ChordRepository _repository;

  static const Map<MiniGameLevel, List<String>> _major =
      <MiniGameLevel, List<String>>{
        MiniGameLevel.easy: <String>['I', 'IV', 'V'],
        MiniGameLevel.medium: <String>['I', 'ii', 'iii', 'IV', 'V', 'vi', 'V7'],
        MiniGameLevel.hard: <String>[
          'Imaj7',
          'ii7',
          'iii7',
          'IVmaj7',
          'V7',
          'vi7',
          'ii',
          'vi',
          'bVII',
          'bVI',
          'iv',
        ],
      };

  static const Map<MiniGameLevel, List<String>> _minor =
      <MiniGameLevel, List<String>>{
        MiniGameLevel.medium: <String>[
          'i',
          'iv',
          'v',
          'bIII',
          'bVI',
          'bVII',
          'V7',
        ],
        MiniGameLevel.hard: <String>[
          'i7',
          'iv7',
          'v7',
          'ii°',
          'bIII',
          'bVI',
          'bVII',
          'V7',
        ],
      };

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final bool minor =
        level != MiniGameLevel.easy && random.nextDouble() < 0.35;
    final List<String> tokens = _playable(
      minor ? _minor[level]! : _major[level]!,
    );
    if (tokens.isEmpty) {
      throw StateError('El banco no tiene acordes para los grados romanos');
    }
    final int tonic = randomTonic(random, level);
    final String token = tokens[random.nextInt(tokens.length)];
    final ChordSymbol answer = RomanChord.parse(token).inKey(tonic);
    final List<String> others = tokens.where((String t) => t != token).toList()
      ..shuffle(random);
    final int count = choiceCountFor(level, hard: 5);
    final bool toChord = random.nextBool();
    final ShuffledChoices shuffled = toChord
        ? _toChord(random, answer, others, tonic, count)
        : _toRoman(random, token, answer, others, tonic, count);
    return QuizQuestion(
      kind: MiniGameKind.romanDegree,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      keyTonic: tonic,
      scaleId: (minor ? ScaleType.naturalMinor : ScaleType.major).id,
      detail: toChord ? 'toChord' : 'toRoman',
      params: <String, String>{
        if (toChord) 'roman': romanLabel(token) else 'chord': answer.name,
      },
    );
  }

  /// Los grados cuyo acorde existe en el banco.
  List<String> _playable(List<String> tokens) => <String>[
    for (final String token in tokens)
      if (_repository.chordById(RomanChord.parse(token).inKey(0).chordId) !=
          null)
        token,
  ];

  ShuffledChoices _toChord(
    math.Random random,
    ChordSymbol answer,
    List<String> others,
    int tonic,
    int count,
  ) => shuffleChoices(
    random,
    symbolChoice(answer),
    distractorSymbols(answer, <ChordSymbol>[
      for (final String t in others) RomanChord.parse(t).inKey(tonic),
    ], count - 1).map(symbolChoice),
  );

  ShuffledChoices _toRoman(
    math.Random random,
    String token,
    ChordSymbol answer,
    List<String> others,
    int tonic,
    int count,
  ) => shuffleChoices(
    random,
    romanChoice(token),
    others
        .where(
          (String t) => !sameNotes(answer, RomanChord.parse(t).inKey(tonic)),
        )
        .take(count - 1)
        .map(romanChoice),
  );
}
