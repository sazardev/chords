/// Idioma de la interfaz seleccionable en la aplicación.
///
/// Sigue el patrón de `ThemeMode`: el valor `system` delega en el idioma del
/// dispositivo y el resto fija un idioma concreto. Para soportar un idioma
/// nuevo basta con añadir una entrada aquí y su fichero
/// `lib/l10n/<código>.i18n.json`; el resto del código (ajustes, persistencia
/// y traducciones) no cambia.
enum AppLanguage {
  /// Sigue el idioma del sistema.
  system(null),

  /// Español.
  spanish('es'),

  /// Inglés.
  english('en');

  /// Crea el idioma con su código BCP-47 (`null` = seguir al sistema).
  const AppLanguage(this.languageCode);

  /// Resuelve el idioma a partir de un código BCP-47.
  ///
  /// Devuelve [fallback] si el código es `null` o no está soportado.
  factory AppLanguage.fromCode(String? code) {
    for (final AppLanguage language in AppLanguage.values) {
      if (language.languageCode == code) {
        return language;
      }
    }
    return fallback;
  }

  /// Resuelve el idioma a partir del nombre persistido de su valor.
  ///
  /// Devuelve [fallback] si el nombre no corresponde a ningún idioma.
  factory AppLanguage.fromName(String? name) {
    for (final AppLanguage language in AppLanguage.values) {
      if (language.name == name) {
        return language;
      }
    }
    return fallback;
  }

  /// Idioma usado cuando no hay una preferencia válida guardada.
  static const AppLanguage fallback = AppLanguage.system;

  /// Código de idioma BCP-47 o `null` si sigue al sistema.
  final String? languageCode;

  /// Si el idioma se delega en el sistema.
  bool get followsSystem => languageCode == null;
}
