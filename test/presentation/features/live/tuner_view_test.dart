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
    tuner = TunerController(audio, referenceMute: Duration.zero);
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

  /// Activa el micrófono como lo haría la pantalla al hacerse visible.
  Future<void> startTuner(WidgetTester tester) async {
    await tester.runAsync(tuner.start);
    await tester.pump();
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

  testWidgets('en reposo ofrece activar el micrófono y muestra las clavijas', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);

    expect(find.text('Activar micrófono'), findsOne);
    expect(find.textContaining('Automático'), findsOne);
    for (final String note in <String>['Re', 'La', 'Mi', 'Sol', 'Si']) {
      expect(find.text(note), findsWidgets);
    }
  });

  testWidgets('una cuerda floja dice qué cuerda es y que hay que subir', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await startTuner(tester);

    await play(tester, _hz(5, -22), 6);

    expect(find.text('5ª cuerda · 108.6 Hz'), findsOne);
    expect(find.text('Sube'), findsOne);
    expect(find.text('Aprieta la clavija'), findsOne);
    await drain(tester);
  });

  testWidgets('una cuerda alta dice que hay que bajar', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await startTuner(tester);

    await play(tester, _hz(2, 30), 6);

    expect(find.text('Baja'), findsOne);
    expect(find.text('Afloja la clavija'), findsOne);
    await drain(tester);
  });

  testWidgets('afinada: felicita y marca la clavija con check', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await startTuner(tester);

    await play(tester, _hz(3), 8);

    expect(find.text('¡Afinada!'), findsOne);
    expect(find.byIcon(Icons.check_rounded), findsOne);
    await drain(tester);
  });

  testWidgets('las seis cuerdas afinadas muestran el mensaje final', (
    WidgetTester tester,
  ) async {
    tuner = TunerController(
      audio,
      referenceMute: Duration.zero,
      signalTimeout: const Duration(milliseconds: 20),
    );
    await pumpTuner(tester);
    await startTuner(tester);

    for (final GuitarString string in kStandardTuning) {
      await play(tester, string.frequency, 6);
    }
    // El temporizador de señal perdida corre en tiempo real (vive en runAsync).
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 80)),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('¡Guitarra afinada!'), findsOne);
  });

  testWidgets('pulsar una clavija elige la cuerda y avisa si suena otra', (
    WidgetTester tester,
  ) async {
    await pumpTuner(tester);
    await startTuner(tester);

    await tester.tap(find.bySemanticsLabel(RegExp('Clavija de la 4ª')));
    await tester.pump();
    expect(find.text('Toca la 4ª cuerda'), findsOne);
    expect(find.text('Fijada: 4ª cuerda'), findsOne);
    expect(audio.tones, hasLength(1));

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
    await startTuner(tester);

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
