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

  /// `true` si hay que acertar varias opciones seguidas.
  bool get isSequence => answer.length > 1;

  /// `true` si la pregunta tiene sonido para escuchar.
  bool get hasSound => cues.isNotEmpty;

  /// Opción correcta (la primera de la respuesta).
  QuizChoice get correctChoice => choices[answer.first];

  /// Huella para evitar repetir la misma pregunta dos veces seguidas.
  String get signature =>
      '${kind.id}|${answer.map((int i) => choices[i].value).join(',')}|'
      '$chordId|$stringNumber|$fret|$note|'
      '${cues.map((SoundCue c) => switch (c) {
        ToneCue() => c.frequency.toStringAsFixed(1),
        ChordCue() => c.chordId,
      }).join(',')}';
}
