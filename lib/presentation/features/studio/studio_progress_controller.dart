import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/preferences/repositories/studio_preferences.dart';
import 'package:chords/domain/studio/practice_streak.dart';
import 'package:flutter/foundation.dart';

/// Máximo de acordes que guarda el historial.
const int kHistoryLimit = 30;

/// Progreso del estudio: historial de acordes, racha de días, lecciones
/// aprendidas y récords del jam.
///
/// Responsabilidad única: recordar lo que la persona ha practicado. Las
/// pantallas lo consultan para mostrar el historial y la racha.
class StudioProgressController extends ChangeNotifier {
  /// Crea el controlador; [clock] permite fijar la fecha en las pruebas.
  StudioProgressController(this._preferences, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final StudioPreferences _preferences;
  final DateTime Function() _clock;

  /// Acordes abiertos recientemente, del más reciente al más antiguo.
  List<String> get recentChordIds => _preferences.recentChordIds;

  /// Racha: días seguidos practicando (hasta ayer si hoy aún no se tocó) y
  /// si hoy ya se practicó.
  ({int days, bool today}) get streak {
    final Set<String> days = _preferences.practiceDays;
    final DateTime now = _clock();
    return (days: practiceStreak(days, now), today: days.contains(dayKey(now)));
  }

  /// Lecciones aprendidas.
  Set<String> get completedLessons => _preferences.completedLessons;

  /// Récord de la pista [trackKey].
  int jamBest(String trackKey) => _preferences.jamBest(trackKey);

  /// Apunta que se abrió el acorde [chordId] y que hoy se practicó.
  Future<void> recordChord(String chordId) async {
    final List<String> updated = <String>[
      chordId,
      ...recentChordIds.where((String id) => id != chordId),
    ].take(kHistoryLimit).toList();
    await _preferences.setRecentChordIds(updated);
    await markPracticed();
  }

  /// Vacía el historial de acordes.
  Future<void> clearHistory() async {
    await _preferences.setRecentChordIds(const <String>[]);
    appLogger.info('historial de acordes borrado', channel: LogChannel.learn);
    notifyListeners();
  }

  /// Marca (o desmarca) una lección como aprendida.
  Future<void> toggleLesson(String lessonId) async {
    final Set<String> updated = <String>{...completedLessons};
    if (!updated.remove(lessonId)) {
      updated.add(lessonId);
      await markPracticed();
    }
    await _preferences.setCompletedLessons(updated);
    notifyListeners();
  }

  /// Guarda el resultado de una sesión de jam; `true` si es récord.
  Future<bool> saveJam(String trackKey, int points) async {
    final bool record = points > jamBest(trackKey);
    await _preferences.saveJamBest(trackKey, points);
    await markPracticed();
    return record;
  }

  /// Apunta que hoy se practicó.
  Future<void> markPracticed() async {
    final DateTime today = _clock();
    final Set<String> days = recentDays(<String>{
      ..._preferences.practiceDays,
      dayKey(today),
    }, today);
    await _preferences.setPracticeDays(days);
    notifyListeners();
  }
}
