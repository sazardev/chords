import 'package:args/args.dart';

import 'cli_command.dart';
import 'cli_registry.dart';

/// Escritor de la ayuda del CLI.
class UsageWriter {
  /// Crea el escritor.
  const UsageWriter(this.registry);

  /// Registro del que se leen los comandos.
  final CliRegistry registry;

  /// Escribe la ayuda completa en la salida indicada.
  void write(StringSink sink) {
    final ArgParser parser = registry.buildParser();
    sink
      ..writeln('CLI de desarrollo de Chords')
      ..writeln()
      ..writeln('Uso: chords_cli <comando> [opciones]')
      ..writeln()
      ..writeln('Comandos:');
    final int width = registry.commands
        .map((CliCommand command) => command.name.length)
        .fold<int>(0, (int max, int length) => length > max ? length : max);
    for (final CliCommand command in registry.commands) {
      final String padding = ' ' * (width - command.name.length);
      sink.writeln('  ${command.name}$padding  ${command.summary}');
    }
    sink
      ..writeln()
      ..writeln('Opciones globales:')
      ..writeln(parser.usage.trimRight())
      ..writeln()
      ..writeln('Detalle de un comando: chords_cli <comando> --help');
  }
}
