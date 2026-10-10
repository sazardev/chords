import 'declaration_block.dart';
import 'declaration_kind.dart';
import 'declaration_tree.dart';
import 'member_signature.dart';
import 'scanned_line.dart';

/// Patrón de declaración de tipo con modificadores previos.
final RegExp _typePattern = RegExp(
  r'^(?:(?:abstract|base|final|sealed|interface|mixin)\s+)*'
  r'(class|mixin|enum|extension|typedef)\s+'
  r'([A-Za-z_$][\w$]*)',
);

/// Resultado de reconocer una declaración en una línea.
class _Outcome {
  /// Crea el resultado con el bloque reconocido.
  const _Outcome(this.block);

  /// Bloque declarado en la línea analizada.
  final DeclarationBlock block;
}

/// Escáner de declaraciones de un archivo Dart.
///
/// Detecta tipos y cuerpos ejecutables usando sólo la profundidad de llaves,
/// sin construir un AST completo: es suficiente para medir tamaño y forma.
class DeclarationScanner {
  /// Crea el escáner.
  const DeclarationScanner();

  /// Analiza las líneas normalizadas del archivo.
  DeclarationTree scan(List<ScannedLine> lines) {
    final List<DeclarationBlock> types = <DeclarationBlock>[];
    final List<DeclarationBlock> executables = <DeclarationBlock>[];
    final List<_Scope> scopes = <_Scope>[];
    int index = 0;
    while (index < lines.length) {
      final ScannedLine line = lines[index];
      if (line.isCodeEmpty) {
        index++;
        continue;
      }
      final _Scope? scope = scopes.isEmpty ? null : scopes.last;
      if (_closesScope(line, scope)) {
        scopes.removeLast();
        index++;
        continue;
      }
      if (scope == null || !scope.block.isExecutable) {
        final _Outcome? outcome = _declare(lines, index, line, scope);
        if (outcome != null) {
          if (outcome.block.isExecutable) {
            executables.add(outcome.block);
          } else {
            types.add(outcome.block);
          }
          if (line.opensBlock) {
            scopes.add(_Scope(outcome.block, line.depthAfter));
          }
        }
      }
      index++;
    }
    return DeclarationTree(types, executables);
  }

  /// Reconoce el tipo o la firma que abre la línea indicada.
  _Outcome? _declare(
    List<ScannedLine> lines,
    int index,
    ScannedLine line,
    _Scope? scope,
  ) {
    final RegExpMatch? type = _typePattern.firstMatch(line.trimmed);
    if (type != null) {
      return _Outcome(
        DeclarationBlock(
          kind: _kindOf(type.group(1)!),
          name: type.group(2)!,
          startLine: line.number,
          endLine: _blockEnd(lines, index),
        ),
      );
    }
    if (looksLikeSignature(line)) {
      final String? name = signatureName(line);
      return _Outcome(
        DeclarationBlock(
          kind: _executableKind(name, line, scope),
          name: name ?? '<anónimo>',
          startLine: line.number,
          endLine: _blockEnd(lines, index),
          enclosingType: scope?.block.name,
        ),
      );
    }
    return null;
  }

  /// `true` si la línea cierra el ámbito abierto.
  bool _closesScope(ScannedLine line, _Scope? scope) =>
      scope != null &&
      line.isLoneClosingBrace &&
      scope.bodyDepth == line.depthBefore;

  /// Última línea del bloque que empieza en `start`.
  int _blockEnd(List<ScannedLine> lines, int start) {
    final ScannedLine first = lines[start];
    if (first.opensBlock) {
      if (first.depthAfter == first.depthBefore + 1) {
        for (int index = start + 1; index < lines.length; index++) {
          if (lines[index].depthAfter == first.depthBefore) {
            return lines[index].number;
          }
        }
      }
      return first.number;
    }
    if (first.trimmed.endsWith(';')) {
      return first.number;
    }
    for (int index = start + 1; index < lines.length; index++) {
      final ScannedLine line = lines[index];
      if (line.depthBefore < first.depthBefore) {
        return lines[index - 1].number;
      }
      if (line.depthBefore == first.depthBefore && line.trimmed.endsWith(';')) {
        return line.number;
      }
      if (looksLikeSignature(line)) {
        return lines[index - 1].number;
      }
    }
    return lines.last.number;
  }

  /// Tipo de declaración a partir de la palabra clave.
  DeclarationKind _kindOf(String keyword) => switch (keyword) {
    'class' => DeclarationKind.classType,
    'mixin' => DeclarationKind.mixinType,
    'enum' => DeclarationKind.enumType,
    'extension' => DeclarationKind.extensionType,
    'typedef' => DeclarationKind.typedefType,
    _ => DeclarationKind.classType,
  };

  /// Clasifica un cuerpo ejecutable según su ámbito y su nombre.
  DeclarationKind _executableKind(
    String? name,
    ScannedLine line,
    _Scope? scope,
  ) {
    if (RegExp(r'\b(?:get|set)\s+[A-Za-z_$]').hasMatch(line.trimmed)) {
      return DeclarationKind.accessor;
    }
    if (scope == null) {
      return DeclarationKind.function;
    }
    final String typeName = scope.block.name;
    if (name != null && (name == typeName || name.startsWith('$typeName.'))) {
      return DeclarationKind.constructor;
    }
    return DeclarationKind.method;
  }
}

/// Ámbito abierto durante el recorrido.
class _Scope {
  /// Crea el ámbito del bloque indicado.
  const _Scope(this.block, this.bodyDepth);

  /// Bloque que abre el ámbito.
  final DeclarationBlock block;

  /// Profundidad de llaves dentro del bloque.
  final int bodyDepth;
}
