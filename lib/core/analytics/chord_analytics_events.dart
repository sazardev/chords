import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';

/// Eventos de analítica del dominio de acordes.
///
/// Amplía [AnalyticsService] con las acciones de la biblioteca y la ficha de
/// acorde. Recibe datos primitivos —no entidades— para que el núcleo de
/// analíticas no dependa de la capa de dominio.
extension ChordAnalyticsEvents on AnalyticsService {
  /// Se ha abierto la ficha de un acorde.
  void chordViewed({
    required String chordId,
    required String chordName,
    required String quality,
    required int difficulty,
  }) => event(
    AnalyticsEventName.chordViewed,
    parameters: <String, Object?>{
      AnalyticsParam.chordId: chordId,
      AnalyticsParam.chordName: chordName,
      AnalyticsParam.quality: quality,
      AnalyticsParam.difficulty: difficulty,
    },
  );

  /// Se ha reproducido un acorde (rasgueo o arpegio con [patternId]).
  void chordPlayed({
    required String chordId,
    required String variantId,
    bool arpeggio = false,
    String? patternId,
  }) => event(
    AnalyticsEventName.chordPlayed,
    parameters: <String, Object?>{
      AnalyticsParam.chordId: chordId,
      AnalyticsParam.variantId: variantId,
      AnalyticsParam.arpeggio: arpeggio ? 1 : 0,
      AnalyticsParam.patternId: ?patternId,
    },
  );

  /// Se ha ejecutado una búsqueda con [results] resultados.
  void searchPerformed({required String query, required int results}) => event(
    AnalyticsEventName.searchPerformed,
    parameters: <String, Object?>{
      AnalyticsParam.queryLength: query.length,
      AnalyticsParam.results: results,
    },
  );

  /// Ha cambiado el filtro [filter] de la biblioteca.
  void filterChanged({
    required String filter,
    required int results,
    Object? value,
  }) => event(
    AnalyticsEventName.filterChanged,
    parameters: <String, Object?>{
      AnalyticsParam.filter: filter,
      AnalyticsParam.results: results,
      AnalyticsParam.filterValue: ?value,
    },
  );

  /// Un acorde ha pasado a dominado (o se ha desmarcado).
  void chordMasteryChanged({
    required String chordId,
    required bool mastered,
    required int totalMastered,
  }) => event(
    AnalyticsEventName.chordMasteryChanged,
    parameters: <String, Object?>{
      AnalyticsParam.chordId: chordId,
      AnalyticsParam.mastered: mastered ? 1 : 0,
      AnalyticsParam.totalMastered: totalMastered,
    },
  );
}
