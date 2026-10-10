import 'dart:io';

import 'package:args/args.dart';

import '../git_hook_installer.dart';
import 'cli_command.dart';

/// Instancia reutilizable del comando `hooksCommand`.
const HooksCommand hooksCommand = HooksCommand();

/// Comando `hooks`: instala los git hooks versionados.
class HooksCommand implements CliCommand {
  /// Crea el comando.
  const HooksCommand();

  @override
  String get name => 'hooks';

  @override
  String get summary => 'Instala los git hooks del proyecto';

  @override
  void configure(ArgParser parser) {
    parser.addCommand(
      'install',
      ArgParser()
        ..addOption('root', abbr: 'r', defaultsTo: Directory.current.path),
    );
  }

  @override
  int run(ArgResults results) {
    final ArgResults? subcommand = results.command;
    if (subcommand?.name != 'install') {
      return 2;
    }
    final String root = _rootOf(subcommand!);
    final HookInstallResult result = installHooks(root);
    stdout.writeln(
      'Hooks instalados en ${result.hooksDir}: ${result.installed.join(', ')}',
    );
    return 0;
  }

  /// Lee la opción `root` con su valor por defecto.
  String _rootOf(ArgResults command) {
    final Object? value = command['root'];
    return value is String && value.isNotEmpty ? value : Directory.current.path;
  }
}
