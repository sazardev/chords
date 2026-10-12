import 'package:meta/meta.dart';

/// Un sonido que una pregunta hace escuchar.
@immutable
sealed class SoundCue {
  /// Crea el sonido con la espera previa respecto al anterior.
  const SoundCue({this.delayMs = 0});

  /// Milisegundos de espera antes de reproducirlo (tras el sonido anterior).
  final int delayMs;
}

/// Una nota suelta a una frecuencia.
final class ToneCue extends SoundCue {
  /// Crea la nota.
  const ToneCue(this.frequency, {super.delayMs});

  /// Frecuencia en Hz.
  final double frequency;
}

/// Un acorde del banco con una de sus posiciones.
final class ChordCue extends SoundCue {
  /// Crea el acorde.
  const ChordCue(this.chordId, {this.variantIndex = 0, super.delayMs});

  /// Identificador del acorde.
  final String chordId;

  /// Posición del acorde que suena.
  final int variantIndex;
}
