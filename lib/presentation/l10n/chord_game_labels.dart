/// Textos de los minijuegos con acordes.
///
/// Convierten las preguntas de los juegos nuevos (notas, fórmulas, diagramas,
/// formas, progresiones, transporte y estilos) en frases del idioma activo. El
/// dominio solo guarda datos —el acorde, el grado, la relación—; cada juego
/// tiene aquí la función que arma su enunciado.
library;

import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/services/chord_inversion.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';

typedef _Prompt = String Function(Translations t, QuizQuestion q);

String _param(QuizQuestion q, String key) => q.params[key] ?? '';

String _tonality(Translations t, QuizQuestion q) =>
    keyName(t, q.keyTonic ?? 0, minor: q.scaleId == ScaleType.naturalMinor.id);

String _spell(Translations t, QuizQuestion q) => q.detail == 'order'
    ? t.chordGames.prompt.spellOrder(chord: _param(q, 'chord'))
    : t.chordGames.prompt.spellSet(chord: _param(q, 'chord'));

String _formula(Translations t, QuizQuestion q) => q.detail == 'toName'
    ? t.chordGames.prompt.formulaName(
        note: noteLabelOf(t, q.note ?? 'C'),
        formula: _param(q, 'formula'),
      )
    : t.chordGames.prompt.formulaTo(chord: _param(q, 'chord'));

String _rootAndBass(Translations t, QuizQuestion q) => q.detail == 'rootString'
    ? t.chordGames.prompt.rootString(chord: _param(q, 'chord'))
    : t.chordGames.prompt.bassNote(chord: _param(q, 'chord'));

String _inversion(Translations t, QuizQuestion q) => q.hasSound
    ? t.chordGames.prompt.inversionEar(chord: _param(q, 'chord'))
    : t.chordGames.prompt.inversionDiagram(chord: _param(q, 'chord'));

String _caged(Translations t, QuizQuestion q) => q.detail == 'barre'
    ? t.chordGames.prompt.cagedBarre(
        chord: _param(q, 'chord'),
        shape: _param(q, 'shape'),
      )
    : t.chordGames.prompt.cagedShape(chord: _param(q, 'chord'));

String _fill(Translations t, QuizQuestion q) {
  final String genre = genreGuideName(t, _param(q, 'genre'));
  final String key = _tonality(t, q);
  return q.detail == 'roman'
      ? t.chordGames.prompt.fillRoman(genre: genre, key: key)
      : t.chordGames.prompt.fillChord(genre: genre, key: key);
}

String _roman(Translations t, QuizQuestion q) => q.detail == 'toChord'
    ? t.chordGames.prompt.romanToChord(
        key: _tonality(t, q),
        roman: _param(q, 'roman'),
      )
    : t.chordGames.prompt.romanToRoman(
        key: _tonality(t, q),
        chord: _param(q, 'chord'),
      );

String _transpose(Translations t, QuizQuestion q) {
  final String chord = _param(q, 'chord');
  final int n = int.tryParse(_param(q, 'n')) ?? 1;
  return switch (q.detail) {
    'up' => t.chordGames.prompt.transposeUp(n: n, chord: chord),
    'down' => t.chordGames.prompt.transposeDown(n: n, chord: chord),
    'capoSounds' => t.chordGames.prompt.capoSounds(n: n, chord: chord),
    _ => t.chordGames.prompt.capoShape(n: n, chord: chord),
  };
}

String _neighbor(Translations t, QuizQuestion q) {
  final String chord = _param(q, 'chord');
  return switch (q.detail) {
    'relativeMinor' => t.chordGames.prompt.relativeMinor(chord: chord),
    'relativeMajor' => t.chordGames.prompt.relativeMajor(chord: chord),
    'dominant' => t.chordGames.prompt.dominant(chord: chord),
    'subdominant' => t.chordGames.prompt.subdominant(chord: chord),
    'fifthUp' => t.chordGames.prompt.fifthUp(chord: chord),
    'fifthDown' => t.chordGames.prompt.fifthDown(chord: chord),
    'parallel' => t.chordGames.prompt.parallel(chord: chord),
    _ => t.chordGames.prompt.tritone(chord: chord),
  };
}

final Map<MiniGameKind, _Prompt> _prompts = <MiniGameKind, _Prompt>{
  MiniGameKind.spellChord: _spell,
  MiniGameKind.chordFormula: _formula,
  MiniGameKind.chordVariantEar: (Translations t, QuizQuestion q) =>
      t.chordGames.prompt.variantEar(note: noteLabelOf(t, q.note ?? 'C')),
  MiniGameKind.chordMemory: (Translations t, QuizQuestion q) =>
      t.chordGames.prompt.chordMemory,
  MiniGameKind.rootAndBass: _rootAndBass,
  MiniGameKind.inversion: _inversion,
  MiniGameKind.wrongDiagram: (Translations t, QuizQuestion q) =>
      t.chordGames.prompt.wrongDiagram(chord: _param(q, 'chord')),
  MiniGameKind.cagedShape: _caged,
  MiniGameKind.rushOpen: _rush,
  MiniGameKind.rushBarre: _rush,
  MiniGameKind.rushSeventh: _rush,
  MiniGameKind.fillProgression: _fill,
  MiniGameKind.romanDegree: _roman,
  MiniGameKind.transposeChord: _transpose,
  MiniGameKind.chordNeighbors: _neighbor,
  MiniGameKind.styleDuel: (Translations t, QuizQuestion q) =>
      t.chordGames.prompt.styleDuel,
};

String _rush(Translations t, QuizQuestion q) => t.chordGames.prompt.rush;

/// Enunciado de una pregunta de los juegos con acordes; `null` si la pregunta
/// no es de uno de ellos.
String? chordGamePrompt(Translations t, QuizQuestion question) =>
    _prompts[question.kind]?.call(t, question);

/// Texto de una opción de los tipos que añaden los juegos con acordes.
String chordGameChoiceLabel(Translations t, QuizChoice choice) =>
    switch (choice.type) {
      ChoiceType.noteSet => <String>[
        for (final String pc in choice.value.split(','))
          noteLabel(t, int.tryParse(pc) ?? 0),
      ].join(' – '),
      ChoiceType.inversion => _inversionLabel(t, choice.value),
      ChoiceType.genre => genreGuideName(t, choice.value),
      _ => choice.label ?? choice.value,
    };

String _inversionLabel(Translations t, String id) =>
    switch (ChordInversion.fromId(id)) {
      ChordInversion.root => t.chordGames.choice.inversionRoot,
      ChordInversion.first => t.chordGames.choice.inversionFirst,
      ChordInversion.second => t.chordGames.choice.inversionSecond,
      ChordInversion.third => t.chordGames.choice.inversionThird,
      null => id,
    };

/// Texto de un diagrama como opción, para lectores de pantalla.
String diagramChoiceLabel(Translations t, int number) =>
    t.chordGames.choice.diagram(n: number);

/// Explicación que acompaña al resultado de una pregunta (por qué), si hay.
String? questionExplanation(Translations t, QuizQuestion question) {
  final String chord = _param(question, 'chord');
  final String note = noteLabelOf(t, question.note ?? 'C');
  final String string = stringShort(t, question.stringNumber ?? 1);
  return switch (question.kind) {
    MiniGameKind.wrongDiagram => switch (question.detail) {
      'alienNote' => t.chordGames.explain.alienNote(
        string: string,
        note: note,
        chord: chord,
      ),
      'unmutedString' => t.chordGames.explain.unmutedString(
        string: string,
        note: note,
        chord: chord,
      ),
      _ => t.chordGames.explain.missingNote(note: note, chord: chord),
    },
    MiniGameKind.styleDuel => t.chordGames.explain.styleDuel(
      genre: genreGuideName(t, question.correctChoice.value),
    ),
    MiniGameKind.cagedShape when question.detail == 'shape' =>
      t.chordGames.explain.shape(shape: question.correctChoice.value),
    _ => null,
  };
}
