import 'package:chords/domain/audio/entities/mic_status.dart';

/// Lo que oye el micrófono, expresado en notas de acorde.
///
/// Es la costura entre el juego "cambios de acorde" y la detección: hoy la
/// implementa un oyente monofónico (una nota cada vez, acumuladas por el
/// juez) y un detector polifónico puede sustituirla sin tocar el juego, porque
/// solo promete "estas clases de tono suenan ahora".
abstract interface class ChordHearing {
  /// Abre el micrófono y empieza a oír; devuelve su estado.
  Future<MicStatus> open();

  /// Clases de tono (0 = Do … 11 = Si) que se oyen en cada instante.
  ///
  /// Cada evento es el conjunto detectado en ese momento, no el acumulado.
  Stream<Set<int>> get detections;

  /// Nivel de entrada del micrófono (0-1).
  Stream<double> get levels;

  /// Deja de oír y libera el micrófono.
  Future<void> close();
}
