import 'package:args/args.dart';

/// Comando del CLI de desarrollo de Chords.
///
/// Cada comando vive en su propio archivo y solo conoce sus opciones; el
/// registro se encarga del parser y de la ayuda.
abstract interface class CliCommand {
  /// Nombre con el que se invoca el comando.
  String get name;

  /// Resumen de una línea para la ayuda.
  String get summary;

  /// Declara subcomandos y opciones en el parser recibido.
  void configure(ArgParser parser);

  /// Ejecuta el comando y devuelve el código de salida.
  int run(ArgResults results);
}
