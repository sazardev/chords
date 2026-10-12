import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del perfil: persistencia y sincronización con el espejo de zurdos.
void main() {
  late PreferencesService preferences;
  late SettingsController settings;
  late ProfileController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    settings = SettingsController(preferences);
    controller = ProfileController(preferences, settings)..load();
  });

  test('empieza con un perfil por defecto sin personalizar', () {
    expect(controller.profile.personalized, isFalse);
    expect(controller.profile.guitar, GuitarType.acoustic);
    expect(controller.profile.experience, ExperienceLevel.beginner);
    expect(controller.profile.genres, isEmpty);
  });

  test('cada elección se guarda y sobrevive a un reinicio', () async {
    controller
      ..setGuitar(GuitarType.electric)
      ..setStyle(PlayingStyle.fingers)
      ..setExperience(ExperienceLevel.advanced)
      ..toggleGenre('Rock')
      ..toggleGenre('Jazz')
      ..toggleGenre('Rock');
    await Future<void>.delayed(Duration.zero);

    final ProfileController reloaded = ProfileController(
      await _fresh(preferences),
      settings,
    )..load();
    expect(reloaded.profile.guitar, GuitarType.electric);
    expect(reloaded.profile.style, PlayingStyle.fingers);
    expect(reloaded.profile.experience, ExperienceLevel.advanced);
    expect(reloaded.profile.genres, <String>{'Jazz'});
    expect(reloaded.profile.personalized, isTrue);
  });

  test(
    'ser zurdo activa el espejo de los diagramas y diestro lo quita',
    () async {
      controller.setHand(PlayingHand.left);
      await Future<void>.delayed(Duration.zero);
      expect(settings.mirrorChords, isTrue);

      controller.setHand(PlayingHand.right);
      await Future<void>.delayed(Duration.zero);
      expect(settings.mirrorChords, isFalse);
    },
  );

  test('confirm marca el perfil como elegido aunque no se toque nada', () {
    controller.confirm();
    expect(controller.profile.personalized, isTrue);
  });
}

Future<PreferencesService> _fresh(PreferencesService previous) =>
    PreferencesService.create();
