import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:meta/meta.dart';

/// Estado de una cuerda durante la práctica de un acorde.
enum PracticeStringStatus {
  /// El acorde no usa esta cuerda.
  muted,

  /// Aún no se ha reconocido.
  pending,

  /// Reconocida con la nota correcta.
  matched,
}

/// Cuerda a practicar: qué nota debe sonar, con qué traste y qué dedo.
@immutable
class PracticeString {
  /// Crea una cuerda de práctica.
  const PracticeString({
    required this.string,
    required this.fret,
    required this.finger,
    required this.frequency,
    required this.status,
  });

  /// Cuerda de la guitarra.
  final GuitarString string;

  /// Traste a pulsar: `-1` muda, `0` al aire.
  final int fret;

  /// Dedo que la pulsa (`0` = sin dedo).
  final int finger;

  /// Frecuencia que debe sonar.
  final double frequency;

  /// Estado actual.
  final PracticeStringStatus status;

  /// Número de cuerda (1-6).
  int get number => string.number;

  /// `true` si se toca al aire.
  bool get isOpen => fret == 0;

  /// `true` si el acorde no usa la cuerda.
  bool get isMuted => status == PracticeStringStatus.muted;

  /// `true` si ya se reconoció.
  bool get isMatched => status == PracticeStringStatus.matched;

  /// Copia la cuerda con otro estado.
  PracticeString withStatus(PracticeStringStatus value) => PracticeString(
    string: string,
    fret: fret,
    finger: finger,
    frequency: frequency,
    status: value,
  );
}

/// Tipo de consejo para corregir una cuerda mal tocada.
enum PracticeTipKind {
  /// Suena al aire: falta pulsar la cuerda.
  soundsOpen,

  /// Suena más grave por uno o más trastes: subir el dedo hacia la caja.
  moveUp,

  /// Suena más agudo por uno o más trastes: bajar el dedo hacia el clavijero.
  moveDown,

  /// Pulsada, algo floja: acercar el dedo al traste o reafinar.
  tooFlat,

  /// Pulsada, algo alta: aflojar la presión o reafinar.
  tooSharp,

  /// Al aire y floja: apretar la clavija.
  retuneUp,

  /// Al aire y alta: aflojar la clavija.
  retuneDown,

  /// La nota no se parece a la esperada.
  unknown,
}

/// Consejo concreto para una cuerda.
@immutable
class PracticeTip {
  /// Crea un consejo.
  const PracticeTip({
    required this.kind,
    required this.stringNumber,
    this.finger = 0,
    this.fret = 0,
    this.steps = 0,
    this.cents = 0,
  });

  /// Tipo de consejo.
  final PracticeTipKind kind;

  /// Cuerda a la que se refiere.
  final int stringNumber;

  /// Dedo que debería pulsarla (`0` = sin dedo).
  final int finger;

  /// Traste objetivo.
  final int fret;

  /// Trastes a mover (en `moveUp` y `moveDown`).
  final int steps;

  /// Desviación detectada en cents.
  final double cents;

  /// `true` si el consejo se resuelve reafinando la cuerda.
  bool get suggestsRetune =>
      kind == PracticeTipKind.retuneUp ||
      kind == PracticeTipKind.retuneDown ||
      kind == PracticeTipKind.tooFlat ||
      kind == PracticeTipKind.tooSharp;

  @override
  String toString() => 'PracticeTip($kind, cuerda $stringNumber, $steps)';
}
