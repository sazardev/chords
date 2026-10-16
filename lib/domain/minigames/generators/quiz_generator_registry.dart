import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/generators/chord_challenge_generators.dart';
import 'package:chords/domain/minigames/generators/chord_diagram_generators.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/chord_spelling_generators.dart';
import 'package:chords/domain/minigames/generators/chord_transform_generators.dart';
import 'package:chords/domain/minigames/generators/chord_variant_generators.dart';
import 'package:chords/domain/minigames/generators/note_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/pitch_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/progression_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/generators/string_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/style_duel_generator.dart';
import 'package:chords/domain/minigames/generators/theory_ear_generators.dart';
import 'package:chords/domain/minigames/generators/theory_quiz_generators.dart';

/// Generador de preguntas de cada minijuego de opciones.
///
/// Es la única tabla que une un [MiniGameKind] con su generador: para añadir
/// un juego de preguntas basta una entrada aquí.
Map<MiniGameKind, QuizGenerator> buildQuizGenerators(
  ChordRepository repository,
) => <MiniGameKind, QuizGenerator>{
  MiniGameKind.guessNote: const GuessNoteGenerator(),
  MiniGameKind.whichString: const WhichStringGenerator(),
  MiniGameKind.whichFret: const WhichFretGenerator(),
  MiniGameKind.interval: const IntervalGenerator(),
  MiniGameKind.higherLower: const HigherLowerGenerator(),
  MiniGameKind.chordQuality: ChordQualityGenerator(repository),
  MiniGameKind.nameChord: NameChordGenerator(repository),
  MiniGameKind.tuneEar: const TuneEarGenerator(),
  MiniGameKind.memory: const MemoryGenerator(),
  MiniGameKind.noteAtFret: const NoteAtFretGenerator(),
  MiniGameKind.fretOfNote: const FretOfNoteGenerator(),
  MiniGameKind.fingerQuiz: FingerQuizGenerator(repository),
  MiniGameKind.readDiagram: ReadDiagramGenerator(repository),
  MiniGameKind.scaleNote: const ScaleNoteGenerator(),
  MiniGameKind.keyChord: const KeyChordGenerator(),
  MiniGameKind.scaleDegree: const ScaleDegreeGenerator(),
  MiniGameKind.findTonic: FindTonicGenerator(repository),
  MiniGameKind.progressionEar: ProgressionEarGenerator(repository),
  MiniGameKind.spellChord: SpellChordGenerator(repository),
  MiniGameKind.chordFormula: ChordFormulaGenerator(repository),
  MiniGameKind.chordVariantEar: ChordVariantEarGenerator(repository),
  MiniGameKind.chordMemory: ChordMemoryGenerator(repository),
  MiniGameKind.rootAndBass: RootAndBassGenerator(repository),
  MiniGameKind.inversion: InversionGenerator(repository),
  MiniGameKind.wrongDiagram: WrongDiagramGenerator(repository),
  MiniGameKind.cagedShape: CagedShapeGenerator(repository),
  MiniGameKind.rushOpen: RushChordGenerator(
    repository,
    MiniGameKind.rushOpen,
    RushTheme.open,
  ),
  MiniGameKind.rushBarre: RushChordGenerator(
    repository,
    MiniGameKind.rushBarre,
    RushTheme.barre,
  ),
  MiniGameKind.rushSeventh: RushChordGenerator(
    repository,
    MiniGameKind.rushSeventh,
    RushTheme.seventh,
  ),
  MiniGameKind.fillProgression: FillProgressionGenerator(repository),
  MiniGameKind.romanDegree: RomanDegreeGenerator(repository),
  MiniGameKind.transposeChord: TransposeChordGenerator(repository),
  MiniGameKind.chordNeighbors: ChordNeighborGenerator(repository),
  MiniGameKind.styleDuel: StyleDuelGenerator(repository),
};
