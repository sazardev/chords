import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:meta/meta.dart';

/// Tolerancias de afinación en cents, pensadas para un oído humano.
///
/// El margen "afinada" es algo más ancho que el ±5 de un afinador de estudio
/// para que el micrófono de un móvil no haga imposible el ajuste.
abstract final class TuningTolerance {
  /// Hasta aquí la cuerda se considera afinada.
  static const double inTune = 7;

  /// Hasta aquí está casi: falta un toque de clavija.
  static const double near = 20;

  /// Hasta aquí hay que mover la clavija; más allá está muy lejos.
  static const double off = 50;
}

/// Cuánto se aleja una cuerda de su afinación.
enum TuningZone {
  /// Dentro de la tolerancia.
  inTune,

  /// Casi: ajuste fino.
  near,

  /// Fuera de afinación.
  off,

  /// Muy lejos de la nota.
  far,
}

/// Qué hacer con la clavija para llegar a la nota.
enum TuneDirection {
  /// Subir el tono: apretar la cuerda.
  up,

  /// Bajar el tono: aflojar la cuerda.
  down,

  /// Nada: la cuerda está afinada.
  none,
}

/// Lectura de afinación de una cuerda concreta.
@immutable
class StringTuningReading {
  /// Crea la lectura.
  const StringTuningReading({
    required this.string,
    required this.frequency,
    required this.cents,
  });

  /// Cuerda identificada.
  final GuitarString string;

  /// Frecuencia detectada en Hz.
  final double frequency;

  /// Desviación respecto a la nota de la cuerda (negativo = floja).
  final double cents;

  /// Zona de afinación según las tolerancias.
  TuningZone get zone {
    final double distance = cents.abs();
    if (distance <= TuningTolerance.inTune) {
      return TuningZone.inTune;
    }
    if (distance <= TuningTolerance.near) {
      return TuningZone.near;
    }
    return distance <= TuningTolerance.off ? TuningZone.off : TuningZone.far;
  }

  /// `true` si la cuerda está dentro de la tolerancia.
  bool get isInTune => zone == TuningZone.inTune;

  /// Hacia dónde mover la clavija.
  TuneDirection get direction {
    if (isInTune) {
      return TuneDirection.none;
    }
    return cents < 0 ? TuneDirection.up : TuneDirection.down;
  }

  /// Copia la lectura con otra desviación y frecuencia.
  StringTuningReading copyWith({double? frequency, double? cents}) =>
      StringTuningReading(
        string: string,
        frequency: frequency ?? this.frequency,
        cents: cents ?? this.cents,
      );

  @override
  String toString() =>
      'StringTuningReading(${string.label}, ${cents.toStringAsFixed(1)}¢)';
}
