import 'package:chords/domain/l10n/entities/app_language.dart';

/// Repositorio de la preferencia de idioma del usuario.
///
/// Abstrae el almacenamiento para que el controlador de idioma dependa de una
/// interfaz estable y no de `SharedPreferences`.
abstract interface class LocaleRepository {
  /// Idioma guardado por el usuario.
  ///
  /// Devuelve [AppLanguage.system] si nunca eligió uno.
  AppLanguage get selectedLanguage;

  /// Persiste el idioma seleccionado.
  Future<void> saveLanguage(AppLanguage language);
}
