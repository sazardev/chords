import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/audio/services/pitch_math.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/scale_positions.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter/foundation.dart';

/// Pausa entre notas al tocar una escala.
const int kScaleNoteGapMs = 320;

/// Controlador del explorador de escalas.
///
/// Responsabilidad única: qué escala, tónica y posición se miran, y hacerlas
/// sonar. Dibujarlas es cosa de la pantalla.
class ScaleExplorerController extends ChangeNotifier {
  /// Crea el controlador con el reproductor de sonidos.
  ScaleExplorerController(this._player);

  final SoundCuePlayer _player;

  int _tonic = 9;
  ScaleType _scale = ScaleType.minorPentatonic;
  int _position = 0;
  bool _degrees = false;
  bool _playing = false;

  /// Tónica (0 = Do).
  int get tonic => _tonic;

  /// Escala elegida.
  ScaleType get scale => _scale;

  /// Posición elegida (0 = todo el mástil).
  int get position => _position;

  /// `true` si las notas se etiquetan con su grado.
  bool get showDegrees => _degrees;

  /// `true` mientras suena la escala.
  bool get isPlaying => _playing;

  /// Número de posiciones (cajas) de la escala.
  int get positionCount => ScalePositions(_scale, _tonic).positions().length;

  /// Elige tónica y escala de golpe (al abrir desde una lección o un enlace).
  void show(ScaleType scale, int tonic, {int position = 0}) {
    _scale = scale;
    _tonic = tonic % 12;
    _position = position.clamp(0, positionCount);
    notifyListeners();
  }

  /// Alterna entre nombres de nota y grados.
  void toggleLabels() {
    _degrees = !_degrees;
    notifyListeners();
  }

  /// Toca la escala: la posición elegida o una octava desde la tónica, subiendo
  /// y bajando.
  Future<void> play() async {
    if (_playing) {
      _player.cancel();
      _setPlaying(false);
      return;
    }
    final List<double> up = _frequencies();
    final List<double> path = <double>[...up, ...up.reversed.skip(1)];
    _setPlaying(true);
    await _player.play(<SoundCue>[
      for (int i = 0; i < path.length; i++)
        ToneCue(path[i], delayMs: i == 0 ? 0 : kScaleNoteGapMs),
    ]);
    _setPlaying(false);
  }

  /// Toca una nota suelta del mástil.
  Future<void> playNote(FretPosition note) =>
      _player.play(<SoundCue>[ToneCue(note.frequency)]);

  List<double> _frequencies() {
    if (_position == 0) {
      final double root = FretPosition(6, (_tonic - 4 + 12) % 12).frequency;
      return <double>[
        for (final int interval in <int>[..._scale.intervals, 12])
          shiftBySemitones(root, interval),
      ];
    }
    final List<ScalePosition> boxes = ScalePositions(
      _scale,
      _tonic,
    ).positions();
    final List<double> notes =
        boxes[_position - 1].notes.map((FretPosition p) => p.frequency).toList()
          ..sort();
    return notes;
  }

  void _setPlaying(bool value) {
    if (_playing != value) {
      _playing = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player.cancel();
    super.dispose();
  }
}
