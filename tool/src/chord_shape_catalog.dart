/// Catálogo de formas de acorde movibles para guitararra.
///
/// Cada forma define los trastes relativos al cejillo (barre), la cuerda donde
/// vive la raíz y la digitación en posición abierta y con cejillo. El generador
/// transpone estas formas a las 12 raíces para construir el banco extenso.
library;

/// Definición de una forma movible de acorde.
class MovableShapeSpec {
  /// Crea una forma movible.
  const MovableShapeSpec({
    required this.qualityId,
    required this.id,
    required this.rootString,
    required this.positionLabel,
    required this.fretOffsets,
    required this.fingersOpen,
    required this.fingersBarre,
    required this.difficultyOpen,
    required this.difficultyBarre,
    required this.tags,
  });

  /// Identificador de la calidad de acorde (coincide con `ChordQuality.id`).
  final String qualityId;

  /// Identificador estable de la forma (p. ej. `e-shape`).
  final String id;

  /// Índice de cuerda (0 = sexta) donde vive la nota raíz al aire.
  final int rootString;

  /// Etiqueta legible de la posición (p. ej. `Forma de Mi`).
  final String positionLabel;

  /// Trastes relativos al cejillo por cuerda; `null` = cuerda muda.
  final List<int?> fretOffsets;

  /// Digitación cuando el cejillo está en el traste 0 (posición abierta).
  final List<int> fingersOpen;

  /// Digitación cuando el cejillo está en un traste > 0.
  final List<int> fingersBarre;

  /// Dificultad asignada en posición abierta (1-5).
  final int difficultyOpen;

  /// Dificultad asignada con cejillo (1-5).
  final int difficultyBarre;

  /// Etiquetas descriptivas de la forma.
  final List<String> tags;
}

/// Todas las formas movibles soportadas por el generador.
const List<MovableShapeSpec> kMovableShapes = <MovableShapeSpec>[
  // Formas ancladas en la sexta cuerda (Mi).
  MovableShapeSpec(
    qualityId: 'maj',
    id: 'e-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi',
    fretOffsets: <int?>[0, 2, 2, 1, 0, 0],
    fingersOpen: <int>[0, 2, 3, 1, 0, 0],
    fingersBarre: <int>[1, 3, 4, 2, 1, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable', 'barre-shape'],
  ),
  MovableShapeSpec(
    qualityId: 'min',
    id: 'e-shape-min',
    rootString: 0,
    positionLabel: 'Forma de Mi menor',
    fretOffsets: <int?>[0, 2, 2, 0, 0, 0],
    fingersOpen: <int>[0, 2, 3, 0, 0, 0],
    fingersBarre: <int>[1, 3, 4, 1, 1, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable', 'barre-shape'],
  ),
  MovableShapeSpec(
    qualityId: '7',
    id: 'e7-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi 7',
    fretOffsets: <int?>[0, 2, 0, 1, 0, 0],
    fingersOpen: <int>[0, 2, 0, 3, 0, 0],
    fingersBarre: <int>[1, 3, 1, 2, 1, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable', 'dominant'],
  ),
  MovableShapeSpec(
    qualityId: 'm7',
    id: 'e-m7-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi m7',
    fretOffsets: <int?>[0, 2, 0, 0, 0, 0],
    fingersOpen: <int>[0, 2, 0, 0, 0, 0],
    fingersBarre: <int>[1, 3, 1, 1, 1, 1],
    difficultyOpen: 2,
    difficultyBarre: 3,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: 'maj7',
    id: 'e-maj7-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi maj7',
    fretOffsets: <int?>[0, 2, 1, 1, 0, 0],
    fingersOpen: <int>[0, 3, 1, 2, 0, 0],
    fingersBarre: <int>[1, 3, 2, 3, 1, 1],
    difficultyOpen: 3,
    difficultyBarre: 4,
    tags: <String>['movable', 'jazz'],
  ),
  MovableShapeSpec(
    qualityId: 'sus4',
    id: 'e-sus4-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi sus4',
    fretOffsets: <int?>[0, 2, 2, 2, 0, 0],
    fingersOpen: <int>[0, 1, 1, 2, 0, 0],
    fingersBarre: <int>[1, 1, 1, 2, 1, 1],
    difficultyOpen: 2,
    difficultyBarre: 3,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: 'sus2',
    id: 'e-sus2-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi sus2',
    fretOffsets: <int?>[0, 2, 4, 4, 0, 0],
    fingersOpen: <int>[0, 2, 3, 4, 0, 0],
    fingersBarre: <int>[1, 3, 3, 4, 1, 1],
    difficultyOpen: 3,
    difficultyBarre: 4,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: '5',
    id: 'e-power',
    rootString: 0,
    positionLabel: 'Power cuerda 6',
    fretOffsets: <int?>[0, 2, 2, null, null, null],
    fingersOpen: <int>[0, 1, 1, 0, 0, 0],
    fingersBarre: <int>[1, 1, 1, 0, 0, 0],
    difficultyOpen: 1,
    difficultyBarre: 2,
    tags: <String>['movable', 'power'],
  ),
  MovableShapeSpec(
    qualityId: '6',
    id: 'e6-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi 6',
    fretOffsets: <int?>[0, 2, 2, 1, 2, 0],
    fingersOpen: <int>[0, 2, 3, 1, 4, 0],
    fingersBarre: <int>[1, 3, 4, 2, 4, 1],
    difficultyOpen: 3,
    difficultyBarre: 4,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: '9',
    id: 'e9-shape',
    rootString: 0,
    positionLabel: 'Forma de Mi 9',
    fretOffsets: <int?>[0, 2, 0, 1, 0, 2],
    fingersOpen: <int>[0, 3, 0, 1, 0, 2],
    fingersBarre: <int>[1, 3, 1, 2, 1, 3],
    difficultyOpen: 3,
    difficultyBarre: 4,
    tags: <String>['movable', 'jazz'],
  ),
  // Formas de La (root on the 5th string).
  MovableShapeSpec(
    qualityId: 'maj',
    id: 'a-shape',
    rootString: 1,
    positionLabel: 'Forma de La',
    fretOffsets: <int?>[null, 0, 2, 2, 2, 0],
    fingersOpen: <int>[0, 0, 1, 2, 3, 0],
    fingersBarre: <int>[0, 1, 1, 3, 3, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable', 'barre-shape'],
  ),
  MovableShapeSpec(
    qualityId: 'min',
    id: 'a-shape-min',
    rootString: 1,
    positionLabel: 'Forma de La menor',
    fretOffsets: <int?>[null, 0, 2, 2, 1, 0],
    fingersOpen: <int>[0, 0, 2, 3, 1, 0],
    fingersBarre: <int>[0, 1, 3, 4, 2, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable', 'barre-shape'],
  ),
  MovableShapeSpec(
    qualityId: '7',
    id: 'a7-shape',
    rootString: 1,
    positionLabel: 'Forma de La 7',
    fretOffsets: <int?>[null, 0, 2, 0, 2, 0],
    fingersOpen: <int>[0, 0, 2, 0, 3, 0],
    fingersBarre: <int>[0, 1, 2, 1, 3, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable', 'dominant'],
  ),
  MovableShapeSpec(
    qualityId: 'm7',
    id: 'a-m7-shape',
    rootString: 1,
    positionLabel: 'Forma de La m7',
    fretOffsets: <int?>[null, 0, 2, 0, 1, 0],
    fingersOpen: <int>[0, 0, 2, 0, 1, 0],
    fingersBarre: <int>[0, 1, 2, 1, 2, 1],
    difficultyOpen: 1,
    difficultyBarre: 3,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: 'maj7',
    id: 'a-maj7-shape',
    rootString: 1,
    positionLabel: 'Forma de La maj7',
    fretOffsets: <int?>[null, 0, 2, 1, 2, 0],
    fingersOpen: <int>[0, 0, 2, 1, 3, 0],
    fingersBarre: <int>[0, 1, 3, 2, 3, 1],
    difficultyOpen: 2,
    difficultyBarre: 4,
    tags: <String>['movable', 'jazz'],
  ),
  MovableShapeSpec(
    qualityId: 'sus4',
    id: 'a-sus4-shape',
    rootString: 1,
    positionLabel: 'Forma de La sus4',
    fretOffsets: <int?>[null, 0, 2, 2, 3, 0],
    fingersOpen: <int>[0, 0, 1, 2, 3, 0],
    fingersBarre: <int>[0, 1, 2, 3, 4, 1],
    difficultyOpen: 2,
    difficultyBarre: 3,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: 'sus2',
    id: 'a-sus2-shape',
    rootString: 1,
    positionLabel: 'Forma de La sus2',
    fretOffsets: <int?>[null, 0, 2, 2, 0, 0],
    fingersOpen: <int>[0, 0, 1, 2, 0, 0],
    fingersBarre: <int>[0, 1, 1, 2, 1, 1],
    difficultyOpen: 2,
    difficultyBarre: 3,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: '5',
    id: 'a-power',
    rootString: 1,
    positionLabel: 'Power cuerda 5',
    fretOffsets: <int?>[null, 0, 2, 2, null, null],
    fingersOpen: <int>[0, 0, 1, 1, 0, 0],
    fingersBarre: <int>[0, 1, 1, 1, 0, 0],
    difficultyOpen: 1,
    difficultyBarre: 2,
    tags: <String>['movable', 'power'],
  ),
  MovableShapeSpec(
    qualityId: '6',
    id: 'a6-shape',
    rootString: 1,
    positionLabel: 'Forma de La 6',
    fretOffsets: <int?>[null, 0, 2, 2, 2, 2],
    fingersOpen: <int>[0, 0, 1, 2, 3, 4],
    fingersBarre: <int>[0, 1, 1, 2, 3, 4],
    difficultyOpen: 2,
    difficultyBarre: 4,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: 'm6',
    id: 'a-m6-shape',
    rootString: 1,
    positionLabel: 'Forma de La m6',
    fretOffsets: <int?>[null, 0, 2, 2, 1, 2],
    fingersOpen: <int>[0, 0, 2, 3, 1, 4],
    fingersBarre: <int>[0, 1, 3, 4, 2, 3],
    difficultyOpen: 3,
    difficultyBarre: 4,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: '9',
    id: 'a9-shape',
    rootString: 1,
    positionLabel: 'Forma de La 9',
    fretOffsets: <int?>[null, 0, 2, 4, 2, 3],
    fingersOpen: <int>[0, 0, 1, 3, 2, 4],
    fingersBarre: <int>[0, 1, 1, 3, 1, 2],
    difficultyOpen: 4,
    difficultyBarre: 5,
    tags: <String>['movable', 'jazz'],
  ),
  // Formas de Re (root on the 4th string).
  MovableShapeSpec(
    qualityId: 'maj',
    id: 'd-shape',
    rootString: 2,
    positionLabel: 'Forma de Re',
    fretOffsets: <int?>[null, null, 0, 2, 3, 2],
    fingersOpen: <int>[0, 0, 0, 1, 3, 2],
    fingersBarre: <int>[0, 0, 1, 3, 4, 2],
    difficultyOpen: 2,
    difficultyBarre: 4,
    tags: <String>['movable', 'upper'],
  ),
  MovableShapeSpec(
    qualityId: 'min',
    id: 'd-shape-min',
    rootString: 2,
    positionLabel: 'Forma de Re menor',
    fretOffsets: <int?>[null, null, 0, 2, 3, 1],
    fingersOpen: <int>[0, 0, 0, 2, 3, 1],
    fingersBarre: <int>[0, 0, 1, 2, 4, 1],
    difficultyOpen: 2,
    difficultyBarre: 4,
    tags: <String>['movable', 'upper'],
  ),
  MovableShapeSpec(
    qualityId: 'sus4',
    id: 'd-sus4-shape',
    rootString: 2,
    positionLabel: 'Forma de Re sus4',
    fretOffsets: <int?>[null, null, 0, 2, 3, 3],
    fingersOpen: <int>[0, 0, 0, 1, 3, 4],
    fingersBarre: <int>[0, 0, 1, 2, 3, 4],
    difficultyOpen: 2,
    difficultyBarre: 4,
    tags: <String>['movable', 'upper'],
  ),
  MovableShapeSpec(
    qualityId: 'm7',
    id: 'd-m7-shape',
    rootString: 2,
    positionLabel: 'Forma de Re m7',
    fretOffsets: <int?>[null, null, 0, 2, 1, 1],
    fingersOpen: <int>[0, 0, 0, 2, 1, 1],
    fingersBarre: <int>[0, 0, 1, 3, 1, 2],
    difficultyOpen: 3,
    difficultyBarre: 5,
    tags: <String>['movable', 'jazz'],
  ),
  // Formas de Do y Sol (raíz con offset sobre cuerdas intermedias).
  MovableShapeSpec(
    qualityId: 'maj',
    id: 'c-shape',
    rootString: 1,
    positionLabel: 'Forma de Do',
    fretOffsets: <int?>[null, 3, 2, 0, 1, 0],
    fingersOpen: <int>[0, 3, 2, 0, 1, 0],
    fingersBarre: <int>[0, 3, 2, 1, 4, 1],
    difficultyOpen: 1,
    difficultyBarre: 4,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: 'maj',
    id: 'g-shape',
    rootString: 0,
    positionLabel: 'Forma de Sol',
    fretOffsets: <int?>[3, 2, 0, 0, 0, 3],
    fingersOpen: <int>[2, 1, 0, 0, 0, 3],
    fingersBarre: <int>[3, 1, 1, 1, 1, 4],
    difficultyOpen: 2,
    difficultyBarre: 5,
    tags: <String>['movable'],
  ),
  MovableShapeSpec(
    qualityId: '7',
    id: 'g7-shape',
    rootString: 0,
    positionLabel: 'Forma de Sol 7',
    fretOffsets: <int?>[3, 2, 0, 0, 0, 1],
    fingersOpen: <int>[3, 2, 0, 0, 0, 1],
    fingersBarre: <int>[3, 1, 1, 1, 1, 1],
    difficultyOpen: 2,
    difficultyBarre: 4,
    tags: <String>['movable', 'dominant'],
  ),
];

/// Grupos de cuerdas sobre los que se buscan tríadas e inversiones.
const List<List<int>> kTriadStringSets = <List<int>>[
  <int>[1, 2, 3], // A-D-G
  <int>[2, 3, 4], // D-G-B
  <int>[3, 4, 5], // G-B-e
];
