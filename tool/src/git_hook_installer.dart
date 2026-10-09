/// Instalador de git hooks para Chords.
///
/// Copia los hooks versionados en `tool/hooks/` a `.git/hooks/` y los marca
/// como ejecutables.
library;

import 'dart:io';

/// Hooks gestionados por el proyecto.
const List<String> kManagedHooks = <String>['pre-commit', 'pre-push'];

/// Resultado de instalar los hooks.
class HookInstallResult {
  /// Crea el resultado de la instalación.
  const HookInstallResult({
    required this.installed,
    required this.gitRoot,
    required this.hooksDir,
  });

  /// Nombres de hooks instalados.
  final List<String> installed;

  /// Ruta raíz del repositorio git.
  final String gitRoot;

  /// Directorio de hooks efectivo.
  final String hooksDir;
}

/// Excepción lanzada si no se puede instalar los hooks.
class HookInstallException implements Exception {
  /// Crea la excepción con un mensaje.
  const HookInstallException(this.message);

  /// Mensaje descriptivo.
  final String message;

  @override
  String toString() => 'HookInstallException: $message';
}

/// Instala los hooks versionados del proyecto en `.git/hooks/`.
HookInstallResult installHooks(String projectRoot) {
  final File gitDir = File('$projectRoot/.git');
  if (!Directory('$projectRoot/.git').existsSync() && !gitDir.existsSync()) {
    throw const HookInstallException(
      'No se encontró un repositorio git. Ejecuta `git init` primero.',
    );
  }

  final String gitRoot = _resolveGitRoot(projectRoot);
  final String hooksDir = '$gitRoot/tool/hooks';
  if (!Directory(hooksDir).existsSync()) {
    throw const HookInstallException(
      'Falta el directorio versionado tool/hooks/',
    );
  }
  for (final String hook in kManagedHooks) {
    final File file = File('$hooksDir/$hook');
    if (!file.existsSync()) {
      throw const HookInstallException('Falta el hook versionado tool/hooks/');
    }
    Process.runSync('chmod', <String>['+x', file.path]);
  }
  // Apunta git a los hooks versionados del proyecto.
  Process.runSync('git', <String>[
    'config',
    'core.hooksPath',
    'tool/hooks',
  ], workingDirectory: projectRoot);

  return HookInstallResult(
    installed: List<String>.of(kManagedHooks),
    gitRoot: gitRoot,
    hooksDir: hooksDir,
  );
}

/// Resuelve la ruta del repositorio git.
String _resolveGitRoot(String projectRoot) {
  final ProcessResult result = Process.runSync('git', <String>[
    'rev-parse',
    '--show-toplevel',
  ], workingDirectory: projectRoot);
  if (result.exitCode != 0) {
    throw const HookInstallException(
      'git rev-parse falló; ¿estás en un repositorio?',
    );
  }
  return (result.stdout as String).trim();
}
