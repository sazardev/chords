/// Presupuestos de tamaño y forma que hace cumplir la auditoría.
///
/// Los valores por defecto son deliberados: obligan a archivos y clases
/// pequeñas y a cuerpos de función legibles sin fragmentar el código.
class AuditConfig {
  /// Crea la configuración.
  const AuditConfig({
    this.maxFileLines = 400,
    this.maxClassLines = 250,
    this.maxFunctionLines = 60,
    this.maxBranches = 10,
    this.maxSwitchCases = 7,
    this.maxPublicMembers = 12,
    this.excludedDirectories = const <String>{
      'build',
      'ios',
      'android',
      'linux',
      'macos',
      'windows',
      'web',
      '.dart_tool',
      '.git',
    },
  });

  /// Configuración por defecto.
  static const AuditConfig defaults = AuditConfig();

  /// Máximo de líneas por archivo.
  final int maxFileLines;

  /// Máximo de líneas por clase, mixin, enum o extensión.
  final int maxClassLines;

  /// Máximo de líneas por función, método o constructor.
  final int maxFunctionLines;

  /// Máximo de puntos de decisión por cuerpo ejecutable.
  final int maxBranches;

  /// Máximo de `case` por sentencia `switch`.
  final int maxSwitchCases;

  /// Máximo de miembros públicos por tipo.
  final int maxPublicMembers;

  /// Directorios excluidos del análisis.
  final Set<String> excludedDirectories;

  /// Copia la configuración aplicando las modificaciones indicadas.
  AuditConfig copyWith({
    int? maxFileLines,
    int? maxClassLines,
    int? maxFunctionLines,
    int? maxBranches,
    int? maxSwitchCases,
    int? maxPublicMembers,
  }) => AuditConfig(
    maxFileLines: maxFileLines ?? this.maxFileLines,
    maxClassLines: maxClassLines ?? this.maxClassLines,
    maxFunctionLines: maxFunctionLines ?? this.maxFunctionLines,
    maxBranches: maxBranches ?? this.maxBranches,
    maxSwitchCases: maxSwitchCases ?? this.maxSwitchCases,
    maxPublicMembers: maxPublicMembers ?? this.maxPublicMembers,
    excludedDirectories: excludedDirectories,
  );
}
