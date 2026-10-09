import 'package:chords/data/audio/audio_repository_impl.dart';
import 'package:chords/data/chords/datasources/chord_asset_datasource.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/get_chord_by_id_use_case.dart';
import 'package:chords/domain/chords/usecases/get_chords_use_case.dart';
import 'package:chords/domain/chords/usecases/match_chords_by_pitch_classes_use_case.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';

/// Composición de dependencias de la aplicación.
///
/// Centraliza la creación de repositorios y casos de uso para que los
/// controladores reciban colaboradores ya construidos.
class AppDependencies {
  AppDependencies._({
    required this.chordRepository,
    required this.audioRepository,
    required this.getChordsUseCase,
    required this.getChordByIdUseCase,
    required this.searchChordsUseCase,
    required this.matchChordsUseCase,
  });

  /// Crea el grafo de dependencias por defecto.
  factory AppDependencies.create() {
    final ChordRepository chordRepository = ChordRepositoryImpl(
      dataSource: const ChordAssetDataSource(),
    );
    final AudioRepository audioRepository = AudioRepositoryImpl();
    return AppDependencies._(
      chordRepository: chordRepository,
      audioRepository: audioRepository,
      getChordsUseCase: GetChordsUseCase(chordRepository),
      getChordByIdUseCase: GetChordByIdUseCase(chordRepository),
      searchChordsUseCase: const SearchChordsUseCase(),
      matchChordsUseCase: const MatchChordsByPitchClassesUseCase(),
    );
  }

  /// Repositorio de acordes.
  final ChordRepository chordRepository;

  /// Repositorio de audio.
  final AudioRepository audioRepository;

  /// Caso de uso de carga de acordes.
  final GetChordsUseCase getChordsUseCase;

  /// Caso de uso de búsqueda por identificador.
  final GetChordByIdUseCase getChordByIdUseCase;

  /// Caso de uso de búsqueda con filtros.
  final SearchChordsUseCase searchChordsUseCase;

  /// Caso de uso de coincidencia por notas.
  final MatchChordsByPitchClassesUseCase matchChordsUseCase;
}
