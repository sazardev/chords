/// Formas extra de sextas y acordes con novena añadida: 6, m6, 6/9, add9 y
/// madd9.
library;

import '../chord_shape_spec.dart';
import 'shape_dsl.dart';

/// Formas movibles de sextas y novenas añadidas.
final List<MovableShapeSpec> kSixthAddedShapes = <MovableShapeSpec>[
  // Sexta.
  refShape('6', 'c6-shape', 'Forma de Do 6', 'x32210', 'C'),
  refShape('6', 'g6-shape', 'Forma de Sol 6', '320000', 'G'),
  refShape('6', 'd6-shape', 'Forma de Re 6', 'xx0202', 'D'),
  // Sexta menor.
  refShape('m6', 'e-m6-shape', 'Forma de Mi m6', '022020', 'E'),
  refShape('m6', 'd-m6-shape', 'Forma de Re m6', 'xx0201', 'D'),
  // Sexta con novena.
  refShape('69', 'c-69-shape', 'Forma de Do 6/9', 'x32233', 'C'),
  refShape('69', 'e-69-shape', 'Forma de Mi 6/9', '022122', 'E'),
  refShape('69', 'g-69-shape', 'Forma de Sol 6/9', '320200', 'G'),
  // Novena añadida.
  refShape('add9', 'c-add9-shape', 'Forma de Do add9', 'x32030', 'C'),
  refShape('add9', 'a-add9-shape', 'Forma de La add9', 'x02420', 'A'),
  refShape('add9', 'e-add9-shape', 'Forma de Mi add9', '022102', 'E'),
  refShape('add9', 'g-add9-shape', 'Forma de Sol add9', '320203', 'G'),
  refShape('add9', 'f-add9-shape', 'Forma de Fa add9', 'xx3213', 'F'),
  // Menor con novena añadida.
  refShape('madd9', 'a-madd9-shape', 'Forma de La madd9', 'x02410', 'A'),
  refShape('madd9', 'e-madd9-shape', 'Forma de Mi madd9', '024000', 'E'),
  refShape('madd9', 'c-madd9-shape', 'Forma de Do madd9', 'x3103x', 'C'),
];
