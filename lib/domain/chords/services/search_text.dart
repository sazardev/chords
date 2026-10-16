/// Normaliza un texto para buscarlo: minúsculas, sin tildes ni diéresis y con
/// los espacios simples.
String normalizeSearchText(String text) {
  const String from = 'áàäâéèëêíìïîóòöôúùüûñ';
  const String to = 'aaaaeeeeiiiioooouuuun';
  final StringBuffer out = StringBuffer();
  for (final int unit in text.toLowerCase().runes) {
    final String char = String.fromCharCode(unit);
    final int index = from.indexOf(char);
    out.write(index < 0 ? char : to[index]);
  }
  return out.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Lo mismo que [normalizeSearchText] pero sin ningún separador (espacios,
/// puntos, guiones, paréntesis): `Menor 7` y `menor7` quedan iguales.
String compactSearchText(String text) =>
    normalizeSearchText(text).replaceAll(RegExp(r'[\s.\-()_]'), '');
