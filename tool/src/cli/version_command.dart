import 'dart:io';

import 'package:args/args.dart';

import 'cli_command.dart';

/// Versión del CLI de desarrollo.
const String cliVersion = '1.1.0';

/// Instancia reutilizable del comando `versionCommand`.
const VersionCommand versionCommand = VersionCommand();

/// Comando `version`: muestra la versión del CLI.
class VersionCommand implements CliCommand {
  /// Crea el comando.
  const VersionCommand();

  @override
  String get name => 'version';

  @override
  String get summary => 'Muestra la versión del CLI';

  @override
  void configure(ArgParser parser) {}

  @override
  int run(ArgResults results) {
    stdout.writeln('chords_cli $cliVersion');
    return 0;
  }
}
