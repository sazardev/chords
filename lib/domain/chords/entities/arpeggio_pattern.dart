/// Patrón de arpegio aplicable a una posición de acorde.
class ArpeggioPattern {
  /// Crea un patrón de arpegio.
  const ArpeggioPattern({
    required this.id,
    required this.label,
    required this.stringOrder,
    required this.intervalMs,
    required this.difficulty,
  });

  /// Identificador estable del patrón.
  final String id;

  /// Nombre visible del patrón.
  final String label;

  /// Orden de cuerdas (0 = sexta cuerda) que se pulsa.
  final List<int> stringOrder;

  /// Milisegundos entre notas.
  final int intervalMs;

  /// Dificultad del patrón (1-5).
  final int difficulty;

  /// Arpegio ascendente clásico.
  static const ArpeggioPattern ascending = ArpeggioPattern(
    id: 'asc',
    label: 'Ascendente',
    stringOrder: <int>[5, 4, 3, 2, 1, 0],
    intervalMs: 150,
    difficulty: 1,
  );

  /// Arpegio descendente.
  static const ArpeggioPattern descending = ArpeggioPattern(
    id: 'desc',
    label: 'Descendente',
    stringOrder: <int>[0, 1, 2, 3, 4, 5],
    intervalMs: 150,
    difficulty: 1,
  );

  /// Arpegio alterno de ida y vuelta.
  static const ArpeggioPattern alternating = ArpeggioPattern(
    id: 'alt',
    label: 'Alterno',
    stringOrder: <int>[5, 3, 2, 3, 5, 2],
    intervalMs: 130,
    difficulty: 2,
  );

  /// Bajos con cejilla (patrón tipo fingerstyle).
  static const ArpeggioPattern fingerstyle = ArpeggioPattern(
    id: 'fingerstyle',
    label: 'Fingerstyle',
    stringOrder: <int>[0, 5, 2, 1, 3, 4],
    intervalMs: 125,
    difficulty: 3,
  );

  /// Todos los patrones disponibles.
  static const List<ArpeggioPattern> all = <ArpeggioPattern>[
    ascending,
    descending,
    alternating,
    fingerstyle,
  ];
}
