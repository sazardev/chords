import 'package:chords/domain/audio/entities/string_tuning.dart';

/// Suaviza las lecturas de afinación para que la aguja no salte.
///
/// Guarda las últimas desviaciones de la cuerda en curso y devuelve su
/// mediana, que descarta los valores extremos del ataque de la púa. Al
/// cambiar de cuerda empieza de cero.
class TuningSmoother {
  /// Crea el suavizador con una ventana de [window] lecturas.
  TuningSmoother({this.window = 5});

  /// Número de lecturas que se promedian.
  final int window;

  final List<double> _cents = <double>[];
  int? _currentString;

  /// Añade una lectura y devuelve la versión suavizada.
  StringTuningReading add(StringTuningReading reading) {
    if (_currentString != reading.string.number) {
      _cents.clear();
      _currentString = reading.string.number;
    }
    _cents.add(reading.cents);
    if (_cents.length > window) {
      _cents.removeAt(0);
    }
    return reading.copyWith(cents: _median(_cents));
  }

  /// Olvida el historial (p. ej. tras un silencio).
  void reset() {
    _cents.clear();
    _currentString = null;
  }

  double _median(List<double> values) {
    final List<double> sorted = List<double>.of(values)..sort();
    final int middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) {
      return sorted[middle];
    }
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }
}
