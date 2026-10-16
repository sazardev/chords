import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/preferences/repositories/progress_preferences.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/minigames/build_chord_controller.dart';
import 'package:chords/presentation/features/minigames/chord_changes_controller.dart';
import 'package:chords/presentation/features/minigames/mic_game_controller.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Los controladores de los minijuegos, ya conectados entre sí.
///
/// Comparten el progreso (estrellas y récords) y el reproductor de sonidos;
/// cada familia de juegos tiene el suyo: opciones, "arma el acorde",
/// micrófono y "cambios de acorde".
class MiniGamesKit {
  /// Construye los controladores sobre el audio, el banco y las preferencias.
  ///
  /// [guitar] silencia el micrófono mientras suena la referencia y deja que
  /// los juegos se manejen con las cuerdas al aire.
  factory MiniGamesKit(
    AudioRepository audio,
    ChordRepository chords,
    ProgressPreferences preferences, {
    GuitarCommandListener? guitar,
  }) {
    final MiniGameProgressController progress = MiniGameProgressController(
      preferences,
    );
    final SoundCuePlayer player = SoundCuePlayer(audio, chords);
    return MiniGamesKit._(
      progress,
      QuizController(chords, player, progress),
      BuildChordController(chords, audio, progress),
      MicGameController(audio, player, progress, guitar: guitar),
      ChordChangesController(audio, chords, progress, guitar: guitar),
    );
  }

  MiniGamesKit._(
    this.progress,
    this.quiz,
    this.buildChord,
    this.mic,
    this.chordChanges,
  );

  /// Estrellas y récords de cada juego.
  final MiniGameProgressController progress;

  /// Juegos de preguntas de opciones.
  final QuizController quiz;

  /// "Arma el acorde".
  final BuildChordController buildChord;

  /// Juegos con micrófono por retos.
  final MicGameController mic;

  /// "Cambios de acorde".
  final ChordChangesController chordChanges;

  /// Proveedores para el árbol de widgets.
  List<SingleChildWidget> get providers => <SingleChildWidget>[
    ChangeNotifierProvider<MiniGameProgressController>.value(value: progress),
    ChangeNotifierProvider<QuizController>.value(value: quiz),
    ChangeNotifierProvider<BuildChordController>.value(value: buildChord),
    ChangeNotifierProvider<MicGameController>.value(value: mic),
    ChangeNotifierProvider<ChordChangesController>.value(value: chordChanges),
  ];
}
