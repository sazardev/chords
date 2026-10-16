import 'dart:async';

import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_loading_view.dart';
import 'package:chords/presentation/features/jam/jam_result_view.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:chords/presentation/features/jam/jam_setup_view.dart';
import 'package:chords/presentation/features/jam/jam_stage_view.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../support/jam_harness.dart';

/// Las pantallas del jam: preparación, escena y resultado.
void main() {
  const Duration bar = Duration(seconds: 2);
  const Duration tick = Duration(milliseconds: 1);

  Widget stage(JamHarness h) => h.host(
    Consumer<JamController>(
      builder: (_, JamController c, _) => JamStageView(state: c.state),
    ),
  );

  testWidgets('el escenario cabe en un móvil pequeño y silencia al tocar', (
    WidgetTester tester,
  ) async {
    final JamHarness h = await JamHarness.create(tester);
    await h.jam.start();
    await tester.pump(bar + tick);
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(stage(h));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('C'), findsWidgets);
    final Finder drums = find.byKey(const ValueKey<String>('strip-drums'));
    await tester.dragUntilVisible(
      drums,
      find.byType(ListView),
      const Offset(0, -150),
    );
    await tester.ensureVisible(drums);
    await tester.pump();
    await tester.tap(drums);
    await tester.pump();
    expect(h.settings.config.isOn(BandChannel.drums), isFalse);
    await h.jam.stop();
    h.jam.dispose();
  });

  testWidgets('la escena enciende la luz del instrumento que suena', (
    WidgetTester tester,
  ) async {
    final JamHarness h = await JamHarness.create(tester);
    await h.jam.start();
    await tester.pump(bar + tick);
    expect(h.jam.activity.isActive(BandChannel.drums), isTrue);
    expect(h.jam.activity.active, contains(BandChannel.bass));
    h.settings.toggleChannel(BandChannel.drums);
    await tester.pump(const Duration(milliseconds: 130));
    expect(h.jam.activity.isActive(BandChannel.drums), isFalse);
    await h.jam.stop();
    h.jam.dispose();
  });

  testWidgets('el tempo se ajusta de 1 en 1, de 5 en 5 y escribiéndolo', (
    WidgetTester tester,
  ) async {
    final JamHarness h = await JamHarness.create(tester);
    await h.jam.start();
    await tester.pump(bar);
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(stage(h));
    await tester.pump();

    Future<void> tap(String key) async {
      await tester.tap(find.byKey(ValueKey<String>(key)));
      await tester.pump();
    }

    await tap('tempo-1+');
    expect(h.jam.state.track!.bpm, 121);
    await tap('tempo-5+');
    expect(h.jam.state.track!.bpm, 126);
    await tap('tempo-1-');
    expect(h.jam.state.track!.bpm, 125);
    await tap('tempo-5-');
    expect(h.jam.state.track!.bpm, 120);

    await tap('tempo-edit');
    await tester.enterText(
      find.byKey(const ValueKey<String>('tempo-field')),
      '97',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(h.jam.state.track!.bpm, 97);

    await tap('tempo-edit');
    await tester.enterText(
      find.byKey(const ValueKey<String>('tempo-field')),
      '900',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(h.jam.state.track!.bpm, kJamMaxBpm);
    await h.jam.stop();
    h.jam.dispose();
  });

  testWidgets('mientras prepara la banda se muestra el progreso', (
    WidgetTester tester,
  ) async {
    final JamHarness h = await JamHarness.create(tester);
    h.band.gate = Completer<void>();
    final Future<void> starting = h.jam.start();
    await tester.pump();
    await tester.pumpWidget(stage(h));
    await tester.pump();
    expect(find.byType(JamLoadingView), findsOneWidget);
    expect(find.textContaining('40%'), findsOneWidget);
    h.band.gate!.complete();
    await starting;
    await tester.pump();
    expect(find.byType(JamLoadingView), findsNothing);
    await h.jam.stop();
    h.jam.dispose();
  });

  testWidgets('preparación y resultado caben a 320 px de ancho', (
    WidgetTester tester,
  ) async {
    final JamHarness h = await JamHarness.create(tester);
    tester.view.physicalSize = const Size(320, 4200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final ValueNotifier<Widget> body = ValueNotifier<Widget>(
      const SizedBox.shrink(),
    );
    await tester.pumpWidget(
      h.host(
        ValueListenableBuilder<Widget>(
          valueListenable: body,
          builder: (_, Widget child, _) => child,
        ),
      ),
    );
    for (final JamSource source in JamSource.values) {
      for (final JamMode mode in JamMode.values) {
        h.jam.setMode(mode);
        body.value = JamSetupView(
          selection: JamSelection(
            source: source,
            custom: <ChordSymbol>[ChordSymbol.parse('Am')],
          ),
          onChanged: (_) {},
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$source $mode');
      }
    }
    h.jam.setMode(JamMode.score);
    await h.jam.start();
    await h.jam.stop();
    body.value = JamResultView(state: h.jam.state);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Sesión terminada'), findsOne);
    h.jam.dispose();
  });
}
