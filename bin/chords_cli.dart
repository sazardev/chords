/// CLI de desarrollo de Chords.
///
/// Punto de entrada deliberadamente fino: delega en el registro de comandos y
/// cada comando vive en su propio archivo bajo `tool/src/cli/`.
library;

import 'dart:io';

import '../tool/src/cli/cli.dart';
import '../tool/src/cli/usage_writer.dart';

/// Ejecuta el CLI y propaga el código de salida.
void main(List<String> arguments) {
  const UsageWriter writer = UsageWriter(cliRegistry);
  if (arguments.isEmpty || arguments.contains('--help')) {
    writer.write(stdout);
    exitCode = arguments.isEmpty ? 2 : 0;
    return;
  }
  final int code = cliRegistry.run(arguments);
  if (code == 2) {
    writer.write(stderr);
  }
  exitCode = code;
}
