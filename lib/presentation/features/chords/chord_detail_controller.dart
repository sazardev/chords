import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/chord_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:chords/presentation/features/chords/chord_detail_extras.dart';
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
  ChordDetailExtras? _extras;
  int _selectedIndex = 0;
  bool _loading = false;
  ChordDetailProblem? _problem;

  /// Acorde cargado.
  Chord? get chord => _chord;

  /// Notas, parientes, progresiones, escalas y filtro de posiciones.
  ChordDetailExtras? get extras => _extras;

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
        _extras = null;
      } else {
        _chord = chord;
        _extras = ChordDetailExtras(
          chord,
          ChordInsights.of(chord, _repository.chords),
        );
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

  /// Reproduce la posición seleccionada: rasgueada o, con [arpeggio], como
  /// arpegio.
  Future<void> playSelected({ArpeggioPattern? arpeggio}) =>
      arpeggio == null ? _strum() : _arpeggiate(arpeggio);

  Future<void> _strum() async {
    final Chord? chord = _chord;
    final ChordVariant? variant = selectedVariant;
    if (chord == null || variant == null || !_preferences.soundEnabled) {
      return;
    }
    try {
      await _audioRepository.playChord(chord, variant);
    } on Object catch (error, stackTrace) {
      appLogger.warning(
        'no se pudo reproducir ${chord.id}',
        channel: LogChannel.audio,
        error: error,
        stackTrace: stackTrace,
      );
      return;
    }
    analytics.chordPlayed(chordId: chord.id, variantId: variant.id);
  }

  Future<void> _arpeggiate(ArpeggioPattern pattern) async {
    final Chord? chord = _chord;
    final ChordVariant? variant = selectedVariant;
    if (chord == null || variant == null || !_preferences.soundEnabled) {
      return;
    }
    try {
      await _audioRepository.playArpeggio(chord, variant, pattern);
    } on Object catch (error, stackTrace) {
      appLogger.warning(
        'no se pudo reproducir el arpegio de ${chord.id}',
        channel: LogChannel.audio,
        error: error,
        stackTrace: stackTrace,
      );
      return;
    }
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
