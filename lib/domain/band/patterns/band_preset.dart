import 'package:chords/domain/band/clock/swing_grid.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/presets/waltz_defaults.dart';
import 'package:meta/meta.dart';

/// Cómo suena la banda en un género: instrumentos, ritmos y carácter.
///
/// Los patrones están escritos en rejilla de semicorcheas (16 pasos en 4/4,
/// 12 en 3/4). Lo que un género no define en 3/4 se rellena con el vals
/// genérico de [waltz_defaults].
@immutable
class BandPreset {
  /// Crea el preset.
  const BandPreset({
    required this.id,
    required this.drums,
    required this.bass,
    required this.guitar,
    required this.baseStrum,
    this.bassB,
    this.keys,
    this.winds,
    this.drums34,
    this.bass34,
    this.kit = DrumKit.acoustic,
    this.bassKind = BassKind.finger,
    this.guitarKind = GuitarKind.acoustic,
    this.keysKind = KeysKind.piano,
    this.windKind = WindKind.brass,
    this.swing = 0,
    this.swingGrid = SwingGrid.eighth,
    this.loopAccent = DrumVoice.crash,
    this.fillEvery = 4,
    this.punch = 1,
  });

  /// Identificador del género (`rock`).
  final String id;

  /// Ritmo de batería y percusión en 4/4.
  final DrumGroove drums;

  /// Línea de bajo en 4/4.
  final BassPattern bass;

  /// Variante del bajo para las frases con más empuje.
  final BassPattern? bassB;

  /// Rasgueo de la guitarra en 4/4.
  final ChordPattern guitar;

  /// Notación del rasgueo de `StrumPattern` que [guitar] amplía.
  ///
  /// Si la pista usa otro rasgueo, la guitarra sigue el de la pista.
  final String baseStrum;

  /// Comping del teclado en 4/4 (`null` = sin teclado).
  final ChordPattern? keys;

  /// Notas del viento en 4/4 (`null` = sin vientos).
  final ChordPattern? winds;

  /// Ritmo de batería en 3/4 (`null` = el vals genérico).
  final DrumGroove? drums34;

  /// Bajo en 3/4 (`null` = el vals genérico).
  final BassPattern? bass34;

  /// Kit por defecto.
  final DrumKit kit;

  /// Bajo por defecto.
  final BassKind bassKind;

  /// Guitarra por defecto.
  final GuitarKind guitarKind;

  /// Teclado por defecto.
  final KeysKind keysKind;

  /// Viento por defecto.
  final WindKind windKind;

  /// Swing por defecto (0 recto, 1 tresillo completo).
  final double swing;

  /// Figuras sobre las que actúa el swing.
  final SwingGrid swingGrid;

  /// Golpe que marca el principio de cada vuelta (`null` = ninguno).
  final DrumVoice? loopAccent;

  /// Cada cuántos compases hay relleno (4 u 8).
  final int fillEvery;

  /// Fuerza general de la banda en el género (0-1).
  final double punch;

  /// Ritmo de batería para un compás de [beats] pulsos.
  DrumGroove drumsFor(int beats) =>
      beats == 3 ? (drums34 ?? kWaltzGroove) : drums;

  /// Bajo para un compás de [beats] pulsos; [lift] pide la variante fuerte.
  BassPattern bassFor(int beats, {required bool lift}) {
    if (beats == 3) {
      return bass34 ?? kWaltzBass;
    }
    return lift ? (bassB ?? bass) : bass;
  }

  /// Teclado para un compás de [beats] pulsos.
  ChordPattern? keysFor(int beats) =>
      beats == 3 && keys != null ? kWaltzKeys : keys;

  /// Vientos para un compás de [beats] pulsos.
  ChordPattern? windsFor(int beats) =>
      beats == 3 && winds != null ? kWaltzWinds : winds;
}
