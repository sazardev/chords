import 'package:chords/bootstrap.dart';
import 'package:chords/config/app_config.dart';

/// Punto de entrada del flavor de producción.
void main() => bootstrap(const AppConfig.prod());
