import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests de widgets: diagramas y tarjetas de acorde.
void main() {
  /// Construye un acorde de prueba (C mayor con cejillo en Mi).
  Chord buildChord() => const Chord(
    id: 'C-maj',
    root: ChordRoot.c,
    quality: ChordQuality.major,
    variants: <ChordVariant>[
      ChordVariant(
        id: 'C-maj-e-shape-8',
        positionLabel: 'Forma de Mi · traste 8',
        frets: <int>[8, 10, 10, 9, 8, 8],
        fingers: <int>[1, 3, 4, 2, 1, 1],
        difficulty: Difficulty.medium,
        notes: <String>['C', 'E', 'G'],
      ),
    ],
  );

  testWidgets('ChordDiagram pinta el diagrama del acorde', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ChordDiagram(variant: buildChord().easiestVariant),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(ChordDiagram), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Diagrama de Forma de Mi')),
      findsOneWidget,
    );
  });

  testWidgets('ChordCard muestra nombre, posiciones y botón de play', (
    WidgetTester tester,
  ) async {
    bool played = false;
    bool tapped = false;
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: ChordCard(
                  chord: buildChord(),
                  onTap: () => tapped = true,
                  onPlay: () => played = true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('C'), findsOneWidget);
    expect(find.text('1 posición'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    expect(played, isTrue);
    await tester.tap(find.byType(AppCard));
    expect(tapped, isTrue);
  });
}
