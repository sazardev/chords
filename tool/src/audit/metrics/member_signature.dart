/// Reglas de reconocimiento de firmas de funciones, métodos y accesores.
///
/// Compartido por el escáner de declaraciones y el de miembros públicos para
/// que ambos detecten exactamente las mismas líneas.
library;

import 'scanned_line.dart';

/// Cabecera permitida antes del nombre de una firma.
final RegExp _headPattern = RegExp(r'^[\w$<>,.\s\[\]]*$');

/// Identificador final de una firma, con posible sufijo de nombre con punto.
final RegExp _namePattern = RegExp(
  r'([A-Za-z_$][\w$]*(?:\s*\.\s*[A-Za-z_$][\w$]*)?)\s*$',
);

/// Acceso rápido (`get`/`set`) de una firma.
final RegExp _accessorPattern = RegExp(
  r'\b(?:get|set)\s+([A-Za-z_$][\w$]*)\s*(?:=>|;|\(|{)',
);

/// Identificador final de una línea de campo.
final RegExp _fieldPattern = RegExp(r'([A-Za-z_$][\w$]*)\s*$');

/// Palabras clave que nunca son el nombre de una firma.
const Set<String> _keywords = <String>{
  'abstract',
  'as',
  'assert',
  'await',
  'base',
  'case',
  'catch',
  'class',
  'const',
  'covariant',
  'do',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'final',
  'for',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'this',
  'throw',
  'try',
  'typedef',
  'when',
  'while',
  'with',
  'yield',
};

/// `true` si la línea parece el inicio de una función, método o accesor.
bool looksLikeSignature(ScannedLine line) {
  if (line.isCodeEmpty) {
    return false;
  }
  final String code = line.trimmed;
  if (code.startsWith('}') || code.startsWith('{')) {
    return false;
  }
  if (_accessorPattern.hasMatch(code)) {
    return true;
  }
  final int paren = code.indexOf('(');
  if (paren < 0) {
    return false;
  }
  final String head = code.substring(0, paren);
  if (!_headPattern.hasMatch(head)) {
    return false;
  }
  if (_normalizedHead(head).contains('=')) {
    return false;
  }
  return _trailingName(head) != null;
}

/// Nombre declarado por la firma; `null` si no se reconoce.
String? signatureName(ScannedLine line) {
  final String code = line.trimmed;
  final RegExpMatch? accessor = _accessorPattern.firstMatch(code);
  if (accessor != null) {
    return accessor.group(1);
  }
  final int paren = code.indexOf('(');
  if (paren < 0) {
    return null;
  }
  final RegExpMatch? match = _namePattern.firstMatch(code.substring(0, paren));
  return match?.group(1)?.trim();
}

/// Nombre del campo declarado en una línea de miembro.
String? fieldName(ScannedLine line) {
  final String code = line.trimmed.replaceFirst(';', '');
  final int assign = _assignmentIndex(code);
  final String head = assign >= 0 ? code.substring(0, assign) : code;
  return _fieldPattern.firstMatch(head.trim())?.group(1);
}

/// Nombre propio declarado al final de la cabecera; `null` si es palabra clave.
String? _trailingName(String head) {
  final RegExpMatch? match = _namePattern.firstMatch(head.trim());
  final String? name = match?.group(1)?.trim();
  if (name == null || _keywords.contains(name.split('.').last)) {
    return null;
  }
  return name;
}

/// Sustituye los comparadores que contienen `=` por un marcador neutro.
String _normalizedHead(String head) => head
    .replaceAll('=>', '@@')
    .replaceAll('==', '@@')
    .replaceAll('!=', '@@')
    .replaceAll('<=', '@@')
    .replaceAll('>=', '@@');

/// Índice del primer `=` de asignación; `-1` si no hay ninguno.
int _assignmentIndex(String code) {
  for (int index = 0; index < code.length; index++) {
    final String? next = index + 1 < code.length ? code[index + 1] : null;
    if (code[index] == '=' && next != '=' && next != '>') {
      return index;
    }
  }
  return -1;
}
