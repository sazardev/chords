import 'package:chords/bootstrap.dart';
import 'package:chords/config/app_config.dart';

/// Punto de entrada del flavor de prod.
Future<void> main() async {
  await bootstrap(const AppConfig.prod());
}
