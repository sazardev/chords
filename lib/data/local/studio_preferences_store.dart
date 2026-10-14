import 'package:chords/domain/preferences/repositories/studio_preferences.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda en `SharedPreferences` el historial, las lecciones, el jam y la
/// racha de práctica.
///
/// Es un mixin para que [PreferencesService] siga siendo el único punto de
/// acceso a las preferencias sin crecer más de la cuenta.
mixin StudioPreferencesStore implements StudioPreferences {
  /// Clave del historial de acordes.
  static const String kRecentChordsKey = 'recent_chords_v1';

  /// Clave de las lecciones aprendidas.
  static const String kLessonsKey = 'theory_lessons_v1';

  /// Prefijo de las claves del récord de cada pista de jam.
  static const String kJamBestPrefix = 'jam_best_v1_';

  /// Clave de los días practicados.
  static const String kPracticeDaysKey = 'practice_days_v1';

  /// Almacén donde se guardan los valores.
  @protected
  SharedPreferences get store;

  @override
  List<String> get recentChordIds =>
      store.getStringList(kRecentChordsKey) ?? const <String>[];

  @override
  Future<void> setRecentChordIds(List<String> ids) =>
      store.setStringList(kRecentChordsKey, ids);

  @override
  Set<String> get completedLessons =>
      store.getStringList(kLessonsKey)?.toSet() ?? <String>{};

  @override
  Future<void> setCompletedLessons(Set<String> ids) =>
      store.setStringList(kLessonsKey, ids.toList());

  @override
  int jamBest(String trackKey) => store.getInt('$kJamBestPrefix$trackKey') ?? 0;

  @override
  Future<void> saveJamBest(String trackKey, int score) async {
    if (score > jamBest(trackKey)) {
      await store.setInt('$kJamBestPrefix$trackKey', score);
    }
  }

  @override
  Set<String> get practiceDays =>
      store.getStringList(kPracticeDaysKey)?.toSet() ?? <String>{};

  @override
  Future<void> setPracticeDays(Set<String> days) =>
      store.setStringList(kPracticeDaysKey, days.toList());
}
