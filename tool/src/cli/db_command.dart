import 'dart:io';

import 'package:args/args.dart';

import '../chord_database_writer.dart';
import '../chord_db_show.dart';
import '../chord_db_validator.dart';
import 'cli_command.dart';

/// Ruta por defecto del banco de acordes.
const String defaultChordDbPath = 'assets/chords/chords_db.json';

/// Instancia reutilizable del comando `dbCommand`.
const DbCommand dbCommand = DbCommand();

/// Comando `db`: genera, valida y muestra el banco de acordes.
class DbCommand implements CliCommand {
  /// Crea el comando.
  const DbCommand();

  @override
  String get name => 'db';

  @override
  String get summary => 'Genera, valida o muestra el banco de acordes';

  @override
  void configure(ArgParser parser) {
    parser
      ..addCommand(
        'generate',
        ArgParser()
          ..addOption('path', abbr: 'p', defaultsTo: defaultChordDbPath),
      )
      ..addCommand(
        'validate',
        ArgParser()
          ..addOption('path', abbr: 'p', defaultsTo: defaultChordDbPath),
      )
      ..addCommand(
        'show',
        ArgParser()
          ..addOption('path', abbr: 'p', defaultsTo: defaultChordDbPath),
      );
  }

  @override
  int run(ArgResults results) {
    final ArgResults? subcommand = results.command;
    final String? action = subcommand?.name;
    if (action == 'generate') {
      _generate(_pathOf(subcommand!, defaultChordDbPath));
      return 0;
    }
    if (action == 'validate') {
      return _validate(_pathOf(subcommand!, defaultChordDbPath));
    }
    if (action == 'show') {
      stdout.write(
        describeChords(
          _pathOf(subcommand!, defaultChordDbPath),
          subcommand.rest,
        ),
      );
      return 0;
    }
    return 2;
  }

  /// Lee la opción `path` con su valor por defecto.
  String _pathOf(ArgResults command, String fallback) {
    final Object? value = command['path'];
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
    for (final MapEntry<String, int> entry in _sorted(database.byDifficulty)) {
      stdout.writeln('  · ${entry.key}: ${entry.value} acordes');
    }
    for (final MapEntry<String, int> entry in _sorted(database.byQuality)) {
      stdout.writeln('  · ${entry.key}: ${entry.value} posiciones');
    }
  }

  /// Valora el banco de acordes y devuelve el código de salida.
  int _validate(String path) {
    final ValidationReport report = validateChordDatabase(path);
    if (report.isValid) {
      stdout.writeln(
        'OK: ${report.chordCount} acordes, '
        '${report.variantCount} posiciones válidas.',
      );
      return 0;
    }
    stderr.writeln('Se encontraron ${report.issues.length} problemas:');
    for (final ValidationIssue issue in report.issues) {
      stderr.writeln('  · $issue');
    }
    return 1;
  }

  /// Entradas del resumen ordenadas por clave.
  List<MapEntry<String, int>> _sorted(Map<String, int> source) =>
      (source.entries.toList()..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) =>
            a.key.compareTo(b.key),
      ));
}
