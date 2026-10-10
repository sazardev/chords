import 'dart:io';

/// Descubridor de archivos Dart a auditar.
class SourceDiscovery {
  /// Crea el descubridor.
  const SourceDiscovery();

  /// Extensiones generadas que se excluyen del análisis.
  static const Set<String> generatedExtensions = <String>{
    '.g.dart',
    '.freezed.dart',
  };

  /// Lista los archivos Dart de `root` respetando las exclusiones.
  List<File> discover(String root, Set<String> excludedDirectories) {
    final List<File> files = <File>[];
    final Directory base = Directory(root);
    if (!base.existsSync()) {
      return files;
    }
    for (final FileSystemEntity entity in base.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      if (_isExcluded(entity.path, root, excludedDirectories)) {
        continue;
      }
      if (generatedExtensions.any(
        (String extension) => entity.path.endsWith(extension),
      )) {
        continue;
      }
      files.add(entity);
    }
    files.sort((File a, File b) => a.path.compareTo(b.path));
    return files;
  }

  /// `true` si la ruta cae en un directorio excluido.
  bool _isExcluded(String path, String root, Set<String> excluded) {
    final String relative = path.startsWith(root)
        ? path.substring(root.length)
        : path;
    for (final String segment in relative.split(Platform.pathSeparator)) {
      if (segment.isEmpty) {
        continue;
      }
      if (excluded.contains(segment)) {
        return true;
      }
    }
    return false;
  }
}
