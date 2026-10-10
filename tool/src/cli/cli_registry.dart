import 'dart:io';

import 'package:args/args.dart';

import 'cli_command.dart';

/// Registro de comandos del CLI: construye el parser y despacha.
class CliRegistry {
  /// Crea el registro con los comandos indicados.
  const CliRegistry(this.commands);

  /// Comandos disponibles, en el orden en que se listan en la ayuda.
  final List<CliCommand> commands;

  /// Construye el parser raíz con todos los comandos registrados.
  ArgParser buildParser() {
    final ArgParser parser = ArgParser();
    for (final CliCommand command in commands) {
      final ArgParser commandParser = ArgParser();
      command.configure(commandParser);
      parser.addCommand(command.name, commandParser);
    }
    return parser;
  }

  /// Ejecuta el CLI y devuelve el código de salida.
  int run(List<String> arguments) {
    final ArgParser parser = buildParser();
    final ArgResults results;
    try {
      results = parser.parse(arguments);
    } on FormatException catch (error) {
      stderr.writeln('Error: ${error.message}');
      return 2;
    }
    final ArgResults? command = results.command;
    if (command == null) {
      return 2;
    }
    final CliCommand? target = _find(command.name!);
    if (target == null) {
      return 2;
    }
    try {
      return target.run(command);
    } on Exception catch (error) {
      stderr.writeln('Error: $error');
      return 2;
    }
  }

  /// Busca un comando por nombre.
  CliCommand? _find(String name) {
    for (final CliCommand command in commands) {
      if (command.name == name) {
        return command;
      }
    }
    return null;
  }
}
