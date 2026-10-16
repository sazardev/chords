import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';
import 'package:chords/presentation/features/minigames/chord_changes_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/mini_game_harness.dart';
import '../../../fakes/mini_game_pump.dart';

/// La pantalla de "cambios de acorde": bienvenida, cuenta atrás, partida,
/// aviso de micrófono y resultado, en móviles y tabletas.
void main() {
  late MiniGameHarness h;

  setUp(() async => h = await MiniGameHarness.create());

  final String path = MiniGameHarness.gamePath('chordChanges');

  /// Pulsa "Empezar" y deja pasar la cuenta atrás hasta el primer acorde.
  Future<void> startGame(WidgetTester tester) async {
    await tapText(tester, 'Empezar');
    await tester.pumpAndSettle();
    h.kit.questionClock.elapse(3000);
    await tester.pump();
  }

  /// Toca las notas del acorde pedido, como lo haría un guitarrista.
  Future<void> strumTarget(WidgetTester tester) async {
    h.kit.questionClock.tick(2);
    final Chord chord = h.kit.chordChanges.state.target!;
    for (final int pc in pitchClassesOfChord(chord)) {
      h.audio.emitReading(noteNameOfPitchClass(pc));
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  testWidgets('la bienvenida dice la meta de cada dificultad', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, location: path);
    expect(find.text('Cómo se juega'), findsOne);
    expect(find.text('Meta: 8 cambios limpios en 60 s'), findsOne);
    await tapText(tester, 'Dificultad: Fácil');
    expect(find.text('Meta: 12 cambios limpios en 60 s'), findsOne);
    await tapText(tester, 'Dificultad: Media');
    expect(find.text('Meta: 16 cambios limpios en 60 s'), findsOne);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empieza con una cuenta atrás y pide un acorde', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, location: path);
    await tapText(tester, 'Empezar');
    await tester.pumpAndSettle();
    expect(find.text('Prepárate…'), findsOne);
    expect(find.text('Empieza en 3'), findsOne);
    expect(h.audio.requests, greaterThan(0));

    h.kit.questionClock.elapse(1000);
    await tester.pump();
    expect(find.text('Empieza en 2'), findsOne);

    h.kit.questionClock.elapse(2000);
    await tester.pump();
    expect(find.text('Toca este acorde'), findsOne);
    expect(find.text('0 / 8'), findsOne);
    expect(find.text('Cambios limpios'), findsOne);
    expect(find.text('Oír el acorde'), findsOne);
    expect(find.text('Saltar acorde'), findsOne);
    expect(find.byType(ChordDiagram), findsOne);
    expect(find.text(h.kit.chordChanges.state.target!.name), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tocar el acorde suma un cambio y cambia de acorde', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, location: path);
    await startGame(tester);
    final String first = h.kit.chordChanges.state.target!.id;
    await strumTarget(tester);
    expect(find.text('1 / 8'), findsOne);
    expect(h.kit.chordChanges.state.target!.id, isNot(first));
    expect(find.byIcon(Icons.check_circle_rounded), findsOne);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saltar un acorde lo da por fallado y no puntúa', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, location: path);
    await startGame(tester);
    await tapText(tester, 'Saltar acorde');
    expect(find.text('0 / 8'), findsOne);
    expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);
    expect(h.kit.chordChanges.state.misses, 1);
  });

  testWidgets('"Oír el acorde" toca la referencia', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, location: path);
    await startGame(tester);
    await tapText(tester, 'Oír el acorde');
    expect(h.audio.played, <String>[h.kit.chordChanges.state.target!.id]);
  });

  testWidgets('al terminar los 60 s se ve el resultado con estrellas', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, location: path);
    await startGame(tester);
    for (int i = 0; i < 8; i++) {
      await strumTarget(tester);
    }
    h.kit.questionClock.elapse(60000);
    await tester.pumpAndSettle();
    expect(h.kit.chordChanges.state.phase, MiniGamePhase.finished);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    expect(find.text('¡Nuevo récord!'), findsOne);
    expect(h.preferences.miniGameBest('chordChanges_easy'), 100);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sin permiso se avisa y se puede reintentar', (
    WidgetTester tester,
  ) async {
    h.audio.accessResult = MicStatus.permissionDenied;
    await h.pump(tester, location: path);
    await tapText(tester, 'Empezar');
    await tester.pumpAndSettle();
    expect(find.byType(MicProblemCard), findsOne);
    expect(find.text('Necesito tu micrófono'), findsOne);

    h.audio.accessResult = MicStatus.listening;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.byType(MicProblemCard), findsNothing);
    expect(find.text('Prepárate…'), findsOne);
  });

  for (final Size size in const <Size>[
    Size(320, 480),
    Size(360, 640),
    Size(412, 915),
    Size(800, 1280),
  ]) {
    testWidgets('se juega sin desbordes a ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      await h.pump(tester, location: path, size: size);
      expect(tester.takeException(), isNull, reason: 'bienvenida');
      await tapText(tester, 'Empezar');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'cuenta atrás');
      h.kit.questionClock.elapse(3000);
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'partida');
      await strumTarget(tester);
      expect(tester.takeException(), isNull, reason: 'cambio limpio');
      final ChordChangesState state = h.kit.chordChanges.state;
      expect(state.changes, 1);
    });
  }
}
