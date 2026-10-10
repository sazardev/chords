import 'package:chords/config/route_paths.dart';

/// Esquema de deep link propio (p. ej. `chords://chords/C-maj`).
const String kDeepLinkScheme = 'chords';

/// Host de los enlaces universales (App Links / deep links web).
const String kDeepLinkHost = 'chords.app';

/// Prefijos de ruta admitidos en enlaces universales.
const List<String> kDeepLinkPrefixes = <String>[
  '/chords',
  '/live',
  '/settings',
];

/// Ruta absoluta de un acorde a partir de su identificador.
String chordDeepLinkPath(String chordId) =>
    '$kChordDetailPath?id=${Uri.encodeComponent(chordId)}';

/// Ruta de listado filtrado por raíz, calidad y dificultad.
String chordsQueryLinkPath({
  String? root,
  String? quality,
  int? maxDifficulty,
  String? query,
}) {
  final Map<String, String> params = <String, String>{
    'root': ?root,
    'quality': ?quality,
    'difficulty': ?maxDifficulty?.toString(),
    'q': ?query,
  };
  if (params.isEmpty) {
    return kChordsPath;
  }
  final String encoded = params.entries
      .map(
        (MapEntry<String, String> e) =>
            '${e.key}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');
  return '$kChordsPath?$encoded';
}
