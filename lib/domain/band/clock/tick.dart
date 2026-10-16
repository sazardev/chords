import 'package:meta/meta.dart';

/// Un disparo del planificador: una semicorchea de la rejilla.
@immutable
class Tick {
  /// Crea el disparo.
  const Tick({
    required this.index,
    required this.scheduledAt,
    required this.lateness,
  });

  /// Número de semicorchea desde el principio (0, 1, 2…).
  final int index;

  /// Instante musical exacto del golpe (ya con el swing), medido desde el
  /// origen del reloj.
  final Duration scheduledAt;

  /// Cuánto se retrasó el aviso respecto a lo planificado.
  ///
  /// Con 0 el aviso llegó a su hora; un retraso grande (el sistema estuvo
  /// ocupado) indica que ese golpe ya pasó y es mejor no tocarlo.
  final Duration lateness;

  /// Posición dentro del pulso (0-3): 0 en el pulso, 2 en la corchea
  /// siguiente.
  int get beatPosition => index % 4;

  /// `true` si el aviso llegó tan tarde que el golpe no debe sonar.
  bool isStale(Duration tolerance) => lateness > tolerance;
}
