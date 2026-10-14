import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/studio/practice_streak.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_result_view.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:chords/presentation/features/jam/jam_setup_view.dart';
import 'package:chords/presentation/features/jam/jam_stage_view.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';

/// El jam lleva el compás, toca el acompañamiento y puntúa con el micrófono.
void main() {
  final DateTime today = DateTime(2026, 10, 13, 18);
  late FakeAudioRepository audio;
  late PreferencesService preferences;
  late StudioProgressController progress;
  late JamController jam;

  // A 120 BPM cada corchea dura 250 ms y un compás de 4/4, 2 s.
  const Duration bar = Duration(seconds: 2);

  JamTrack track() => JamTrack.custom(
    <ChordSymbol>[ChordSymbol.parse('C'), ChordSymbol.parse('G')],
    title: 'prueba',
    bpm: 120,
    loops: 1,
  );

  Future<void> setUpJam(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    audio = FakeAudioRepository();
    progress = StudioProgressController(preferences, clock: () => today);
    jam = JamController(audio, loadChordBank(), progress);
    await jam.load(track());
  }

  testWidgets('acompañar: cuenta atrás, rasguea cada acorde y termina', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    expect(track().strum, StrumPattern.quarters);
    await jam.start();
    expect(jam.state.phase, JamPhase.countIn);
    expect(jam.state.countdown, 4);
    expect(audio.tones, isNotEmpty, reason: 'clic de la cuenta atrás');

    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.playing);
    expect(audio.played, <String>['C-maj']);

    await tester.pump(bar);
    expect(jam.state.bar, 1);
    expect(audio.played.where((String id) => id == 'C-maj').length, 4);
    expect(audio.played.last, 'G-maj');

    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.finished);
    expect(preferences.practiceDays, contains(dayKey(today)));
    jam.dispose();
  });

  testWidgets('puntuar: califica cada compás por lo que oye y guarda récord', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    jam.setMode(JamMode.score);
    await jam.start();
    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.playing);

    // Compás de Do: se oyen Do, Mi y Sol.
    for (final String note in <String>['C3', 'E3', 'G3', 'C4']) {
      audio.emitReading(note);
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(bar - const Duration(milliseconds: 400));
    expect(jam.state.lastGrade, BarGrade.perfect);
    expect(jam.state.score.points, 100);

    // Compás de Sol: silencio.
    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.finished);
    expect(jam.state.score.perfect, 1);
    expect(jam.state.score.missed, 1);
    expect(jam.state.isNewBest, isTrue);
    expect(progress.jamBest('custom'), 100);
    expect(audio.played, isEmpty, reason: 'en modo puntuar la app calla');
    expect(audio.stops, greaterThan(0), reason: 'cierra el micrófono');
    jam.dispose();
  });

  testWidgets('pausa y tempo', (WidgetTester tester) async {
    await setUpJam(tester);
    await jam.start();
    await tester.pump(bar);
    jam.togglePause();
    expect(jam.state.phase, JamPhase.paused);
    await tester.pump(bar * 3);
    expect(jam.state.phase, JamPhase.paused);
    jam
      ..togglePause()
      ..setTempo(500);
    expect(jam.state.track!.bpm, kJamMaxBpm);
    await jam.stop();
    expect(jam.state.phase, JamPhase.finished);
    jam.dispose();
  });

  testWidgets('el escenario cabe en un móvil pequeño', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    jam.setMode(JamMode.score);
    await jam.start();
    await tester.pump(bar);
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<JamController>.value(value: jam),
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(preferences),
            ),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: Consumer<JamController>(
                builder: (_, JamController c, _) =>
                    JamStageView(state: c.state),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('C'), findsWidgets);
    await jam.stop();
    jam.dispose();
  });

  testWidgets('preparación y resultado caben a 320 px de ancho', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    tester.view.physicalSize = const Size(320, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final ValueNotifier<Widget> body = ValueNotifier<Widget>(
      const SizedBox.shrink(),
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<JamController>.value(value: jam),
            ChangeNotifierProvider<StudioProgressController>.value(
              value: progress,
            ),
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(preferences),
            ),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: ValueListenableBuilder<Widget>(
                valueListenable: body,
                builder: (_, Widget child, _) => child,
              ),
            ),
          ),
        ),
      ),
    );
    for (final JamSource source in JamSource.values) {
      for (final JamMode mode in JamMode.values) {
        jam.setMode(mode);
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
    jam.setMode(JamMode.score);
    await jam.start();
    await jam.stop();
    body.value = JamResultView(state: jam.state);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Sesión terminada'), findsOne);
    jam.dispose();
  });
}
