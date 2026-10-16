import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/services/arranger_context.dart';
import 'package:chords/domain/band/services/chord_voicing.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Golpe de guitarra ya resuelto para un tipo de guitarra.
typedef _Stroke = (GuitarStroke stroke, double velocity);

/// Escribe la guitarra rítmica: el rasgueo del género (o el de la pista) y
/// cómo lo toca cada tipo de guitarra.
class GuitarArranger {
  /// Crea el arreglista.
  const GuitarArranger([this._voicing = const ChordVoicing()]);

  final ChordVoicing _voicing;

  /// Rasgueo que toca la guitarra en esta sesión.
  ///
  /// El del género si la pista usa su rasgueo; si no (canciones, 3/4), el de
  /// la pista, ampliado a semicorcheas.
  ChordPattern patternFor(ArrangerContext context) {
    final String notation = context.track.strum.notation;
    if (context.beats == 4 && notation == context.preset.baseStrum) {
      return context.preset.guitar;
    }
    return expandStrum(notation);
  }

  /// Amplía un rasgueo en corcheas (`D-DU-UDU`) a semicorcheas.
  ChordPattern expandStrum(String eighths) => ChordPattern(
    eighths
        .split('')
        .map((String c) => 'DUB'.contains(c) ? '$c-' : '--')
        .join(),
  );

  /// Golpe de guitarra en el paso [step] del compás [bar], si hay.
  List<BandEvent> eventsAt(ArrangerContext context, int bar, int step) {
    final String token = patternFor(context).at(step);
    final _Stroke? stroke = _resolve(context.kinds.guitar, token);
    if (stroke == null) {
      return const <BandEvent>[];
    }
    final ChordSymbol chord = context.chordAt(bar, step);
    final double accent = step % 4 == 0 ? 1.0 : 0.88;
    return <BandEvent>[
      BandEvent(
        BandSound.guitar(
          context.kinds.guitar,
          stroke.$1,
          _notes(stroke.$1, chord),
        ),
        (stroke.$2 * accent * context.gain).clamp(0.05, 1.0),
      ),
    ];
  }

  List<int> _notes(GuitarStroke stroke, ChordSymbol chord) => switch (stroke) {
    GuitarStroke.power || GuitarStroke.powerMute => _voicing.power(chord),
    GuitarStroke.bass => <int>[_voicing.guitar(chord).first],
    _ => _voicing.guitar(chord),
  };

  /// Qué golpe y con qué fuerza toca [kind] la letra [token].
  _Stroke? _resolve(GuitarKind kind, String token) {
    final bool distorted = kind == GuitarKind.distorted;
    return switch (token) {
      'D' => (distorted ? GuitarStroke.power : GuitarStroke.down, 0.85),
      'U' => (distorted ? GuitarStroke.power : GuitarStroke.up, 0.6),
      'd' => (distorted ? GuitarStroke.powerMute : GuitarStroke.down, 0.45),
      'M' => (distorted ? GuitarStroke.powerMute : GuitarStroke.mute, 0.8),
      'X' => (GuitarStroke.chop, 0.85),
      'B' => (GuitarStroke.bass, 0.8),
      'P' => (distorted ? GuitarStroke.power : GuitarStroke.down, 0.95),
      'p' => (distorted ? GuitarStroke.powerMute : GuitarStroke.mute, 0.85),
      'R' => (
        kind == GuitarKind.nylon ? GuitarStroke.roll : GuitarStroke.down,
        0.9,
      ),
      _ => null,
    };
  }
}
