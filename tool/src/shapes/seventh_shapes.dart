/// Formas extra de séptimas: 7, m7, maj7, mMaj7, m7b5 y dim7.
library;

import '../chord_shape_spec.dart';
import 'shape_dsl.dart';

/// Formas movibles de acordes de séptima.
final List<MovableShapeSpec> kSeventhShapes = <MovableShapeSpec>[
  // Dominante.
  refShape('7', 'c7-shape', 'Forma de Do 7', 'x32310', 'C'),
  refShape('7', 'b7-shape', 'Forma de Si 7', 'x21202', 'B'),
  refShape('7', 'd7-shape', 'Forma de Re 7', 'xx0212', 'D'),
  refShape('7', 'a7-barre-shape', 'Forma de La 7 (aguda)', 'x02223', 'A'),
  // Séptima menor.
  refShape('m7', 'a-m7-short', 'Forma de La m7 (corta)', 'x02213', 'A'),
  refShape('m7', 'e-m7-alt', 'Forma de Mi m7 (alt.)', '022030', 'E'),
  refShape('m7', 'g-m7-shape', 'Forma de Sol m7', '3x333x', 'G'),
  // Séptima mayor.
  refShape('maj7', 'c-maj7-shape', 'Forma de Do maj7', 'x32000', 'C'),
  refShape('maj7', 'd-maj7-shape', 'Forma de Re maj7', 'xx0222', 'D'),
  refShape('maj7', 'f-maj7-shape', 'Forma de Fa maj7', 'xx3210', 'F'),
  refShape('maj7', 'g-maj7-shape', 'Forma de Sol maj7', '320002', 'G'),
  // Menor con séptima mayor.
  refShape('mMaj7', 'e-mmaj7-shape', 'Forma de Mi mMaj7', '021000', 'E'),
  refShape('mMaj7', 'a-mmaj7-shape', 'Forma de La mMaj7', 'x02110', 'A'),
  refShape('mMaj7', 'd-mmaj7-shape', 'Forma de Re mMaj7', 'xx0221', 'D'),
  // Semidisminuido.
  refShape('m7b5', 'c-m7b5-shape', 'Forma de Do m7b5', 'x3434x', 'C'),
  refShape('m7b5', 'e-m7b5-shape', 'Forma de Mi m7b5', '010030', 'E'),
  refShape('m7b5', 'd-m7b5-shape', 'Forma de Re m7b5', 'xx0111', 'D'),
  refShape(
    'm7b5',
    'c-m7b5-sixth',
    'Forma de Do m7b5 (raíz en 6ª)',
    '8x887x',
    'C',
    base: 7,
  ),
  // Séptima disminuida.
  refShape('dim7', 'c-dim7-shape', 'Forma de Do dim7', 'x3424x', 'C'),
  refShape('dim7', 'd-dim7-shape', 'Forma de Re# dim7', 'xx1212', 'D#'),
];
