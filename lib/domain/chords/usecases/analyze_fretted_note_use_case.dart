import 'package:chords/domain/audio/services/pitch_math.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';

/// Caso de uso: compara lo que suena con la nota que debería dar una cuerda.
///
/// Decide si es correcta y, si no, deduce qué ha hecho el guitarrista: no
/// pulsar, pulsar un traste de más o de menos, presionar mal o llevar la
/// cuerda desafinada. Los márgenes son tolerantes porque el dedo y el
/// micrófono de un móvil no son un afinador de estudio.
class AnalyzeFrettedNoteUseCase {
  /// Crea el caso de uso.
  const AnalyzeFrettedNoteUseCase();

  /// Margen en cents para una cuerda pulsada.
  static const double frettedTolerance = 30;

  /// Margen en cents para una cuerda al aire (debe estar bien afinada).
  static const double openTolerance = 20;

  /// Máximo de trastes de error que se corrigen con "sube" o "baja".
  static const int _maxFretShift = 3;

  /// Margen respecto a un traste entero para atribuir el error al dedo.
  static const double _wholeFretMargin = 35;

  /// Distancia en cents de [frequency] a la nota de [target].
  double centsFrom(PracticeString target, double frequency) =>
      centsBetween(frequency, target.frequency);

  /// `true` si [frequency] es la nota correcta de [target].
  bool matches(PracticeString target, double frequency) =>
      centsFrom(target, frequency).abs() <=
      (target.isOpen ? openTolerance : frettedTolerance);

  /// Consejo para corregir [target] a partir de [frequency].
  PracticeTip tipFor(PracticeString target, double frequency) {
    final double cents = centsFrom(target, frequency);
    final int semitones = (cents / 100).round();
    final double residual = cents - semitones * 100;
    final PracticeTipKind kind = semitones == 0
        ? _slightKind(target, cents)
        : _fretKind(target, semitones, residual);
    return PracticeTip(
      kind: kind,
      stringNumber: target.number,
      finger: target.finger,
      fret: target.fret,
      steps: semitones.abs(),
      cents: cents,
    );
  }

  PracticeTipKind _slightKind(PracticeString target, double cents) {
    if (target.isOpen) {
      return cents < 0 ? PracticeTipKind.retuneUp : PracticeTipKind.retuneDown;
    }
    return cents < 0 ? PracticeTipKind.tooFlat : PracticeTipKind.tooSharp;
  }

  PracticeTipKind _fretKind(
    PracticeString target,
    int semitones,
    double residual,
  ) {
    if (target.isOpen || residual.abs() > _wholeFretMargin) {
      return PracticeTipKind.unknown;
    }
    if (semitones == -target.fret) {
      return PracticeTipKind.soundsOpen;
    }
    if (semitones.abs() > _maxFretShift) {
      return PracticeTipKind.unknown;
    }
    return semitones < 0 ? PracticeTipKind.moveUp : PracticeTipKind.moveDown;
  }
}
