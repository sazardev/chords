import 'audit_command.dart';
import 'cli_command.dart';
import 'cli_registry.dart';
import 'db_command.dart';
import 'flavor_command.dart';
import 'hooks_command.dart';
import 'version_command.dart';

/// Comandos que ofrece el CLI de desarrollo.
const List<CliCommand> kCliCommands = <CliCommand>[
  dbCommand,
  auditCommand,
  hooksCommand,
  flavorCommand,
  versionCommand,
];

/// Registro con los comandos del proyecto.
const CliRegistry cliRegistry = CliRegistry(kCliCommands);
