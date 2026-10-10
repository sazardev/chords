import 'declaration_block.dart';
import 'declaration_kind.dart';
import 'member_signature.dart';
import 'scanned_line.dart';

/// Recuento de miembros de un tipo.
class ClassMembers {
  /// Crea el recuento.
  const ClassMembers({
    required this.total,
    required this.publicMembers,
    required this.publicMethods,
    required this.adaptsInterface,
  });

  /// Tipo sin miembros.
  const ClassMembers.empty()
    : total = 0,
      publicMembers = 0,
      publicMethods = 0,
      adaptsInterface = false;

  /// Total de miembros detectados (públicos y privados).
  final int total;

  /// Miembros con nombre público (sin guion bajo inicial).
  final int publicMembers;

  /// Métodos, constructores y accesores públicos (comportamiento).
  final int publicMethods;

  /// `true` si el tipo implementa una interfaz ajena.
  ///
  /// Los adaptadores heredan la anchura del contrato que implementan, así que
  /// no se les exige el mismo presupuesto de miembros públicos.
  final bool adaptsInterface;
}

/// Escáner de miembros declarados en el cuerpo de un tipo.
class ClassMembersScanner {
  /// Crea el escáner.
  const ClassMembersScanner();

  /// Marca de que el tipo implementa un contrato.
  static final RegExp _implementsPattern = RegExp(r'\bimplements\b');

  /// Cuenta los miembros del tipo indicado.
  ClassMembers count(List<ScannedLine> lines, DeclarationBlock type) {
    if (type.kind == DeclarationKind.enumType) {
      return const ClassMembers.empty();
    }
    final int start = type.startLine - 1;
    final int end = type.endLine;
    if (start >= lines.length) {
      return const ClassMembers.empty();
    }
    final int bodyDepth = lines[start].depthBefore + 1;
    int total = 0;
    int publicMembers = 0;
    int publicMethods = 0;
    for (int index = start; index < end && index < lines.length; index++) {
      final ScannedLine line = lines[index];
      if (!_isMemberLine(line, bodyDepth)) {
        continue;
      }
      final bool isSignature = looksLikeSignature(line);
      final String? name = isSignature ? signatureName(line) : fieldName(line);
      if (name == null) {
        continue;
      }
      total++;
      if (name.startsWith('_')) {
        continue;
      }
      publicMembers++;
      if (isSignature) {
        publicMethods++;
      }
    }
    return ClassMembers(
      total: total,
      publicMembers: publicMembers,
      publicMethods: publicMethods,
      adaptsInterface: _implementsPattern.hasMatch(lines[start].trimmed),
    );
  }

  /// `true` si la línea declara un miembro a la altura del cuerpo.
  bool _isMemberLine(ScannedLine line, int bodyDepth) {
    if (line.depthBefore != bodyDepth || line.isCodeEmpty) {
      return false;
    }
    return !line.isLoneClosingBrace && !line.trimmed.endsWith(',');
  }
}
