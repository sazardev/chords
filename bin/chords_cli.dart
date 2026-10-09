/// CLI de desarrollo de Chords.
///
/// Comandos disponibles:
/// - `db generate`: genera el banco extenso de acordes.
/// - `db validate`: valida la integridad del banco.
/// - `hooks install`: instala los git hooks del proyecto.
/// - `flavor list`: lista los flavors configurados.
/// - `version`: muestra la versión.
library;

import 'dart:io';

import 'package:args/args.dart';

import '../tool/src/chord_db_validator.dart';
import '../tool/src/chord_generator.dart';
import '../tool/src/git_hook_installer.dart';

/// Nombre del ejecutable mostrado en la ayuda.
const String _cliName = 'chords_cli';

/// Versión del banco de acordes.
const String _dbVersion = '1.0.0';

/// Ruta por defecto del banco de acordes.
const String _defaultDbPath = 'assets/chords/chords_db.json';

/// Punto de entrada del CLI.
Future<void> main(List<String> arguments) async {
  final ArgParser parser = _buildParser();
  final ArgResults results = parser.parse(arguments);
  final ArgResults? command = results.command;

  try {
    if (command == null) {
      _printUsage();
      return;
    }
    switch (command.name) {
      case 'db':
        _handleDb(command.command);
      case 'hooks':
        if (command.command?.name != 'install') {
          _printUsage();
          return;
        }
        _installHooks(
          _option(command.command!, 'root', Directory.current.path),
        );
      case 'flavor':
        _listFlavors();
      case 'version':
        _printVersion();
      default:
        _printUsage();
    }
  } on HookInstallException catch (error) {
    stderr.writeln('Error: ${error.message}');
    exitCode = 2;
  }
}

/// Construye el parser de argumentos con comandos anidados.
ArgParser _buildParser() {
  final ArgParser db = ArgParser()
    ..addCommand(
      'generate',
      ArgParser()..addOption('path', abbr: 'p', defaultsTo: _defaultDbPath),
    )
    ..addCommand(
      'validate',
      ArgParser()..addOption('path', abbr: 'p', defaultsTo: _defaultDbPath),
    );
  final ArgParser hooks = ArgParser()
    ..addCommand(
      'install',
      ArgParser()
        ..addOption('root', abbr: 'r', defaultsTo: Directory.current.path),
    );
  final ArgParser flavor = ArgParser()..addCommand('list');
  return ArgParser()
    ..addCommand('db', db)
    ..addCommand('hooks', hooks)
    ..addCommand('flavor', flavor)
    ..addCommand('version');
}

/// Maneja el comando `db`.
void _handleDb(ArgResults? subcommand) {
  final String? name = subcommand?.name;
  if (name == 'generate') {
    _generate(_option(subcommand!, 'path', _defaultDbPath));
  } else if (name == 'validate') {
    _validate(_option(subcommand!, 'path', _defaultDbPath));
  } else {
    _printUsage();
  }
}

/// Lee una opción del comando con un valor por defecto.
String _option(ArgResults command, String name, String fallback) {
  final Object? value = command[name];
  return value is String && value.isNotEmpty ? value : fallback;
}

/// Genera el banco de acordes.
void _generate(String path) {
  stdout.writeln('Generando banco de acordes en $path ...');
  final ChordDatabase database = generateChordDatabase(path);
  stdout.writeln(
    'Listo: ${database.chordCount} acordes, '
    '${database.variantCount} posiciones.',
  );
  final List<MapEntry<String, int>> entries =
      database.byDifficulty.entries.toList()..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) =>
            a.key.compareTo(b.key),
      );
  for (final MapEntry<String, int> entry in entries) {
    stdout.writeln('  · ${entry.key}: ${entry.value} acordes');
  }
  final List<MapEntry<String, int>> qualities =
      database.byQuality.entries.toList()..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) =>
            a.key.compareTo(b.key),
      );
  for (final MapEntry<String, int> entry in qualities) {
    stdout.writeln('  · ${entry.key}: ${entry.value} posiciones');
  }
}

/// Valida el banco de acordes.
void _validate(String path) {
  final ValidationReport report = validateChordDatabase(path);
  if (report.isValid) {
    stdout.writeln(
      'OK: ${report.chordCount} acordes, '
      '${report.variantCount} posiciones válidas.',
    );
    return;
  }
  stderr.writeln('Se encontraron ${report.issues.length} problemas:');
  for (final ValidationIssue issue in report.issues) {
    stderr.writeln('  · $issue');
  }
  exitCode = 1;
}

/// Instala los hooks de git.
void _installHooks(String root) {
  final HookInstallResult result = installHooks(root);
  stdout.writeln(
    'Hooks instalados en ${result.hooksDir}: ${result.installed.join(', ')}',
  );
}

/// Lista los flavors configurados.
void _listFlavors() {
  stdout
    ..writeln('dev      (main_dev.dart)     app.chords.chords.dev')
    ..writeln('staging  (main_staging.dart) app.chords.chords.staging')
    ..writeln('prod     (main_prod.dart)    app.chords.chords');
}

/// Imprime la versión.
void _printVersion() {
  stdout.writeln('chords_cli $_dbVersion');
}

/// Imprime la ayuda.
void _printUsage() {
  const String commands =
      'Comandos:\n'
      '  db generate [--path RUTA]    Genera el banco de acordes\n'
      '  db validate [--path RUTA]    Valida el banco de acordes\n'
      '  hooks install [--root RUTA]  Instala los git hooks\n'
      '  flavor list                  Lista los flavors\n'
      '  version                      Versión del CLI';
  const String examples =
      'Ejemplos:\n'
      '  $_cliName db generate\n'
      '  $_cliName db validate\n'
      '  $_cliName hooks install';
  stdout
    ..writeln('CLI de desarrollo de Chords')
    ..writeln()
    ..writeln('Uso: $_cliName <comando> [opciones]')
    ..writeln()
    ..writeln(commands)
    ..writeln()
    ..writeln(examples);
}
