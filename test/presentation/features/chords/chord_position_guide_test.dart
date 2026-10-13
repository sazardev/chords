import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_position_guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests de la tarjeta "Cómo colocarlo".
void main() {
  ChordVariant variant(List<int> frets, List<int> fingers) => ChordVariant(
    id: 'x',
    positionLabel: 'x',
    frets: frets,
    fingers: fingers,
    difficulty: Difficulty.medium,
  );

  Future<void> pump(WidgetTester tester, ChordVariant value) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(body: ChordPositionGuide(variant: value)),
        ),
      ),
    );
  }

  testWidgets('Do abierto: dedo por dedo, cuerdas al aire y muda', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      variant(const <int>[-1, 3, 2, 0, 1, 0], const <int>[0, 3, 2, 0, 1, 0]),
    );
    expect(find.text('Cómo colocarlo'), findsOne);
    expect(find.text('Posición abierta, junto a la cejuela'), findsOne);
    expect(find.text('Índice'), findsOne);
    expect(find.text('Traste 1 · cuerda 2ª'), findsOne);
    expect(find.text('Medio'), findsOne);
    expect(find.text('Anular'), findsOne);
    expect(find.text('Traste 3 · cuerda 5ª'), findsOne);
    expect(find.text('Toca: 5ª → 1ª'), findsOne);
    expect(find.text('Al aire: 3ª, 1ª'), findsOne);
    expect(find.text('No toques: 6ª'), findsOne);
  });

  testWidgets('Fa con cejillo: explica el cejillo del índice', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      variant(const <int>[1, 3, 3, 2, 1, 1], const <int>[1, 3, 4, 2, 1, 1]),
    );
    expect(find.text('Cejillo en el traste 1 · de la 6ª a la 1ª'), findsOne);
    expect(find.text('Zona de los trastes 1 a 3'), findsOne);
    expect(find.text('Toca: 6ª → 1ª'), findsOne);
    expect(find.textContaining('No toques'), findsNothing);
    expect(find.text('Meñique'), findsOne);
  });
}
