import '../audit_rule.dart';
import 'class_size_rule.dart';
import 'complexity_rule.dart';
import 'file_length_rule.dart';
import 'function_length_rule.dart';
import 'layer_boundary_rule.dart';
import 'switch_size_rule.dart';

/// Reglas activas por defecto, en orden de informe.
const List<AuditRule> defaultAuditRules = <AuditRule>[
  layerBoundaryRule,
  fileLengthRule,
  classSizeRule,
  functionLengthRule,
  complexityRule,
  switchSizeRule,
];
