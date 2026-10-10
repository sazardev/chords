import 'class_members_scanner.dart';
import 'declaration_block.dart';

/// Tipo declarado con el recuento de sus miembros.
class TypeSummary {
  /// Crea el resumen.
  const TypeSummary(this.block, this.members);

  /// Declaración del tipo.
  final DeclarationBlock block;

  /// Recuento de miembros del tipo.
  final ClassMembers members;

  /// Número de líneas que ocupa el tipo.
  int get lineCount => block.lineCount;

  /// Nombre legible del tipo (p. ej. `class Chord`).
  String get displayName => '${block.kind.label} ${block.name}';
}
