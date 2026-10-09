/// Raíz (tónica) de un acorde.
enum ChordRoot {
  /// Do (C).
  c('C', 'Do'),

  /// Do sostenido (C#).
  cSharp('C#', 'Do#'),

  /// Re (D).
  d('D', 'Re'),

  /// Re sostenido (D#).
  dSharp('D#', 'Re#'),

  /// Mi (E).
  e('E', 'Mi'),

  /// Fa (F).
  f('F', 'Fa'),

  /// Fa sostenido (F#).
  fSharp('F#', 'Fa#'),

  /// Sol (G).
  g('G', 'Sol'),

  /// Sol sostenido (G#).
  gSharp('G#', 'Sol#'),

  /// La (A).
  a('A', 'La'),

  /// La sostenido (A#).
  aSharp('A#', 'La#'),

  /// Si (B).
  b('B', 'Si');

  /// Crea una raíz con su nombre anglosajón y su nombre en español.
  const ChordRoot(this.name, this.displayName);

  /// Nombre anglosajón de la nota (p. ej. `C#`).
  final String name;

  /// Nombre en español de la nota (p. ej. `Do#`).
  final String displayName;

  /// Clase de tono (0 = Do, 11 = Si).
  int get pitchClass => index;

  /// Resuelve una raíz a partir de su nombre anglosajón.
  ///
  /// Devuelve `null` si el nombre no es válido.
  static ChordRoot? fromName(String name) {
    for (final ChordRoot root in ChordRoot.values) {
      if (root.name == name) {
        return root;
      }
    }
    return null;
  }
}
