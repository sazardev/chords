import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/domain/l10n/repositories/locale_repository.dart';

/// Repositorio de idioma en memoria para pruebas.
class FakeLocaleRepository implements LocaleRepository {
  /// Crea el repositorio con el idioma inicial indicado.
  FakeLocaleRepository([AppLanguage initial = AppLanguage.system])
    : _language = initial;

  AppLanguage _language;

  /// Veces que se ha guardado el idioma.
  int saveCount = 0;

  @override
  AppLanguage get selectedLanguage => _language;

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    _language = language;
    saveCount++;
  }
}
