import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/domain/l10n/repositories/locale_repository.dart';

/// Implementación de [LocaleRepository] sobre preferencias locales.
class LocaleRepositoryImpl implements LocaleRepository {
  /// Crea el repositorio con el servicio de preferencias.
  const LocaleRepositoryImpl(this._preferences);

  final PreferencesService _preferences;

  @override
  AppLanguage get selectedLanguage =>
      AppLanguage.fromName(_preferences.languageName);

  @override
  Future<void> saveLanguage(AppLanguage language) =>
      _preferences.setLanguageName(language.name);
}
