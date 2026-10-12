import 'package:chords/domain/audio/services/pitch_math.dart';

/// Puerta que convierte un flujo de lecturas en notas pulsadas.
///
/// Exige varias lecturas seguidas y estables antes de dar una nota por buena
/// (así se ignora el ruido del ataque de la púa) y no vuelve a disparar
/// mientras la misma nota siga sonando. Se rearma al cambiar de nota o con
/// [reset], que se llama tras un silencio.
class NoteOnsetGate {
  /// Crea la puerta.
  NoteOnsetGate({this.requiredReadings = 3, this.stabilityCents = 25});

  /// Lecturas estables consecutivas necesarias.
  final int requiredReadings;

  /// Variación máxima entre lecturas para considerarlas la misma nota.
  final double stabilityCents;

  /// Distancia a partir de la cual una nota ya disparada se considera nueva.
  static const double _newNoteCents = 60;

  final List<double> _candidates = <double>[];
  double? _fired;

  /// Procesa una lectura; devuelve la frecuencia cuando hay una nota nueva.
  double? feed(double frequency) {
    final double? fired = _fired;
    if (fired != null) {
      if (centsBetween(frequency, fired).abs() <= _newNoteCents) {
        return null;
      }
      _fired = null;
      _candidates.clear();
    }
    if (_candidates.isNotEmpty &&
        centsBetween(frequency, _candidates.last).abs() > stabilityCents) {
      _candidates.clear();
    }
    _candidates.add(frequency);
    if (_candidates.length < requiredReadings) {
      return null;
    }
    _fired = frequency;
    _candidates.clear();
    return frequency;
  }

  /// Rearma la puerta para volver a detectar la misma nota.
  void reset() {
    _fired = null;
    _candidates.clear();
  }
}
