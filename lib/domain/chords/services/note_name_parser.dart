import 'package:chords/domain/chords/services/search_text.dart';

/// Una nota leída de un texto: su clase de tono y lo que sobró detrás.
typedef ParsedNote = ({int pitchClass, String rest});

const Map<String, int> _english = <String, int>{
  'c': 0,
  'd': 2,
  'e': 4,
  'f': 5,
  'g': 7,
  'a': 9,
  'b': 11,
};

const Map<String, int> _spanish = <String, int>{
  'do': 0,
  're': 2,
  'mi': 4,
  'fa': 5,
  'sol': 7,
  'la': 9,
  'si': 11,
};

/// Lee al principio de [text] el nombre de una nota en inglés (`C#`, `Bb`) o
/// en español (`Do`, `Sol#`, `Sib`, `Fa sostenido`) con su alteración.
///
/// Los nombres en español tienen prioridad (`Do` es Do, no Re disminuido).
/// Devuelve `null` si el texto no empieza por una nota.
ParsedNote? parseLeadingNote(String text) {
  final String trimmed = text.trimLeft();
  return _leading(trimmed, _spanish, spanish: true) ??
      _leading(trimmed, _english, spanish: false);
}

ParsedNote? _leading(
  String text,
  Map<String, int> names, {
  required bool spanish,
}) {
  final String lower = text.toLowerCase();
  for (final MapEntry<String, int> entry in names.entries) {
    if (!lower.startsWith(entry.key)) {
      continue;
    }
    if (spanish && !_endsWord(lower, entry.key.length)) {
      continue;
    }
    final String after = text.substring(entry.key.length);
    final ({int shift, String rest}) accidental = _accidental(after);
    return (
      pitchClass: (entry.value + accidental.shift) % 12,
      rest: accidental.rest,
    );
  }
  return null;
}

/// En español el nombre acaba en palabra o en una alteración o sufijo pegado
/// (`Lam`, `Sol7`, `Sib`), pero no es parte de otra palabra (`dominante`).
bool _endsWord(String lower, int length) {
  if (lower.length == length) {
    return true;
  }
  final String next = lower[length];
  return !RegExp('[a-z]').hasMatch(next) ||
      next == 'm' ||
      next == 'b' ||
      next == 's' && lower.startsWith('sost', length);
}

({int shift, String rest}) _accidental(String after) {
  final String lower = normalizeSearchText(after);
  if (after.startsWith('#') || after.startsWith('♯')) {
    return (shift: 1, rest: after.substring(1));
  }
  if (after.startsWith('b') || after.startsWith('♭')) {
    return (shift: -1, rest: after.substring(1));
  }
  if (lower.startsWith('sostenido')) {
    return (shift: 1, rest: after.trimLeft().substring('sostenido'.length));
  }
  if (lower.startsWith('bemol')) {
    return (shift: -1, rest: after.trimLeft().substring('bemol'.length));
  }
  return (shift: 0, rest: after);
}

/// Clase de tono de un texto que es exactamente el nombre de una nota
/// (`C#`, `mib`, `Sol`); `null` si no lo es.
int? parseWholeNote(String text) {
  final ParsedNote? note = parseLeadingNote(text.trim());
  return note != null && note.rest.trim().isEmpty ? note.pitchClass : null;
}
