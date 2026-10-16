/// Formas de dominantes suspendidos y alterados: 7sus4, 9sus4, 7b9, 7#9,
/// 7#5, 7b5 y maj7#5.
library;

import '../chord_shape_spec.dart';
import 'shape_dsl.dart';

/// Formas movibles de acordes suspendidos con séptima y alterados.
final List<MovableShapeSpec> kSuspendedAlteredShapes = <MovableShapeSpec>[
  // Séptima suspendida.
  refShape('7sus4', 'e-7sus4-shape', 'Forma de Mi 7sus4', '020200', 'E'),
  refShape('7sus4', 'a-7sus4-shape', 'Forma de La 7sus4', 'x02030', 'A'),
  refShape('7sus4', 'd-7sus4-shape', 'Forma de Re 7sus4', 'xx0213', 'D'),
  refShape('7sus4', 'g-7sus4-shape', 'Forma de Sol 7sus4', '330011', 'G'),
  // Novena suspendida.
  refShape('9sus4', 'c-9sus4-shape', 'Forma de Do 9sus4', 'x3333x', 'C'),
  refShape('9sus4', 'e-9sus4-shape', 'Forma de Mi 9sus4', '020202', 'E'),
  // Dominante con novena menor.
  refShape('7b9', 'c-7b9-shape', 'Forma de Do 7b9', 'x3232x', 'C'),
  refShape('7b9', 'e-7b9-shape', 'Forma de Mi 7b9', '020101', 'E'),
  refShape('7b9', 'a-7b9-shape', 'Forma de La 7b9', 'x02323', 'A'),
  // Dominante con novena aumentada.
  refShape('7s9', 'c-7s9-shape', 'Forma de Do 7#9', 'x3234x', 'C'),
  refShape('7s9', 'e-7s9-shape', 'Forma de Mi 7#9', '020133', 'E'),
  // Dominante con quinta aumentada y bemol.
  refShape('7s5', 'e-7s5-shape', 'Forma de Mi 7#5', '0x0110', 'E'),
  refShape('7s5', 'a-7s5-shape', 'Forma de La 7#5', 'x0x021', 'A'),
  refShape('7b5', 'c-7b5-shape', 'Forma de Do 7b5', 'x3435x', 'C'),
  refShape('7b5', 'e-7b5-shape', 'Forma de Mi 7b5', '010130', 'E'),
  // Séptima mayor aumentada y séptima mayor con oncena aumentada.
  refShape('maj7s5', 'c-maj7s5-shape', 'Forma de Do maj7#5', 'x32100', 'C'),
  refShape('maj7s11', 'c-maj7s11-shape', 'Forma de Do maj7#11', 'x32002', 'C'),
];
