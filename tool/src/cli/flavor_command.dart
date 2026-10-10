import 'dart:io';

import 'package:args/args.dart';

import 'cli_command.dart';

/// Instancia reutilizable del comando `flavorCommand`.
const FlavorCommand flavorCommand = FlavorCommand();

/// Comando `flavor`: lista los flavors configurados.
class FlavorCommand implements CliCommand {
  /// Crea el comando.
  const FlavorCommand();

  @override
  String get name => 'flavor';

  @override
  String get summary => 'Lista los flavors disponibles';

  @override
  void configure(ArgParser parser) {
    parser.addCommand('list');
  }

  @override
  int run(ArgResults results) {
    if (results.command?.name != 'list') {
      return 2;
    }
    stdout
      ..writeln('dev      (main_dev.dart)     app.chords.chords.dev')
      ..writeln('staging  (main_staging.dart) app.chords.chords.staging')
      ..writeln('prod     (main_prod.dart)    app.chords.chords');
    return 0;
  }
}
