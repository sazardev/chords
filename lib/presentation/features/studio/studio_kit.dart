import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/preferences/repositories/studio_preferences.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/features/theory/scale_explorer_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Las piezas del estudio (teoría, escalas, jam, cancionero e historial),
/// ya conectadas entre sí.
class StudioKit {
  /// Construye las piezas sobre las preferencias, el banco y el audio.
  factory StudioKit(
    StudioPreferences preferences,
    ChordRepository chords,
    AudioRepository audio,
  ) {
    final StudioProgressController progress = StudioProgressController(
      preferences,
    );
    return StudioKit._(
      progress,
      ScaleExplorerController(SoundCuePlayer(audio, chords)),
      JamController(audio, chords, progress),
    );
  }

  StudioKit._(this.progress, this.explorer, this.jam);

  /// Historial, racha, lecciones y récords.
  final StudioProgressController progress;

  /// Explorador de escalas.
  final ScaleExplorerController explorer;

  /// Jam guiado.
  final JamController jam;

  /// Proveedores para el árbol de widgets.
  List<SingleChildWidget> get providers => <SingleChildWidget>[
    ChangeNotifierProvider<StudioProgressController>.value(value: progress),
    ChangeNotifierProvider<ScaleExplorerController>.value(value: explorer),
    ChangeNotifierProvider<JamController>.value(value: jam),
  ];
}
