import '../audit_config.dart';
import '../audit_finding.dart';
import '../audit_rule.dart';
import '../audit_severity.dart';
import '../metrics/import_scanner.dart';
import '../metrics/source_metrics.dart';

/// Capas de la arquitectura y lo que cada una tiene prohibido importar.
///
/// La dependencia siempre apunta hacia dentro: `app -> presentation -> domain
/// -> core`. `data` implementa los contratos de `domain` y nadie fuera de
/// `app`/`di` debe conocerlo.
const Map<String, Set<String>> _forbiddenTargets = <String, Set<String>>{
  'lib/core/': <String>{'domain/', 'data/', 'presentation/', 'config/', 'app/'},
  'lib/domain/': <String>{'data/', 'presentation/', 'config/', 'app/'},
  'lib/data/': <String>{'presentation/', 'app/'},
  'lib/presentation/': <String>{'data/', 'app/'},
  'lib/config/': <String>{'domain/', 'data/', 'presentation/', 'app/'},
};

/// Prefijo de los imports internos del paquete.
const String _packagePrefix = 'package:chords/';

/// Prohíbe que una capa importe otra que debe conocer sólo por dentro.
const LayerBoundaryRule layerBoundaryRule = LayerBoundaryRule();

/// Regla de fronteras entre capas.
class LayerBoundaryRule implements AuditRule {
  /// Crea la regla.
  const LayerBoundaryRule();

  @override
  String get id => 'layer-boundary';

  @override
  String get title => 'Fronteras entre capas';

  @override
  Set<String> get rootPrefixes => kSourceScopes;

  @override
  AuditSeverity get severity => AuditSeverity.error;

  @override
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config) {
    final String? source = _layerOf(metrics.path);
    if (source == null) {
      return const <AuditFinding>[];
    }
    final Set<String> forbidden = _forbiddenTargets[source]!;
    final List<AuditFinding> findings = <AuditFinding>[];
    for (final ImportDirective import in metrics.imports) {
      if (!import.uri.startsWith(_packagePrefix)) {
        continue;
      }
      final String target = import.uri.substring(_packagePrefix.length);
      for (final String bannedLayer in forbidden) {
        if (target.startsWith(bannedLayer)) {
          findings.add(
            AuditFinding(
              ruleId: id,
              ruleTitle: title,
              path: metrics.path,
              line: import.line,
              message:
                  '$source no puede importar $bannedLayer '
                  '(${import.uri}). Depende de la capa de dominio.',
              severity: severity,
            ),
          );
        }
      }
    }
    return findings;
  }

  /// Capa a la que pertenece una ruta; `null` si no es de `lib/`.
  String? _layerOf(String path) {
    if (!path.startsWith('lib/')) {
      return null;
    }
    for (final String layer in _forbiddenTargets.keys) {
      if (path.startsWith(layer)) {
        return layer;
      }
    }
    return null;
  }
}
