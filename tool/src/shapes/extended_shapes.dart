/// Formas de acordes extendidos: 9, m9, maj9, 11, m11 y 13.
library;

import '../chord_shape_spec.dart';
import 'shape_dsl.dart';

/// Formas movibles de novenas, oncenas y trecenas.
final List<MovableShapeSpec> kExtendedShapes = <MovableShapeSpec>[
  // Novena de dominante.
  refShape('9', 'c9-shape', 'Forma de Do 9', 'x3233x', 'C'),
  refShape('9', 'c9-open-shape', 'Forma de Do 9 (abierta)', 'x32330', 'C'),
  // Novena menor.
  refShape('m9', 'c-m9-shape', 'Forma de Do m9', 'x3133x', 'C'),
  refShape('m9', 'e-m9-shape', 'Forma de Mi m9', '020002', 'E'),
  refShape('m9', 'a-m9-shape', 'Forma de La m9', 'x05500', 'A'),
  // Novena mayor.
  refShape('maj9', 'c-maj9-shape', 'Forma de Do maj9', 'x32430', 'C'),
  refShape('maj9', 'e-maj9-shape', 'Forma de Mi maj9', '021102', 'E'),
  // Oncena de dominante y menor.
  refShape('11', 'c11-shape', 'Forma de Do 11', 'x33311', 'C'),
  refShape('m11', 'e-m11-shape', 'Forma de Mi m11', '000000', 'E'),
  refShape('m11', 'a-m11-shape', 'Forma de La m11', 'x00010', 'A'),
  // Trecena de dominante.
  refShape('13', 'c13-shape', 'Forma de Do 13', 'x32355', 'C'),
  refShape('13', 'e13-shape', 'Forma de Mi 13', '020120', 'E'),
  refShape('13', 'a13-shape', 'Forma de La 13', 'x02022', 'A'),
];
