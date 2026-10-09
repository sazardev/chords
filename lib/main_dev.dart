import 'package:chords/bootstrap.dart';
import 'package:chords/config/app_config.dart';

/// Punto de entrada del flavor de dev.
Future<void> main() async {
  await bootstrap(const AppConfig.dev());
}
