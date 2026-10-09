import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/usecases/get_chord_by_id_use_case.dart';
import 'package:flutter/foundation.dart';

/// Controlador del detalle de un acorde.
class ChordDetailController extends ChangeNotifier {
  /// Crea el controlador.
  ChordDetailController(this._getChordById, this._audioRepository);

  final GetChordByIdUseCase _getChordById;
  final AudioRepository _audioRepository;

  Chord? _chord;
  int _selectedIndex = 0;
  bool _loading = false;
  String? _error;

  /// Acorde cargado.
  Chord? get chord => _chord;

  /// Índice de la posición seleccionada.
  int get selectedIndex => _selectedIndex;

  /// Si está cargando.
  bool get loading => _loading;

  /// Mensaje de error.
  String? get error => _error;

  /// Posición seleccionada actualmente.
  ChordVariant? get selectedVariant =>
      _chord == null || _chord!.variants.isEmpty
      ? null
      : _chord!.variants[_selectedIndex.clamp(0, _chord!.variants.length - 1)];

  /// Carga el acorde por identificador.
  Future<void> load(String chordId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final Chord? chord = await _getChordById.load(chordId);
      if (chord == null) {
        _error = 'No se encontró el acorde $chordId';
        _chord = null;
      } else {
        _chord = chord;
        _selectedIndex = 0;
      }
    } on Object catch (error) {
      _error = '$error';
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

  /// Reproduce el sonido de la posición seleccionada.
  Future<void> playSelected() async {
    final Chord? chord = _chord;
    final ChordVariant? variant = selectedVariant;
    if (chord == null || variant == null) {
      return;
    }
    await _audioRepository.playChord(chord, variant);
  }
}
