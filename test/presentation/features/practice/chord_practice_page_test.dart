import 'dart:math' as math;

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:chords/presentation/features/practice/chord_practice_page.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';

double _hz(int number, int fret, [double cents = 0]) =>
    standardStringByNumber(number)!.frequency *
    math.pow(2, (fret * 100 + cents) / 1200);

/// Cede al bucle de eventos real para que terminen los `cancel()` de streams.
Future<void> _realAsync(WidgetTester tester) => tester.runAsync(
  () => Future<void>.delayed(const Duration(milliseconds: 20)),
);

/// Tests de la pantalla de práctica de acordes cuerda a cuerda.
void main() {
  late FakeAudioRepository audio;
  late ChordPracticeController practice;
  late TunerController tuner;

  const Chord cMajor = Chord(
    id: 'C-maj',
    root: ChordRoot.c,
    quality: ChordQuality.major,
    variants: <ChordVariant>[
      ChordVariant(
        id: 'c-open',
        positionLabel: 'Abierto',
        frets: <int>[-1, 3, 2, 0, 1, 0],
        fingers: <int>[0, 3, 2, 0, 1, 0],
        difficulty: Difficulty.beginner,
        notes: <String>['C', 'E', 'G'],
      ),
    ],
  );
  const Chord eMinor = Chord(
    id: 'E-min',
    root: ChordRoot.e,
    quality: ChordQuality.minor,
    variants: <ChordVariant>[
      ChordVariant(
        id: 'em-open',
        positionLabel: 'Abierto',
        frets: <int>[0, 2, 2, 0, 0, 0],
        fingers: <int>[0, 2, 3, 0, 0, 0],
        difficulty: Difficulty.beginner,
        notes: <String>['E', 'G', 'B'],
      ),
    ],
  );

  Future<void> pumpPage(WidgetTester tester, String chordId) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final GoRouter router = GoRouter(
      initialLocation: '/practice?id=$chordId&v=0',
      routes: <RouteBase>[
        GoRoute(
          path: '/practice',
          builder: (BuildContext context, GoRouterState state) =>
              const ChordPracticePage(),
        ),
      ],
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(preferences),
            ),
            ChangeNotifierProvider<ChordPracticeController>.value(
              value: practice,
            ),
            ChangeNotifierProvider<TunerController>.value(value: tuner),
            ChangeNotifierProvider<GuitarCommandListener>.value(
              value: GuitarCommandListener(audio),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  /// Toca [times] lecturas de [frequency] y deja caer el silencio.
  Future<void> pluck(WidgetTester tester, double frequency) async {
    for (int i = 0; i < 4; i++) {
      audio
        ..emitFrequency(frequency)
        ..emitLevel(0.6);
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pump(const Duration(milliseconds: 600));
  }

  setUp(() {
    audio = FakeAudioRepository();
    practice = ChordPracticeController(
      audio,
      FakeChordRepository(<Chord>[cMajor, eMinor]),
    );
    tuner = TunerController(audio);
  });

  testWidgets('dice qué cuerda tocar, con su traste y su dedo', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, 'C-maj');

    expect(
      find.text('Ahora toca la 5ª cuerda: traste 3 con el dedo 3'),
      findsOne,
    );
    expect(find.text('0 de 5 cuerdas'), findsOne);
    expect(find.text('Muda'), findsOne);
  });

  testWidgets('reconoce la cuerda y pasa a la siguiente', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, 'C-maj');

    await pluck(tester, _hz(5, 3));

    expect(find.text('1 de 5 cuerdas'), findsOne);
    expect(
      find.text('Ahora toca la 4ª cuerda: traste 2 con el dedo 2'),
      findsOne,
    );
  });

  testWidgets('una cuerda mal pulsada da un consejo de dedo', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, 'C-maj');

    await pluck(tester, _hz(5, 2));

    expect(find.text('Cómo corregirla'), findsOne);
    expect(
      find.text('Suena más grave. Sube el dedo 3 un traste hacia la caja.'),
      findsOne,
    );
    expect(find.text('Reafinar cuerda'), findsNothing);
  });

  testWidgets('el acorde completo se celebra y suelta el micrófono', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, 'C-maj');

    await pluck(tester, _hz(5, 3));
    await pluck(tester, _hz(4, 2));
    await pluck(tester, _hz(3, 0));
    await pluck(tester, _hz(2, 1));
    await pluck(tester, _hz(1, 0));

    expect(find.text('¡Acorde limpio!'), findsOne);
    expect(find.text('5 de 5 cuerdas'), findsOne);
    expect(practice.status, MicStatus.idle);
  });

  testWidgets('sin permiso de micrófono muestra el aviso', (
    WidgetTester tester,
  ) async {
    audio.accessResult = MicStatus.permissionDenied;
    await pumpPage(tester, 'C-maj');

    expect(find.text('Necesito tu micrófono'), findsOne);
    expect(find.text('Empezar a practicar'), findsOne);
  });

  testWidgets('una cuerda al aire desafinada ofrece reafinar en una hoja', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, 'E-min');

    await pluck(tester, _hz(6, 0, -40));
    expect(
      find.text('La 6ª cuerda al aire suena baja: sube un poco la clavija.'),
      findsOne,
    );

    await tester.tap(find.text('Reafinar cuerda'));
    await _realAsync(tester);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Reafinar cuerda · 6ª cuerda · Mi'), findsOne);
    expect(tuner.state.target?.number, 6);
    expect(practice.status, MicStatus.idle);

    await tester.tapAt(const Offset(10, 10));
    await tester.pump(const Duration(milliseconds: 400));
    await _realAsync(tester);
    await tester.pump();
    expect(practice.status, MicStatus.listening);
    await tester.pump(const Duration(seconds: 3));
  });
}
