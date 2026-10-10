import 'declaration_block.dart';

/// Resultado de escanear un archivo: tipos declarados y cuerpos ejecutables.
class DeclarationTree {
  /// Crea el árbol de declaraciones.
  const DeclarationTree(this.types, this.executables);

  /// Árbol vacío.
  const DeclarationTree.empty()
    : types = const <DeclarationBlock>[],
      executables = const <DeclarationBlock>[];

  /// Tipos (clases, mixins, enums, extensiones y typedefs).
  final List<DeclarationBlock> types;

  /// Funciones, métodos, constructores y accesores.
  final List<DeclarationBlock> executables;
}
