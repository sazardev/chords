import 'package:meta/meta.dart';

/// Estado de una nota del acorde objetivo frente a lo escuchado.
@immutable
class TargetNoteFeedback {
  /// Crea el estado de una nota objetivo.
  const TargetNoteFeedback({
    required this.note,
    required this.heard,
    this.strings = const <int>[],
  });

  /// Nombre de la nota (p. ej. `G`).
  final String note;

  /// Si el micrófono ya la ha detectado.
  final bool heard;

  /// Números de cuerda que la producen (1 = primera).
  final List<int> strings;

  @override
  String toString() => 'TargetNoteFeedback($note, heard: $heard, $strings)';
}

/// Feedback del acorde objetivo: notas acertadas, pendientes y sobrantes.
///
/// Lo usan el modo juego y su interfaz para decir en vivo qué falta, qué
/// suena de más y en qué cuerda mirar, en lugar de esperar al resultado.
@immutable
class ChordMatchFeedback {
  /// Crea el feedback con sus notas y las notas sobrantes.
  const ChordMatchFeedback({
    required this.notes,
    this.extraNotes = const <String>[],
  });

  /// Feedback sin objetivo (aún no hay ronda).
  const ChordMatchFeedback.empty()
    : notes = const <TargetNoteFeedback>[],
      extraNotes = const <String>[];

  /// Estado de cada nota del objetivo, en el orden del acorde.
  final List<TargetNoteFeedback> notes;

  /// Notas escuchadas que no pertenecen al acorde.
  final List<String> extraNotes;

  /// Notas del objetivo ya detectadas.
  int get heardCount =>
      notes.where((TargetNoteFeedback note) => note.heard).length;

  /// Total de notas del objetivo.
  int get total => notes.length;

  /// Si el acorde objetivo está completo.
  bool get isComplete => total > 0 && heardCount == total;

  /// Notas del objetivo que aún no suenan.
  List<TargetNoteFeedback> get missing =>
      notes.where((TargetNoteFeedback note) => !note.heard).toList();
}
