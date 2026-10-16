import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:meta/meta.dart';

/// Qué representa una opción de respuesta; la interfaz la etiqueta.
enum ChoiceType {
  /// Nombre de una nota (`value` = `C#`).
  note,

  /// Número de cuerda (`value` = `3`).
  stringNumber,

  /// Número de traste (`value` = `5`, `0` = al aire).
  fret,

  /// Intervalo en semitonos (`value` = `7`).
  interval,

  /// Calidad de acorde (`value` = `min`).
  quality,

  /// Acorde concreto (`value` = id del acorde, `label` = su nombre).
  chord,

  /// Dedo de la mano izquierda (`value` = `1`…`4`).
  finger,

  /// Primera o segunda nota (`value` = `first` o `second`).
  order,

  /// Comparación de afinación (`value` = `flat`, `inTune` o `sharp`).
  tuning,

  /// Grado de la tonalidad (`value` = `1`…`7`).
  degree,

  /// Progresión en grados (`label` = `I – V – vi – IV`).
  progression,

  /// Conjunto de notas de un acorde (`value` = `0,4,7`, clases de tono).
  noteSet,

  /// Fórmula de intervalos (`value` y `label` = `1 – ♭3 – 5`).
  formula,

  /// Grado romano (`value` y `label` = `bVII`).
  roman,

  /// Forma CAGED (`value` y `label` = `C`, `A`, `G`, `E` o `D`).
  shape,

  /// Inversión de un acorde (`value` = `root`, `first`, `second`, `third`).
  inversion,

  /// Género de la guía (`value` = id del género).
  genre,

  /// Diagrama dibujado en la opción (`value` = trastes `x,3,2,0,1,0`).
  diagram,
}

/// Cómo se dibuja el diagrama del enunciado.
enum QuizDiagram {
  /// Sin diagrama.
  none,

  /// Con los números de dedo.
  fingers,

  /// Solo los puntos, sin números de dedo.
  plain,
}

/// Una opción de respuesta.
@immutable
class QuizChoice {
  /// Crea la opción.
  const QuizChoice(this.type, this.value, {this.label});

  /// Tipo de opción.
  final ChoiceType type;

  /// Valor canónico, independiente del idioma.
  final String value;

  /// Texto ya listo para mostrar cuando no depende del idioma.
  final String? label;

  @override
  bool operator ==(Object other) =>
      other is QuizChoice && other.type == type && other.value == value;

  @override
  int get hashCode => Object.hash(type, value);

  @override
  String toString() => 'QuizChoice(${type.name}: $value)';
}

/// Una pregunta de opción múltiple (o de secuencia) de un minijuego.
@immutable
class QuizQuestion {
  /// Crea la pregunta.
  const QuizQuestion({
    required this.kind,
    required this.choices,
    required this.answer,
    this.cues = const <SoundCue>[],
    this.chordId,
    this.variantIndex = 0,
    this.stringNumber,
    this.fret,
    this.note,
    this.keyTonic,
    this.scaleId,
    this.degree,
    this.diagram = QuizDiagram.none,
    this.detail,
    this.bars = const <String>[],
    this.params = const <String, String>{},
  });

  /// Juego al que pertenece.
  final MiniGameKind kind;

  /// Sonidos que se escuchan, en orden.
  final List<SoundCue> cues;

  /// Opciones de respuesta.
  final List<QuizChoice> choices;

  /// Índices de las opciones correctas, en orden (uno salvo en secuencias).
  final List<int> answer;

  /// Acorde mostrado en el diagrama, si lo hay.
  final String? chordId;

  /// Posición del acorde mostrado.
  final int variantIndex;

  /// Cuerda a la que se refiere el enunciado.
  final int? stringNumber;

  /// Traste al que se refiere el enunciado.
  final int? fret;

  /// Nota a la que se refiere el enunciado (`C#`).
  final String? note;

  /// Tónica de la tonalidad o escala del enunciado (0 = Do).
  final int? keyTonic;

  /// Escala del enunciado (identificador de `ScaleType`).
  final String? scaleId;

  /// Grado del enunciado (1-7).
  final int? degree;

  /// Diagrama del enunciado (el del acorde [chordId], posición
  /// [variantIndex]).
  final QuizDiagram diagram;

  /// Variante del enunciado dentro del juego (`up`, `capoSounds`, un error…).
  final String? detail;

  /// Compases mostrados en el enunciado; `?` marca el que falta.
  final List<String> bars;

  /// Datos del enunciado ya listos para mostrar (`chord` = `Cmaj7`).
  final Map<String, String> params;

  /// `true` si hay que acertar varias opciones seguidas.
  bool get isSequence => answer.length > 1;

  /// `true` si la pregunta tiene sonido para escuchar.
  bool get hasSound => cues.isNotEmpty;

  /// Opción correcta (la primera de la respuesta).
  QuizChoice get correctChoice => choices[answer.first];

  /// Huella para evitar repetir la misma pregunta dos veces seguidas.
  String get signature =>
      '${kind.id}|${answer.map((int i) => choices[i].value).join(',')}|'
      '$chordId|$variantIndex|$stringNumber|$fret|$note|$keyTonic|$scaleId|'
      '$degree|$detail|${bars.join(' ')}|${params.values.join(',')}|'
      '${cues.map((SoundCue c) => switch (c) {
        ToneCue() => c.frequency.toStringAsFixed(1),
        ChordCue() => c.chordId,
      }).join(',')}';
}
