import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/services/arranger_context.dart';

/// Fuerza a partir de la cual se usa la capa fuerte de una muestra.
const double kHardLayer = 0.62;

/// Escribe la batería y la percusión: ritmo, variantes, relleno y el golpe
/// que abre cada vuelta.
class DrumArranger {
  /// Crea el arreglista.
  const DrumArranger();

  /// Golpes de batería y percusión en el paso [step] del compás [bar].
  List<BandEvent> eventsAt(ArrangerContext context, int bar, int step) {
    final DrumGroove groove = context.preset.drumsFor(context.beats);
    final DrumPattern pattern = context.isFillBar(bar)
        ? groove.fill
        : (context.isLift(bar) ? groove.b : groove.a);
    final Map<DrumVoice, double> hits = <DrumVoice, double>{
      for (final (DrumVoice voice, double level) in pattern.hitsAt(step))
        voice: level,
    };
    final DrumVoice? accent = context.preset.loopAccent;
    if (step == 0 && accent != null && context.isLoopStart(bar)) {
      hits[accent] = 1;
    }
    return <BandEvent>[
      for (final MapEntry<DrumVoice, double> hit in hits.entries)
        _event(context, hit.key, hit.value),
    ];
  }

  BandEvent _event(ArrangerContext context, DrumVoice voice, double level) {
    final double velocity = (level * context.gain).clamp(0.05, 1.0);
    return BandEvent(
      BandSound.drum(voice, context.kinds.kit, hard: velocity >= kHardLayer),
      velocity,
    );
  }
}
