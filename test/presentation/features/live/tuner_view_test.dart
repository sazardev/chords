import 'dart:math' as math;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/live/tuner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../fakes/fake_audio_repository.dart';

/// Frecuencia de la cuerda [number] desviada [cents].
double _hz(int number, [double cents = 0]) =>
    standardStringByNumber(number)!.frequency * math.pow(2, cents / 1200);

/// Tests de la interfaz del afinador por cuerdas.
void main() {
  late FakeAudioRepository audio;
  late TunerController tuner;

  setUp(() {
    audio = FakeAudioRepository();
    tuner = TunerController(audio);
  });

  Future<void> pumpTuner(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider<TunerController>.value(
          value: tuner,
          child: const MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: TunerView())),
          ),
        ),
      ),
    );
  }

  /// Emite lecturas seguidas de [frequency].
  Future<void> play(WidgetTester tester, double frequency, int times) async {
    for (int i = 0; i < times; i++) {
      audio
        ..emitFrequency(frequency)
        ..emitLevel(0.6);
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  /// Deja vencer el temporizador de señal perdida.
  Future<void> drain(WidgetTester tester) =>
      tester.pump(const Duration(seconds: 3));

  testWidgets('en reposo explica cómo empezar y ofrece el botón', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);

    expect(find.text('Toca cualquier cuerda: la reconozco sola'), findsOne);
    expect(find.text('Empezar a afinar'), findsOne);
    expect(find.text('0 de 6 afinadas'), findsOne);
    for (final String note in <String>['Re', 'La', 'Mi', 'Sol', 'Si']) {
      expect(find.text(note), findsWidgets);
    }
  });

  testWidgets('una cuerda floja dice qué cuerda es y que hay que subir', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await tester.tap(find.text('Empezar a afinar'));
    await tester.pump();
    await tester.pump();

    await play(tester, _hz(5, -22), 6);

    expect(find.text('5ª cuerda · La'), findsOne);
    expect(find.text('Sube'), findsOne);
    expect(find.text('Aprieta la clavija'), findsOne);
    expect(find.text('-22 cents'), findsOne);
    await drain(tester);
  });

  testWidgets('una cuerda alta dice que hay que bajar', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await tester.tap(find.text('Empezar a afinar'));
    await tester.pump();

    await play(tester, _hz(2, 30), 6);

    expect(find.text('Baja'), findsOne);
    expect(find.text('Afloja la clavija'), findsOne);
    await drain(tester);
  });

  testWidgets('afinada: felicita y marca la clavija con check', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await tester.tap(find.text('Empezar a afinar'));
    await tester.pump();

    await play(tester, _hz(3), 8);

    expect(find.text('¡Afinada!'), findsOne);
    expect(find.text('1 de 6 afinadas'), findsOne);
    expect(find.byIcon(Icons.check_rounded), findsOne);
    await drain(tester);
  });

  testWidgets('las seis cuerdas afinadas muestran el mensaje final', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await tester.tap(find.text('Empezar a afinar'));
    await tester.pump();

    for (final GuitarString string in kStandardTuning) {
      await play(tester, string.frequency, 6);
    }
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('¡Guitarra afinada!'), findsOne);
    await drain(tester);
  });

  testWidgets('pulsar una clavija elige la cuerda y avisa si suena otra', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await tester.tap(find.text('Empezar a afinar'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel(RegExp('Clavija de la 4ª')));
    await tester.pump();
    expect(find.text('Toca la 4ª cuerda'), findsOne);

    await play(tester, _hz(1), 4);
    expect(
      find.text('Esa suena como la 1ª cuerda. Toca la 4ª cuerda.'),
      findsOne,
    );
    await drain(tester);
  });

  testWidgets('sin permiso muestra el aviso con reintento', (
    WidgetTester tester,
  ) async {
    audio.accessResult = MicStatus.permissionDenied;
    await pumpTuner(tester);
    await tester.tap(find.text('Empezar a afinar'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Necesito tu micrófono'), findsOne);
    expect(find.text('Reintentar'), findsOne);

    audio.accessResult = MicStatus.listening;
    await tester.tap(find.text('Reintentar'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
    expect(find.text('Necesito tu micrófono'), findsNothing);
    await drain(tester);
  });
}
