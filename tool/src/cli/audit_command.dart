import 'dart:io';

import 'package:args/args.dart';

import '../audit/audit_config.dart';
import '../audit/audit_engine.dart';
import '../audit/audit_report.dart';
import '../audit/audit_reporter.dart';
import '../audit/audit_severity.dart';
import 'cli_command.dart';

/// Instancia reutilizable del comando `auditCommand`.
const AuditCommand auditCommand = AuditCommand();

/// Comando `audit`: revisa forma y fronteras del código.
class AuditCommand implements CliCommand {
  /// Crea el comando.
  const AuditCommand();

  @override
  String get name => 'audit';

  @override
  String get summary => 'Revisa tamaño, complejidad y capas del código';

  @override
  void configure(ArgParser parser) {
    parser
      ..addOption('root', abbr: 'r', defaultsTo: Directory.current.path)
      ..addOption(
        'fail-on',
        abbr: 'f',
        defaultsTo: 'warning',
        allowed: <String>['info', 'warning', 'error'],
        help: 'Gravedad mínima que hace fallar el comando',
      )
      ..addOption(
        'markdown',
        abbr: 'm',
        help: 'Escribe el informe en Markdown en la ruta indicada',
      )
      ..addOption('max-file-lines', help: 'Líneas máximas por archivo')
      ..addOption('max-class-lines', help: 'Líneas máximas por clase')
      ..addOption('max-function-lines', help: 'Líneas máximas por función')
      ..addOption('max-branches', help: 'Puntos de decisión máximos')
      ..addOption('max-switch-cases', help: 'Casos máximos por switch')
      ..addOption('max-public-members', help: 'Miembros públicos máximos');
  }

  @override
  int run(ArgResults results) {
    final AuditConfig config = _configOf(results);
    final String root = results['root'] as String;
    final AuditEngine engine = AuditEngine(config: config);
    final AuditReport report = engine.run(root);
    const AuditReporter reporter = AuditReporter();
    stdout.writeln(reporter.renderText(report));
    _writeMarkdown(results, reporter, report);
    return report.hasAtLeast(_thresholdOf(results)) ? 1 : 0;
  }

  /// Gravedad mínima que hace fallar el comando.
  AuditSeverity _thresholdOf(ArgResults results) =>
      AuditSeverity.parse(results['fail-on'] as String) ??
      AuditSeverity.warning;

  /// Construye la configuración a partir de las opciones recibidas.
  AuditConfig _configOf(ArgResults results) => AuditConfig.defaults.copyWith(
    maxFileLines: _intOf(results, 'max-file-lines'),
    maxClassLines: _intOf(results, 'max-class-lines'),
    maxFunctionLines: _intOf(results, 'max-function-lines'),
    maxBranches: _intOf(results, 'max-branches'),
    maxSwitchCases: _intOf(results, 'max-switch-cases'),
    maxPublicMembers: _intOf(results, 'max-public-members'),
  );

  /// Lee una opción numérica; `null` si no se indicó.
  int? _intOf(ArgResults results, String name) {
    final Object? value = results[name];
    return value is String && value.isNotEmpty ? int.tryParse(value) : null;
  }

  /// Escribe el informe Markdown si se pidió.
  void _writeMarkdown(
    ArgResults results,
    AuditReporter reporter,
    AuditReport report,
  ) {
    final Object? markdown = results['markdown'];
    if (markdown is! String || markdown.isEmpty) {
      return;
    }
    File(markdown).writeAsStringSync(reporter.renderMarkdown(report));
    stdout.writeln('Informe escrito en $markdown');
  }
}
