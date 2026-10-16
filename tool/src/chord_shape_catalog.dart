/// Catálogo de formas de acorde movibles para guitarra.
///
/// Cada forma define los trastes relativos al cejillo (barre), la cuerda donde
/// vive la raíz y la digitación en posición abierta y con cejillo. El generador
/// transpone estas formas a las 12 raíces para construir el banco extenso.
///
/// Las formas viven en un archivo por familia (o por cuerda de anclaje, las
/// clásicas) para que cada catálogo siga siendo pequeño y revisable; aquí solo
/// se agrupan.
library;

import 'chord_shape_spec.dart';
import 'chord_shapes_fifth_string.dart';
import 'chord_shapes_fourth_string.dart';
import 'chord_shapes_sixth_string.dart';
import 'shapes/extended_shapes.dart';
import 'shapes/seventh_shapes.dart';
import 'shapes/sixth_added_shapes.dart';
import 'shapes/suspended_altered_shapes.dart';
import 'shapes/triad_shapes.dart';

/// Todas las formas movibles soportadas por el generador.
final List<MovableShapeSpec> kMovableShapes = <MovableShapeSpec>[
  ...kSixthStringShapes,
  ...kFifthStringShapes,
  ...kFourthStringShapes,
  ...kTriadShapes,
  ...kSeventhShapes,
  ...kSixthAddedShapes,
  ...kExtendedShapes,
  ...kSuspendedAlteredShapes,
];
