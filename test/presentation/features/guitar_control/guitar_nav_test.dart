import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/guitar_nav_slot.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/presentation/features/guitar_control/guitar_kit.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_navigation.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/fake_audio_repository.dart';

/// Navegación falsa que apunta adónde se va.
class _Trail implements GuitarNavigation {
  final List<String> visited = <String>[];

  @override
  String location = '/';

  @override
  void go(String path) {
    visited.add(path);
    location = path;
  }

  @override
  void back() => visited.add('back');
}

/// Tests del menú global del modo guitarra (sin interfaz).
void main() {
  late FakeAudioRepository audio;
  late SettingsController settings;
  late GuitarKit kit;
  late _Trail trail;
  late DateTime now;

  PitchReading reading(String note, {double hz = 440}) =>
      PitchReading(frequency: hz, note: note, cents: 0, clarity: 0.9);

  Future<void> pluck(String note, {double hz = 440}) async {
    now = now.add(const Duration(seconds: 2));
    await Future<void>.delayed(const Duration(milliseconds: 150));
    for (int i = 0; i < 3; i++) {
      audio.emitReading(note, frequency: hz);
      await pumpEventQueue();
    }
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    settings = SettingsController(await PreferencesService.create());
    audio = FakeAudioRepository();
    now = DateTime(2026);
    kit = GuitarKit(audio, settings, clock: () => now);
    trail = _Trail();
    kit.nav.navigation = trail;
    await settings.setGuitarBrowse(value: true);
  });

  tearDown(() async {
    await kit.keeper.close();
    kit.nav.dispose();
    kit.listener.dispose();
  });

  test('al encender el modo se abre el micrófono y se escucha siempre', () {
    expect(kit.nav.active, isTrue);
    expect(audio.requests, greaterThan(0));
    expect(kit.listener.state.listening, isTrue);
  });

  test('una nota aguda abre el menú y otra lo cierra', () async {
    await pluck('G', hz: 784);
    expect(kit.nav.menuOpen, isTrue);
    await pluck('A', hz: 880);
    expect(kit.nav.menuOpen, isFalse);
  });

  test('con el menú abierto cada nota lleva a su destino', () async {
    final Map<String, String> expected = <String, String>{
      'E': '/',
      'F': '/learn',
      'F#': '/chords',
      'G': '/game',
      'G#': '/live',
      'A': '/settings',
      'A#': '/profile',
    };
    for (final MapEntry<String, String> entry in expected.entries) {
      await pluck('C', hz: 1046);
      expect(kit.nav.menuOpen, isTrue, reason: entry.key);
      await pluck(entry.key);
      expect(trail.visited.last, entry.value, reason: entry.key);
      expect(kit.nav.menuOpen, isFalse, reason: 'vuelve el foco');
    }
  });

  test('Si vuelve atrás y Do cierra sin ir a ningún sitio', () async {
    await pluck('G', hz: 784);
    await pluck('B');
    expect(trail.visited, <String>['back']);
    await pluck('G', hz: 784);
    await pluck('C');
    expect(trail.visited, <String>['back']);
    expect(kit.nav.menuOpen, isFalse);
  });

  test('una nota sin opción deja el menú abierto', () async {
    await pluck('G', hz: 784);
    await pluck('D');
    expect(kit.nav.menuOpen, isTrue);
    expect(trail.visited, isEmpty);
  });

  test('Do♯ apaga el modo guitarra y cierra el micrófono', () async {
    await pluck('G', hz: 784);
    await pluck('C#');
    expect(settings.guitarBrowse, isFalse);
    expect(kit.nav.active, isFalse);
    expect(audio.stops, greaterThan(0));
  });

  test('sin tocar nada el menú se cierra solo', () async {
    await pluck('G', hz: 784);
    expect(kit.nav.menuOpen, isTrue);
    now = now.add(kit.nav.idleTimeout + const Duration(seconds: 1));
    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(kit.nav.menuOpen, isFalse);
  });

  test('con el menú abierto las pantallas ignoran lo que se toca', () async {
    expect(kit.listener.claims(reading('E')), isFalse);
    expect(kit.listener.claims(reading('G', hz: 784)), isTrue, reason: 'aguda');
    await pluck('G', hz: 784);
    expect(kit.listener.claims(reading('E')), isTrue, reason: 'menú abierto');
    await pluck('A', hz: 880);
    expect(kit.listener.claims(reading('E')), isFalse);
  });

  test('apagado el modo, la nota aguda no hace nada', () async {
    await settings.setGuitarBrowse(value: false);
    await pluck('G', hz: 784);
    expect(kit.nav.menuOpen, isFalse);
    kit.nav.openMenu();
    expect(kit.nav.menuOpen, isFalse);
  });

  test('las rutas del menú cubren todos los destinos', () {
    for (final GuitarNavSlot slot in <GuitarNavSlot>[
      GuitarNavSlot.home,
      GuitarNavSlot.learn,
      GuitarNavSlot.chords,
      GuitarNavSlot.game,
      GuitarNavSlot.live,
      GuitarNavSlot.settings,
      GuitarNavSlot.profile,
    ]) {
      expect(GuitarNavController.paths[slot], isNotNull, reason: slot.name);
    }
  });
}
