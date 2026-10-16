import 'package:chords/domain/chords/entities/chord_inversion.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/chord_variant_composer.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:chords/domain/chords/entities/variant_tags.dart';
import 'package:test/test.dart';

/// Identificadores, nombres y etiquetas de las posiciones del banco.
void main() {
  group('VariantIdentity', () {
    test('lee la forma y el traste de un identificador de forma', () {
      final VariantIdentity id = VariantIdentity.parse('e-maj7-shape-8');
      expect(id.kind, VariantKind.shape);
      expect(id.key, 'e-maj7-shape');
      expect(id.isShape, isTrue);
    });

    test('lee el tipo, las cuerdas y el bajo de un voicing buscado', () {
      final VariantIdentity id = VariantIdentity.parse('drop2-4321-b3');
      expect(id.kind, VariantKind.drop2);
      expect(id.strings, <int>[4, 3, 2, 1]);
      expect(id.bassInterval, 3);
      expect(VariantIdentity.parse('triad-321-b0').kind, VariantKind.triad);
      expect(VariantIdentity.parse('shell-643-b0').kind, VariantKind.shell);
      expect(
        VariantIdentity.parse('voicing-5432-b7').kind,
        VariantKind.voicing,
      );
    });
  });

  group('inversiones', () {
    test('según la nota del bajo', () {
      expect(inversionOf(ChordQuality.major, 0), ChordInversion.root);
      expect(inversionOf(ChordQuality.major, 4), ChordInversion.first);
      expect(inversionOf(ChordQuality.minor, 3), ChordInversion.first);
      expect(inversionOf(ChordQuality.major, 7), ChordInversion.second);
      expect(inversionOf(ChordQuality.seven, 10), ChordInversion.third);
      expect(inversionOf(ChordQuality.sixth, 9), ChordInversion.third);
      expect(inversionOf(ChordQuality.ninth, 2), ChordInversion.other);
      expect(degreeOf(ChordQuality.ninth, 2), '9');
      expect(degreeOf(ChordQuality.halfDiminished, 6), 'b5');
    });
  });

  group('composeVariant', () {
    ChordVariant compose(String id, List<int> frets) => composeVariant(
      chordId: 'C-maj',
      root: ChordRoot.c,
      quality: ChordQuality.major,
      id: id,
      frets: frets,
      fingers: const <int>[0, 0, 0, 0, 0, 0],
      difficulty: 2,
      shapeLabels: const <String, String>{
        'c-shape': 'Forma de Do',
        'e-shape': 'Forma de Mi',
      },
    );

    test(
      'deduce las notas, el nombre y las etiquetas de una forma abierta',
      () {
        final ChordVariant v = compose('c-shape-0', const <int>[
          -1,
          3,
          2,
          0,
          1,
          0,
        ]);
        expect(v.id, 'C-maj-c-shape-0');
        expect(v.positionLabel, 'Forma de Do');
        expect(v.notes, <String>['C', 'E', 'G']);
        expect(v.tags, <String>['open']);
        expect(v.kind, VariantKind.shape);
        expect(v.isShape, isTrue);
      },
    );

    test('añade el traste cuando no hay cuerdas al aire', () {
      final ChordVariant v = compose('e-shape-8', const <int>[
        8,
        10,
        10,
        9,
        8,
        8,
      ]);
      expect(v.positionLabel, 'Forma de Mi · traste 8');
      expect(v.tags, containsAll(<String>['movable', 'high-position']));
    });

    test('una tríada en inversión: nombre y etiquetas', () {
      final ChordVariant v = compose('triad-432-b4', const <int>[
        -1,
        -1,
        2,
        0,
        1,
        -1,
      ]);
      expect(v.positionLabel, 'Tríada cuerdas 4-3-2 · 1ª inversión');
      expect(v.tags, containsAll(<String>['triad', 'inversion', 'open']));
      expect(v.isShape, isFalse);
    });

    test('un shell nombra los grados de grave a agudo', () {
      final ChordVariant v = composeVariant(
        chordId: 'C-7',
        root: ChordRoot.c,
        quality: ChordQuality.seven,
        id: 'shell-532-b0',
        frets: const <int>[-1, 3, -1, 3, 5, -1],
        fingers: const <int>[0, 1, 0, 2, 3, 0],
        difficulty: 2,
        shapeLabels: const <String, String>{},
      );
      expect(v.positionLabel, 'Shell 1-b7-3 · cuerdas 5-3-2');
      expect(v.tags, contains('shell'));
    });

    test('drop 2 y drop 3 llevan su etiqueta', () {
      expect(
        variantTags(
          identity: VariantIdentity.parse('drop2-4321-b0'),
          rootPitchClass: 0,
          frets: const <int>[-1, -1, 10, 9, 8, 8],
          hasBarre: true,
        ),
        containsAll(<String>['voicing', 'drop2', 'barre']),
      );
      expect(
        variantTags(
          identity: VariantIdentity.parse('drop3-5432-b0'),
          rootPitchClass: 0,
          frets: const <int>[-1, 3, 5, 4, 5, -1],
          hasBarre: false,
        ),
        containsAll(<String>['voicing', 'drop3', 'movable']),
      );
    });
  });
}
