import 'declaration_kind.dart';

/// Bloque con nombre y rango de líneas dentro de un archivo.
class DeclarationBlock {
  /// Crea un bloque de declaración.
  const DeclarationBlock({
    required this.kind,
    required this.name,
    required this.startLine,
    required this.endLine,
    this.enclosingType,
  });

  /// Tipo de bloque.
  final DeclarationKind kind;

  /// Nombre declarado.
  final String name;

  /// Primera línea del bloque (1-indexada).
  final int startLine;

  /// Última línea del bloque (1-indexada).
  final int endLine;

  /// Nombre del tipo que contiene el bloque; `null` si es de nivel superior.
  final String? enclosingType;

  /// Número de líneas que ocupa.
  int get lineCount => endLine - startLine + 1;

  /// `true` si el bloque es un cuerpo ejecutable (función o miembro).
  bool get isExecutable => switch (kind) {
    DeclarationKind.function => true,
    DeclarationKind.method => true,
    DeclarationKind.constructor => true,
    DeclarationKind.accessor => true,
    _ => false,
  };

  @override
  String toString() => '${kind.label} $name ($startLine-$endLine)';
}
