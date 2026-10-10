import 'dart:io';

/// Archivo fuente normalizado, listo para ser analizado sin I/O.
class SourceFile {
  /// Crea un archivo fuente a partir de sus líneas.
  const SourceFile({required this.path, required this.lines});

  /// Crea un archivo fuente con las líneas de un archivo de disco.
  factory SourceFile.fromFile(File file, {required String relativePath}) =>
      SourceFile(path: relativePath, lines: file.readAsLinesSync());

  /// Ruta mostrable del archivo (relativa a la raíz auditada).
  final String path;

  /// Líneas crudas del archivo.
  final List<String> lines;

  /// Número de líneas del archivo.
  int get lineCount => lines.length;
}
