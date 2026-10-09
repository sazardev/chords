import 'package:meta/meta.dart';

/// Información del cejillo (barre) de una posición de acorde.
@immutable
class BarreInfo {
  /// Crea la información de cejillo.
  const BarreInfo({
    required this.fret,
    required this.fromString,
    required this.lastString,
  });

  /// Traste donde se coloca el cejillo.
  final int fret;

  /// Primera cuerda cejillada (0 = sexta).
  final int fromString;

  /// Última cuerda cejillada (5 = primera).
  final int lastString;

  /// Número de cuerdas cubiertas por el cejillo.
  int get stringCount => lastString - fromString + 1;

  @override
  bool operator ==(Object other) =>
      other is BarreInfo &&
      other.fret == fret &&
      other.fromString == fromString &&
      other.lastString == lastString;

  @override
  int get hashCode => Object.hash(fret, fromString, lastString);

  @override
  String toString() =>
      'BarreInfo(fret: $fret, strings: $fromString-$lastString)';
}
