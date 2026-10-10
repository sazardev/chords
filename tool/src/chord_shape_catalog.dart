/// Catálogo de formas de acorde movibles para guitararra.
///
/// Cada forma define los trastes relativos al cejillo (barre), la cuerda donde
/// vive la raíz y la digitación en posición abierta y con cejillo. El generador
/// transpone estas formas a las 12 raíces para construir el banco extenso.
///
/// Las formas viven en un archivo por cuerda de anclaje para que cada catálogo
/// siga siendo pequeño y revisable; aquí solo se agrupan.
library;

import 'chord_shape_spec.dart';
import 'chord_shapes_fifth_string.dart';
import 'chord_shapes_fourth_string.dart';
import 'chord_shapes_sixth_string.dart';

/// Todas las formas movibles soportadas por el generador.
const List<MovableShapeSpec> kMovableShapes = <MovableShapeSpec>[
  ...kSixthStringShapes,
  ...kFifthStringShapes,
  ...kFourthStringShapes,
];

/// Grupos de cuerdas sobre los que se buscan tríadas e inversiones.
const List<List<int>> kTriadStringSets = <List<int>>[
  <int>[1, 2, 3], // A-D-G
  <int>[2, 3, 4], // D-G-B
  <int>[3, 4, 5], // G-B-e
];
