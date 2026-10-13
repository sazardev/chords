import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';

/// Orden que la persona da a la app tocando una cuerda al aire.
///
/// Cada comando tiene su cuerda fija en todas las pantallas para que la mano
/// lo aprenda: el significado exacto lo pone la pantalla con su etiqueta
/// ("Continuar", "Jugar otra vez"…), pero la cuerda siempre es la misma. Las
/// cinco notas son distintas entre sí, así que basta la clase de tono; la
/// 1ª cuerda también vale para [next] porque suena el mismo Mi.
enum GuitarCommand {
  /// Seguir adelante: continuar, empezar, abrir (6ª cuerda, Mi).
  next(6),

  /// Repetir: reintentar, jugar otra vez (5ª cuerda, La).
  retry(5),

  /// Escuchar de nuevo la referencia (4ª cuerda, Re).
  listen(4),

  /// Saltar u otra opción (3ª cuerda, Sol).
  skip(3),

  /// Salir o volver atrás (2ª cuerda, Si).
  exit(2);

  /// Crea el comando asociado a una cuerda de la afinación estándar.
  const GuitarCommand(this.stringNumber);

  /// Número de la cuerda al aire que lo activa (1 = aguda … 6 = grave).
  final int stringNumber;

  /// Cuerda de la afinación estándar que lo activa.
  GuitarString get string => standardStringByNumber(stringNumber)!;

  /// Nota que suena al tocarla al aire (notación inglesa, p. ej. `E`).
  String get note => string.note;

  /// Clase de tono de la nota (0 = Do … 11 = Si).
  int get pitchClass => pitchClassOfNote(note);

  /// Comando cuya nota es la clase de tono [pitchClass]; `null` si ninguno.
  static GuitarCommand? ofPitchClass(int pitchClass) {
    for (final GuitarCommand command in GuitarCommand.values) {
      if (command.pitchClass == pitchClass) {
        return command;
      }
    }
    return null;
  }
}
