import 'dart:async';

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/studio/practice_streak.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_band_audio_repository.dart';
import '../../../support/jam_harness.dart';

/// El jam lleva el compás con un reloj preciso, toca la banda y puntúa con
/// el micrófono.
void main() {
  final DateTime today = DateTime(2026, 10, 13, 18);
  late FakeAudioRepository audio;
  late FakeBandAudioRepository band;
  late PreferencesService preferences;
  late StudioProgressController progress;
  late BandSettingsController settings;
  late JamController jam;

  // A 120 BPM cada semicorchea dura 125 ms y un compás de 4/4, 2 s.
  const Duration bar = Duration(seconds: 2);

  // Para que se dispare la primera semicorchea (el temporizador de cero).
  const Duration tick = Duration(milliseconds: 1);

  JamTrack track() => JamHarness.track();

  Future<void> setUpJam(
    WidgetTester tester, {
    BandConfig config = const BandConfig(humanize: 0),
  }) async {
    final JamHarness harness = await JamHarness.create(
      tester,
      config: config,
      today: today,
    );
    preferences = harness.preferences;
    audio = harness.audio;
    band = harness.band;
    progress = harness.progress;
    settings = harness.settings;
    jam = harness.jam;
  }

  testWidgets('acompañar: prepara la banda, cuenta, toca y termina', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    expect(track().strum, StrumPattern.quarters);
    await jam.start();
    expect(band.preloads, greaterThan(0), reason: 'precarga las muestras');
    expect(jam.state.phase, JamPhase.countIn);
    expect(jam.state.countdown, 4);

    await tester.pump(tick);
    expect(band.plays, isNotEmpty, reason: 'clic de la cuenta atrás');
    expect(
      band.plays.every((BandPlay p) => p.sound.channel == BandChannel.click),
      isTrue,
      reason: 'en la cuenta atrás solo suena el clic',
    );

    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.playing);
    expect(band.of(BandChannel.bass).first.sound.notes, <int>[
      36,
    ], reason: 'el bajo toca la raíz de Do');
    expect(band.of(BandChannel.drums), isNotEmpty);
    expect(band.of(BandChannel.guitar), isNotEmpty);

    await tester.pump(bar);
    expect(jam.state.bar, 1);
    final Iterable<BandPlay> bass = band.of(BandChannel.bass);
    expect(
      bass.map((BandPlay p) => p.sound.notes.first),
      contains(31),
      reason: 'en el segundo compás el bajo sigue a Sol',
    );

    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.finished);
    expect(preferences.practiceDays, contains(dayKey(today)));
    jam.dispose();
  });

  testWidgets('puntuar: califica cada compás, guarda récord y la banda calla', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    jam.setMode(JamMode.score);
    await jam.start();
    expect(band.preloads, 0, reason: 'sin banda no hay nada que preparar');
    await tester.pump(bar + tick);
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
    expect(audio.played, isEmpty);
    expect(band.plays, isEmpty, reason: 'en modo puntuar la banda calla');
    expect(audio.stops, greaterThan(0), reason: 'cierra el micrófono');
    jam.dispose();
  });

  testWidgets('pausa, reanuda y tempo con precisión', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    await jam.start();
    await tester.pump(bar + tick);
    jam.togglePause();
    expect(jam.state.phase, JamPhase.paused);
    expect(band.silences, contains(null), reason: 'la pausa calla la banda');
    final int before = band.plays.length;
    await tester.pump(bar * 3);
    expect(jam.state.phase, JamPhase.paused);
    expect(band.plays.length, before);
    jam.togglePause();
    expect(jam.state.phase, JamPhase.playing);
    jam.setTempo(121);
    expect(jam.state.track!.bpm, 121);
    jam.setTempo(500);
    expect(jam.state.track!.bpm, kJamMaxBpm);
    jam.setTempo(1);
    expect(jam.state.track!.bpm, kJamMinBpm);
    await jam.stop();
    expect(jam.state.phase, JamPhase.finished);
    jam.dispose();
  });

  testWidgets('la cuenta atrás se configura: 0, 1 o 2 compases', (
    WidgetTester tester,
  ) async {
    await setUpJam(
      tester,
      config: const BandConfig(humanize: 0, countInBars: 0),
    );
    await jam.start();
    expect(jam.state.phase, JamPhase.playing, reason: 'sin cuenta atrás');
    await tester.pump(tick);
    expect(jam.state.bar, 0);
    await jam.stop();

    settings.set(settings.config.copyWith(countInBars: 2));
    await jam.load(track());
    await jam.start();
    expect(jam.state.phase, JamPhase.countIn);
    expect(jam.state.countdown, 8);
    await tester.pump(bar + tick);
    expect(jam.state.phase, JamPhase.countIn);
    expect(jam.state.countdown, 4);
    await tester.pump(bar);
    expect(jam.state.phase, JamPhase.playing);
    await jam.stop();
    jam.dispose();
  });

  testWidgets('mientras prepara la banda se ve el progreso', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    band.gate = Completer<void>();
    final Future<void> starting = jam.start();
    await tester.pump();
    expect(jam.state.phase, JamPhase.loading);
    expect(jam.state.loadProgress, closeTo(0.4, 1e-9));
    band.gate!.complete();
    await starting;
    expect(jam.state.phase, JamPhase.countIn);
    await jam.stop();
    jam.dispose();
  });

  testWidgets('si la banda no se puede preparar, la sesión sigue', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    band.failPreload = true;
    await jam.start();
    expect(jam.state.phase, JamPhase.countIn);
    await jam.stop();
    jam.dispose();
  });

  testWidgets('la transposición cambia los acordes de la pista', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    settings.set(settings.config.copyWith(transpose: 2));
    expect(jam.state.track!.bars.first.chords.single.name, 'D');
    await jam.start();
    await tester.pump(bar);
    expect(band.of(BandChannel.bass).first.sound.notes, <int>[
      38,
    ], reason: 'el bajo toca la raíz de Re');
    await jam.stop();
    jam.dispose();
  });

  testWidgets('silenciar un canal en caliente calla ese instrumento', (
    WidgetTester tester,
  ) async {
    await setUpJam(tester);
    await jam.start();
    await tester.pump(bar + tick);
    final int drums = band.of(BandChannel.drums).length;
    expect(drums, greaterThan(0));
    settings.toggleChannel(BandChannel.drums);
    expect(band.silences, contains(BandChannel.drums));
    await tester.pump(bar);
    expect(band.of(BandChannel.drums).length, drums);
    expect(
      band.of(BandChannel.bass).length,
      greaterThan(1),
      reason: 'el resto de la banda sigue',
    );
    settings.toggleChannel(BandChannel.drums);
    await tester.pump(const Duration(milliseconds: 500));
    expect(band.of(BandChannel.drums).length, greaterThan(drums));
    await jam.stop();
    jam.dispose();
  });

  testWidgets('el clic suena solo si el metrónomo está activo', (
    WidgetTester tester,
  ) async {
    await setUpJam(
      tester,
      config: const BandConfig(humanize: 0, countInBars: 0),
    );
    await jam.start();
    await tester.pump(tick);
    await tester.pump(bar);
    expect(
      band.of(BandChannel.click),
      isEmpty,
      reason: 'el metrónomo está apagado de fábrica',
    );
    settings.toggleChannel(BandChannel.click);
    await tester.pump(bar);
    final Iterable<BandPlay> clicks = band.of(BandChannel.click);
    expect(clicks.length, greaterThanOrEqualTo(3));
    expect(
      clicks.first.sound.shape,
      anyOf(ClickAccent.accent, ClickAccent.normal),
    );
    await jam.stop();
    jam.dispose();
  });
}
