import 'package:chords/domain/l10n/entities/app_language.dart';

/// Aplica el idioma elegido al subsistema de traducciones.
///
/// Desacopla el controlador del generador de traducciones para poder probarlo
/// sin Flutter y para poder sustituirlo (p. ej. traducciones remotas) sin
/// tocar la lógica de estado.
abstract interface class LanguageApplier {
  /// Traduce la interfaz al idioma indicado.
  ///
  /// [AppLanguage.system] delega en el idioma del dispositivo.
  void apply(AppLanguage language);
}
