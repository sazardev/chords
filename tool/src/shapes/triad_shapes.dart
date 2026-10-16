/// Formas extra de triadas, suspendidas, dim, aug y power chords.
///
/// Completan las formas CAGED del catálogo base con las clásicas de Do, Sol y
/// Re, las variantes de cuatro cuerdas y las versiones en cuerdas agudas.
library;

import '../chord_shape_spec.dart';
import 'shape_dsl.dart';

/// Formas movibles de triadas y quintas.
final List<MovableShapeSpec> kTriadShapes = <MovableShapeSpec>[
  // Mayor: Sol con tres dedos y forma de Mi corta en cuerdas agudas.
  refShape('maj', 'g-shape-3', 'Forma de Sol (3 dedos)', '320033', 'G'),
  refShape('maj', 'f-shape-4', 'Forma de Fa corta', 'xx3211', 'F'),
  // Menor.
  refShape('min', 'g-shape-min', 'Forma de Sol menor', '3x033x', 'G'),
  refShape('min', 'c-shape-min', 'Forma de Do menor', 'x31013', 'C'),
  // Suspendidas.
  refShape('sus4', 'c-sus4', 'Forma de Do sus4', 'x33011', 'C'),
  refShape('sus4', 'g-sus4', 'Forma de Sol sus4', '330013', 'G'),
  refShape('sus2', 'd-sus2', 'Forma de Re sus2', 'xx0230', 'D'),
  refShape('sus2', 'c-sus2', 'Forma de Do sus2', 'x30033', 'C'),
  refShape('sus2', 'g-sus2', 'Forma de Sol sus2', '300033', 'G'),
  // Disminuida y aumentada.
  refShape('dim', 'a-dim', 'Forma de La dim', 'x0121x', 'A'),
  refShape('dim', 'e-dim', 'Forma de Mi dim', '0120xx', 'E'),
  refShape('dim', 'd-dim', 'Forma de Re dim', 'xx0131', 'D'),
  refShape('aug', 'e-aug', 'Forma de Mi aug', '032110', 'E'),
  refShape('aug', 'd-aug', 'Forma de Re aug', 'xx0332', 'D'),
  refShape('aug', 'a-aug', 'Forma de La aug', 'x03221', 'A'),
  // Power chords: cuarta cuerda, cuatro notas y octava arriba.
  refShape('5', 'd-power', 'Power cuerda 4', 'xx023x', 'D'),
  refShape('5', 'e-power-4', 'Power 4 cuerdas', '0224xx', 'E'),
  refShape('5', 'a-power-4', 'Power 4 cuerdas (5ª)', 'x0225x', 'A'),
  refShape('5', 'e-power-5', 'Power con octava (5 cuerdas)', '02245x', 'E'),
];
