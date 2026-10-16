/// Familia de una escala: de dónde sale y cómo suena.
enum ScaleFamily {
  /// La mayor y sus modos (dórica, frigia, lidia, mixolidia, eólica, locria).
  majorModes,

  /// Escalas menores: natural, armónica y melódica.
  minor,

  /// Modos de la menor armónica (frigia dominante, dórica #4…).
  harmonicModes,

  /// Modos de la menor melódica (lidia dominante, alterada…).
  melodicModes,

  /// Pentatónicas y escalas de blues.
  pentatonic,

  /// Escalas exóticas de siete o cinco notas (húngara, hirajoshi…).
  exotic,

  /// Escalas simétricas y de paso (tonos enteros, disminuida, bebop).
  symmetric,
}

/// Bloque del selector de escalas: agrupa las familias para que la lista no
/// sea interminable.
enum ScaleGroup {
  /// Mayor y sus modos.
  major,

  /// Menores y los modos de la armónica y la melódica.
  minor,

  /// Pentatónicas y blues.
  pentatonic,

  /// Exóticas y simétricas.
  exotic;

  /// Bloque al que pertenece una familia.
  static ScaleGroup of(ScaleFamily family) => switch (family) {
    ScaleFamily.majorModes => ScaleGroup.major,
    ScaleFamily.minor ||
    ScaleFamily.harmonicModes ||
    ScaleFamily.melodicModes => ScaleGroup.minor,
    ScaleFamily.pentatonic => ScaleGroup.pentatonic,
    ScaleFamily.exotic || ScaleFamily.symmetric => ScaleGroup.exotic,
  };
}
