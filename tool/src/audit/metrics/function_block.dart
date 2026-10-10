import 'declaration_block.dart';

/// Cuerpo ejecutable con sus puntos de decisión.
class FunctionBlock {
  /// Crea el bloque.
  const FunctionBlock(this.block, {required this.branchCount});

  /// Declaración del cuerpo.
  final DeclarationBlock block;

  /// Puntos de decisión contabilizados en el cuerpo.
  final int branchCount;

  /// Nombre del cuerpo, con su tipo contenedor si lo tiene.
  String get qualifiedName {
    final String? owner = block.enclosingType;
    return owner == null ? block.name : '$owner.${block.name}';
  }
}
