import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/chord_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:flutter/foundation.dart';

/// Problema al cargar el detalle de un acorde.
///
/// El controlador describe *qué* ha pasado; la vista decide *cómo* contarlo en
/// el idioma activo.
enum ChordDetailProblem {
  /// El identificador no existe en el banco.
  notFound,

  /// Fallo inesperado al leer el banco.
  failed,
}

/// Controlador del detalle de un acorde.
class ChordDetailController extends ChangeNotifier {
  /// Crea el controlador.
  ChordDetailController(
    this._repository,
    this._audioRepository,
    this._preferences,
  );

  final ChordRepository _repository;
  final AudioRepository _audioRepository;
  final PreferencesRepository _preferences;

  Chord? _chord;
  int _selectedIndex = 0;
  bool _loading = false;
  ChordDetailProblem? _problem;

  /// Acorde cargado.
  Chord? get chord => _chord;

  /// Índice de la posición seleccionada.
  int get selectedIndex => _selectedIndex;

  /// Si está cargando.
  bool get loading => _loading;

  /// Problema de la última carga, si la hubo.
  ChordDetailProblem? get problem => _problem;

  /// Posición seleccionada actualmente.
  ChordVariant? get selectedVariant =>
      _chord == null || _chord!.variants.isEmpty
      ? null
      : _chord!.variants[_selectedIndex.clamp(0, _chord!.variants.length - 1)];

  /// Si el acorde está marcado como dominado.
  bool get isMastered =>
      _chord != null && _preferences.masteredChordIds.contains(_chord!.id);

  /// Carga el acorde por identificador.
  Future<void> load(String chordId) async {
    _loading = true;
    _problem = null;
    notifyListeners();
    try {
      if (!_repository.isLoaded) {
        await _repository.load();
      }
      final Chord? chord = _repository.chordById(chordId);
      if (chord == null) {
        appLogger.warning(
          'acorde no encontrado: $chordId',
          channel: LogChannel.chords,
        );
        _problem = ChordDetailProblem.notFound;
        _chord = null;
      } else {
        _chord = chord;
        _selectedIndex = 0;
        appLogger.debug(
          'detalle abierto: ${chord.id} (${chord.variantCount} posiciones)',
          channel: LogChannel.chords,
        );
        analytics.chordViewed(
          chordId: chord.id,
          chordName: chord.name,
          quality: chord.quality.id,
          difficulty: chord.difficulty.level,
        );
      }
    } on Object catch (error, stackTrace) {
      appLogger.error(
        'fallo al cargar el detalle de $chordId',
        channel: LogChannel.chords,
        error: error,
        stackTrace: stackTrace,
      );
      _problem = ChordDetailProblem.failed;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Selecciona otra posición del acorde.
  void selectVariant(int index) {
    if (_chord == null || index < 0 || index >= _chord!.variants.length) {
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }

  /// Reproduce el sonido de la posición seleccionada (rasgueo).
  Future<void> playSelected() async {
    final Chord? chord = _chord;
    final ChordVariant? variant = selectedVariant;
    if (chord == null || variant == null || !_preferences.soundEnabled) {
      return;
    }
    await _audioRepository.playChord(chord, variant);
    analytics.chordPlayed(chordId: chord.id, variantId: variant.id);
  }

  /// Reproduce la posición seleccionada como arpegio.
  Future<void> playArpeggio(ArpeggioPattern pattern) async {
    final Chord? chord = _chord;
    final ChordVariant? variant = selectedVariant;
    if (chord == null || variant == null || !_preferences.soundEnabled) {
      return;
    }
    await _audioRepository.playArpeggio(chord, variant, pattern);
    analytics.chordPlayed(
      chordId: chord.id,
      variantId: variant.id,
      arpeggio: true,
      patternId: pattern.id,
    );
  }

  /// Marca o desmarca el acorde como dominado.
  Future<void> toggleMastered() async {
    final Chord? chord = _chord;
    if (chord == null) {
      return;
    }
    final Set<String> updated = <String>{..._preferences.masteredChordIds};
    if (!updated.add(chord.id)) {
      updated.remove(chord.id);
    }
    await _preferences.setMasteredChordIds(updated);
    final bool mastered = updated.contains(chord.id);
    appLogger.info(
      mastered
          ? 'acorde dominado: ${chord.id}'
          : 'acorde desmarcado: ${chord.id}',
      channel: LogChannel.learn,
      context: <String, Object?>{'total': updated.length},
    );
    analytics.chordMasteryChanged(
      chordId: chord.id,
      mastered: mastered,
      totalMastered: updated.length,
    );
    notifyListeners();
  }
}
