/// Opción del menú global de la guitarra y la nota que la elige.
///
/// Las opciones están en notas consecutivas a partir del Mi: en una misma
/// cuerda, el Mi al aire es la primera y cada traste que se sube pasa a la
/// siguiente. Así el menú se recorre «subiendo por el mástil» sin soltar la
/// guitarra. Solo cuenta la clase de tono, de modo que vale cualquier cuerda y
/// cualquier octava.
enum GuitarNavSlot {
  /// Ir al inicio (Mi, cuerda al aire).
  home(4),

  /// Ir al itinerario de aprendizaje (Fa, traste 1).
  learn(5),

  /// Ir a la biblioteca de acordes (Fa♯, traste 2).
  chords(6),

  /// Ir a los juegos (Sol, traste 3).
  game(7),

  /// Ir al afinador en vivo (Sol♯, traste 4).
  live(8),

  /// Ir a los ajustes (La, traste 5).
  settings(9),

  /// Ir al perfil (La♯, traste 6).
  profile(10),

  /// Volver a la pantalla anterior (Si, traste 7).
  back(11),

  /// Cerrar el menú y volver al foco de la pantalla (Do, traste 8).
  close(0),

  /// Apagar el modo guitarra (Do♯, traste 9).
  off(1);

  /// Crea la opción asociada a una clase de tono.
  const GuitarNavSlot(this.pitchClass);

  /// Clase de tono que la elige (0 = Do … 11 = Si).
  final int pitchClass;

  /// Traste en el que está la nota si se cuenta desde el Mi al aire (0-9).
  int get fretFromE => (pitchClass - home.pitchClass + 12) % 12;

  /// Opción cuya nota es la clase de tono [pitchClass]; `null` si ninguna.
  static GuitarNavSlot? ofPitchClass(int pitchClass) {
    for (final GuitarNavSlot slot in GuitarNavSlot.values) {
      if (slot.pitchClass == pitchClass) {
        return slot;
      }
    }
    return null;
  }
}
