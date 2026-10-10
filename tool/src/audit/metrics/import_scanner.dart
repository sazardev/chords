/// Directiva `import` encontrada en un archivo.
class ImportDirective {
  /// Crea la directiva.
  const ImportDirective({required this.uri, required this.line});

  /// URI importado.
  final String uri;

  /// Línea de la directiva (1-indexada).
  final int line;
}

/// Escáner de directivas `import`.
class ImportScanner {
  /// Crea el escáner.
  const ImportScanner();

  /// Patrón de una directiva `import`.
  static final RegExp _pattern = RegExp(r"""^\s*import\s+'([^']+)'""");

  /// Detecta los imports del archivo.
  List<ImportDirective> scan(List<String> lines) {
    final List<ImportDirective> imports = <ImportDirective>[];
    for (int index = 0; index < lines.length; index++) {
      final RegExpMatch? match = _pattern.firstMatch(lines[index]);
      final String? uri = match?.group(1);
      if (uri != null) {
        imports.add(ImportDirective(uri: uri, line: index + 1));
      }
    }
    return imports;
  }
}
