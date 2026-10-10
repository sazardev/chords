import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/language_applier.dart';

/// Aplica el idioma sobre `LocaleSettings` (slang).
///
/// El modo sistema activa además el seguimiento del idioma del dispositivo, de
/// forma que un cambio de idioma del sistema se refleja sin reiniciar la app.
class SlangLanguageApplier implements LanguageApplier {
  /// Crea el aplicador.
  const SlangLanguageApplier();

  @override
  void apply(AppLanguage language) {
    final String? code = language.languageCode;
    if (code == null) {
      LocaleSettings.useDeviceLocaleSync();
      return;
    }
    LocaleSettings.setLocaleSync(AppLocaleUtils.parse(code));
  }
}
