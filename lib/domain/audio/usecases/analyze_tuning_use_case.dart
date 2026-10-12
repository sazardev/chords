import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/domain/audio/services/pitch_math.dart';

/// Caso de uso: averigua qué cuerda suena y cuánto le falta o le sobra.
///
/// A diferencia de buscar la nota cromática más cercana, compara contra las
/// cuerdas reales de la guitarra, así una cuerda muy floja (más de medio
/// tono) sigue identificándose bien. Tolera los errores de octava del
/// detector, frecuentes en las cuerdas graves.
class AnalyzeTuningUseCase {
  /// Crea el caso de uso con la afinación indicada (estándar por defecto).
  const AnalyzeTuningUseCase({this.tuning = kStandardTuning});

  /// Cuerdas contra las que se compara.
  final List<GuitarString> tuning;

  /// Máxima desviación para atribuir una nota a una cuerda concreta.
  static const double _maxDistance = 300;

  /// Coste en cents de aceptar una nota una octava desplazada.
  static const double _octavePenalty = 40;

  /// Analiza [frequency].
  ///
  /// Con [target] mide contra esa cuerda (modo manual); sin él, elige la
  /// cuerda más cercana (modo automático). Devuelve `null` si la nota no se
  /// parece a ninguna cuerda.
  StringTuningReading? call(double frequency, {GuitarString? target}) {
    if (frequency <= 0 || !frequency.isFinite) {
      return null;
    }
    if (target != null) {
      return _measure(frequency, target);
    }
    StringTuningReading? best;
    double bestScore = double.infinity;
    for (final GuitarString string in tuning) {
      final StringTuningReading? reading = _measure(frequency, string);
      if (reading == null) {
        continue;
      }
      final double score = _score(frequency, reading);
      if (score < bestScore) {
        bestScore = score;
        best = reading;
      }
    }
    return best;
  }

  StringTuningReading? _measure(double frequency, GuitarString string) {
    final double cents = foldOctaveError(
      centsBetween(frequency, string.frequency),
    );
    if (cents.abs() > _maxDistance) {
      return null;
    }
    return StringTuningReading(
      string: string,
      frequency: frequency,
      cents: cents,
    );
  }

  /// Menor es mejor: distancia en cents, penalizando la octava desplazada y
  /// desempatando por cercanía real en Hz.
  double _score(double frequency, StringTuningReading reading) {
    final double raw = centsBetween(frequency, reading.string.frequency);
    final double folded = raw - reading.cents;
    final double penalty = folded == 0 ? 0 : _octavePenalty;
    final double hzGap =
        (frequency - reading.string.frequency).abs() / frequency;
    return reading.cents.abs() + penalty + hzGap;
  }
}
