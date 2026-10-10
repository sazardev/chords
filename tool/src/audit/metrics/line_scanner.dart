import 'scanned_line.dart';

/// Resultado de normalizar una línea cruda.
class _StrippedLine {
  /// Crea el resultado.
  const _StrippedLine({required this.code, required this.endsInBlockComment});

  /// Código sin comentarios y con el interior de las cadenas vaciado.
  final String code;

  /// `true` si la línea termina dentro de un comentario de bloque.
  final bool endsInBlockComment;
}

/// Recortador de una línea: come comentarios y contenido de cadenas.
///
/// Cada contexto (comentario de bloque, cadena, comentario de línea) tiene su
/// propio método, así ninguno acumula decisiones ajenas.
class _Stripper {
  /// Crea el recortador; conserva su estado entre líneas.
  _Stripper();

  /// `true` si el recorte arranca dentro de un comentario de bloque.
  bool inBlockComment = false;
  bool _inString = false;
  bool _escaped = false;
  final StringBuffer _buffer = StringBuffer();

  /// Recorta la línea recibida.
  ///
  /// El estado de cadena se reinicia en cada línea; solo el comentario de
  /// bloque puede sobrevivir de una línea a la siguiente.
  _StrippedLine strip(String raw) {
    _buffer.clear();
    _inString = false;
    _escaped = false;
    int cursor = 0;
    while (cursor < raw.length) {
      final String char = raw[cursor];
      final int consumed =
          _skipBlockCommentEnd(raw, cursor, char) ??
          _keepInsideBlockComment(char) ??
          _keepInsideString(char) ??
          _dropLineComment(raw, cursor, char) ??
          _openBlockComment(raw, cursor, char) ??
          _openString(char) ??
          _keep(char);
      cursor += consumed;
    }
    return _StrippedLine(
      code: _buffer.toString(),
      endsInBlockComment: inBlockComment,
    );
  }

  /// Cierra un comentario de bloque cuando aparece `*/`.
  int? _skipBlockCommentEnd(String raw, int cursor, String char) {
    if (!inBlockComment || char != '*' || _peek(raw, cursor + 1) != '/') {
      return null;
    }
    inBlockComment = false;
    _buffer.write('  ');
    return 2;
  }

  /// Consume caracteres dentro de un comentario de bloque.
  int? _keepInsideBlockComment(String char) {
    if (!inBlockComment) {
      return null;
    }
    _buffer.write(' ');
    return 1;
  }

  /// Consume caracteres dentro de una cadena de texto.
  int? _keepInsideString(String char) {
    if (!_inString) {
      return null;
    }
    if (_escaped) {
      _escaped = false;
    } else if (char == r'\') {
      _escaped = true;
    } else if (char == "'" || char == '"') {
      _inString = false;
    }
    _buffer.write(' ');
    return 1;
  }

  /// Descarta el resto de la línea si empieza un comentario de línea.
  int? _dropLineComment(String raw, int cursor, String char) {
    if (char != '/' || _peek(raw, cursor + 1) != '/') {
      return null;
    }
    _buffer.write(' ' * (raw.length - cursor));
    return raw.length - cursor;
  }

  /// Abre un comentario de bloque.
  int? _openBlockComment(String raw, int cursor, String char) {
    if (char != '/' || _peek(raw, cursor + 1) != '*') {
      return null;
    }
    inBlockComment = true;
    _buffer.write('  ');
    return 2;
  }

  /// Abre una cadena de texto conservando la comilla.
  int? _openString(String char) {
    if (char != "'" && char != '"') {
      return null;
    }
    _inString = true;
    _buffer.write(char);
    return 1;
  }

  /// Conserva el carácter recibido.
  int _keep(String char) {
    _buffer.write(char);
    return 1;
  }

  /// Carácter en `index` o `null` si está fuera de rango.
  String? _peek(String raw, int index) =>
      index < raw.length ? raw[index] : null;
}

/// Escáner de líneas: convierte código Dart en [ScannedLine].
///
/// Elimina comentarios (`//`, `/* */`) y vacía el interior de las cadenas para
/// que ni los comentarios ni los textos contaminen el conteo de llaves ni las
/// métricas de complejidad.
class LineScanner {
  /// Crea el escáner.
  const LineScanner();

  /// Normaliza las líneas recibidas.
  List<ScannedLine> scan(List<String> lines) {
    final List<ScannedLine> scanned = <ScannedLine>[];
    final _Stripper stripper = _Stripper();
    int depth = 0;
    for (int index = 0; index < lines.length; index++) {
      final String raw = lines[index];
      final int depthBefore = depth;
      final _StrippedLine stripped = stripper.strip(raw);
      depth = _depthAfter(stripped.code, depth);
      scanned.add(
        ScannedLine(
          number: index + 1,
          indent: _indentOf(raw),
          code: stripped.code,
          depthBefore: depthBefore,
          depthAfter: depth,
        ),
      );
    }
    return scanned;
  }

  /// Profundidad de llaves resultante de procesar la línea.
  int _depthAfter(String code, int depth) {
    int value = depth;
    for (int index = 0; index < code.length; index++) {
      final String char = code[index];
      if (char == '{') {
        value++;
      } else if (char == '}') {
        value = value > 0 ? value - 1 : 0;
      }
    }
    return value;
  }

  /// Número de espacios iniciales de la línea.
  int _indentOf(String raw) {
    int spaces = 0;
    while (spaces < raw.length && raw[spaces] == ' ') {
      spaces++;
    }
    return spaces;
  }
}
