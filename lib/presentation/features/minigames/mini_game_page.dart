import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/presentation/features/minigames/build_chord_page.dart';
import 'package:chords/presentation/features/minigames/chord_changes_page.dart';
import 'package:chords/presentation/features/minigames/mic_game_page.dart';
import 'package:chords/presentation/features/minigames/quiz_page.dart';
import 'package:chords/presentation/router/router_error_screen.dart';
import 'package:flutter/material.dart';

/// Elige la pantalla que corresponde a un minijuego según su tipo.
///
/// Los juegos de opciones usan [QuizPage], "arma el acorde" su tablero,
/// "cambios de acorde" su reloj y los demás de micrófono [MicGamePage]. Un
/// identificador desconocido muestra la pantalla de ruta no encontrada.
class MiniGamePage extends StatelessWidget {
  /// Crea la pantalla del juego con identificador [gameId].
  const MiniGamePage({required this.gameId, super.key});

  /// Identificador recibido en la ruta (`?kind=guessNote`).
  final String? gameId;

  @override
  Widget build(BuildContext context) {
    final MiniGameKind? kind = MiniGameKind.fromId(gameId);
    if (kind == null) {
      return RouterErrorScreen(location: 'minigame:$gameId');
    }
    if (kind == MiniGameKind.buildChord) {
      return const BuildChordPage();
    }
    if (kind == MiniGameKind.chordChanges) {
      return const ChordChangesPage();
    }
    return kind.usesMic ? MicGamePage(kind: kind) : QuizPage(kind: kind);
  }
}
