///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEs = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.es,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <es>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  dynamic operator [](String key) => _meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final Translations$app$es app = Translations$app$es.internal(_root);
  late final Translations$nav$es nav = Translations$nav$es.internal(_root);
  late final Translations$home$es home = Translations$home$es.internal(_root);
  late final Translations$chords$es chords = Translations$chords$es.internal(
    _root,
  );
  late final Translations$chordDetail$es chordDetail =
      Translations$chordDetail$es.internal(_root);
  late final Translations$game$es game = Translations$game$es.internal(_root);
  late final Translations$chordDiagram$es chordDiagram =
      Translations$chordDiagram$es.internal(_root);
  late final Translations$live$es live = Translations$live$es.internal(_root);
  late final Translations$learn$es learn = Translations$learn$es.internal(
    _root,
  );
  late final Translations$settings$es settings =
      Translations$settings$es.internal(_root);
  late final Translations$onboarding$es onboarding =
      Translations$onboarding$es.internal(_root);
  late final Translations$data$es data = Translations$data$es.internal(_root);
  late final Translations$chordTheory$es chordTheory =
      Translations$chordTheory$es.internal(_root);
  late final Translations$scalesPlus$es scalesPlus =
      Translations$scalesPlus$es.internal(_root);
  late final Translations$logs$es logs = Translations$logs$es.internal(_root);
  late final Translations$router$es router = Translations$router$es.internal(
    _root,
  );
  late final Translations$mic$es mic = Translations$mic$es.internal(_root);
  late final Translations$tuner$es tuner = Translations$tuner$es.internal(
    _root,
  );
  late final Translations$practice$es practice =
      Translations$practice$es.internal(_root);
  late final Translations$profile$es profile = Translations$profile$es.internal(
    _root,
  );
  late final Translations$minigames$es minigames =
      Translations$minigames$es.internal(_root);
  late final Translations$guitar$es guitar = Translations$guitar$es.internal(
    _root,
  );
  late final Translations$theory$es theory = Translations$theory$es.internal(
    _root,
  );
  late final Translations$studio$es studio = Translations$studio$es.internal(
    _root,
  );
  late final Translations$jam$es jam = Translations$jam$es.internal(_root);
  late final Translations$songs$es songs = Translations$songs$es.internal(
    _root,
  );
}

// Path: app
class Translations$app$es {
  Translations$app$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Chords'
  String get title => 'Chords';

  /// es: 'Acorde'
  String get chordFallback => 'Acorde';

  /// es: 'Omitir'
  String get skip => 'Omitir';

  /// es: 'Siguiente'
  String get next => 'Siguiente';

  /// es: 'Empezar'
  String get start => 'Empezar';
}

// Path: nav
class Translations$nav$es {
  Translations$nav$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Inicio'
  String get home => 'Inicio';

  /// es: 'Aprender'
  String get learn => 'Aprender';

  /// es: 'Acordes'
  String get chords => 'Acordes';

  /// es: 'Jugar'
  String get game => 'Jugar';

  /// es: 'Afinar'
  String get live => 'Afinar';

  /// es: 'Ajustes'
  String get settings => 'Ajustes';
}

// Path: home
class Translations$home$es {
  Translations$home$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Hola, guitararrista'
  String get greeting => 'Hola, guitararrista';

  /// es: '¿Qué tocas hoy?'
  String get question => '¿Qué tocas hoy?';

  /// es: 'Progreso del itinerario'
  String get progressTitle => 'Progreso del itinerario';

  /// es: '(one) {$n acorde dominado} (other) {$n acordes dominados}'
  String masteredCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: '${n} acorde dominado',
        other: '${n} acordes dominados',
      );

  /// es: 'Continúa aprendiendo'
  String get continueLearning => 'Continúa aprendiendo';

  /// es: '¡Itinerario completo!'
  String get itineraryComplete => '¡Itinerario completo!';

  /// es: 'Siguiente: $name'
  String nextChord({required Object name}) => 'Siguiente: ${name}';

  /// es: 'Biblioteca de acordes'
  String get library => 'Biblioteca de acordes';

  /// es: '$count acordes por género y nivel'
  String librarySubtitle({required Object count}) =>
      '${count} acordes por género y nivel';

  /// es: 'Minijuegos'
  String get gameMode => 'Minijuegos';

  /// es: '$count juegos de oído, mástil y dedos'
  String gameSubtitle({required Object count}) =>
      '${count} juegos de oído, mástil y dedos';

  /// es: 'Afinador y escucha'
  String get liveTitle => 'Afinador y escucha';

  /// es: 'Afina cuerda a cuerda con tu micrófono'
  String get liveSubtitle => 'Afina cuerda a cuerda con tu micrófono';

  /// es: 'Buenos días'
  String get greetingMorning => 'Buenos días';

  /// es: 'Buenas tardes'
  String get greetingAfternoon => 'Buenas tardes';

  /// es: 'Buenas noches'
  String get greetingEvening => 'Buenas noches';

  /// es: 'Tu siguiente acorde'
  String get nextUp => 'Tu siguiente acorde';

  /// es: 'Practicar'
  String get practiceCta => 'Practicar';

  /// es: 'Dominados'
  String get statMastered => 'Dominados';

  /// es: 'Mejor puntaje'
  String get statBest => 'Mejor puntaje';

  /// es: 'Nivel'
  String get statLevel => 'Nivel';

  /// es: 'Para ti'
  String get recommendedTitle => 'Para ti';

  /// es: 'Completa tu perfil para ver recomendaciones.'
  String get recommendedEmpty => 'Completa tu perfil para ver recomendaciones.';

  /// es: 'Herramientas'
  String get toolsTitle => 'Herramientas';

  /// es: 'Ver todo'
  String get seeAll => 'Ver todo';

  /// es: 'Tu ruta paso a paso'
  String get learnSubtitle => 'Tu ruta paso a paso';
}

// Path: chords
class Translations$chords$es {
  Translations$chords$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Acordes'
  String get title => 'Acordes';

  /// es: 'Limpiar filtros'
  String get clearFilters => 'Limpiar filtros';

  /// es: 'Buscar acordes'
  String get searchHint => 'Buscar acordes';

  /// es: 'Todos'
  String get filterAll => 'Todos';

  /// es: 'Todas'
  String get filterAllQualities => 'Todas';

  /// es: '(one) {$n posición} (other) {$n posiciones}'
  String positionCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: '${n} posición',
        other: '${n} posiciones',
      );

  /// es: 'Nv $level'
  String levelShort({required Object level}) => 'Nv ${level}';

  /// es: 'Dificultad máx: $level'
  String maxDifficulty({required Object level}) => 'Dificultad máx: ${level}';

  /// es: 'Cargando acordes…'
  String get loading => 'Cargando acordes…';

  /// es: 'No se pudo cargar el banco'
  String get loadErrorTitle => 'No se pudo cargar el banco';

  /// es: 'Reinicia la app para reintentar la carga del banco.'
  String get loadErrorMessage =>
      'Reinicia la app para reintentar la carga del banco.';

  /// es: 'Sin resultados'
  String get emptyTitle => 'Sin resultados';

  /// es: 'Ajusta la búsqueda o los filtros para ver más acordes.'
  String get emptyMessage =>
      'Ajusta la búsqueda o los filtros para ver más acordes.';

  /// es: 'Filtros'
  String get filters => 'Filtros';

  /// es: 'Nivel'
  String get filterLevel => 'Nivel';

  /// es: 'Tipo de acorde'
  String get filterQuality => 'Tipo de acorde';

  /// es: 'Dificultad máxima'
  String get filterDifficulty => 'Dificultad máxima';

  /// es: 'Para mi nivel'
  String get forMyLevel => 'Para mi nivel';

  /// es: 'Ver resultados'
  String get apply => 'Ver resultados';

  /// es: 'Restablecer'
  String get reset => 'Restablecer';

  /// es: '(one) {$n acorde} (other) {$n acordes}'
  String results({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: '${n} acorde',
        other: '${n} acordes',
      );
}

// Path: chordDetail
class Translations$chordDetail$es {
  Translations$chordDetail$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Acorde'
  String get titleFallback => 'Acorde';

  /// es: 'Marcar como dominado'
  String get markMastered => 'Marcar como dominado';

  /// es: 'Quitar de dominados'
  String get unmarkMastered => 'Quitar de dominados';

  /// es: 'Modo zurdo'
  String get leftHandMode => 'Modo zurdo';

  /// es: 'Desactivar modo zurdo'
  String get leftHandModeOff => 'Desactivar modo zurdo';

  /// es: 'Cargando acorde…'
  String get loading => 'Cargando acorde…';

  /// es: 'Acorde no disponible'
  String get errorTitle => 'Acorde no disponible';

  /// es: 'No se encontró el acorde $chordId'
  String notFoundMessage({required Object chordId}) =>
      'No se encontró el acorde ${chordId}';

  /// es: 'No se pudo leer el banco de acordes.'
  String get loadFailed => 'No se pudo leer el banco de acordes.';

  /// es: 'Sin acorde seleccionado'
  String get noChordTitle => 'Sin acorde seleccionado';

  /// es: 'Vuelve al listado y elige un acorde.'
  String get noChordMessage => 'Vuelve al listado y elige un acorde.';

  /// es: 'Escuchar acorde'
  String get listen => 'Escuchar acorde';

  /// es: 'Escuchar $position'
  String listenPosition({required Object position}) => 'Escuchar ${position}';

  /// es: 'Arpegios'
  String get arpeggios => 'Arpegios';

  /// es: 'Posiciones'
  String get positions => 'Posiciones';

  /// es: 'Notas: $notes'
  String notes({required Object notes}) => 'Notas: ${notes}';

  /// es: '$label · Nv $level'
  String arpeggioChip({required Object label, required Object level}) =>
      '${label} · Nv ${level}';

  /// es: 'Practicar'
  String get practice => 'Practicar';

  /// es: 'Cómo colocarlo'
  String get guideTitle => 'Cómo colocarlo';

  /// es: '1 índice · 2 medio · 3 anular · 4 meñique'
  String get guideLegend => '1 índice · 2 medio · 3 anular · 4 meñique';

  /// es: 'Traste $fret · cuerda $string'
  String guideFinger({required Object fret, required Object string}) =>
      'Traste ${fret} · cuerda ${string}';

  /// es: 'Cejillo en el traste $fret · de la $from a la $to'
  String guideBarre({
    required Object fret,
    required Object from,
    required Object to,
  }) => 'Cejillo en el traste ${fret} · de la ${from} a la ${to}';

  /// es: 'Toca: $strings'
  String guidePlay({required Object strings}) => 'Toca: ${strings}';

  /// es: 'Al aire: $strings'
  String guideOpen({required Object strings}) => 'Al aire: ${strings}';

  /// es: 'No toques: $strings'
  String guideMuted({required Object strings}) => 'No toques: ${strings}';

  /// es: 'Posición abierta, junto a la cejuela'
  String get guideOpenPosition => 'Posición abierta, junto a la cejuela';

  /// es: 'Zona de los trastes $from a $to'
  String guideRange({required Object from, required Object to}) =>
      'Zona de los trastes ${from} a ${to}';

  /// es: 'Zona del traste $fret'
  String guideSingleFret({required Object fret}) => 'Zona del traste ${fret}';

  /// es: 'Para empezar'
  String get recommended => 'Para empezar';

  Map<String, String> get fingerNames => {
    'f1': 'Índice',
    'f2': 'Medio',
    'f3': 'Anular',
    'f4': 'Meñique',
  };
}

// Path: game
class Translations$game$es {
  Translations$game$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Jugar'
  String get title => 'Jugar';

  /// es: 'Empezar serie'
  String get start => 'Empezar serie';

  /// es: 'Toca el acorde'
  String get emptyTitle => 'Toca el acorde';

  /// es: 'Encadena una serie de acordes con el micrófono. Récord: $best puntos.'
  String emptyMessage({required Object best}) =>
      'Encadena una serie de acordes con el micrófono. Récord: ${best} puntos.';

  /// es: 'Ronda $number'
  String round({required Object number}) => 'Ronda ${number}';

  /// es: 'Toca este acorde'
  String get playThisChord => 'Toca este acorde';

  /// es: 'Cargando acorde…'
  String get loadingChord => 'Cargando acorde…';

  /// es: 'Escuchando tu guitarra…'
  String get listening => 'Escuchando tu guitarra…';

  /// es: '¡Correcto! Siguiente'
  String get correctNext => '¡Correcto! Siguiente';

  /// es: 'Inténtalo otra vez'
  String get retry => 'Inténtalo otra vez';

  /// es: 'Estoy listo'
  String get ready => 'Estoy listo';

  /// es: 'Racha'
  String get streak => 'Racha';

  /// es: 'Puntos'
  String get score => 'Puntos';

  /// es: '¡Vas bien! $hit de $total notas'
  String feedbackProgress({required Object hit, required Object total}) =>
      '¡Vas bien! ${hit} de ${total} notas';

  /// es: 'Te falta: $notes'
  String feedbackMissing({required Object notes}) => 'Te falta: ${notes}';

  /// es: 'Suena de más: $notes'
  String feedbackExtra({required Object notes}) => 'Suena de más: ${notes}';

  /// es: '¡Acorde completo!'
  String get feedbackComplete => '¡Acorde completo!';

  /// es: '¡Casi! Siguiente'
  String get almostNext => '¡Casi! Siguiente';

  /// es: '1ª'
  String get stringFirst => '1ª';

  /// es: '2ª'
  String get stringSecond => '2ª';

  /// es: '3ª'
  String get stringThird => '3ª';

  /// es: '4ª'
  String get stringFourth => '4ª';

  /// es: '5ª'
  String get stringFifth => '5ª';

  /// es: '6ª'
  String get stringSixth => '6ª';

  /// es: 'Practicar cuerda a cuerda'
  String get practiceChord => 'Practicar cuerda a cuerda';

  /// es: '¡Serie completa!'
  String get finishedTitle => '¡Serie completa!';

  /// es: '$won de $total acordes · $score puntos'
  String finishedMessage({
    required Object won,
    required Object total,
    required Object score,
  }) => '${won} de ${total} acordes · ${score} puntos';

  /// es: 'Tu récord: $best puntos'
  String finishedBest({required Object best}) => 'Tu récord: ${best} puntos';
}

// Path: chordDiagram
class Translations$chordDiagram$es {
  Translations$chordDiagram$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'cuerda $number: $fret'
  String stringLabel({required Object number, required Object fret}) =>
      'cuerda ${number}: ${fret}';

  /// es: 'muda'
  String get muted => 'muda';

  /// es: 'al aire'
  String get open => 'al aire';

  /// es: 'traste $value'
  String fret({required Object value}) => 'traste ${value}';

  /// es: 'Diagrama de $position, $details'
  String description({required Object position, required Object details}) =>
      'Diagrama de ${position}, ${details}';
}

// Path: live
class Translations$live$es {
  Translations$live$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Afinador'
  String get title => 'Afinador';

  /// es: 'Sin sugerencias aún'
  String get emptyTitle => 'Sin sugerencias aún';

  /// es: 'Pulsa escuchar y toca un acorde para ver coincidencias.'
  String get emptyMessage =>
      'Pulsa escuchar y toca un acorde para ver coincidencias.';

  /// es: 'Sugerencias'
  String get suggestions => 'Sugerencias';

  /// es: 'Micrófono en espera'
  String get idleTitle => 'Micrófono en espera';

  /// es: 'Toca una nota en la guitarra'
  String get idleMessage => 'Toca una nota en la guitarra';

  /// es: 'Escuchando…'
  String get listening => 'Escuchando…';

  /// es: 'Permiso denegado'
  String get deniedTitle => 'Permiso denegado';

  /// es: 'Error de captura'
  String get errorTitle => 'Error de captura';
}

// Path: learn
class Translations$learn$es {
  Translations$learn$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Aprender'
  String get title => 'Aprender';

  /// es: 'Preparando niveles…'
  String get loading => 'Preparando niveles…';

  /// es: 'No se pudo cargar el itinerario'
  String get errorTitle => 'No se pudo cargar el itinerario';

  /// es: 'Reinicia la app para reintentar.'
  String get errorMessage => 'Reinicia la app para reintentar.';

  /// es: 'Tu progreso'
  String get yourProgress => 'Tu progreso';

  /// es: '(one) {$n acorde dominado} (other) {$n acordes dominados}'
  String masteredCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: '${n} acorde dominado',
        other: '${n} acordes dominados',
      );

  /// es: 'Paso a paso'
  String get stepByStep => 'Paso a paso';

  /// es: 'Coloca los dedos uno a uno sobre el diapasón'
  String get stepFingers => 'Coloca los dedos uno a uno sobre el diapasón';

  /// es: 'Rasgueo lento: escucha cada cuerda'
  String get stepStrum => 'Rasgueo lento: escucha cada cuerda';

  /// es: 'Cambia al acorde siguiente sin parar el ritmo'
  String get stepChange => 'Cambia al acorde siguiente sin parar el ritmo';

  /// es: 'Arpegios guiados'
  String get guidedArpeggios => 'Arpegios guiados';

  /// es: '$emoji Nivel $level: $title'
  String levelSection({
    required Object emoji,
    required Object level,
    required Object title,
  }) => '${emoji}  Nivel ${level}: ${title}';

  /// es: 'Abre el acorde y toca su arpegio $label'
  String arpeggioHint({required Object label}) =>
      'Abre el acorde y toca su arpegio ${label}';
}

// Path: settings
class Translations$settings$es {
  Translations$settings$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Ajustes'
  String get title => 'Ajustes';

  /// es: 'Apariencia'
  String get appearance => 'Apariencia';

  late final Translations$settings$theme$es theme =
      Translations$settings$theme$es.internal(_root);
  late final Translations$settings$color$es color =
      Translations$settings$color$es.internal(_root);
  late final Translations$settings$text$es text =
      Translations$settings$text$es.internal(_root);
  late final Translations$settings$language$es language =
      Translations$settings$language$es.internal(_root);
  late final Translations$settings$accent$es accent =
      Translations$settings$accent$es.internal(_root);
  late final Translations$settings$fontScale$es fontScale =
      Translations$settings$fontScale$es.internal(_root);

  /// es: 'Guitarra'
  String get guitar => 'Guitarra';

  /// es: 'Modo zurdo'
  String get leftHandMode => 'Modo zurdo';

  /// es: 'Muestra los diagramas en espejo'
  String get leftHandModeSubtitle => 'Muestra los diagramas en espejo';

  /// es: 'Sonido'
  String get sound => 'Sonido';

  /// es: 'Sonido de acordes'
  String get chordSound => 'Sonido de acordes';

  /// es: 'Sintetiza rasgueos y arpegios'
  String get chordSoundSubtitle => 'Sintetiza rasgueos y arpegios';

  /// es: 'Aprendizaje'
  String get learning => 'Aprendizaje';

  /// es: 'Reiniciar onboarding'
  String get resetOnboarding => 'Reiniciar onboarding';

  /// es: 'Vuelve a ver la introducción'
  String get resetOnboardingSubtitle => 'Vuelve a ver la introducción';

  /// es: 'Onboarding reiniciado'
  String get onboardingReset => 'Onboarding reiniciado';

  /// es: 'Versión'
  String get version => 'Versión';

  /// es: 'CLI de desarrollo'
  String get cli => 'CLI de desarrollo';

  /// es: 'dart run bin/chords_cli.dart db generate'
  String get cliCommand => 'dart run bin/chords_cli.dart db generate';
}

// Path: onboarding
class Translations$onboarding$es {
  Translations$onboarding$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Todos los acordes, todas las posiciones'
  String get slideOneTitle => 'Todos los acordes, todas las posiciones';

  /// es: '156 acordes y 561 posiciones verificadas, de los abiertos esenciales a los voicings de jazz.'
  String get slideOneBody =>
      '156 acordes y 561 posiciones verificadas, de los abiertos esenciales a los voicings de jazz.';

  /// es: 'Escucha cada acorde y su arpegio'
  String get slideTwoTitle => 'Escucha cada acorde y su arpegio';

  /// es: 'Sintetizamos cada cuerda para que reconozcas el sonido antes de tocar.'
  String get slideTwoBody =>
      'Sintetizamos cada cuerda para que reconozcas el sonido antes de tocar.';

  /// es: 'Aprende por niveles y practica'
  String get slideThreeTitle => 'Aprende por niveles y practica';

  /// es: 'Itinerario paso a paso, filtro por género y modo juego para encadenar series de acordes.'
  String get slideThreeBody =>
      'Itinerario paso a paso, filtro por género y modo juego para encadenar series de acordes.';

  /// es: 'Tu guitarra, a tu medida'
  String get welcomeTitle => 'Tu guitarra, a tu medida';

  /// es: 'Cinco preguntas rápidas y te recomiendo los acordes ideales para ti.'
  String get welcomeBody =>
      'Cinco preguntas rápidas y te recomiendo los acordes ideales para ti.';

  /// es: 'Empezar'
  String get welcomeCta => 'Empezar';

  /// es: 'Paso $current de $total'
  String stepOf({required Object current, required Object total}) =>
      'Paso ${current} de ${total}';

  /// es: 'Atrás'
  String get back => 'Atrás';

  /// es: 'Continuar'
  String get proceed => 'Continuar';

  /// es: 'Empezar a tocar'
  String get finish => 'Empezar a tocar';

  /// es: '¿Qué guitarra tocas?'
  String get guitarTitle => '¿Qué guitarra tocas?';

  /// es: 'Cada una pide acordes distintos.'
  String get guitarBody => 'Cada una pide acordes distintos.';

  /// es: 'Acústica'
  String get guitarAcoustic => 'Acústica';

  /// es: 'Cuerdas de acero y acordes abiertos'
  String get guitarAcousticHint => 'Cuerdas de acero y acordes abiertos';

  /// es: 'Eléctrica'
  String get guitarElectric => 'Eléctrica';

  /// es: 'Power chords y riffs'
  String get guitarElectricHint => 'Power chords y riffs';

  /// es: 'Clásica'
  String get guitarClassical => 'Clásica';

  /// es: 'Cuerdas de nailon y dedos'
  String get guitarClassicalHint => 'Cuerdas de nailon y dedos';

  /// es: '¿Cómo la tocas?'
  String get playTitle => '¿Cómo la tocas?';

  /// es: 'Ajusto los diagramas y los arpegios a tu forma de tocar.'
  String get playBody =>
      'Ajusto los diagramas y los arpegios a tu forma de tocar.';

  /// es: 'Tu mano'
  String get handLabel => 'Tu mano';

  /// es: 'Diestro'
  String get handRight => 'Diestro';

  /// es: 'Diagramas normales'
  String get handRightHint => 'Diagramas normales';

  /// es: 'Zurdo'
  String get handLeft => 'Zurdo';

  /// es: 'Diagramas en espejo'
  String get handLeftHint => 'Diagramas en espejo';

  /// es: 'Cómo atacas las cuerdas'
  String get styleLabel => 'Cómo atacas las cuerdas';

  /// es: 'Púa'
  String get stylePick => 'Púa';

  /// es: 'Dedos'
  String get styleFingers => 'Dedos';

  /// es: 'Ambos'
  String get styleBoth => 'Ambos';

  /// es: '¿Qué música te gusta?'
  String get genresTitle => '¿Qué música te gusta?';

  /// es: 'Elige los que quieras: recomiendo acordes de esos estilos.'
  String get genresBody =>
      'Elige los que quieras: recomiendo acordes de esos estilos.';

  /// es: '¿Cuánta experiencia tienes?'
  String get levelTitle => '¿Cuánta experiencia tienes?';

  /// es: 'Ajusto la dificultad para que avances sin frustrarte.'
  String get levelBody =>
      'Ajusto la dificultad para que avances sin frustrarte.';

  /// es: 'Estoy empezando'
  String get levelBeginner => 'Estoy empezando';

  /// es: 'Acordes abiertos, sin cejilla'
  String get levelBeginnerHint => 'Acordes abiertos, sin cejilla';

  /// es: 'Ya toco canciones'
  String get levelIntermediate => 'Ya toco canciones';

  /// es: 'Cambio de acorde y cejillas básicas'
  String get levelIntermediateHint => 'Cambio de acorde y cejillas básicas';

  /// es: 'Toco con soltura'
  String get levelAdvanced => 'Toco con soltura';

  /// es: 'Cejillas, séptimas y voicings'
  String get levelAdvancedHint => 'Cejillas, séptimas y voicings';

  /// es: 'Tu plan está listo'
  String get planTitle => 'Tu plan está listo';

  /// es: 'Empieza por estos acordes, elegidos para ti.'
  String get planBody => 'Empieza por estos acordes, elegidos para ti.';

  /// es: 'Explora la biblioteca y empieza por el que más te guste.'
  String get planEmpty =>
      'Explora la biblioteca y empieza por el que más te guste.';

  /// es: 'Tu guitarra también es el mando'
  String get guitarModeTitle => 'Tu guitarra también es el mando';

  /// es: 'Mueve toda la app tocando notas, sin soltar la guitarra.'
  String get guitarModeBody =>
      'Mueve toda la app tocando notas, sin soltar la guitarra.';

  /// es: 'Activar el modo guitarra'
  String get guitarModeSwitch => 'Activar el modo guitarra';

  /// es: 'Pedirá permiso para el micrófono. Puedes cambiarlo en Ajustes.'
  String get guitarModeSwitchHint =>
      'Pedirá permiso para el micrófono. Puedes cambiarlo en Ajustes.';

  /// es: 'Toca una nota aguda (traste 14 o más de la 1ª cuerda) y se abre el menú.'
  String get guitarModeStep1 =>
      'Toca una nota aguda (traste 14 o más de la 1ª cuerda) y se abre el menú.';

  /// es: 'Con el menú abierto, toca la nota de la opción: en una cuerda, Mi al aire y un traste más por destino.'
  String get guitarModeStep2 =>
      'Con el menú abierto, toca la nota de la opción: en una cuerda, Mi al aire y un traste más por destino.';

  /// es: 'Toca una opción para ver qué nota la elige'
  String get guitarModeTry => 'Toca una opción para ver qué nota la elige';

  /// es: '$note · $fret → $label'
  String guitarModePreview({
    required Object note,
    required Object fret,
    required Object label,
  }) => '${note} · ${fret} → ${label}';
}

// Path: data
class Translations$data$es {
  Translations$data$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final Translations$data$language$es language =
      Translations$data$language$es.internal(_root);
  late final Translations$data$genre$es genre =
      Translations$data$genre$es.internal(_root);
  late final Translations$data$quality$es quality =
      Translations$data$quality$es.internal(_root);
  late final Translations$data$qualityDescription$es qualityDescription =
      Translations$data$qualityDescription$es.internal(_root);
  late final Translations$data$difficulty$es difficulty =
      Translations$data$difficulty$es.internal(_root);
  late final Translations$data$difficultyHint$es difficultyHint =
      Translations$data$difficultyHint$es.internal(_root);
  late final Translations$data$level$es level =
      Translations$data$level$es.internal(_root);
  late final Translations$data$levelGoal$es levelGoal =
      Translations$data$levelGoal$es.internal(_root);
  late final Translations$data$arpeggio$es arpeggio =
      Translations$data$arpeggio$es.internal(_root);
}

// Path: chordTheory
class Translations$chordTheory$es {
  Translations$chordTheory$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  Map<String, String> get qualityNames => {
    'add9': 'Novena añadida',
    'madd9': 'Menor con novena añadida',
    '69': 'Sexta con novena',
    'm9': 'Novena menor',
    'maj9': 'Novena mayor',
    '11': 'Oncena',
    'm11': 'Oncena menor',
    '13': 'Trecena',
    '7sus4': 'Séptima suspendida 4',
    '9sus4': 'Novena suspendida 4',
    'mMaj7': 'Menor con séptima mayor',
    'm7b5': 'Semidisminuido',
    'dim7': 'Séptima disminuida',
    '7b9': 'Séptima con novena menor',
    '7s9': 'Séptima con novena aumentada',
    '7s5': 'Séptima aumentada',
    '7b5': 'Séptima con quinta bemol',
    '7s11': 'Séptima con oncena aumentada',
    'maj7s11': 'Séptima mayor con oncena aumentada',
    'maj7s5': 'Séptima mayor aumentada',
  };
  Map<String, String> get qualityAbout => {
    'add9': 'Triada con novena añadida; brillo de pop y baladas.',
    'madd9': 'Menor con novena añadida; íntima y cinematográfica.',
    '69': 'Sexta con novena; cierre clásico de jazz y bossa.',
    'm9': 'Séptima menor con novena; soul, jazz y r&b.',
    'maj9': 'Séptima mayor con novena; lujo de jazz y neo-soul.',
    '11': 'Dominante con oncena; sonido abierto de funk y gospel.',
    'm11': 'Menor con oncena; espacioso, de jazz y r&b.',
    '13': 'Dominante con trecena; blues urbano, funk y jazz.',
    '7sus4': 'Dominante suspendido; tensión sin tercera, muy de funk.',
    '9sus4': 'Novena suspendida; flotante, de funk y r&b.',
    'mMaj7': 'Menor con séptima mayor; misterio de película de espías.',
    'm7b5': 'Semidisminuido; el ii de los ii-V-i menores.',
    'dim7': 'Simétrico de cuatro notas; paso cromático y tensión.',
    '7b9': 'Dominante con novena menor; tensión latina y de jazz.',
    '7s9': 'El acorde de Hendrix; dominante agrio de rock y funk.',
    '7s5': 'Dominante aumentado (aug7); tensión de tonos enteros.',
    '7b5': 'Dominante con quinta bemol; sustituto de tritono.',
    '7s11': 'Dominante lidio; brillo de jazz moderno y bossa.',
    'maj7s11': 'Séptima mayor lidia; sonido flotante y soñador.',
    'maj7s5': 'Séptima mayor aumentada; luminosa e inquieta.',
  };
  Map<String, String> get families => {
    'triad': 'Triadas',
    'power': 'Quintas',
    'sixth': 'Sextas',
    'seventh': 'Séptimas',
    'extended': 'Extendidos',
    'suspendedAdded': 'Suspendidos y añadidos',
    'altered': 'Alterados',
  };
  Map<String, String> get tags => {
    'open': 'Abierta',
    'barre': 'Cejilla',
    'movable': 'Movible',
    'inversion': 'Inversión',
    'triad': 'Tríada',
    'shell': 'Shell',
    'voicing': 'Voicing',
    'drop2': 'Drop 2',
    'drop3': 'Drop 3',
    'upper': 'Cuerdas agudas',
    'high-position': 'Posición alta',
  };
  Map<String, String> get intervalNames => {
    '1': 'tónica',
    'b2': 'segunda menor',
    '2': 'segunda mayor',
    'b3': 'tercera menor',
    '3': 'tercera mayor',
    '4': 'cuarta justa',
    'b5': 'quinta disminuida',
    '5': 'quinta justa',
    '#5': 'quinta aumentada',
    '6': 'sexta mayor',
    'bb7': 'séptima disminuida',
    'b7': 'séptima menor',
    '7': 'séptima mayor',
    'b9': 'novena menor',
    '9': 'novena mayor',
    '#9': 'novena aumentada',
    '11': 'oncena justa',
    '#11': 'oncena aumentada',
    '13': 'trecena mayor',
  };

  /// es: 'Ordenar'
  String get sortTooltip => 'Ordenar';

  /// es: 'Esenciales primero'
  String get sortEssentials => 'Esenciales primero';

  /// es: 'Más fáciles primero'
  String get sortDifficulty => 'Más fáciles primero';

  /// es: 'Por nota (Do, Re, Mi…)'
  String get sortRoot => 'Por nota (Do, Re, Mi…)';

  /// es: 'Por tipo de acorde'
  String get sortQuality => 'Por tipo de acorde';

  /// es: 'Elegir nota y tipo'
  String get pickChord => 'Elegir nota y tipo';

  /// es: 'Nota'
  String get pickRoot => 'Nota';

  /// es: 'Tipo de acorde'
  String get pickQuality => 'Tipo de acorde';

  /// es: 'Ver $n acordes'
  String pickShow({required Object n}) => 'Ver ${n} acordes';

  /// es: 'Abrir ficha de $name'
  String pickOpen({required Object name}) => 'Abrir ficha de ${name}';

  /// es: 'Quitar'
  String get pickClear => 'Quitar';

  /// es: 'Prueba con Cm7, Do mayor, Re menor 7 o C E G.'
  String get searchTip => 'Prueba con Cm7, Do mayor, Re menor 7 o C E G.';

  /// es: 'Notas y fórmula'
  String get notesTitle => 'Notas y fórmula';

  /// es: 'Fórmula: $formula'
  String formulaLine({required Object formula}) => 'Fórmula: ${formula}';

  /// es: 'Se puede omitir'
  String get optionalNote => 'Se puede omitir';

  /// es: '$note es la $interval'
  String noteMeaning({required Object note, required Object interval}) =>
      '${note} es la ${interval}';

  /// es: 'Qué es este acorde'
  String get aboutTitle => 'Qué es este acorde';

  /// es: 'En qué tonalidades está'
  String get keysTitle => 'En qué tonalidades está';

  /// es: 'El grado que ocupa en cada tonalidad.'
  String get keysHint => 'El grado que ocupa en cada tonalidad.';

  /// es: '$roman en $key'
  String keyChip({required Object roman, required Object key}) =>
      '${roman} en ${key}';

  /// es: '$note mayor'
  String keyMajor({required Object note}) => '${note} mayor';

  /// es: '$note menor'
  String keyMinor({required Object note}) => '${note} menor';

  /// es: 'Variantes de este acorde'
  String get variantsTitle => 'Variantes de este acorde';

  /// es: 'Posiciones ($n)'
  String positionsCount({required Object n}) => 'Posiciones (${n})';

  /// es: 'Todas'
  String get filterAll => 'Todas';

  /// es: 'Ninguna posición de este tipo.'
  String get variantsEmpty => 'Ninguna posición de este tipo.';

  /// es: 'Acordes parientes'
  String get relativesTitle => 'Acordes parientes';

  /// es: 'La misma raíz con otro color: toca uno para ver su ficha.'
  String get relativesHint =>
      'La misma raíz con otro color: toca uno para ver su ficha.';

  /// es: 'Relativo: $name'
  String relativeOf({required Object name}) => 'Relativo: ${name}';

  /// es: 'Dónde se usa'
  String get whereTitle => 'Dónde se usa';

  /// es: 'Géneros'
  String get genresLabel => 'Géneros';

  /// es: 'En las progresiones'
  String get progressionsLabel => 'En las progresiones';

  /// es: '$degree en $key'
  String progressionRow({required Object degree, required Object key}) =>
      '${degree} en ${key}';

  /// es: 'Todavía no está en ninguna progresión del catálogo.'
  String get noProgressions =>
      'Todavía no está en ninguna progresión del catálogo.';

  /// es: 'Tríada cuerdas $strings · $inversion'
  String variantTriad({required Object strings, required Object inversion}) =>
      'Tríada cuerdas ${strings} · ${inversion}';

  /// es: 'Shell $degrees · cuerdas $strings'
  String variantShell({required Object degrees, required Object strings}) =>
      'Shell ${degrees} · cuerdas ${strings}';

  /// es: 'Voicing · cuerdas $strings · $inversion'
  String variantVoicing({required Object strings, required Object inversion}) =>
      'Voicing · cuerdas ${strings} · ${inversion}';

  /// es: 'Drop 2 · cuerdas $strings · $inversion'
  String variantDrop2({required Object strings, required Object inversion}) =>
      'Drop 2 · cuerdas ${strings} · ${inversion}';

  /// es: 'Drop 3 · cuerdas $strings · $inversion'
  String variantDrop3({required Object strings, required Object inversion}) =>
      'Drop 3 · cuerdas ${strings} · ${inversion}';

  /// es: 'posición fundamental'
  String get inversionRoot => 'posición fundamental';

  /// es: '1ª inversión'
  String get inversionFirst => '1ª inversión';

  /// es: '2ª inversión'
  String get inversionSecond => '2ª inversión';

  /// es: '3ª inversión'
  String get inversionThird => '3ª inversión';

  /// es: '$degree en el bajo'
  String inversionOther({required Object degree}) => '${degree} en el bajo';

  /// es: 'Forma de $note$rest'
  String shapeNameFormat({required Object note, required Object rest}) =>
      'Forma de ${note}${rest}';

  /// es: '$name · traste $n'
  String fretSuffix({required Object name, required Object n}) =>
      '${name} · traste ${n}';

  Map<String, String> get shapeNames => {
    'e-power': 'Power cuerda 6',
    'a-power': 'Power cuerda 5',
    'd-power': 'Power cuerda 4',
    'e-power-4': 'Power 4 cuerdas',
    'a-power-4': 'Power 4 cuerdas (5ª)',
    'e-power-5': 'Power con octava (5 cuerdas)',
  };
  Map<String, String> get shapeWords => {
    'menor': 'menor',
    'corta': 'corta',
    '(corta)': '(corta)',
    '(aguda)': '(aguda)',
    '(abierta)': '(abierta)',
    '(alt.)': '(alt.)',
    '(3': '(3',
    'dedos)': 'dedos)',
    '(raíz': '(raíz',
    'en': 'en',
    '6ª)': '6ª)',
  };
}

// Path: scalesPlus
class Translations$scalesPlus$es {
  Translations$scalesPlus$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  Map<String, String> get names => {
    'major': 'mayor (jónica)',
    'dorian': 'dórica',
    'phrygian': 'frigia',
    'lydian': 'lidia',
    'mixolydian': 'mixolidia',
    'minor': 'menor natural (eólica)',
    'locrian': 'locria',
    'harmonicMinor': 'menor armónica',
    'melodicMinor': 'menor melódica',
    'locrianNatural6': 'locria ♮6',
    'ionianSharp5': 'jónica #5',
    'ukrainianDorian': 'dórica #4 (ucraniana)',
    'phrygianDominant': 'frigia dominante',
    'lydianSharp2': 'lidia #2',
    'superLocrianBb7': 'superlocria bb7',
    'dorianFlat2': 'dórica b2',
    'lydianAugmented': 'lidia aumentada',
    'lydianDominant': 'lidia dominante',
    'mixolydianFlat6': 'mixolidia b6',
    'locrianSharp2': 'locria #2 (semilocria)',
    'altered': 'alterada (superlocria)',
    'minorPentatonic': 'pentatónica menor',
    'majorPentatonic': 'pentatónica mayor',
    'blues': 'escala de blues',
    'majorBlues': 'blues mayor',
    'minorHexatonic': 'pentatónica menor con 9ª (hexatónica)',
    'suspendedPentatonic': 'pentatónica suspendida (egipcia)',
    'wholeTone': 'tonos enteros',
    'diminishedWholeHalf': 'disminuida (tono-semitono)',
    'diminishedHalfWhole': 'disminuida (semitono-tono)',
    'augmentedScale': 'aumentada',
    'bebopDominant': 'bebop dominante',
    'bebopMajor': 'bebop mayor',
    'hungarianMinor': 'húngara menor',
    'doubleHarmonic': 'doble armónica (arábiga)',
    'hirajoshi': 'hirajoshi',
    'neapolitanMinor': 'napolitana menor',
    'persian': 'persa',
  };
  Map<String, String> get about => {
    'major': 'La base de la armonía: alegre, estable y luminosa.',
    'dorian':
        'Menor con sexta mayor: elegante y con ritmo, ni triste ni dulce.',
    'phrygian':
        'Menor con segunda menor: oscura, tensa y con aire de flamenco.',
    'lydian': 'Mayor con cuarta aumentada: flotante, soñadora y de cine.',
    'mixolydian':
        'Mayor con séptima menor: relajada, de rock clásico y country.',
    'minor': 'La menor de siempre: melancólica, épica y muy cantable.',
    'locrian':
        'Menor con segunda y quinta bemol: la más inestable, sin reposo.',
    'harmonicMinor': 'Menor con la séptima elevada: dramática y clásica, con un salto exótico.',
    'melodicMinor': 'Menor con sexta y séptima mayores: suave y misteriosa, base del jazz moderno.',
    'locrianNatural6':
        'Locria con sexta natural: tensa y poco usada, de color oscuro.',
    'ionianSharp5': 'Mayor con quinta aumentada: luminosa e inquieta.',
    'ukrainianDorian':
        'Dórica con cuarta aumentada: sabor de Europa del Este y klezmer.',
    'phrygianDominant':
        'Frigia con tercera mayor: el sonido del flamenco y de Oriente Medio.',
    'lydianSharp2': 'Lidia con segunda aumentada: brillante, rara y llamativa.',
    'superLocrianBb7': 'La más tensa de la armónica: simétrica y disminuida.',
    'dorianFlat2': 'Dórica con segunda menor: oscura y cinematográfica.',
    'lydianAugmented': 'Lidia con quinta aumentada: etérea, de acordes maj7#5.',
    'lydianDominant':
        'Mixolidia con cuarta aumentada: dominante brillante de jazz y fusión.',
    'mixolydianFlat6':
        'Mixolidia con sexta menor: entre lo mayor y lo menor, aire hindú.',
    'locrianSharp2':
        'Locria con segunda mayor: la más suave sobre los acordes m7b5.',
    'altered': 'Toda la tensión de un dominante: b9, #9, b5 y #5 a la vez.',
    'minorPentatonic':
        'Cinco notas que nunca fallan: el corazón del rock y el blues.',
    'majorPentatonic': 'Dulce y abierta: country, pop, soul y solos melódicos.',
    'blues': 'Pentatónica menor con la blue note (b5): pura actitud.',
    'majorBlues': 'Pentatónica mayor con la tercera menor de paso: blues alegre y country.',
    'minorHexatonic': 'Pentatónica menor con novena: suave y moderna, entre el rock y el jazz.',
    'suspendedPentatonic':
        'Sin terceras: abierta, ambigua y muy usada en pop y ambient.',
    'wholeTone': 'Seis tonos seguidos: flotante, sin tónica clara, de ensueño.',
    'diminishedWholeHalf':
        'Tono-semitono: simétrica, para acordes disminuidos.',
    'diminishedHalfWhole':
        'Semitono-tono: simétrica, con todas las tensiones de un dominante.',
    'augmentedScale':
        'Tercera menor y semitono alternados: simétrica y moderna.',
    'bebopDominant': 'Mixolidia con la séptima mayor de paso: corcheas que caen en los tiempos.',
    'bebopMajor': 'Mayor con la sexta menor de paso: líneas fluidas de bebop.',
    'hungarianMinor':
        'Menor armónica con cuarta aumentada: dramática, gitana y oscura.',
    'doubleHarmonic':
        'Dos segundas aumentadas: sabor arábigo, bizantino y flamenco.',
    'hirajoshi': 'Cinco notas japonesas: contemplativa, de koto y de anime.',
    'neapolitanMinor': 'Menor armónica con segunda bemol: clásica y trágica.',
    'persian': 'Siete notas con segunda y quinta bemol: exótica y muy tensa.',
  };
  Map<String, String> get styles => {
    'major': 'Pop, folk, country, canciones infantiles.',
    'dorian': 'Funk, jazz, Santana, Pink Floyd, soul.',
    'phrygian': 'Flamenco, metal, música oscura.',
    'lydian': 'Bandas sonoras, Joe Satriani, indie, jazz.',
    'mixolydian': 'Rock clásico, blues, country, funk.',
    'minor': 'Baladas, rock, metal, pop triste.',
    'locrian': 'Metal, jazz sobre acordes m7b5.',
    'harmonicMinor': 'Clásica, flamenco, metal neoclásico, boleros.',
    'melodicMinor': 'Jazz, fusión, música de cine.',
    'locrianNatural6': 'Jazz avanzado y metal progresivo.',
    'ionianSharp5': 'Jazz moderno sobre maj7#5.',
    'ukrainianDorian': 'Klezmer, música balcánica, metal folk.',
    'phrygianDominant': 'Flamenco, surf rock, klezmer, metal.',
    'lydianSharp2': 'Jazz moderno y fusión.',
    'superLocrianBb7': 'Jazz avanzado, sobre acordes dim7 con tensión.',
    'dorianFlat2': 'Jazz moderno, bandas sonoras, metal.',
    'lydianAugmented': 'Jazz, fusión y pasajes etéreos.',
    'lydianDominant': 'Jazz, fusión, bossa y funk (7#11).',
    'mixolydianFlat6': 'Jazz, bandas sonoras y fusión.',
    'locrianSharp2': 'Jazz sobre acordes m7b5 (el ii de los menores).',
    'altered': 'Jazz: V7 alterado que resuelve a un acorde menor o mayor.',
    'minorPentatonic': 'Rock, blues, metal, funk, cualquier solo.',
    'majorPentatonic': 'Country, pop, soul, gospel, solos dulces.',
    'blues': 'Blues, rock, hard rock, funk.',
    'majorBlues': 'Blues alegre, country, soul, rock sureño.',
    'minorHexatonic': 'Rock suave, fusión, neo-soul.',
    'suspendedPentatonic': 'Pop, ambient, rock progresivo, música étnica.',
    'wholeTone': 'Impresionismo, jazz (Monk), bandas sonoras oníricas.',
    'diminishedWholeHalf': 'Jazz, música clásica, metal (acordes dim).',
    'diminishedHalfWhole': 'Jazz sobre dominantes con b9, #9 y #11.',
    'augmentedScale': 'Jazz moderno y fusión (Coltrane).',
    'bebopDominant': 'Jazz bebop sobre acordes dominantes (7).',
    'bebopMajor': 'Jazz bebop sobre acordes mayores (maj7, 6).',
    'hungarianMinor': 'Música gitana, metal neoclásico, bandas sonoras.',
    'doubleHarmonic': 'Música arábiga, flamenco, surf rock, metal.',
    'hirajoshi': 'Música japonesa, metal, bandas sonoras.',
    'neapolitanMinor': 'Música clásica, metal neoclásico.',
    'persian': 'Música persa, árabe y metal oriental.',
  };
  Map<String, String> get groups => {
    'major': 'Mayor y modos',
    'minor': 'Menores',
    'pentatonic': 'Pentatónicas y blues',
    'exotic': 'Exóticas y simétricas',
  };
  Map<String, String> get sections => {
    'majorModes': 'Los siete modos de la mayor',
    'minors': 'Menor natural, armónica y melódica',
    'harmonicModes': 'Modos de la menor armónica',
    'melodicModes': 'Modos de la menor melódica',
    'pentatonics': 'Pentatónicas, blues y hexatónicas',
    'symmetric': 'Simétricas y bebop',
    'exotic': 'Exóticas',
  };

  /// es: '$n notas'
  String notesCount({required Object n}) => '${n} notas';

  /// es: 'Fórmula'
  String get formulaTitle => 'Fórmula';

  /// es: '$degrees'
  String formulaLine({required Object degrees}) => '${degrees}';

  /// es: 'Intervalos: $steps'
  String intervalsLine({required Object steps}) => 'Intervalos: ${steps}';

  /// es: 'Carácter'
  String get characterTitle => 'Carácter';

  /// es: 'Dónde se usa'
  String get stylesTitle => 'Dónde se usa';

  /// es: 'Nota característica: $degree'
  String characteristicNote({required Object degree}) =>
      'Nota característica: ${degree}';

  /// es: 'Acordes de la escala'
  String get harmonyTitle => 'Acordes de la escala';

  /// es: 'Tríadas'
  String get triads => 'Tríadas';

  /// es: 'Séptimas'
  String get sevenths => 'Séptimas';

  /// es: 'Con $n notas no forma acordes por terceras: úsala sobre un acorde fijo, como un color.'
  String noHarmony({required Object n}) =>
      'Con ${n} notas no forma acordes por terceras: úsala sobre un acorde fijo, como un color.';

  /// es: '5 cajas de dos notas por cuerda'
  String get positionsFive => '5 cajas de dos notas por cuerda';

  /// es: '7 posiciones de tres notas por cuerda'
  String get positionsSeven => '7 posiciones de tres notas por cuerda';

  /// es: '$n cajas de su escala base más las notas de paso'
  String positionsExtras({required Object n}) =>
      '${n} cajas de su escala base más las notas de paso';

  /// es: '$n ventanas de trastes (escala simétrica)'
  String positionsWindow({required Object n}) =>
      '${n} ventanas de trastes (escala simétrica)';

  /// es: 'Sube y baja'
  String get playUpDown => 'Sube y baja';

  /// es: 'Escala para improvisar'
  String get chordScalesTitle => 'Escala para improvisar';

  /// es: 'Sobre $chord suena bien: $scale'
  String chordScaleHint({required Object chord, required Object scale}) =>
      'Sobre ${chord} suena bien: ${scale}';

  /// es: 'También: $scales'
  String chordScaleAlso({required Object scales}) => 'También: ${scales}';

  /// es: 'Ver en el explorador'
  String get openInExplorer => 'Ver en el explorador';
}

// Path: logs
class Translations$logs$es {
  Translations$logs$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Diagnóstico'
  String get title => 'Diagnóstico';

  /// es: 'Vaciar registro'
  String get clear => 'Vaciar registro';

  /// es: 'Total'
  String get total => 'Total';

  /// es: 'Errores'
  String get errors => 'Errores';

  /// es: 'Avisos'
  String get warnings => 'Avisos';

  /// es: 'Todo'
  String get allLevels => 'Todo';

  /// es: 'Sin eventos registrados'
  String get empty => 'Sin eventos registrados';
}

// Path: router
class Translations$router$es {
  Translations$router$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Ruta no encontrada'
  String get notFound => 'Ruta no encontrada';

  /// es: 'Ir al inicio'
  String get goHome => 'Ir al inicio';
}

// Path: mic
class Translations$mic$es {
  Translations$mic$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Necesito tu micrófono'
  String get deniedTitle => 'Necesito tu micrófono';

  /// es: 'Activa el permiso de micrófono en los ajustes del teléfono y vuelve a intentarlo.'
  String get deniedMessage =>
      'Activa el permiso de micrófono en los ajustes del teléfono y vuelve a intentarlo.';

  /// es: 'No pude escuchar'
  String get errorTitle => 'No pude escuchar';

  /// es: 'Algo falló al abrir el micrófono. Comprueba que otra app no lo esté usando.'
  String get errorMessage =>
      'Algo falló al abrir el micrófono. Comprueba que otra app no lo esté usando.';

  /// es: 'Reintentar'
  String get retry => 'Reintentar';

  /// es: 'Nivel del micrófono'
  String get levelLabel => 'Nivel del micrófono';

  /// es: 'Esperando sonido…'
  String get levelWaiting => 'Esperando sonido…';

  /// es: 'Apenas te oigo: acerca la guitarra al micrófono'
  String get levelQuiet => 'Apenas te oigo: acerca la guitarra al micrófono';

  /// es: 'Te escucho bien'
  String get levelGood => 'Te escucho bien';

  /// es: 'Suena muy fuerte: aleja un poco la guitarra'
  String get levelLoud => 'Suena muy fuerte: aleja un poco la guitarra';
}

// Path: tuner
class Translations$tuner$es {
  Translations$tuner$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Toca una cuerda al aire'
  String get pluckPrompt => 'Toca una cuerda al aire';

  /// es: 'Toca la $string'
  String pluckString({required Object string}) => 'Toca la ${string}';

  /// es: '$ordinal cuerda · $note'
  String stringTitle({required Object ordinal, required Object note}) =>
      '${ordinal} cuerda · ${note}';

  /// es: 'Mi'
  String get noteE => 'Mi';

  /// es: 'La'
  String get noteA => 'La';

  /// es: 'Re'
  String get noteD => 'Re';

  /// es: 'Sol'
  String get noteG => 'Sol';

  /// es: 'Si'
  String get noteB => 'Si';

  /// es: '¡Afinada!'
  String get tuned => '¡Afinada!';

  /// es: 'Sube un poco'
  String get upLittle => 'Sube un poco';

  /// es: 'Sube'
  String get up => 'Sube';

  /// es: 'Sube mucho'
  String get upALot => 'Sube mucho';

  /// es: 'Baja un poco'
  String get downLittle => 'Baja un poco';

  /// es: 'Baja'
  String get down => 'Baja';

  /// es: 'Baja mucho'
  String get downALot => 'Baja mucho';

  /// es: 'Aprieta la clavija'
  String get tightenPeg => 'Aprieta la clavija';

  /// es: 'Afloja la clavija'
  String get loosenPeg => 'Afloja la clavija';

  /// es: 'Mantén la nota sonando'
  String get holdSteady => 'Mantén la nota sonando';

  /// es: 'Esa suena como la $heard. Toca la $target.'
  String heardOther({required Object heard, required Object target}) =>
      'Esa suena como la ${heard}. Toca la ${target}.';

  /// es: 'Floja'
  String get flat => 'Floja';

  /// es: 'Alta'
  String get sharp => 'Alta';

  /// es: '$cents cents'
  String cents({required Object cents}) => '${cents} cents';

  /// es: '¡Guitarra afinada!'
  String get allTunedTitle => '¡Guitarra afinada!';

  /// es: 'Las seis cuerdas están en su sitio. ¡A tocar!'
  String get allTunedMessage => 'Las seis cuerdas están en su sitio. ¡A tocar!';

  /// es: 'Clavija de la $string'
  String peg({required Object string}) => 'Clavija de la ${string}';

  /// es: 'Afinación: $cents cents'
  String meterLabel({required Object cents}) => 'Afinación: ${cents} cents';

  /// es: 'Activar micrófono'
  String get activate => 'Activar micrófono';

  /// es: 'Automático · toca una clavija para fijarla'
  String get modeAuto => 'Automático · toca una clavija para fijarla';

  /// es: 'Fijada: $string'
  String modeManual({required Object string}) => 'Fijada: ${string}';

  /// es: 'Detectar acordes'
  String get chordsTitle => 'Detectar acordes';

  /// es: 'Detectar acordes'
  String get switchToChords => 'Detectar acordes';

  /// es: 'Volver al afinador'
  String get switchToTuner => 'Volver al afinador';
}

// Path: practice
class Translations$practice$es {
  Translations$practice$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Practicar acorde'
  String get title => 'Practicar acorde';

  /// es: 'Toca las cuerdas una a una. Las reconozco en el orden que quieras.'
  String get intro =>
      'Toca las cuerdas una a una. Las reconozco en el orden que quieras.';

  /// es: 'Empezar a practicar'
  String get start => 'Empezar a practicar';

  /// es: 'Detener'
  String get stop => 'Detener';

  /// es: 'Otra vez'
  String get restart => 'Otra vez';

  /// es: 'Escuchar acorde'
  String get listenChord => 'Escuchar acorde';

  /// es: 'Escuchar cuerda'
  String get listenString => 'Escuchar cuerda';

  /// es: '$count de $total cuerdas'
  String progress({required Object count, required Object total}) =>
      '${count} de ${total} cuerdas';

  /// es: 'Ahora toca la $string al aire'
  String nextOpen({required Object string}) =>
      'Ahora toca la ${string} al aire';

  /// es: 'Ahora toca la $string: traste $fret con $finger'
  String nextFretted({
    required Object string,
    required Object fret,
    required Object finger,
  }) => 'Ahora toca la ${string}: traste ${fret} con ${finger}';

  /// es: 'Ahora toca la $string: traste $fret'
  String nextFrettedAny({required Object string, required Object fret}) =>
      'Ahora toca la ${string}: traste ${fret}';

  /// es: 'Muda'
  String get muted => 'Muda';

  /// es: 'Al aire'
  String get open => 'Al aire';

  /// es: 'Traste $fret'
  String fret({required Object fret}) => 'Traste ${fret}';

  /// es: 'No toques esta cuerda'
  String get mutedHint => 'No toques esta cuerda';

  /// es: 'Bien'
  String get matched => 'Bien';

  /// es: '¡Acorde limpio!'
  String get doneTitle => '¡Acorde limpio!';

  /// es: 'Todas las cuerdas suenan como deben. Repítelo despacio hasta que salga solo.'
  String get doneMessage =>
      'Todas las cuerdas suenan como deben. Repítelo despacio hasta que salga solo.';

  /// es: 'Reafinar cuerda'
  String get retune => 'Reafinar cuerda';

  /// es: 'Cómo corregirla'
  String get tipsTitle => 'Cómo corregirla';

  /// es: 'el dedo $n'
  String fingerThe({required Object n}) => 'el dedo ${n}';

  /// es: 'el dedo'
  String get fingerAny => 'el dedo';

  /// es: 'La $string suena al aire: pisa el traste $fret con $finger.'
  String tipSoundsOpen({
    required Object string,
    required Object fret,
    required Object finger,
  }) => 'La ${string} suena al aire: pisa el traste ${fret} con ${finger}.';

  /// es: '(one) {Suena más grave. Sube $finger un traste hacia la caja.} (other) {Suena más grave. Sube $finger $n trastes hacia la caja.}'
  String tipMoveUp({required num n, required Object finger}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: 'Suena más grave. Sube ${finger} un traste hacia la caja.',
        other: 'Suena más grave. Sube ${finger} ${n} trastes hacia la caja.',
      );

  /// es: '(one) {Suena más aguda. Baja $finger un traste hacia el clavijero.} (other) {Suena más aguda. Baja $finger $n trastes hacia el clavijero.}'
  String tipMoveDown({required num n, required Object finger}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: 'Suena más aguda. Baja ${finger} un traste hacia el clavijero.',
        other:
            'Suena más aguda. Baja ${finger} ${n} trastes hacia el clavijero.',
      );

  /// es: 'Suena algo baja. Acerca $finger al traste (sin pisarlo) o reafina la cuerda.'
  String tipTooFlat({required Object finger}) =>
      'Suena algo baja. Acerca ${finger} al traste (sin pisarlo) o reafina la cuerda.';

  /// es: 'Suena algo alta. Presiona con menos fuerza, sin estirar la cuerda, o reafínala.'
  String get tipTooSharp =>
      'Suena algo alta. Presiona con menos fuerza, sin estirar la cuerda, o reafínala.';

  /// es: 'La $string al aire suena baja: sube un poco la clavija.'
  String tipRetuneUp({required Object string}) =>
      'La ${string} al aire suena baja: sube un poco la clavija.';

  /// es: 'La $string al aire suena alta: baja un poco la clavija.'
  String tipRetuneDown({required Object string}) =>
      'La ${string} al aire suena alta: baja un poco la clavija.';

  /// es: 'No reconozco esa nota. Toca solo la $string, con calma.'
  String tipUnknown({required Object string}) =>
      'No reconozco esa nota. Toca solo la ${string}, con calma.';
}

// Path: profile
class Translations$profile$es {
  Translations$profile$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Tu perfil'
  String get title => 'Tu perfil';

  /// es: 'Editar perfil'
  String get edit => 'Editar perfil';

  /// es: '$guitar · $level'
  String summary({required Object guitar, required Object level}) =>
      '${guitar} · ${level}';

  /// es: 'Guitarra'
  String get guitar => 'Guitarra';

  /// es: 'Forma de tocar'
  String get play => 'Forma de tocar';

  /// es: 'Géneros'
  String get genres => 'Géneros';

  /// es: 'Experiencia'
  String get experience => 'Experiencia';

  /// es: 'Recomendaciones según tu perfil'
  String get personalizedHint => 'Recomendaciones según tu perfil';

  /// es: 'Cuéntame cómo tocas y personalizo todo'
  String get setupHint => 'Cuéntame cómo tocas y personalizo todo';
}

// Path: minigames
class Translations$minigames$es {
  Translations$minigames$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Jugar'
  String get hubTitle => 'Jugar';

  /// es: 'Entrena el oído, el mástil y tus dedos'
  String get hubSubtitle => 'Entrena el oído, el mástil y tus dedos';

  /// es: '$earned de $total estrellas'
  String starsTotal({required Object earned, required Object total}) =>
      '${earned} de ${total} estrellas';

  /// es: 'Toca el acorde'
  String get chordGameTitle => 'Toca el acorde';

  /// es: 'Encadena una serie de acordes con el micrófono'
  String get chordGameSubtitle =>
      'Encadena una serie de acordes con el micrófono';

  /// es: 'Entrena el oído'
  String get earTitle => 'Entrena el oído';

  /// es: 'Solo escuchas y reconoces: sin guitarra'
  String get earSubtitle => 'Solo escuchas y reconoces: sin guitarra';

  /// es: 'Mástil y dedos'
  String get fretboardTitle => 'Mástil y dedos';

  /// es: 'Aprende dónde está cada nota y cada dedo'
  String get fretboardSubtitle => 'Aprende dónde está cada nota y cada dedo';

  /// es: 'Toca la guitarra'
  String get playTitle => 'Toca la guitarra';

  /// es: 'El micrófono comprueba lo que tocas'
  String get playSubtitle => 'El micrófono comprueba lo que tocas';

  /// es: 'Micrófono'
  String get needsMic => 'Micrófono';

  /// es: 'Sin jugar'
  String get unplayed => 'Sin jugar';

  /// es: 'Dificultad'
  String get levelTitle => 'Dificultad';

  /// es: 'Fácil'
  String get levelEasy => 'Fácil';

  /// es: 'Media'
  String get levelMedium => 'Media';

  /// es: 'Difícil'
  String get levelHard => 'Difícil';

  /// es: 'Mejor: $percent%'
  String levelBest({required Object percent}) => 'Mejor: ${percent}%';

  /// es: 'Cómo se juega'
  String get howToPlay => 'Cómo se juega';

  /// es: 'Mejor con auriculares y en un sitio tranquilo.'
  String get earTip => 'Mejor con auriculares y en un sitio tranquilo.';

  /// es: 'Necesitas tu guitarra afinada y el micrófono.'
  String get micTip => 'Necesitas tu guitarra afinada y el micrófono.';

  /// es: 'Empezar'
  String get start => 'Empezar';

  /// es: 'Pregunta $n de $total'
  String questionOf({required Object n, required Object total}) =>
      'Pregunta ${n} de ${total}';

  /// es: 'Ronda $n de $total'
  String roundOf({required Object n, required Object total}) =>
      'Ronda ${n} de ${total}';

  /// es: 'Escuchar'
  String get listen => 'Escuchar';

  /// es: 'Escuchar otra vez'
  String get listenAgain => 'Escuchar otra vez';

  /// es: 'Escuchando…'
  String get listening => 'Escuchando…';

  /// es: 'Racha'
  String get streak => 'Racha';

  /// es: 'Puntos'
  String get points => 'Puntos';

  /// es: '¡Correcto!'
  String get correct => '¡Correcto!';

  /// es: 'Era: $answer'
  String wrong({required Object answer}) => 'Era: ${answer}';

  /// es: 'La secuencia era: $sequence'
  String wrongSequence({required Object sequence}) =>
      'La secuencia era: ${sequence}';

  /// es: 'Siguiente'
  String get next => 'Siguiente';

  /// es: 'Ver resultado'
  String get seeResult => 'Ver resultado';

  /// es: 'Tu turno: $done de $total'
  String yourTurn({required Object done, required Object total}) =>
      'Tu turno: ${done} de ${total}';

  /// es: 'Sigue practicando'
  String get resultTitle0 => 'Sigue practicando';

  /// es: 'Buen comienzo'
  String get resultTitle1 => 'Buen comienzo';

  /// es: '¡Muy bien!'
  String get resultTitle2 => '¡Muy bien!';

  /// es: '¡Perfecto!'
  String get resultTitle3 => '¡Perfecto!';

  /// es: '$correct de $total aciertos'
  String resultCorrect({required Object correct, required Object total}) =>
      '${correct} de ${total} aciertos';

  /// es: 'Mejor racha: $n'
  String resultStreak({required Object n}) => 'Mejor racha: ${n}';

  /// es: '$n puntos'
  String resultPoints({required Object n}) => '${n} puntos';

  /// es: 'Jugar otra vez'
  String get playAgain => 'Jugar otra vez';

  /// es: 'Más juegos'
  String get moreGames => 'Más juegos';

  /// es: '¡Nuevo récord!'
  String get newBest => '¡Nuevo récord!';

  /// es: 'Ver pista'
  String get buildHint => 'Ver pista';

  /// es: 'Comprobar'
  String get buildCheck => 'Comprobar';

  /// es: 'Borrar todo'
  String get buildClear => 'Borrar todo';

  /// es: 'Ahora tócalo'
  String get buildPlayIt => 'Ahora tócalo';

  /// es: 'Toca una casilla para poner un dedo. Toca las marcas de arriba para dejar la cuerda al aire o silenciada.'
  String get buildTapHint =>
      'Toca una casilla para poner un dedo. Toca las marcas de arriba para dejar la cuerda al aire o silenciada.';

  /// es: 'Revisa las cuerdas marcadas en rojo.'
  String get buildWrong => 'Revisa las cuerdas marcadas en rojo.';

  /// es: '¡Así se hace!'
  String get buildCorrect => '¡Así se hace!';

  /// es: 'Ahora tócalo en tu guitarra y comprueba cómo suena.'
  String get buildCorrectBody =>
      'Ahora tócalo en tu guitarra y comprueba cómo suena.';

  /// es: 'Con pista no suma acierto.'
  String get buildHinted => 'Con pista no suma acierto.';

  /// es: 'Silenciada'
  String get buildMuted => 'Silenciada';

  /// es: 'Al aire'
  String get buildOpen => 'Al aire';

  /// es: 'Cuerda $string, traste $fret'
  String buildCell({required Object string, required Object fret}) =>
      'Cuerda ${string}, traste ${fret}';

  /// es: 'Cuerda $string: $state'
  String buildMark({required Object string, required Object state}) =>
      'Cuerda ${string}: ${state}';

  /// es: 'Toca ahora…'
  String get micListening => 'Toca ahora…';

  /// es: 'Oigo: $note'
  String micHeard({required Object note}) => 'Oigo: ${note}';

  /// es: '$done de $total notas'
  String micProgress({required Object done, required Object total}) =>
      '${done} de ${total} notas';

  /// es: 'Se acabó el tiempo'
  String get micTimeUp => 'Se acabó el tiempo';

  /// es: '¡Bien tocado!'
  String get micSuccess => '¡Bien tocado!';

  /// es: 'Escuchar la nota'
  String get micHearIt => 'Escuchar la nota';

  /// es: 'Escuchar la melodía'
  String get micHearMelody => 'Escuchar la melodía';

  /// es: 'Saltar'
  String get micSkip => 'Saltar';

  /// es: 'Pista: cuerda $string, traste $fret'
  String micHintFret({required Object string, required Object fret}) =>
      'Pista: cuerda ${string}, traste ${fret}';

  /// es: 'Pista: cuerda $string al aire'
  String micHintOpen({required Object string}) =>
      'Pista: cuerda ${string} al aire';

  /// es: '$n s'
  String micSeconds({required Object n}) => '${n} s';

  late final Translations$minigames$prompt$es prompt =
      Translations$minigames$prompt$es.internal(_root);
  Map<String, String> get titles => {
    'guessNote': 'Adivina la nota',
    'whichString': '¿Qué cuerda es?',
    'whichFret': '¿Qué traste es?',
    'interval': 'Intervalos',
    'higherLower': 'Agudo o grave',
    'chordQuality': 'Mayor o menor',
    'nameChord': 'Reconoce el acorde',
    'tuneEar': 'Oído de afinador',
    'memory': 'Memoria de cuerdas',
    'noteAtFret': 'Notas del mástil',
    'fretOfNote': 'Busca la nota',
    'fingerQuiz': '¿Qué dedo?',
    'readDiagram': 'Lee el diagrama',
    'buildChord': 'Arma el acorde',
    'playNote': 'Toca la nota',
    'playStringFret': 'Cuerda y traste',
    'echo': 'Eco de guitarra',
    'scaleNote': 'Notas de la escala',
    'keyChord': 'Acordes del tono',
    'scaleDegree': '¿Qué grado es?',
    'findTonic': 'Encuentra la tónica',
    'progressionEar': 'Progresión al oído',
  };
  Map<String, String> get descriptions => {
    'guessNote': 'Suena una nota: ¿cuál es?',
    'whichString': 'Reconoce la cuerda al aire',
    'whichFret': 'Oye cuántos trastes sube',
    'interval': 'Distancia entre dos notas',
    'higherLower': 'Compara dos notas',
    'chordQuality': 'Distingue mayor, menor y séptima',
    'nameChord': 'Escucha y nombra el acorde',
    'tuneEar': '¿Floja, afinada o alta?',
    'memory': 'Repite la secuencia que oyes',
    'noteAtFret': 'Nombre de la nota en el mástil',
    'fretOfNote': 'Encuentra el traste de la nota',
    'fingerQuiz': 'Qué dedo pisa cada cuerda',
    'readDiagram': 'De la forma al nombre del acorde',
    'buildChord': 'Del nombre a la posición',
    'playNote': 'Toca la nota que se pide',
    'playStringFret': 'Toca una posición exacta',
    'echo': 'Escucha y toca la melodía',
    'scaleNote': 'Reconoce qué nota pertenece a cada escala',
    'keyChord': 'El IV de Sol, el V de La… al instante',
    'scaleDegree': 'Pon número a cada nota de la tonalidad',
    'findTonic': 'Escucha y descubre la nota «casa»',
    'progressionEar': 'Distingue el I-IV-V del I-V-vi-IV',
  };
  Map<String, String> get howTo => {
    'guessNote': 'Oirás una nota suelta de la guitarra. Elige su nombre. En fácil solo hay notas naturales; en difícil, las doce.',
    'whichString': 'Oirás una cuerda al aire. Di cuál es, de la 6ª (la más grave) a la 1ª (la más aguda). En fácil hay solo tres.',
    'whichFret': 'Oirás la cuerda al aire y después pulsada en un traste. Cada traste sube un semitono: cuenta cuántos suben.',
    'interval': 'Oirás dos notas seguidas, de grave a aguda. Reconoce la distancia entre ellas: tercera, quinta, octava…',
    'higherLower': 'Oirás dos notas. Di si la primera o la segunda suena más aguda. En difícil casi no hay diferencia.',
    'chordQuality': 'Oirás un acorde. Distingue si es mayor (brillante), menor (triste), séptima y más según subes de nivel.',
    'nameChord': 'Oirás un acorde del banco. Elige su nombre entre varias opciones parecidas.',
    'tuneEar': 'Oirás una nota de referencia y otra que puede estar floja, afinada o alta. Entrena el oído del afinador.',
    'memory': 'Oirás una secuencia de cuerdas al aire. Tócalas en el mismo orden. Cada pregunta añade más notas.',
    'noteAtFret': 'Se te da una cuerda y un traste. Di qué nota es. Aprenderás el mástil sin mirar la guitarra.',
    'fretOfNote': 'Se te da una cuerda y una nota. Di en qué traste está (0 es la cuerda al aire).',
    'fingerQuiz': 'Verás un acorde con una cuerda marcada y sin números. Di qué dedo la pisa: 1 índice, 2 medio, 3 anular, 4 meñique.',
    'readDiagram':
        'Verás el diagrama de una posición. Reconoce de qué acorde se trata.',
    'buildChord': 'Se te da el nombre de un acorde. Pon los dedos en el mástil y comprueba. Después tócalo en tu guitarra.',
    'playNote': 'Se te pide una nota. Tócala en cualquier cuerda: el micrófono la reconoce. Puedes escuchar la nota antes.',
    'playStringFret': 'Se te pide una cuerda y un traste exactos. Pisa y toca: el micrófono comprueba que suena la nota correcta.',
    'echo': 'Oirás una melodía corta. Tócala en tu guitarra nota a nota, en el mismo orden.',
    'scaleNote': 'Se indica una escala y su tónica. Elige la única nota de las opciones que pertenece a esa escala. Usa la fórmula o imagina la caja en el mástil.',
    'keyChord': 'Se indica una tonalidad y un grado en números romanos. Elige el acorde que ocupa ese grado. Recuerda: en mayor, I IV V son mayores; ii iii vi, menores.',
    'scaleDegree': 'Se indica una tonalidad y una nota. Di qué grado ocupa (I = tónica, IV = subdominante, V = dominante…).',
    'findTonic': 'Suena una cadencia de cuatro acordes que termina en casa. Elige la nota que suena a reposo: la tónica.',
    'progressionEar': 'Suenan cuatro acordes. Elige qué progresión es, escrita en grados. Fíjate en si empieza en mayor o en menor y en cómo vuelve a casa.',
  };
  Map<String, String> get noteNames => {
    'n0': 'Do',
    'n1': 'Do♯',
    'n2': 'Re',
    'n3': 'Re♯',
    'n4': 'Mi',
    'n5': 'Fa',
    'n6': 'Fa♯',
    'n7': 'Sol',
    'n8': 'Sol♯',
    'n9': 'La',
    'n10': 'La♯',
    'n11': 'Si',
  };
  Map<String, String> get intervalNames => {
    'i1': '2ª menor',
    'i2': '2ª mayor',
    'i3': '3ª menor',
    'i4': '3ª mayor',
    'i5': '4ª justa',
    'i6': 'Tritono',
    'i7': '5ª justa',
    'i8': '6ª menor',
    'i9': '6ª mayor',
    'i10': '7ª menor',
    'i11': '7ª mayor',
    'i12': 'Octava',
  };
  late final Translations$minigames$choice$es choice =
      Translations$minigames$choice$es.internal(_root);

  /// es: 'Así se forma. ¡Memorízalo y sigue!'
  String get buildMissed => 'Así se forma. ¡Memorízalo y sigue!';

  /// es: 'Esta vez no suma puntos'
  String get micPracticeNote => 'Esta vez no suma puntos';

  /// es: 'Escucha la melodía…'
  String get micPlayingMelody => 'Escucha la melodía…';

  /// es: 'Teoría musical'
  String get theoryTitle => 'Teoría musical';

  /// es: 'Escalas, tonalidades, grados y progresiones: entiende lo que tocas.'
  String get theorySubtitle =>
      'Escalas, tonalidades, grados y progresiones: entiende lo que tocas.';
}

// Path: guitar
class Translations$guitar$es {
  Translations$guitar$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Toca una cuerda al aire'
  String get ready => 'Toca una cuerda al aire';

  /// es: 'Deja que se apague la nota…'
  String get waiting => 'Deja que se apague la nota…';

  /// es: 'No te oigo: revisa el micrófono o usa los botones'
  String get noMic => 'No te oigo: revisa el micrófono o usa los botones';

  /// es: '$string al aire'
  String openString({required Object string}) => '${string} al aire';

  /// es: 'Continuar'
  String get continueLabel => 'Continuar';

  /// es: 'Reintentar'
  String get retry => 'Reintentar';

  /// es: 'Salir'
  String get leave => 'Salir';

  /// es: 'Abrir'
  String get open => 'Abrir';

  /// es: 'Anterior'
  String get previousGame => 'Anterior';

  /// es: 'Siguiente'
  String get nextGame => 'Siguiente';

  /// es: 'Prepara el acorde'
  String get getReady => 'Prepara el acorde';

  /// es: 'Empiezo en $n'
  String startsIn({required Object n}) => 'Empiezo en ${n}';

  /// es: '¡Ya!'
  String get imReady => '¡Ya!';

  /// es: 'Controlar con la guitarra'
  String get setting => 'Controlar con la guitarra';

  /// es: 'Toca una cuerda al aire para continuar, reintentar o salir sin tocar el móvil'
  String get settingSubtitle =>
      'Toca una cuerda al aire para continuar, reintentar o salir sin tocar el móvil';

  /// es: 'Navegar con la guitarra'
  String get hubTitle => 'Navegar con la guitarra';

  /// es: 'Toda la app con la guitarra: una nota aguda abre el menú'
  String get hubSubtitle =>
      'Toda la app con la guitarra: una nota aguda abre el menú';

  /// es: '$name · $n de $total'
  String hubSelected({
    required Object name,
    required Object n,
    required Object total,
  }) => '${name} · ${n} de ${total}';

  /// es: 'Menú'
  String get navMenu => 'Menú';

  /// es: 'Menú de la guitarra'
  String get navTitle => 'Menú de la guitarra';

  /// es: 'Nota aguda (traste 14 o más de la 1ª cuerda): menú'
  String get navWake => 'Nota aguda (traste 14 o más de la 1ª cuerda): menú';

  /// es: 'En cualquier cuerda: Mi al aire y un traste más por destino'
  String get navHint =>
      'En cualquier cuerda: Mi al aire y un traste más por destino';

  /// es: 'Atrás'
  String get navBack => 'Atrás';

  /// es: 'Cerrar'
  String get navClose => 'Cerrar';

  /// es: 'Apagar'
  String get navOff => 'Apagar';

  /// es: 'Perfil'
  String get navProfile => 'Perfil';

  /// es: 'Nota aguda'
  String get navWakeShort => 'Nota aguda';

  /// es: 'al aire'
  String get navFretOpen => 'al aire';

  /// es: 'traste $n'
  String navFret({required Object n}) => 'traste ${n}';

  /// es: 'Modo guitarra en toda la app'
  String get navSetting => 'Modo guitarra en toda la app';

  /// es: 'Un panel fijo sustituye la barra de navegación: una nota aguda abre el menú y cada nota te lleva a una pantalla'
  String get navSettingSubtitle =>
      'Un panel fijo sustituye la barra de navegación: una nota aguda abre el menú y cada nota te lleva a una pantalla';
}

// Path: theory
class Translations$theory$es {
  Translations$theory$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Escuela de guitarra'
  String get title => 'Escuela de guitarra';

  /// es: 'Entiende lo que tocas: tónica, escalas, posiciones y armonía.'
  String get subtitle =>
      'Entiende lo que tocas: tónica, escalas, posiciones y armonía.';

  /// es: 'Fundamentos'
  String get unitBasics => 'Fundamentos';

  /// es: 'Escalas y posiciones'
  String get unitScales => 'Escalas y posiciones';

  /// es: 'Armonía y progresiones'
  String get unitHarmony => 'Armonía y progresiones';

  /// es: 'Ideas clave'
  String get keyPoints => 'Ideas clave';

  /// es: 'Pruébalo en el mástil'
  String get tryIt => 'Pruébalo en el mástil';

  /// es: 'Abrir en el explorador'
  String get openExplorer => 'Abrir en el explorador';

  /// es: 'Practica: $game'
  String practiceGame({required Object game}) => 'Practica: ${game}';

  /// es: 'Tócalo en el jam: $name'
  String practiceJam({required Object name}) => 'Tócalo en el jam: ${name}';

  /// es: 'Marcar como aprendida'
  String get markLearned => 'Marcar como aprendida';

  /// es: 'Aprendida'
  String get learned => 'Aprendida';

  /// es: '$done de $total lecciones aprendidas'
  String lessonsDone({required Object done, required Object total}) =>
      '${done} de ${total} lecciones aprendidas';

  /// es: 'Acordes de $key'
  String harmonyTitle({required Object key}) => 'Acordes de ${key}';

  /// es: '$note $scale'
  String scaleIn({required Object note, required Object scale}) =>
      '${note} ${scale}';

  /// es: '$note $mode'
  String keyName({required Object note, required Object mode}) =>
      '${note} ${mode}';

  /// es: 'mayor'
  String get majorMode => 'mayor';

  /// es: 'menor'
  String get minorMode => 'menor';

  /// es: 'Explorador de escalas'
  String get explorerTitle => 'Explorador de escalas';

  /// es: 'Tónica'
  String get explorerTonic => 'Tónica';

  /// es: 'Escala'
  String get explorerScale => 'Escala';

  /// es: 'Posición'
  String get explorerPosition => 'Posición';

  /// es: 'Todo el mástil'
  String get allPositions => 'Todo el mástil';

  /// es: 'Posición $n'
  String positionN({required Object n}) => 'Posición ${n}';

  /// es: 'Grados'
  String get showDegrees => 'Grados';

  /// es: 'Notas'
  String get showNotes => 'Notas';

  /// es: 'Escuchar'
  String get playScale => 'Escuchar';

  /// es: 'Parar'
  String get stopScale => 'Parar';

  /// es: 'Toca una nota del mástil para oírla. Las tónicas van en color principal y la nota característica, resaltada.'
  String get explorerHint =>
      'Toca una nota del mástil para oírla. Las tónicas van en color principal y la nota característica, resaltada.';

  /// es: 'Fórmula: $formula'
  String formula({required Object formula}) => 'Fórmula: ${formula}';

  /// es: 'Notas: $notes'
  String notesOf({required Object notes}) => 'Notas: ${notes}';

  /// es: 'Mástil con $scale'
  String fretboardLabel({required Object scale}) => 'Mástil con ${scale}';

  /// es: 'Géneros'
  String get genresTitle => 'Géneros';

  /// es: 'Cómo suena cada estilo: tempo, rasgueo, escalas, acordes y progresiones.'
  String get genresSubtitle =>
      'Cómo suena cada estilo: tempo, rasgueo, escalas, acordes y progresiones.';

  /// es: '$min–$max BPM'
  String tempoRange({required Object min, required Object max}) =>
      '${min}–${max} BPM';

  /// es: 'Ritmo'
  String get genreRhythmTitle => 'Ritmo';

  /// es: 'Consejo'
  String get genreTipTitle => 'Consejo';

  /// es: 'Escalas para solear'
  String get genreScales => 'Escalas para solear';

  /// es: 'Acordes típicos'
  String get genreChords => 'Acordes típicos';

  /// es: 'Progresiones para jammear'
  String get genreProgressions => 'Progresiones para jammear';

  /// es: 'Canciones'
  String get genreSongs => 'Canciones';

  /// es: 'Ver acordes de $genre en la biblioteca'
  String genreLibrary({required Object genre}) =>
      'Ver acordes de ${genre} en la biblioteca';

  /// es: 'Rasgueo: $name'
  String strumLabel({required Object name}) => 'Rasgueo: ${name}';

  Map<String, String> get scaleNames => {
    'major': 'mayor',
    'minor': 'menor natural',
    'harmonicMinor': 'menor armónica',
    'minorPentatonic': 'pentatónica menor',
    'majorPentatonic': 'pentatónica mayor',
    'blues': 'escala de blues',
    'dorian': 'dórica',
    'phrygian': 'frigia',
    'lydian': 'lidia',
    'mixolydian': 'mixolidia',
  };
  Map<String, String> get scaleAbout => {
    'major': 'La base de la armonía: alegre y estable. Pop, folk y canciones infantiles.',
    'minor':
        'La relativa de la mayor: melancólica y épica. Baladas, rock y metal.',
    'harmonicMinor':
        'Menor con la séptima elevada: sabor clásico, flamenco y neoclásico.',
    'minorPentatonic':
        'Cinco notas que nunca fallan: el corazón del rock y el blues.',
    'majorPentatonic': 'Dulce y abierta: country, pop, soul y solos melódicos.',
    'blues': 'Pentatónica menor con la blue note (b5): pura actitud.',
    'dorian': 'Menor con sexta mayor: funk, jazz, Santana y Pink Floyd.',
    'phrygian': 'Menor con segunda menor: flamenco y metal oscuro.',
    'lydian': 'Mayor con cuarta aumentada: soñadora, de banda sonora.',
    'mixolydian': 'Mayor con séptima menor: rock clásico, blues y country.',
  };
  Map<String, String> get degreeNames => {
    'd1': 'tónica',
    'd2': 'supertónica',
    'd3': 'mediante',
    'd4': 'subdominante',
    'd5': 'dominante',
    'd6': 'superdominante',
    'd7': 'sensible',
  };
  Map<String, String> get strumNames => {
    'whole': 'Un golpe por compás',
    'quarters': 'Negras',
    'pop': 'Pop',
    'eighths': 'Corcheas',
    'boomChick': 'Bajo y rasgueo',
    'skank': 'Contratiempo (reggae)',
    'bossa': 'Bossa nova',
    'shuffle': 'Shuffle',
    'waltz': 'Vals 3/4',
  };
  Map<String, String> get genreNames => {
    'pop': 'Pop',
    'rock': 'Rock',
    'blues': 'Blues',
    'country': 'Country',
    'jazz': 'Jazz',
    'funk': 'Funk',
    'ballad': 'Balada',
    'latin': 'Latino',
    'reggae': 'Reggae',
    'bossa': 'Bossa nova',
    'metal': 'Metal',
    'punk': 'Punk',
    'soul': 'Soul y R&B',
    'gospel': 'Gospel',
    'folk': 'Folk y tradicional',
  };
  Map<String, String> get genreAbout => {
    'pop': 'Canciones pegadizas sobre pocas progresiones (I-V-vi-IV). La guitarra acompaña con acordes abiertos y un rasgueo constante.',
    'rock': 'Power chords, corcheas con energía y riffs con la pentatónica menor. El I-IV-V y el bVII mandan.',
    'blues': 'Doce compases, acordes de séptima y la escala de blues. El feeling importa más que la velocidad.',
    'country': 'Acordes abiertos, bajo alternado y melodías con la pentatónica mayor. Historias sencillas y mucho swing en la mano derecha.',
    'jazz': 'Cuatriadas (maj7, m7, 7), el ii-V-I y cambios constantes de tonalidad. Se toca ligero y con swing.',
    'funk': 'Acordes de novena y m7 tocados cortos y percusivos. La guitarra es parte de la batería.',
    'ballad': 'Tempos lentos y acordes que se dejan sonar. Arpegios o un golpe por pulso.',
    'latin': 'Desde la ranchera en 3/4 hasta la cadencia andaluza y el bolero. Mucha menor armónica.',
    'reggae': 'El acorde suena solo en los contratiempos, corto y seco. El bajo y la batería llevan el pulso.',
    'bossa': 'Cuatriadas suaves, bajo con el pulgar y acordes sincopados con los dedos.',
    'metal': 'Power chords con palm mute, tempos rápidos y escalas menores, frigias y armónicas.',
    'punk': 'Tres o cuatro power chords, corcheas hacia abajo y mucha velocidad. Actitud ante todo.',
    'soul': 'Acordes de color (maj7, m7, 9), groove relajado y adornos con la pentatónica mayor.',
    'gospel': 'Armonía de iglesia: I-IV-V con séptimas, el iv menor y cadencias plagales («amén»).',
    'folk': 'Canciones de siempre con tres o cuatro acordes abiertos. Ideal para cantar.',
  };
  Map<String, String> get genreRhythm => {
    'pop': '↓ ↓↑ ↑↓↑ en 4/4. Acentúa el 2 y el 4.',
    'rock': 'Corcheas abajo o abajo-arriba, con palm mute en las estrofas.',
    'blues': 'Shuffle: cada pulso en largo-corto (ta-ka ta-ka).',
    'country': 'Boom-chick: bajo en el 1 y el 3, rasgueo en el 2 y el 4, alternando la cuerda del bajo.',
    'jazz':
        'Cuatro golpes cortos por compás (estilo Freddie Green), con swing.',
    'funk': 'Semicorcheas con la mano siempre en marcha; casi todo apagado y unos pocos golpes abiertos.',
    'ballad': 'Un golpe por compás o arpegio lento de la 6ª a la 1ª cuerda.',
    'latin': 'Ranchera: bajo-acorde-acorde (3/4). Rumba: rasgueo con acento en el contratiempo.',
    'reggae': 'Silencio en el 1, golpe seco en el 2 y el 4 (skank).',
    'bossa': 'Pulgar en el bajo en cada pulso y acorde sincopado entre medias.',
    'metal':
        'Corcheas o galope (una corchea y dos semicorcheas) con palm mute.',
    'punk': 'Corcheas todo hacia abajo, rápido y constante.',
    'soul': 'Golpes suaves en el 2 y el 4 y adornos entre acordes.',
    'gospel': 'Negras firmes con acentos en el 2 y el 4; llamada y respuesta.',
    'folk': 'Negras o el patrón pop; en 3/4, bajo y dos golpes.',
  };
  Map<String, String> get genreTip => {
    'pop':
        'Aprende el I-V-vi-IV en Sol, Do y Re: tocarás cientos de canciones.',
    'rock': 'Apaga las cuerdas con la mano derecha (palm mute) en las estrofas y ábrelas en el estribillo.',
    'blues': 'Haz un bend de la 4ª a la 5ª de la escala y termina las frases en la tónica.',
    'country': 'Alterna el bajo entre la raíz y la quinta del acorde para el típico boom-chick.',
    'jazz': 'Aprende las formas de m7, 7 y maj7 con raíz en la 6ª y la 5ª cuerda: cubren el 90 %.',
    'funk': 'Rasguea muy cerca del puente y relaja la mano izquierda para apagar entre golpes.',
    'ballad':
        'Deja sonar los acordes y cambia justo antes del pulso 1, no tarde.',
    'latin': 'En la cadencia andaluza, usa la menor armónica sobre el acorde V (Mi mayor en La menor).',
    'reggae':
        'Toca el skank en las tres cuerdas agudas y apágalo justo después.',
    'bossa': 'Practica el bajo con el pulgar solo antes de añadir los acordes.',
    'metal':
        'Afina el palm mute: la mano en el puente, ni muy encima ni muy fuera.',
    'punk': 'Mantén la muñeca suelta: la velocidad sale de la relajación.',
    'soul': 'Toca el acorde solo en las tres o cuatro cuerdas agudas para un sonido limpio.',
    'gospel':
        'Prueba el IV → iv → I: el cambio de mayor a menor es pura emoción.',
    'folk': 'Canta mientras tocas: la mano derecha debe ir en automático.',
  };
  Map<String, String> get progressionNames => {
    'popAxis': 'El eje del pop',
    'dooWop': 'Doo-wop de los 50',
    'rockClassic': 'Rock clásico I-IV-V',
    'rockMixo': 'Rock con bVII',
    'blues12': 'Blues de 12 compases',
    'bluesMinor': 'Blues menor',
    'countryRoad': 'Camino country',
    'countryTwoStep': 'Two-step',
    'jazz251': 'ii-V-I de jazz',
    'jazzTurnaround': 'Turnaround',
    'funkDorian': 'Vamp dórico',
    'balladSad': 'Balada sentimental',
    'canon': 'Canon de Pachelbel',
    'andalusian': 'Cadencia andaluza',
    'ranchera': 'Ranchera tónica-dominante',
    'reggaeSkank': 'Skank de reggae',
    'bossaCycle': 'Ciclo de bossa',
    'metalMinor': 'Metal en menor',
    'metalPhrygian': 'Metal frigio',
    'punkPower': 'Punk a toda velocidad',
    'soulGroove': 'Groove soul',
    'gospelPlagal': 'Gospel con iv menor',
    'folkThree': 'Tres acordes folk',
  };
  Map<String, String> get lessonTitles => {
    'notes': 'Las notas y el mástil',
    'intervals': 'Intervalos: la distancia entre notas',
    'tonic': 'La tónica y la tonalidad',
    'rhythm': 'Ritmo, compás y rasgueo',
    'majorScale': 'La escala mayor',
    'minorScales': 'Escalas menores',
    'pentatonic': 'Pentatónicas: la escala del solista',
    'positions': 'Las posiciones (cajas) de la escala',
    'blues': 'El blues y la blue note',
    'modes': 'Los modos griegos',
    'harmony': 'Armonía: los acordes de una tonalidad',
    'degrees': 'Grados y funciones',
    'progressions': 'Progresiones famosas',
    'caged': 'Sistema CAGED',
  };
  Map<String, String> get lessonSummaries => {
    'notes': 'Las 12 notas, sostenidos y bemoles, y cómo encontrarlas en la guitarra.',
    'intervals':
        'Semitonos, terceras, quintas y octavas: el ADN de escalas y acordes.',
    'tonic': 'La nota «casa» de una canción y cómo descubrir en qué tono está.',
    'rhythm': 'Pulso, 4/4 y 3/4, corcheas y los patrones de cada género.',
    'majorScale': 'La fórmula T-T-S-T-T-T-S, la madre de la armonía.',
    'minorScales': 'Menor natural, menor armónica y la relativa menor.',
    'pentatonic': 'Cinco notas que nunca suenan mal: el atajo para improvisar.',
    'positions':
        'Teoría de posición: cómo dividir el mástil en cajas que encajan.',
    'blues': 'La escala de blues, el shuffle y la forma de 12 compases.',
    'modes':
        'Siete colores de la misma escala: dórico, frigio, lidio, mixolidio…',
    'harmony': 'Cada nota de la escala da un acorde: el campo armónico.',
    'degrees':
        'Tónica, subdominante y dominante: reposo, movimiento y tensión.',
    'progressions':
        'Las combinaciones de acordes que suenan en miles de canciones.',
    'caged': 'Cinco formas de acorde abierto que recorren todo el mástil.',
  };
  Map<String, String> get lessonBodies => {
    'notes': 'La música occidental usa solo 12 notas que se repiten en octavas: Do, Do♯, Re, Re♯, Mi, Fa, Fa♯, Sol, Sol♯, La, La♯ y Si. En inglés se escriben con letras: C D E F G A B.\n\nEntre dos notas seguidas hay un semitono, y en la guitarra un semitono es exactamente un traste; dos trastes son un tono. Entre Mi y Fa, y entre Si y Do, no hay sostenido: están a un semitono.\n\nUn sostenido (♯) sube un semitono y un bemol (♭) lo baja, así que Do♯ y Re♭ son la misma nota con dos nombres. En el traste 12 cada cuerda repite su nota al aire una octava más aguda: ahí el mástil vuelve a empezar.',
    'intervals': 'Un intervalo es la distancia entre dos notas, medida en semitonos (trastes). Cada distancia tiene su color: la tercera mayor (4 semitonos) suena alegre, la tercera menor (3) triste y la quinta justa (7) sólida y abierta.\n\nLos acordes se construyen apilando intervalos sobre la raíz: un acorde mayor es raíz + tercera mayor + quinta; uno menor solo cambia la tercera. Por eso mover una sola nota un traste convierte Do en Do menor.\n\nEn la guitarra cada intervalo tiene una forma: la quinta está en la cuerda siguiente (más aguda), dos trastes más arriba, y la octava dos cuerdas más allá y dos trastes arriba. Al cruzar la 2ª cuerda (Si) la forma se desplaza un traste.',
    'tonic': 'La tónica es la nota alrededor de la cual gira una canción: la casa a la que todo quiere volver. Cuando la melodía o el acorde llegan a la tónica sentimos reposo; al alejarse, tensión.\n\nLa tonalidad es la tónica más su escala. «Sol mayor» significa que Sol es la casa y que se usan las notas de la escala mayor de Sol. Casi todas las canciones terminan, y muchas empiezan, en el acorde de la tónica.\n\nPara descubrir el tono de una canción busca el acorde que suena a final, comprueba que el resto de acordes pertenecen a esa tonalidad y canta la nota que «cierra» la melodía. Con práctica lo oirás al instante: juega a «Encuentra la tónica».',
    'rhythm': 'El pulso es el latido constante de la música. El compás agrupa pulsos: 4/4 (cuatro por compás) es el del pop, el rock y casi todo; 3/4 es el del vals, la ranchera y muchas canciones tradicionales.\n\nCada pulso se divide en dos corcheas: abajo en el pulso («1») y arriba en el contratiempo («y»). La mano derecha se mueve siempre abajo-arriba como un péndulo, aunque no toque las cuerdas en cada viaje: así el ritmo nunca se rompe.\n\nCada género tiene su patrón: pop (↓ ↓↑ ↑↓↑), rock (corcheas), country (bajo y rasgueo), reggae (solo contratiempos) o blues (shuffle). El modo jam te muestra el patrón golpe a golpe mientras tocas.',
    'majorScale': 'La escala mayor tiene siete notas y sigue siempre la misma fórmula de tonos (T) y semitonos (S): T T S T T T S. Desde Do salen Do Re Mi Fa Sol La Si, todas naturales.\n\nCon la fórmula puedes construirla desde cualquier nota. Desde Sol: Sol La Si Do Re Mi Fa♯; el Fa♯ aparece para respetar el último tono antes del semitono final.\n\nEn una sola cuerda la escala mayor se toca contando trastes: 2, 2, 1, 2, 2, 2, 1. Pruébalo en la 5ª cuerda desde el traste 3 (Do) y escucha el famoso do-re-mi. En el explorador verás sus siete posiciones de tres notas por cuerda.',
    'minorScales': 'La escala menor natural cambia la fórmula: T S T T S T T. La menor de La usa las mismas notas que Do mayor (La Si Do Re Mi Fa Sol), pero al empezar en La todo suena más oscuro: es la relativa menor de Do.\n\nToda tonalidad mayor tiene una relativa menor tres semitonos por debajo (Sol mayor ↔ Mi menor). Comparten notas y acordes; lo que cambia es la casa.\n\nLa menor armónica sube la séptima nota un semitono (Sol♯ en La menor). Esa nota convierte el acorde del quinto grado en mayor (Mi mayor en La menor), que empuja con fuerza hacia la tónica: es el sonido del flamenco, la música clásica y muchos boleros.',
    'pentatonic': 'La pentatónica es una escala de cinco notas: quita a la escala mayor o menor las dos notas que crean más tensión. Por eso casi cualquier nota que toques sobre los acordes de la canción sonará bien.\n\nLa pentatónica menor (1 b3 4 5 b7) es la base del rock y del blues: La Do Re Mi Sol en La menor. La pentatónica mayor (1 2 3 5 6) suena dulce y abierta, típica del country y el pop: Do Re Mi Sol La en Do.\n\nTruco clave: la pentatónica menor de La y la mayor de Do tienen las mismas notas. La misma forma, con otra tónica, te da los dos sonidos. Para sonar mayor apóyate en la tónica mayor; para sonar a blues, en la menor.',
    'positions': 'Una posición o caja es el grupo de notas de la escala que alcanzas sin mover la mano: cuatro o cinco trastes, un dedo por traste. La pentatónica tiene cinco cajas y las escalas de siete notas, siete posiciones de tres notas por cuerda.\n\nLas cajas encajan como piezas de un puzle: el borde derecho de una es el izquierdo de la siguiente, y tras la última vuelve la primera doce trastes más arriba. Conocerlas todas te permite tocar la escala en todo el mástil.\n\nLa posición 1 de la pentatónica menor empieza con la tónica en la 6ª cuerda bajo el índice. Apréndela primero, después la 2, y conéctalas deslizando un dedo. Para cambiar de tonalidad no hay que aprender nada nuevo: mueve la caja entera hasta la nueva tónica.',
    'blues': 'La escala de blues es la pentatónica menor con una nota más: la quinta disminuida (b5), la famosa blue note. En La: La Do Re Re♯ Mi Sol. Úsala de paso, camino de la quinta; no te quedes en ella.\n\nEl blues clásico dura 12 compases con tres acordes de séptima: cuatro de I7, dos de IV7, dos de I7, luego V7, IV7, I7 y V7 para volver a empezar (el «turnaround»).\n\nEl ritmo es el shuffle: cada pulso se divide en un golpe largo y uno corto (ta-ka, ta-ka). Prueba el jam «Blues de 12 compases» y toca la escala de blues encima.',
    'modes': 'Si tocas las notas de Do mayor empezando en otra nota obtienes un modo: desde Re el dórico, desde Mi el frigio, desde Fa el lidio, desde Sol el mixolidio, desde La el eólico (menor natural) y desde Si el locrio.\n\nCada modo tiene una nota característica. El dórico es menor con sexta mayor (funk, Santana). El frigio, menor con segunda menor (flamenco, metal). El lidio, mayor con cuarta aumentada (soñador, bandas sonoras). El mixolidio, mayor con séptima menor (rock, blues, country).\n\nPara oírlos, toca el modo sobre un acorde fijo de su tónica: así la nota característica destaca. El explorador la marca con otro color.',
    'harmony': 'Si construyes un acorde sobre cada nota de la escala mayor usando solo notas de la escala obtienes siete acordes: I mayor, ii menor, iii menor, IV mayor, V mayor, vi menor y vii disminuido. En Do: C Dm Em F G Am B°.\n\nEsa lista es el campo armónico y explica por qué ciertos acordes suenan bien juntos: pertenecen a la misma tonalidad. Los números romanos permiten escribir progresiones sin depender del tono: «I-V-vi-IV» es igual en Do (C G Am F) que en Sol (G D Em C).\n\nCon cuatro notas aparecen los acordes de jazz: Imaj7, ii7, iii7, IVmaj7, V7, vi7 y viiø. El V7 es el único dominante: el que pide volver a la tónica.',
    'degrees': 'Cada grado de la escala cumple una función. La tónica (I) es el reposo. La subdominante (IV) se aleja suavemente. La dominante (V) crea tensión y quiere resolver en la tónica.\n\nLos demás grados sustituyen a estos tres: el vi y el iii comparten notas con el I (función de tónica) y el ii se parece al IV (subdominante). Por eso «I-vi-IV-V» y «I-IV-V» cuentan la misma historia: casa, viaje, tensión y regreso.\n\nCuando entiendes las funciones puedes adivinar el siguiente acorde de una canción, sacar temas de oído y componer tus propias progresiones.',
    'progressions': 'Una progresión es una secuencia de acordes que se repite. Unas pocas sostienen gran parte de la música popular: I-V-vi-IV (pop), I-IV-V (rock, country, folk, ranchera), ii-V-I (jazz), vi-IV-I-V (baladas) y la cadencia andaluza i-bVII-bVI-V (flamenco y rock latino).\n\nComo están escritas en grados puedes tocarlas en cualquier tono: elige uno cómodo para cantar. Aprende cada progresión en dos o tres tonos y empezarás a reconocerlas en todo lo que escuches.\n\nEn el jam guiado tienes todas estas progresiones con acompañamiento, metrónomo, el patrón de rasgueo y la escala recomendada para improvisar.',
    'caged': 'Las cinco formas de acorde abierto mayor —Do, La, Sol, Mi y Re (C-A-G-E-D)— se pueden mover por el mástil con cejilla. Encadenadas en ese orden cubren los doce trastes con el mismo acorde.\n\nPor ejemplo, Do mayor se toca en forma de Do (abierto), de La (cejilla en el traste 3), de Sol (traste 5), de Mi (traste 8) y de Re (traste 10). Cada forma comparte notas con la siguiente.\n\nCada forma CAGED coincide con una caja de la pentatónica mayor. Así se unen acordes y escalas: siempre sabes qué notas de solo tienes alrededor del acorde que estás tocando.',
  };
  Map<String, String> get lessonPoints => {
    'notes': '12 notas: 7 naturales y 5 alteradas\n1 traste = 1 semitono; 2 trastes = 1 tono\nMi–Fa y Si–Do están a un semitono\nTraste 12 = la misma nota una octava arriba\nAprende primero las notas de la 6ª y la 5ª cuerda: son las raíces de las cejillas',
    'intervals': 'Tercera menor = 3 semitonos (triste)\nTercera mayor = 4 semitonos (alegre)\nQuinta justa = 7 semitonos (power chord)\nOctava = 12 semitonos: la misma nota más aguda\nLa cuerda Si desplaza las formas un traste',
    'tonic': 'Tónica = reposo; alejarse = tensión\nTonalidad = tónica + escala\nEl último acorde suele ser la tónica\nCada tonalidad mayor tiene una relativa menor con las mismas notas\nTransportar = mover todo el mismo número de trastes',
    'rhythm': '4/4: cuenta 1 y 2 y 3 y 4 y\n3/4: cuenta 1 y 2 y 3 y\nLa mano nunca para: abajo en el pulso, arriba en el «y»\nEmpieza lento con metrónomo y sube el tempo poco a poco\nCambia de acorde en el último golpe del compás',
    'majorScale': 'Fórmula: T T S T T T S (2-2-1-2-2-2-1 trastes)\nSiete notas, una de cada letra\nSus grados se numeran del 1 al 7\nDe ella salen los acordes de la tonalidad\nTiene 7 posiciones de 3 notas por cuerda',
    'minorScales': 'Menor natural: T S T T S T T\nRelativa menor = 3 semitonos por debajo de la mayor\nComparten notas, cambia la tónica\nMenor armónica: séptima elevada\nEl V mayor en menor da la cadencia flamenca',
    'pentatonic': 'Menor: 1 b3 4 5 b7\nMayor: 1 2 3 5 6\nDos notas por cuerda en cada caja\nPentatónica menor de La = mayor de Do (mismas notas)\nTermina tus frases en la tónica para sonar resuelto',
    'positions': 'Una caja = 4-5 trastes, un dedo por traste\nPentatónica: 5 cajas; escalas de 7 notas: 7 posiciones\nLas cajas se solapan y se repiten cada 12 trastes\nLocaliza siempre las tónicas dentro de la caja\nMover la caja entera = cambiar de tonalidad',
    'blues': 'Blues = pentatónica menor + b5\n12 compases: I7 – IV7 – I7 – V7 – IV7 – I7\nTodos los acordes son de séptima\nShuffle: largo-corto en cada pulso\nBends y vibrato dan el carácter',
    'modes': 'Jónico = mayor · Eólico = menor natural\nDórico: menor con 6ª mayor\nFrigio: menor con b2\nLidio: mayor con #4\nMixolidio: mayor con b7',
    'harmony': 'Mayúsculas = mayor · minúsculas = menor\nEn mayor: I ii iii IV V vi vii°\nEn menor: i ii° III iv v VI VII\nNúmeros romanos = progresiones en cualquier tono\nEl V7 empuja hacia el I',
    'degrees': 'I tónica: reposo\nIV subdominante: movimiento\nV dominante: tensión que vuelve al I\nvi y iii hacen de tónica; ii, de subdominante\nV → I es la cadencia más fuerte',
    'progressions': 'Pop: I – V – vi – IV\nRock y country: I – IV – V\nJazz: ii – V – I\nBalada: vi – IV – I – V\nAndaluza: i – bVII – bVI – V',
    'caged': 'Orden: C → A → G → E → D → C…\nCada forma es un acorde abierto movible\nCubren todo el mástil sin huecos\nCada forma se apoya en una caja de pentatónica\nLa raíz siempre está dentro de la forma',
  };
}

// Path: studio
class Translations$studio$es {
  Translations$studio$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Explora la guitarra'
  String get sectionTitle => 'Explora la guitarra';

  /// es: 'Teoría'
  String get theoryCard => 'Teoría';

  /// es: 'Tónica, escalas, pentatónicas y armonía'
  String get theoryCardBody => 'Tónica, escalas, pentatónicas y armonía';

  /// es: 'Escalas'
  String get scalesCard => 'Escalas';

  /// es: 'Mástil interactivo con posiciones'
  String get scalesCardBody => 'Mástil interactivo con posiciones';

  /// es: 'Géneros'
  String get genresCard => 'Géneros';

  /// es: 'Ritmos y acordes de cada estilo'
  String get genresCardBody => 'Ritmos y acordes de cada estilo';

  /// es: 'Jam guiado'
  String get jamCard => 'Jam guiado';

  /// es: 'Toca con acompañamiento y puntuación'
  String get jamCardBody => 'Toca con acompañamiento y puntuación';

  /// es: 'Canciones'
  String get songsCard => 'Canciones';

  /// es: 'Acordes y letra para tocar'
  String get songsCardBody => 'Acordes y letra para tocar';

  /// es: 'Historial'
  String get historyCard => 'Historial';

  /// es: 'Tus acordes recientes'
  String get historyCardBody => 'Tus acordes recientes';

  /// es: '(one) {$n día seguido tocando} (other) {$n días seguidos tocando}'
  String streakDays({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: '${n} día seguido tocando',
        other: '${n} días seguidos tocando',
      );

  /// es: 'Toca hoy para empezar tu racha'
  String get streakZero => 'Toca hoy para empezar tu racha';

  /// es: '¡Hoy ya practicaste!'
  String get streakToday => '¡Hoy ya practicaste!';

  /// es: 'Acordes recientes'
  String get recentTitle => 'Acordes recientes';

  /// es: 'Ver todo'
  String get seeAll => 'Ver todo';

  /// es: 'Borrar historial'
  String get clearHistory => 'Borrar historial';

  /// es: 'Historial de acordes'
  String get historyTitle => 'Historial de acordes';

  /// es: 'Aún no hay historial'
  String get historyEmptyTitle => 'Aún no hay historial';

  /// es: 'Los acordes que abras aparecerán aquí para repasarlos rápido.'
  String get historyEmptyBody =>
      'Los acordes que abras aparecerán aquí para repasarlos rápido.';

  /// es: 'Del más reciente al más antiguo'
  String get historyHint => 'Del más reciente al más antiguo';
}

// Path: jam
class Translations$jam$es {
  Translations$jam$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Jam guiado'
  String get title => 'Jam guiado';

  /// es: 'Elige qué tocar, ajusta el tono y el tempo y toca junto a la app.'
  String get subtitle =>
      'Elige qué tocar, ajusta el tono y el tempo y toca junto a la app.';

  /// es: 'Progresiones'
  String get progressionsTab => 'Progresiones';

  /// es: 'Canciones'
  String get songsTab => 'Canciones';

  /// es: 'La tuya'
  String get customTab => 'La tuya';

  /// es: 'Tonalidad'
  String get key => 'Tonalidad';

  /// es: 'Tempo'
  String get tempo => 'Tempo';

  /// es: '$n BPM'
  String bpm({required Object n}) => '${n} BPM';

  /// es: 'Vueltas: $n'
  String loops({required Object n}) => 'Vueltas: ${n}';

  /// es: 'Acompañar'
  String get modeBacking => 'Acompañar';

  /// es: 'La app toca los acordes con el rasgueo del estilo.'
  String get modeBackingBody =>
      'La app toca los acordes con el rasgueo del estilo.';

  /// es: 'Puntuar'
  String get modeScore => 'Puntuar';

  /// es: 'Tocas tú y el micrófono puntúa cada compás (la app no suena).'
  String get modeScoreBody =>
      'Tocas tú y el micrófono puntúa cada compás (la app no suena).';

  /// es: 'Metrónomo'
  String get metronome => 'Metrónomo';

  /// es: '¡A tocar!'
  String get start => '¡A tocar!';

  /// es: 'Prepárate…'
  String get countIn => 'Prepárate…';

  /// es: 'Ahora'
  String get now => 'Ahora';

  /// es: 'Después'
  String get next => 'Después';

  /// es: 'Fin'
  String get end => 'Fin';

  /// es: 'Compás $n de $total'
  String barOf({required Object n, required Object total}) =>
      'Compás ${n} de ${total}';

  /// es: 'Pausa'
  String get pause => 'Pausa';

  /// es: 'Seguir'
  String get resume => 'Seguir';

  /// es: 'Terminar'
  String get stop => 'Terminar';

  /// es: '$n pts'
  String points({required Object n}) => '${n} pts';

  /// es: 'Racha $n'
  String streak({required Object n}) => 'Racha ${n}';

  /// es: '¡Perfecto!'
  String get gradePerfect => '¡Perfecto!';

  /// es: '¡Bien!'
  String get gradeGood => '¡Bien!';

  /// es: 'Fallo'
  String get gradeMiss => 'Fallo';

  /// es: 'No te oigo'
  String get gradeSilent => 'No te oigo';

  /// es: 'Sesión terminada'
  String get resultTitle => 'Sesión terminada';

  /// es: 'Precisión: $n%'
  String accuracy({required Object n}) => 'Precisión: ${n}%';

  /// es: 'Mejor racha: $n'
  String bestStreak({required Object n}) => 'Mejor racha: ${n}';

  /// es: 'Compases perfectos: $n'
  String perfectBars({required Object n}) => 'Compases perfectos: ${n}';

  /// es: 'Otra vez'
  String get playAgain => 'Otra vez';

  /// es: 'Más lento'
  String get slower => 'Más lento';

  /// es: 'Más rápido'
  String get faster => 'Más rápido';

  /// es: 'Elegir otra'
  String get back => 'Elegir otra';

  /// es: '¡Nuevo récord!'
  String get newBest => '¡Nuevo récord!';

  /// es: 'Récord: $n'
  String best({required Object n}) => 'Récord: ${n}';

  /// es: 'Improvisa con: $scale'
  String scaleHint({required Object scale}) => 'Improvisa con: ${scale}';

  /// es: 'Toca acordes para añadirlos a tu progresión (hasta 8).'
  String get customHint =>
      'Toca acordes para añadirlos a tu progresión (hasta 8).';

  /// es: 'Añade al menos un acorde'
  String get customEmpty => 'Añade al menos un acorde';

  /// es: 'Mi progresión'
  String get customTitle => 'Mi progresión';

  /// es: 'Borrar'
  String get clear => 'Borrar';

  /// es: 'Quitar el último'
  String get removeLast => 'Quitar el último';

  /// es: 'Sin acceso al micrófono: la sesión no puntuará.'
  String get micProblem => 'Sin acceso al micrófono: la sesión no puntuará.';

  /// es: 'Truco: en «Puntuar» la app calla para oírte bien; usa el metrónomo visual.'
  String get headphonesTip =>
      'Truco: en «Puntuar» la app calla para oírte bien; usa el metrónomo visual.';

  /// es: 'Elige qué tocar'
  String get chooseTrack => 'Elige qué tocar';

  /// es: 'Rasgueo'
  String get strum => 'Rasgueo';

  /// es: 'Toca para elegir'
  String get pickTrack => 'Toca para elegir';
}

// Path: songs
class Translations$songs$es {
  Translations$songs$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Cancionero'
  String get title => 'Cancionero';

  /// es: 'Canciones tradicionales y de dominio público con acordes y letra.'
  String get subtitle =>
      'Canciones tradicionales y de dominio público con acordes y letra.';

  /// es: 'Busca una canción'
  String get searchHint => 'Busca una canción';

  /// es: 'Todas'
  String get all => 'Todas';

  /// es: 'Tradicional'
  String get traditional => 'Tradicional';

  /// es: 'Ejercicio de Chords'
  String get exercise => 'Ejercicio de Chords';

  /// es: 'Tono'
  String get transpose => 'Tono';

  /// es: 'Tono original'
  String get transposeReset => 'Tono original';

  /// es: 'Nivel $n'
  String level({required Object n}) => 'Nivel ${n}';

  /// es: 'Acordes de la canción'
  String get chordsUsed => 'Acordes de la canción';

  /// es: 'Tocar en el jam'
  String get playJam => 'Tocar en el jam';

  /// es: 'Ninguna canción coincide'
  String get empty => 'Ninguna canción coincide';

  /// es: 'Prueba con otro nombre o quita el filtro de género.'
  String get emptyBody => 'Prueba con otro nombre o quita el filtro de género.';

  /// es: 'No encontramos esa canción'
  String get notFound => 'No encontramos esa canción';

  Map<String, String> get exercises => {
    'bluesInA': 'Blues en La · 12 compases',
    'rockInE': 'Power chords en Mi',
    'popFourChords': 'Los cuatro acordes del pop',
    'metalGallop': 'Galope metalero en Mi menor',
    'funkVamp': 'Vamp funky en Mi',
  };
  Map<String, String> get parts => {
    'intro': 'Intro',
    'verse': 'Estrofa',
    'chorus': 'Estribillo',
    'bridge': 'Puente',
    'outro': 'Final',
  };
}

// Path: settings.theme
class Translations$settings$theme$es {
  Translations$settings$theme$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Tema'
  String get title => 'Tema';

  /// es: 'Sistema'
  String get system => 'Sistema';

  /// es: 'Claro'
  String get light => 'Claro';

  /// es: 'Oscuro'
  String get dark => 'Oscuro';

  /// es: 'Se adapta al tema del sistema'
  String get summarySystem => 'Se adapta al tema del sistema';

  /// es: 'Siempre claro'
  String get summaryLight => 'Siempre claro';

  /// es: 'Siempre oscuro'
  String get summaryDark => 'Siempre oscuro';

  /// es: 'Tema del sistema'
  String get valueSystem => 'Tema del sistema';

  /// es: 'Tema claro'
  String get valueLight => 'Tema claro';

  /// es: 'Tema oscuro'
  String get valueDark => 'Tema oscuro';
}

// Path: settings.color
class Translations$settings$color$es {
  Translations$settings$color$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Color de la app'
  String get title => 'Color de la app';

  /// es: 'Color dinámico del sistema activo'
  String get dynamicActive => 'Color dinámico del sistema activo';

  /// es: 'Color del sistema'
  String get systemTitle => 'Color del sistema';

  /// es: 'Usa el fondo de pantalla de tu dispositivo'
  String get systemSubtitle => 'Usa el fondo de pantalla de tu dispositivo';

  /// es: 'No disponible en esta plataforma'
  String get systemUnavailable => 'No disponible en esta plataforma';

  /// es: 'El acento manual se desactiva mientras el color del sistema esté activo.'
  String get accentDisabledNote =>
      'El acento manual se desactiva mientras el color del sistema esté activo.';
}

// Path: settings.text
class Translations$settings$text$es {
  Translations$settings$text$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Texto'
  String get title => 'Texto';

  /// es: 'Tamaño de letra'
  String get fontSize => 'Tamaño de letra';

  /// es: 'Vista previa'
  String get preview => 'Vista previa';

  /// es: 'Do mayor · cejilla en el traste 3'
  String get previewSample => 'Do mayor · cejilla en el traste 3';
}

// Path: settings.language
class Translations$settings$language$es {
  Translations$settings$language$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Idioma'
  String get title => 'Idioma';
}

// Path: settings.accent
class Translations$settings$accent$es {
  Translations$settings$accent$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Violeta'
  String get violeta => 'Violeta';

  /// es: 'Azul'
  String get azul => 'Azul';

  /// es: 'Añil'
  String get anil => 'Añil';

  /// es: 'Cian'
  String get cian => 'Cian';

  /// es: 'Verde'
  String get verde => 'Verde';

  /// es: 'Lima'
  String get lima => 'Lima';

  /// es: 'Ámbar'
  String get ambar => 'Ámbar';

  /// es: 'Naranja'
  String get naranja => 'Naranja';

  /// es: 'Rojo'
  String get rojo => 'Rojo';

  /// es: 'Rosa'
  String get rosa => 'Rosa';
}

// Path: settings.fontScale
class Translations$settings$fontScale$es {
  Translations$settings$fontScale$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Pequeño'
  String get pequena => 'Pequeño';

  /// es: 'Normal'
  String get normal => 'Normal';

  /// es: 'Grande'
  String get grande => 'Grande';

  /// es: 'Muy grande'
  String get extraGrande => 'Muy grande';
}

// Path: data.language
class Translations$data$language$es {
  Translations$data$language$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Idioma del sistema'
  String get system => 'Idioma del sistema';

  /// es: 'Español'
  String get es => 'Español';

  /// es: 'Inglés'
  String get en => 'Inglés';
}

// Path: data.genre
class Translations$data$genre$es {
  Translations$data$genre$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Pop'
  String get pop => 'Pop';

  /// es: 'Rock'
  String get rock => 'Rock';

  /// es: 'Blues'
  String get blues => 'Blues';

  /// es: 'Jazz'
  String get jazz => 'Jazz';

  /// es: 'Funk'
  String get funk => 'Funk';

  /// es: 'Balada'
  String get ballad => 'Balada';

  /// es: 'Latino'
  String get latin => 'Latino';

  /// es: 'Metal'
  String get metal => 'Metal';

  /// es: 'R&B'
  String get rnb => 'R&B';

  /// es: 'Soul'
  String get soul => 'Soul';

  /// es: 'Bossa'
  String get bossa => 'Bossa';

  /// es: 'Country'
  String get country => 'Country';

  /// es: 'Infantil'
  String get kids => 'Infantil';

  /// es: 'Ambient'
  String get ambient => 'Ambient';

  /// es: 'Clásico'
  String get classical => 'Clásico';

  /// es: 'Gospel'
  String get gospel => 'Gospel';

  /// es: 'Punk'
  String get punk => 'Punk';
}

// Path: data.quality
class Translations$data$quality$es {
  Translations$data$quality$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Mayor'
  String get major => 'Mayor';

  /// es: 'Menor'
  String get minor => 'Menor';

  /// es: 'Séptima de dominante'
  String get seven => 'Séptima de dominante';

  /// es: 'Séptima menor'
  String get minorSeven => 'Séptima menor';

  /// es: 'Séptima mayor'
  String get majorSeven => 'Séptima mayor';

  /// es: 'Suspendida 4'
  String get suspendedFourth => 'Suspendida 4';

  /// es: 'Suspendida 2'
  String get suspendedSecond => 'Suspendida 2';

  /// es: 'Quinta'
  String get power => 'Quinta';

  /// es: 'Sexta'
  String get sixth => 'Sexta';

  /// es: 'Sexta menor'
  String get minorSixth => 'Sexta menor';

  /// es: 'Disminuido'
  String get diminished => 'Disminuido';

  /// es: 'Aumentado'
  String get augmented => 'Aumentado';

  /// es: 'Novena'
  String get ninth => 'Novena';
}

// Path: data.qualityDescription
class Translations$data$qualityDescription$es {
  Translations$data$qualityDescription$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Triada mayor; base de casi todo.'
  String get major => 'Triada mayor; base de casi todo.';

  /// es: 'Triada menor; color triste o íntimo.'
  String get minor => 'Triada menor; color triste o íntimo.';

  /// es: 'Blues y funk; tensión con resolución fuerte.'
  String get seven => 'Blues y funk; tensión con resolución fuerte.';

  /// es: 'Suave y versátil; columna vertebral del ii-V-I.'
  String get minorSeven => 'Suave y versátil; columna vertebral del ii-V-I.';

  /// es: 'Color soñador de pop y jazz.'
  String get majorSeven => 'Color soñador de pop y jazz.';

  /// es: 'Suspensión abierta; suele resolver a mayor.'
  String get suspendedFourth => 'Suspensión abierta; suele resolver a mayor.';

  /// es: 'Abierta y etérea; habitual en pop y rock.'
  String get suspendedSecond => 'Abierta y etérea; habitual en pop y rock.';

  /// es: 'Dos notas; rock, metal y distorsión.'
  String get power => 'Dos notas; rock, metal y distorsión.';

  /// es: 'Aire vintage; frecuente en funk y folk.'
  String get sixth => 'Aire vintage; frecuente en funk y folk.';

  /// es: 'Color latino y jazz; muy expresiva.'
  String get minorSixth => 'Color latino y jazz; muy expresiva.';

  /// es: 'Tensión inestable; acorde de paso.'
  String get diminished => 'Tensión inestable; acorde de paso.';

  /// es: 'Simétrico y luminoso; enlaces cromáticos.'
  String get augmented => 'Simétrico y luminoso; enlaces cromáticos.';

  /// es: 'Rica y moderna; funk y r&b.'
  String get ninth => 'Rica y moderna; funk y r&b.';
}

// Path: data.difficulty
class Translations$data$difficulty$es {
  Translations$data$difficulty$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Principiante'
  String get beginner => 'Principiante';

  /// es: 'Fácil'
  String get easy => 'Fácil';

  /// es: 'Intermedio'
  String get medium => 'Intermedio';

  /// es: 'Difícil'
  String get hard => 'Difícil';

  /// es: 'Experto'
  String get expert => 'Experto';
}

// Path: data.difficultyHint
class Translations$data$difficultyHint$es {
  Translations$data$difficultyHint$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Abierto, sin cejillo'
  String get beginner => 'Abierto, sin cejillo';

  /// es: 'Tríadas o formas cortas'
  String get easy => 'Tríadas o formas cortas';

  /// es: 'Cejillo completo'
  String get medium => 'Cejillo completo';

  /// es: 'Gran estiramiento o cejillo alto'
  String get hard => 'Gran estiramiento o cejillo alto';

  /// es: 'Voicing avanzado o jazz'
  String get expert => 'Voicing avanzado o jazz';
}

// Path: data.level
class Translations$data$level$es {
  Translations$data$level$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Primeros acordes'
  String get first => 'Primeros acordes';

  /// es: 'Séptimas fáciles'
  String get second => 'Séptimas fáciles';

  /// es: 'Cejilla'
  String get third => 'Cejilla';

  /// es: 'Color y suspensión'
  String get fourth => 'Color y suspensión';

  /// es: 'Jazz y voicings'
  String get fifth => 'Jazz y voicings';
}

// Path: data.levelGoal
class Translations$data$levelGoal$es {
  Translations$data$levelGoal$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Mayores y menores abiertos'
  String get first => 'Mayores y menores abiertos';

  /// es: 'Séptima de dominante sin cejilla'
  String get second => 'Séptima de dominante sin cejilla';

  /// es: 'Formas movibles completas'
  String get third => 'Formas movibles completas';

  /// es: 'm7, maj7, sus2, sus4, 6'
  String get fourth => 'm7, maj7, sus2, sus4, 6';

  /// es: '9, dim, aug y voicings avanzados'
  String get fifth => '9, dim, aug y voicings avanzados';
}

// Path: data.arpeggio
class Translations$data$arpeggio$es {
  Translations$data$arpeggio$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Ascendente'
  String get ascending => 'Ascendente';

  /// es: 'Descendente'
  String get descending => 'Descendente';

  /// es: 'Alterno'
  String get alternating => 'Alterno';

  /// es: 'Fingerstyle'
  String get fingerstyle => 'Fingerstyle';
}

// Path: minigames.prompt
class Translations$minigames$prompt$es {
  Translations$minigames$prompt$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: '¿Qué nota suena?'
  String get guessNote => '¿Qué nota suena?';

  /// es: '¿Qué cuerda suena?'
  String get whichString => '¿Qué cuerda suena?';

  /// es: 'Suena la $string al aire y luego pulsada. ¿En qué traste?'
  String whichFret({required Object string}) =>
      'Suena la ${string} al aire y luego pulsada. ¿En qué traste?';

  /// es: '¿Qué intervalo suena?'
  String get interval => '¿Qué intervalo suena?';

  /// es: '¿Cuál suena más agudo?'
  String get higherLower => '¿Cuál suena más agudo?';

  /// es: '¿Qué tipo de acorde suena?'
  String get chordQuality => '¿Qué tipo de acorde suena?';

  /// es: '¿Qué acorde suena?'
  String get nameChord => '¿Qué acorde suena?';

  /// es: 'Escucha la referencia. ¿Cómo está la segunda nota?'
  String get tuneEar => 'Escucha la referencia. ¿Cómo está la segunda nota?';

  /// es: 'Escucha y repite la secuencia de cuerdas'
  String get memory => 'Escucha y repite la secuencia de cuerdas';

  /// es: '¿Qué nota suena en la $string, traste $fret?'
  String noteAtFret({required Object string, required Object fret}) =>
      '¿Qué nota suena en la ${string}, traste ${fret}?';

  /// es: '¿En qué traste de la $string está $note?'
  String fretOfNote({required Object string, required Object note}) =>
      '¿En qué traste de la ${string} está ${note}?';

  /// es: '¿Qué dedo pisa la $string?'
  String fingerQuiz({required Object string}) => '¿Qué dedo pisa la ${string}?';

  /// es: '¿Qué acorde es este?'
  String get readDiagram => '¿Qué acorde es este?';

  /// es: 'Forma el acorde $chord'
  String buildChord({required Object chord}) => 'Forma el acorde ${chord}';

  /// es: 'Toca la nota $note'
  String playNote({required Object note}) => 'Toca la nota ${note}';

  /// es: 'Toca la $string en el traste $fret'
  String playStringFret({required Object string, required Object fret}) =>
      'Toca la ${string} en el traste ${fret}';

  /// es: 'Escucha y toca la melodía'
  String get echo => 'Escucha y toca la melodía';

  /// es: '¿Qué nota suena en la $string al aire?'
  String noteAtOpen({required Object string}) =>
      '¿Qué nota suena en la ${string} al aire?';

  /// es: 'Toca la $string al aire'
  String playStringOpen({required Object string}) =>
      'Toca la ${string} al aire';

  /// es: '¿Qué nota está en $scale?'
  String scaleNote({required Object scale}) => '¿Qué nota está en ${scale}?';

  /// es: 'En $key, ¿cuál es el acorde $degree?'
  String keyChord({required Object key, required Object degree}) =>
      'En ${key}, ¿cuál es el acorde ${degree}?';

  /// es: 'En $key, ¿qué grado es $note?'
  String scaleDegree({required Object key, required Object note}) =>
      'En ${key}, ¿qué grado es ${note}?';

  /// es: 'Escucha la cadencia. ¿Cuál es la tónica?'
  String get findTonic => 'Escucha la cadencia. ¿Cuál es la tónica?';

  /// es: '¿Qué progresión suena?'
  String get progressionEar => '¿Qué progresión suena?';
}

// Path: minigames.choice
class Translations$minigames$choice$es {
  Translations$minigames$choice$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Traste $n'
  String fret({required Object n}) => 'Traste ${n}';

  /// es: 'Al aire'
  String get fretOpen => 'Al aire';

  /// es: '1 · Índice'
  String get finger1 => '1 · Índice';

  /// es: '2 · Medio'
  String get finger2 => '2 · Medio';

  /// es: '3 · Anular'
  String get finger3 => '3 · Anular';

  /// es: '4 · Meñique'
  String get finger4 => '4 · Meñique';

  /// es: 'La primera'
  String get first => 'La primera';

  /// es: 'La segunda'
  String get second => 'La segunda';

  /// es: 'Floja (más grave)'
  String get flat => 'Floja (más grave)';

  /// es: 'Afinada'
  String get inTune => 'Afinada';

  /// es: 'Alta (más aguda)'
  String get sharp => 'Alta (más aguda)';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
          'app.title' => 'Chords',
          'app.chordFallback' => 'Acorde',
          'app.skip' => 'Omitir',
          'app.next' => 'Siguiente',
          'app.start' => 'Empezar',
          'nav.home' => 'Inicio',
          'nav.learn' => 'Aprender',
          'nav.chords' => 'Acordes',
          'nav.game' => 'Jugar',
          'nav.live' => 'Afinar',
          'nav.settings' => 'Ajustes',
          'home.greeting' => 'Hola, guitararrista',
          'home.question' => '¿Qué tocas hoy?',
          'home.progressTitle' => 'Progreso del itinerario',
          'home.masteredCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: '${n} acorde dominado',
                  other: '${n} acordes dominados',
                ),
          'home.continueLearning' => 'Continúa aprendiendo',
          'home.itineraryComplete' => '¡Itinerario completo!',
          'home.nextChord' => ({required Object name}) => 'Siguiente: ${name}',
          'home.library' => 'Biblioteca de acordes',
          'home.librarySubtitle' => ({
            required Object count,
          }) => '${count} acordes por género y nivel',
          'home.gameMode' => 'Minijuegos',
          'home.gameSubtitle' => ({
            required Object count,
          }) => '${count} juegos de oído, mástil y dedos',
          'home.liveTitle' => 'Afinador y escucha',
          'home.liveSubtitle' => 'Afina cuerda a cuerda con tu micrófono',
          'home.greetingMorning' => 'Buenos días',
          'home.greetingAfternoon' => 'Buenas tardes',
          'home.greetingEvening' => 'Buenas noches',
          'home.nextUp' => 'Tu siguiente acorde',
          'home.practiceCta' => 'Practicar',
          'home.statMastered' => 'Dominados',
          'home.statBest' => 'Mejor puntaje',
          'home.statLevel' => 'Nivel',
          'home.recommendedTitle' => 'Para ti',
          'home.recommendedEmpty' =>
            'Completa tu perfil para ver recomendaciones.',
          'home.toolsTitle' => 'Herramientas',
          'home.seeAll' => 'Ver todo',
          'home.learnSubtitle' => 'Tu ruta paso a paso',
          'chords.title' => 'Acordes',
          'chords.clearFilters' => 'Limpiar filtros',
          'chords.searchHint' => 'Buscar acordes',
          'chords.filterAll' => 'Todos',
          'chords.filterAllQualities' => 'Todas',
          'chords.positionCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: '${n} posición',
                  other: '${n} posiciones',
                ),
          'chords.levelShort' => ({required Object level}) => 'Nv ${level}',
          'chords.maxDifficulty' => ({
            required Object level,
          }) => 'Dificultad máx: ${level}',
          'chords.loading' => 'Cargando acordes…',
          'chords.loadErrorTitle' => 'No se pudo cargar el banco',
          'chords.loadErrorMessage' =>
            'Reinicia la app para reintentar la carga del banco.',
          'chords.emptyTitle' => 'Sin resultados',
          'chords.emptyMessage' =>
            'Ajusta la búsqueda o los filtros para ver más acordes.',
          'chords.filters' => 'Filtros',
          'chords.filterLevel' => 'Nivel',
          'chords.filterQuality' => 'Tipo de acorde',
          'chords.filterDifficulty' => 'Dificultad máxima',
          'chords.forMyLevel' => 'Para mi nivel',
          'chords.apply' => 'Ver resultados',
          'chords.reset' => 'Restablecer',
          'chords.results' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: '${n} acorde',
                  other: '${n} acordes',
                ),
          'chordDetail.titleFallback' => 'Acorde',
          'chordDetail.markMastered' => 'Marcar como dominado',
          'chordDetail.unmarkMastered' => 'Quitar de dominados',
          'chordDetail.leftHandMode' => 'Modo zurdo',
          'chordDetail.leftHandModeOff' => 'Desactivar modo zurdo',
          'chordDetail.loading' => 'Cargando acorde…',
          'chordDetail.errorTitle' => 'Acorde no disponible',
          'chordDetail.notFoundMessage' => ({
            required Object chordId,
          }) => 'No se encontró el acorde ${chordId}',
          'chordDetail.loadFailed' => 'No se pudo leer el banco de acordes.',
          'chordDetail.noChordTitle' => 'Sin acorde seleccionado',
          'chordDetail.noChordMessage' =>
            'Vuelve al listado y elige un acorde.',
          'chordDetail.listen' => 'Escuchar acorde',
          'chordDetail.listenPosition' => ({
            required Object position,
          }) => 'Escuchar ${position}',
          'chordDetail.arpeggios' => 'Arpegios',
          'chordDetail.positions' => 'Posiciones',
          'chordDetail.notes' => ({required Object notes}) => 'Notas: ${notes}',
          'chordDetail.arpeggioChip' => ({
            required Object label,
            required Object level,
          }) => '${label} · Nv ${level}',
          'chordDetail.practice' => 'Practicar',
          'chordDetail.guideTitle' => 'Cómo colocarlo',
          'chordDetail.guideLegend' =>
            '1 índice · 2 medio · 3 anular · 4 meñique',
          'chordDetail.guideFinger' => ({
            required Object fret,
            required Object string,
          }) => 'Traste ${fret} · cuerda ${string}',
          'chordDetail.guideBarre' => ({
            required Object fret,
            required Object from,
            required Object to,
          }) => 'Cejillo en el traste ${fret} · de la ${from} a la ${to}',
          'chordDetail.guidePlay' => ({
            required Object strings,
          }) => 'Toca: ${strings}',
          'chordDetail.guideOpen' => ({
            required Object strings,
          }) => 'Al aire: ${strings}',
          'chordDetail.guideMuted' => ({
            required Object strings,
          }) => 'No toques: ${strings}',
          'chordDetail.guideOpenPosition' =>
            'Posición abierta, junto a la cejuela',
          'chordDetail.guideRange' => ({
            required Object from,
            required Object to,
          }) => 'Zona de los trastes ${from} a ${to}',
          'chordDetail.guideSingleFret' => ({
            required Object fret,
          }) => 'Zona del traste ${fret}',
          'chordDetail.recommended' => 'Para empezar',
          'chordDetail.fingerNames.f1' => 'Índice',
          'chordDetail.fingerNames.f2' => 'Medio',
          'chordDetail.fingerNames.f3' => 'Anular',
          'chordDetail.fingerNames.f4' => 'Meñique',
          'game.title' => 'Jugar',
          'game.start' => 'Empezar serie',
          'game.emptyTitle' => 'Toca el acorde',
          'game.emptyMessage' => ({
            required Object best,
          }) => 'Encadena una serie de acordes con el micrófono. Récord: ${best} puntos.',
          'game.round' => ({required Object number}) => 'Ronda ${number}',
          'game.playThisChord' => 'Toca este acorde',
          'game.loadingChord' => 'Cargando acorde…',
          'game.listening' => 'Escuchando tu guitarra…',
          'game.correctNext' => '¡Correcto! Siguiente',
          'game.retry' => 'Inténtalo otra vez',
          'game.ready' => 'Estoy listo',
          'game.streak' => 'Racha',
          'game.score' => 'Puntos',
          'game.feedbackProgress' => ({
            required Object hit,
            required Object total,
          }) => '¡Vas bien! ${hit} de ${total} notas',
          'game.feedbackMissing' => ({
            required Object notes,
          }) => 'Te falta: ${notes}',
          'game.feedbackExtra' => ({
            required Object notes,
          }) => 'Suena de más: ${notes}',
          'game.feedbackComplete' => '¡Acorde completo!',
          'game.almostNext' => '¡Casi! Siguiente',
          'game.stringFirst' => '1ª',
          'game.stringSecond' => '2ª',
          'game.stringThird' => '3ª',
          'game.stringFourth' => '4ª',
          'game.stringFifth' => '5ª',
          'game.stringSixth' => '6ª',
          'game.practiceChord' => 'Practicar cuerda a cuerda',
          'game.finishedTitle' => '¡Serie completa!',
          'game.finishedMessage' => ({
            required Object won,
            required Object total,
            required Object score,
          }) => '${won} de ${total} acordes · ${score} puntos',
          'game.finishedBest' => ({
            required Object best,
          }) => 'Tu récord: ${best} puntos',
          'chordDiagram.stringLabel' => ({
            required Object number,
            required Object fret,
          }) => 'cuerda ${number}: ${fret}',
          'chordDiagram.muted' => 'muda',
          'chordDiagram.open' => 'al aire',
          'chordDiagram.fret' => ({required Object value}) => 'traste ${value}',
          'chordDiagram.description' => ({
            required Object position,
            required Object details,
          }) => 'Diagrama de ${position}, ${details}',
          'live.title' => 'Afinador',
          'live.emptyTitle' => 'Sin sugerencias aún',
          'live.emptyMessage' =>
            'Pulsa escuchar y toca un acorde para ver coincidencias.',
          'live.suggestions' => 'Sugerencias',
          'live.idleTitle' => 'Micrófono en espera',
          'live.idleMessage' => 'Toca una nota en la guitarra',
          'live.listening' => 'Escuchando…',
          'live.deniedTitle' => 'Permiso denegado',
          'live.errorTitle' => 'Error de captura',
          'learn.title' => 'Aprender',
          'learn.loading' => 'Preparando niveles…',
          'learn.errorTitle' => 'No se pudo cargar el itinerario',
          'learn.errorMessage' => 'Reinicia la app para reintentar.',
          'learn.yourProgress' => 'Tu progreso',
          'learn.masteredCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: '${n} acorde dominado',
                  other: '${n} acordes dominados',
                ),
          'learn.stepByStep' => 'Paso a paso',
          'learn.stepFingers' => 'Coloca los dedos uno a uno sobre el diapasón',
          'learn.stepStrum' => 'Rasgueo lento: escucha cada cuerda',
          'learn.stepChange' => 'Cambia al acorde siguiente sin parar el ritmo',
          'learn.guidedArpeggios' => 'Arpegios guiados',
          'learn.levelSection' => ({
            required Object emoji,
            required Object level,
            required Object title,
          }) => '${emoji}  Nivel ${level}: ${title}',
          'learn.arpeggioHint' => ({
            required Object label,
          }) => 'Abre el acorde y toca su arpegio ${label}',
          'settings.title' => 'Ajustes',
          'settings.appearance' => 'Apariencia',
          'settings.theme.title' => 'Tema',
          'settings.theme.system' => 'Sistema',
          'settings.theme.light' => 'Claro',
          'settings.theme.dark' => 'Oscuro',
          'settings.theme.summarySystem' => 'Se adapta al tema del sistema',
          'settings.theme.summaryLight' => 'Siempre claro',
          'settings.theme.summaryDark' => 'Siempre oscuro',
          'settings.theme.valueSystem' => 'Tema del sistema',
          'settings.theme.valueLight' => 'Tema claro',
          'settings.theme.valueDark' => 'Tema oscuro',
          'settings.color.title' => 'Color de la app',
          'settings.color.dynamicActive' => 'Color dinámico del sistema activo',
          'settings.color.systemTitle' => 'Color del sistema',
          'settings.color.systemSubtitle' =>
            'Usa el fondo de pantalla de tu dispositivo',
          'settings.color.systemUnavailable' =>
            'No disponible en esta plataforma',
          'settings.color.accentDisabledNote' => 'El acento manual se desactiva mientras el color del sistema esté activo.',
          'settings.text.title' => 'Texto',
          'settings.text.fontSize' => 'Tamaño de letra',
          'settings.text.preview' => 'Vista previa',
          'settings.text.previewSample' => 'Do mayor · cejilla en el traste 3',
          'settings.language.title' => 'Idioma',
          'settings.accent.violeta' => 'Violeta',
          'settings.accent.azul' => 'Azul',
          'settings.accent.anil' => 'Añil',
          'settings.accent.cian' => 'Cian',
          'settings.accent.verde' => 'Verde',
          'settings.accent.lima' => 'Lima',
          'settings.accent.ambar' => 'Ámbar',
          'settings.accent.naranja' => 'Naranja',
          'settings.accent.rojo' => 'Rojo',
          'settings.accent.rosa' => 'Rosa',
          'settings.fontScale.pequena' => 'Pequeño',
          'settings.fontScale.normal' => 'Normal',
          'settings.fontScale.grande' => 'Grande',
          'settings.fontScale.extraGrande' => 'Muy grande',
          'settings.guitar' => 'Guitarra',
          'settings.leftHandMode' => 'Modo zurdo',
          'settings.leftHandModeSubtitle' => 'Muestra los diagramas en espejo',
          'settings.sound' => 'Sonido',
          'settings.chordSound' => 'Sonido de acordes',
          'settings.chordSoundSubtitle' => 'Sintetiza rasgueos y arpegios',
          'settings.learning' => 'Aprendizaje',
          'settings.resetOnboarding' => 'Reiniciar onboarding',
          'settings.resetOnboardingSubtitle' => 'Vuelve a ver la introducción',
          'settings.onboardingReset' => 'Onboarding reiniciado',
          'settings.version' => 'Versión',
          'settings.cli' => 'CLI de desarrollo',
          'settings.cliCommand' => 'dart run bin/chords_cli.dart db generate',
          'onboarding.slideOneTitle' =>
            'Todos los acordes, todas las posiciones',
          'onboarding.slideOneBody' => '156 acordes y 561 posiciones verificadas, de los abiertos esenciales a los voicings de jazz.',
          'onboarding.slideTwoTitle' => 'Escucha cada acorde y su arpegio',
          'onboarding.slideTwoBody' => 'Sintetizamos cada cuerda para que reconozcas el sonido antes de tocar.',
          'onboarding.slideThreeTitle' => 'Aprende por niveles y practica',
          'onboarding.slideThreeBody' => 'Itinerario paso a paso, filtro por género y modo juego para encadenar series de acordes.',
          'onboarding.welcomeTitle' => 'Tu guitarra, a tu medida',
          'onboarding.welcomeBody' => 'Cinco preguntas rápidas y te recomiendo los acordes ideales para ti.',
          'onboarding.welcomeCta' => 'Empezar',
          'onboarding.stepOf' => ({
            required Object current,
            required Object total,
          }) => 'Paso ${current} de ${total}',
          'onboarding.back' => 'Atrás',
          'onboarding.proceed' => 'Continuar',
          'onboarding.finish' => 'Empezar a tocar',
          'onboarding.guitarTitle' => '¿Qué guitarra tocas?',
          'onboarding.guitarBody' => 'Cada una pide acordes distintos.',
          'onboarding.guitarAcoustic' => 'Acústica',
          'onboarding.guitarAcousticHint' =>
            'Cuerdas de acero y acordes abiertos',
          'onboarding.guitarElectric' => 'Eléctrica',
          'onboarding.guitarElectricHint' => 'Power chords y riffs',
          'onboarding.guitarClassical' => 'Clásica',
          'onboarding.guitarClassicalHint' => 'Cuerdas de nailon y dedos',
          'onboarding.playTitle' => '¿Cómo la tocas?',
          'onboarding.playBody' =>
            'Ajusto los diagramas y los arpegios a tu forma de tocar.',
          'onboarding.handLabel' => 'Tu mano',
          'onboarding.handRight' => 'Diestro',
          'onboarding.handRightHint' => 'Diagramas normales',
          'onboarding.handLeft' => 'Zurdo',
          'onboarding.handLeftHint' => 'Diagramas en espejo',
          'onboarding.styleLabel' => 'Cómo atacas las cuerdas',
          'onboarding.stylePick' => 'Púa',
          'onboarding.styleFingers' => 'Dedos',
          'onboarding.styleBoth' => 'Ambos',
          'onboarding.genresTitle' => '¿Qué música te gusta?',
          'onboarding.genresBody' =>
            'Elige los que quieras: recomiendo acordes de esos estilos.',
          'onboarding.levelTitle' => '¿Cuánta experiencia tienes?',
          'onboarding.levelBody' =>
            'Ajusto la dificultad para que avances sin frustrarte.',
          'onboarding.levelBeginner' => 'Estoy empezando',
          'onboarding.levelBeginnerHint' => 'Acordes abiertos, sin cejilla',
          'onboarding.levelIntermediate' => 'Ya toco canciones',
          'onboarding.levelIntermediateHint' =>
            'Cambio de acorde y cejillas básicas',
          'onboarding.levelAdvanced' => 'Toco con soltura',
          'onboarding.levelAdvancedHint' => 'Cejillas, séptimas y voicings',
          'onboarding.planTitle' => 'Tu plan está listo',
          'onboarding.planBody' =>
            'Empieza por estos acordes, elegidos para ti.',
          'onboarding.planEmpty' =>
            'Explora la biblioteca y empieza por el que más te guste.',
          'onboarding.guitarModeTitle' => 'Tu guitarra también es el mando',
          'onboarding.guitarModeBody' =>
            'Mueve toda la app tocando notas, sin soltar la guitarra.',
          'onboarding.guitarModeSwitch' => 'Activar el modo guitarra',
          'onboarding.guitarModeSwitchHint' =>
            'Pedirá permiso para el micrófono. Puedes cambiarlo en Ajustes.',
          'onboarding.guitarModeStep1' => 'Toca una nota aguda (traste 14 o más de la 1ª cuerda) y se abre el menú.',
          'onboarding.guitarModeStep2' => 'Con el menú abierto, toca la nota de la opción: en una cuerda, Mi al aire y un traste más por destino.',
          'onboarding.guitarModeTry' =>
            'Toca una opción para ver qué nota la elige',
          'onboarding.guitarModePreview' => ({
            required Object note,
            required Object fret,
            required Object label,
          }) => '${note} · ${fret} → ${label}',
          'data.language.system' => 'Idioma del sistema',
          'data.language.es' => 'Español',
          'data.language.en' => 'Inglés',
          'data.genre.pop' => 'Pop',
          'data.genre.rock' => 'Rock',
          'data.genre.blues' => 'Blues',
          'data.genre.jazz' => 'Jazz',
          'data.genre.funk' => 'Funk',
          'data.genre.ballad' => 'Balada',
          'data.genre.latin' => 'Latino',
          'data.genre.metal' => 'Metal',
          'data.genre.rnb' => 'R&B',
          'data.genre.soul' => 'Soul',
          'data.genre.bossa' => 'Bossa',
          'data.genre.country' => 'Country',
          'data.genre.kids' => 'Infantil',
          'data.genre.ambient' => 'Ambient',
          'data.genre.classical' => 'Clásico',
          'data.genre.gospel' => 'Gospel',
          'data.genre.punk' => 'Punk',
          'data.quality.major' => 'Mayor',
          'data.quality.minor' => 'Menor',
          'data.quality.seven' => 'Séptima de dominante',
          'data.quality.minorSeven' => 'Séptima menor',
          'data.quality.majorSeven' => 'Séptima mayor',
          'data.quality.suspendedFourth' => 'Suspendida 4',
          'data.quality.suspendedSecond' => 'Suspendida 2',
          'data.quality.power' => 'Quinta',
          'data.quality.sixth' => 'Sexta',
          'data.quality.minorSixth' => 'Sexta menor',
          'data.quality.diminished' => 'Disminuido',
          'data.quality.augmented' => 'Aumentado',
          'data.quality.ninth' => 'Novena',
          'data.qualityDescription.major' => 'Triada mayor; base de casi todo.',
          'data.qualityDescription.minor' =>
            'Triada menor; color triste o íntimo.',
          'data.qualityDescription.seven' =>
            'Blues y funk; tensión con resolución fuerte.',
          'data.qualityDescription.minorSeven' =>
            'Suave y versátil; columna vertebral del ii-V-I.',
          'data.qualityDescription.majorSeven' =>
            'Color soñador de pop y jazz.',
          'data.qualityDescription.suspendedFourth' =>
            'Suspensión abierta; suele resolver a mayor.',
          'data.qualityDescription.suspendedSecond' =>
            'Abierta y etérea; habitual en pop y rock.',
          'data.qualityDescription.power' =>
            'Dos notas; rock, metal y distorsión.',
          'data.qualityDescription.sixth' =>
            'Aire vintage; frecuente en funk y folk.',
          'data.qualityDescription.minorSixth' =>
            'Color latino y jazz; muy expresiva.',
          'data.qualityDescription.diminished' =>
            'Tensión inestable; acorde de paso.',
          'data.qualityDescription.augmented' =>
            'Simétrico y luminoso; enlaces cromáticos.',
          'data.qualityDescription.ninth' => 'Rica y moderna; funk y r&b.',
          'data.difficulty.beginner' => 'Principiante',
          'data.difficulty.easy' => 'Fácil',
          'data.difficulty.medium' => 'Intermedio',
          'data.difficulty.hard' => 'Difícil',
          'data.difficulty.expert' => 'Experto',
          'data.difficultyHint.beginner' => 'Abierto, sin cejillo',
          'data.difficultyHint.easy' => 'Tríadas o formas cortas',
          'data.difficultyHint.medium' => 'Cejillo completo',
          'data.difficultyHint.hard' => 'Gran estiramiento o cejillo alto',
          'data.difficultyHint.expert' => 'Voicing avanzado o jazz',
          'data.level.first' => 'Primeros acordes',
          'data.level.second' => 'Séptimas fáciles',
          'data.level.third' => 'Cejilla',
          'data.level.fourth' => 'Color y suspensión',
          'data.level.fifth' => 'Jazz y voicings',
          'data.levelGoal.first' => 'Mayores y menores abiertos',
          'data.levelGoal.second' => 'Séptima de dominante sin cejilla',
          'data.levelGoal.third' => 'Formas movibles completas',
          'data.levelGoal.fourth' => 'm7, maj7, sus2, sus4, 6',
          'data.levelGoal.fifth' => '9, dim, aug y voicings avanzados',
          'data.arpeggio.ascending' => 'Ascendente',
          'data.arpeggio.descending' => 'Descendente',
          'data.arpeggio.alternating' => 'Alterno',
          'data.arpeggio.fingerstyle' => 'Fingerstyle',
          'chordTheory.qualityNames.add9' => 'Novena añadida',
          'chordTheory.qualityNames.madd9' => 'Menor con novena añadida',
          'chordTheory.qualityNames."69"' => 'Sexta con novena',
          'chordTheory.qualityNames.m9' => 'Novena menor',
          'chordTheory.qualityNames.maj9' => 'Novena mayor',
          'chordTheory.qualityNames."11"' => 'Oncena',
          'chordTheory.qualityNames.m11' => 'Oncena menor',
          'chordTheory.qualityNames."13"' => 'Trecena',
          'chordTheory.qualityNames.7sus4' => 'Séptima suspendida 4',
          'chordTheory.qualityNames.9sus4' => 'Novena suspendida 4',
          'chordTheory.qualityNames.mMaj7' => 'Menor con séptima mayor',
          'chordTheory.qualityNames.m7b5' => 'Semidisminuido',
          'chordTheory.qualityNames.dim7' => 'Séptima disminuida',
          'chordTheory.qualityNames.7b9' => 'Séptima con novena menor',
          'chordTheory.qualityNames.7s9' => 'Séptima con novena aumentada',
          'chordTheory.qualityNames.7s5' => 'Séptima aumentada',
          'chordTheory.qualityNames.7b5' => 'Séptima con quinta bemol',
          'chordTheory.qualityNames.7s11' => 'Séptima con oncena aumentada',
          'chordTheory.qualityNames.maj7s11' =>
            'Séptima mayor con oncena aumentada',
          'chordTheory.qualityNames.maj7s5' => 'Séptima mayor aumentada',
          'chordTheory.qualityAbout.add9' =>
            'Triada con novena añadida; brillo de pop y baladas.',
          'chordTheory.qualityAbout.madd9' =>
            'Menor con novena añadida; íntima y cinematográfica.',
          'chordTheory.qualityAbout."69"' =>
            'Sexta con novena; cierre clásico de jazz y bossa.',
          'chordTheory.qualityAbout.m9' =>
            'Séptima menor con novena; soul, jazz y r&b.',
          'chordTheory.qualityAbout.maj9' =>
            'Séptima mayor con novena; lujo de jazz y neo-soul.',
          'chordTheory.qualityAbout."11"' =>
            'Dominante con oncena; sonido abierto de funk y gospel.',
          'chordTheory.qualityAbout.m11' =>
            'Menor con oncena; espacioso, de jazz y r&b.',
          'chordTheory.qualityAbout."13"' =>
            'Dominante con trecena; blues urbano, funk y jazz.',
          'chordTheory.qualityAbout.7sus4' =>
            'Dominante suspendido; tensión sin tercera, muy de funk.',
          'chordTheory.qualityAbout.9sus4' =>
            'Novena suspendida; flotante, de funk y r&b.',
          'chordTheory.qualityAbout.mMaj7' =>
            'Menor con séptima mayor; misterio de película de espías.',
          'chordTheory.qualityAbout.m7b5' =>
            'Semidisminuido; el ii de los ii-V-i menores.',
          'chordTheory.qualityAbout.dim7' =>
            'Simétrico de cuatro notas; paso cromático y tensión.',
          'chordTheory.qualityAbout.7b9' =>
            'Dominante con novena menor; tensión latina y de jazz.',
          'chordTheory.qualityAbout.7s9' =>
            'El acorde de Hendrix; dominante agrio de rock y funk.',
          'chordTheory.qualityAbout.7s5' =>
            'Dominante aumentado (aug7); tensión de tonos enteros.',
          'chordTheory.qualityAbout.7b5' =>
            'Dominante con quinta bemol; sustituto de tritono.',
          'chordTheory.qualityAbout.7s11' =>
            'Dominante lidio; brillo de jazz moderno y bossa.',
          'chordTheory.qualityAbout.maj7s11' =>
            'Séptima mayor lidia; sonido flotante y soñador.',
          'chordTheory.qualityAbout.maj7s5' =>
            'Séptima mayor aumentada; luminosa e inquieta.',
          'chordTheory.families.triad' => 'Triadas',
          'chordTheory.families.power' => 'Quintas',
          'chordTheory.families.sixth' => 'Sextas',
          'chordTheory.families.seventh' => 'Séptimas',
          'chordTheory.families.extended' => 'Extendidos',
          'chordTheory.families.suspendedAdded' => 'Suspendidos y añadidos',
          'chordTheory.families.altered' => 'Alterados',
          'chordTheory.tags.open' => 'Abierta',
          'chordTheory.tags.barre' => 'Cejilla',
          'chordTheory.tags.movable' => 'Movible',
          'chordTheory.tags.inversion' => 'Inversión',
          'chordTheory.tags.triad' => 'Tríada',
          'chordTheory.tags.shell' => 'Shell',
          'chordTheory.tags.voicing' => 'Voicing',
          'chordTheory.tags.drop2' => 'Drop 2',
          'chordTheory.tags.drop3' => 'Drop 3',
          'chordTheory.tags.upper' => 'Cuerdas agudas',
          'chordTheory.tags.high-position' => 'Posición alta',
          'chordTheory.intervalNames."1"' => 'tónica',
          'chordTheory.intervalNames.b2' => 'segunda menor',
          'chordTheory.intervalNames."2"' => 'segunda mayor',
          'chordTheory.intervalNames.b3' => 'tercera menor',
          'chordTheory.intervalNames."3"' => 'tercera mayor',
          'chordTheory.intervalNames."4"' => 'cuarta justa',
          'chordTheory.intervalNames.b5' => 'quinta disminuida',
          'chordTheory.intervalNames."5"' => 'quinta justa',
          'chordTheory.intervalNames.#5' => 'quinta aumentada',
          'chordTheory.intervalNames."6"' => 'sexta mayor',
          'chordTheory.intervalNames.bb7' => 'séptima disminuida',
          'chordTheory.intervalNames.b7' => 'séptima menor',
          'chordTheory.intervalNames."7"' => 'séptima mayor',
          'chordTheory.intervalNames.b9' => 'novena menor',
          'chordTheory.intervalNames."9"' => 'novena mayor',
          'chordTheory.intervalNames.#9' => 'novena aumentada',
          'chordTheory.intervalNames."11"' => 'oncena justa',
          'chordTheory.intervalNames.#11' => 'oncena aumentada',
          'chordTheory.intervalNames."13"' => 'trecena mayor',
          'chordTheory.sortTooltip' => 'Ordenar',
          'chordTheory.sortEssentials' => 'Esenciales primero',
          'chordTheory.sortDifficulty' => 'Más fáciles primero',
          'chordTheory.sortRoot' => 'Por nota (Do, Re, Mi…)',
          'chordTheory.sortQuality' => 'Por tipo de acorde',
          'chordTheory.pickChord' => 'Elegir nota y tipo',
          'chordTheory.pickRoot' => 'Nota',
          'chordTheory.pickQuality' => 'Tipo de acorde',
          'chordTheory.pickShow' => ({required Object n}) => 'Ver ${n} acordes',
          'chordTheory.pickOpen' => ({
            required Object name,
          }) => 'Abrir ficha de ${name}',
          'chordTheory.pickClear' => 'Quitar',
          'chordTheory.searchTip' =>
            'Prueba con Cm7, Do mayor, Re menor 7 o C E G.',
          'chordTheory.notesTitle' => 'Notas y fórmula',
          'chordTheory.formulaLine' => ({
            required Object formula,
          }) => 'Fórmula: ${formula}',
          'chordTheory.optionalNote' => 'Se puede omitir',
          'chordTheory.noteMeaning' => ({
            required Object note,
            required Object interval,
          }) => '${note} es la ${interval}',
          'chordTheory.aboutTitle' => 'Qué es este acorde',
          'chordTheory.keysTitle' => 'En qué tonalidades está',
          'chordTheory.keysHint' => 'El grado que ocupa en cada tonalidad.',
          'chordTheory.keyChip' => ({
            required Object roman,
            required Object key,
          }) => '${roman} en ${key}',
          'chordTheory.keyMajor' => ({required Object note}) => '${note} mayor',
          'chordTheory.keyMinor' => ({required Object note}) => '${note} menor',
          'chordTheory.variantsTitle' => 'Variantes de este acorde',
          'chordTheory.positionsCount' => ({
            required Object n,
          }) => 'Posiciones (${n})',
          'chordTheory.filterAll' => 'Todas',
          'chordTheory.variantsEmpty' => 'Ninguna posición de este tipo.',
          'chordTheory.relativesTitle' => 'Acordes parientes',
          'chordTheory.relativesHint' =>
            'La misma raíz con otro color: toca uno para ver su ficha.',
          'chordTheory.relativeOf' => ({
            required Object name,
          }) => 'Relativo: ${name}',
          'chordTheory.whereTitle' => 'Dónde se usa',
          'chordTheory.genresLabel' => 'Géneros',
          'chordTheory.progressionsLabel' => 'En las progresiones',
          'chordTheory.progressionRow' => ({
            required Object degree,
            required Object key,
          }) => '${degree} en ${key}',
          'chordTheory.noProgressions' =>
            'Todavía no está en ninguna progresión del catálogo.',
          'chordTheory.variantTriad' => ({
            required Object strings,
            required Object inversion,
          }) => 'Tríada cuerdas ${strings} · ${inversion}',
          'chordTheory.variantShell' => ({
            required Object degrees,
            required Object strings,
          }) => 'Shell ${degrees} · cuerdas ${strings}',
          'chordTheory.variantVoicing' => ({
            required Object strings,
            required Object inversion,
          }) => 'Voicing · cuerdas ${strings} · ${inversion}',
          'chordTheory.variantDrop2' => ({
            required Object strings,
            required Object inversion,
          }) => 'Drop 2 · cuerdas ${strings} · ${inversion}',
          'chordTheory.variantDrop3' => ({
            required Object strings,
            required Object inversion,
          }) => 'Drop 3 · cuerdas ${strings} · ${inversion}',
          'chordTheory.inversionRoot' => 'posición fundamental',
          'chordTheory.inversionFirst' => '1ª inversión',
          'chordTheory.inversionSecond' => '2ª inversión',
          'chordTheory.inversionThird' => '3ª inversión',
          'chordTheory.inversionOther' => ({
            required Object degree,
          }) => '${degree} en el bajo',
          'chordTheory.shapeNameFormat' => ({
            required Object note,
            required Object rest,
          }) => 'Forma de ${note}${rest}',
          'chordTheory.fretSuffix' => ({
            required Object name,
            required Object n,
          }) => '${name} · traste ${n}',
          'chordTheory.shapeNames.e-power' => 'Power cuerda 6',
          'chordTheory.shapeNames.a-power' => 'Power cuerda 5',
          'chordTheory.shapeNames.d-power' => 'Power cuerda 4',
          'chordTheory.shapeNames.e-power-4' => 'Power 4 cuerdas',
          'chordTheory.shapeNames.a-power-4' => 'Power 4 cuerdas (5ª)',
          'chordTheory.shapeNames.e-power-5' => 'Power con octava (5 cuerdas)',
          'chordTheory.shapeWords.menor' => 'menor',
          'chordTheory.shapeWords.corta' => 'corta',
          'chordTheory.shapeWords.(corta)' => '(corta)',
          'chordTheory.shapeWords.(aguda)' => '(aguda)',
          'chordTheory.shapeWords.(abierta)' => '(abierta)',
          'chordTheory.shapeWords."(alt.)"' => '(alt.)',
          'chordTheory.shapeWords.(3' => '(3',
          'chordTheory.shapeWords.dedos)' => 'dedos)',
          'chordTheory.shapeWords.(raíz' => '(raíz',
          'chordTheory.shapeWords.en' => 'en',
          'chordTheory.shapeWords.6ª)' => '6ª)',
          'scalesPlus.names.major' => 'mayor (jónica)',
          'scalesPlus.names.dorian' => 'dórica',
          'scalesPlus.names.phrygian' => 'frigia',
          'scalesPlus.names.lydian' => 'lidia',
          'scalesPlus.names.mixolydian' => 'mixolidia',
          'scalesPlus.names.minor' => 'menor natural (eólica)',
          'scalesPlus.names.locrian' => 'locria',
          'scalesPlus.names.harmonicMinor' => 'menor armónica',
          'scalesPlus.names.melodicMinor' => 'menor melódica',
          'scalesPlus.names.locrianNatural6' => 'locria ♮6',
          'scalesPlus.names.ionianSharp5' => 'jónica #5',
          'scalesPlus.names.ukrainianDorian' => 'dórica #4 (ucraniana)',
          'scalesPlus.names.phrygianDominant' => 'frigia dominante',
          'scalesPlus.names.lydianSharp2' => 'lidia #2',
          'scalesPlus.names.superLocrianBb7' => 'superlocria bb7',
          'scalesPlus.names.dorianFlat2' => 'dórica b2',
          'scalesPlus.names.lydianAugmented' => 'lidia aumentada',
          'scalesPlus.names.lydianDominant' => 'lidia dominante',
          'scalesPlus.names.mixolydianFlat6' => 'mixolidia b6',
          'scalesPlus.names.locrianSharp2' => 'locria #2 (semilocria)',
          'scalesPlus.names.altered' => 'alterada (superlocria)',
          'scalesPlus.names.minorPentatonic' => 'pentatónica menor',
          'scalesPlus.names.majorPentatonic' => 'pentatónica mayor',
          'scalesPlus.names.blues' => 'escala de blues',
          'scalesPlus.names.majorBlues' => 'blues mayor',
          'scalesPlus.names.minorHexatonic' =>
            'pentatónica menor con 9ª (hexatónica)',
          'scalesPlus.names.suspendedPentatonic' =>
            'pentatónica suspendida (egipcia)',
          'scalesPlus.names.wholeTone' => 'tonos enteros',
          'scalesPlus.names.diminishedWholeHalf' =>
            'disminuida (tono-semitono)',
          'scalesPlus.names.diminishedHalfWhole' =>
            'disminuida (semitono-tono)',
          'scalesPlus.names.augmentedScale' => 'aumentada',
          'scalesPlus.names.bebopDominant' => 'bebop dominante',
          'scalesPlus.names.bebopMajor' => 'bebop mayor',
          'scalesPlus.names.hungarianMinor' => 'húngara menor',
          'scalesPlus.names.doubleHarmonic' => 'doble armónica (arábiga)',
          'scalesPlus.names.hirajoshi' => 'hirajoshi',
          'scalesPlus.names.neapolitanMinor' => 'napolitana menor',
          'scalesPlus.names.persian' => 'persa',
          'scalesPlus.about.major' =>
            'La base de la armonía: alegre, estable y luminosa.',
          'scalesPlus.about.dorian' =>
            'Menor con sexta mayor: elegante y con ritmo, ni triste ni dulce.',
          'scalesPlus.about.phrygian' =>
            'Menor con segunda menor: oscura, tensa y con aire de flamenco.',
          'scalesPlus.about.lydian' =>
            'Mayor con cuarta aumentada: flotante, soñadora y de cine.',
          'scalesPlus.about.mixolydian' =>
            'Mayor con séptima menor: relajada, de rock clásico y country.',
          'scalesPlus.about.minor' =>
            'La menor de siempre: melancólica, épica y muy cantable.',
          'scalesPlus.about.locrian' =>
            'Menor con segunda y quinta bemol: la más inestable, sin reposo.',
          'scalesPlus.about.harmonicMinor' => 'Menor con la séptima elevada: dramática y clásica, con un salto exótico.',
          'scalesPlus.about.melodicMinor' => 'Menor con sexta y séptima mayores: suave y misteriosa, base del jazz moderno.',
          'scalesPlus.about.locrianNatural6' =>
            'Locria con sexta natural: tensa y poco usada, de color oscuro.',
          'scalesPlus.about.ionianSharp5' =>
            'Mayor con quinta aumentada: luminosa e inquieta.',
          'scalesPlus.about.ukrainianDorian' =>
            'Dórica con cuarta aumentada: sabor de Europa del Este y klezmer.',
          'scalesPlus.about.phrygianDominant' => 'Frigia con tercera mayor: el sonido del flamenco y de Oriente Medio.',
          'scalesPlus.about.lydianSharp2' =>
            'Lidia con segunda aumentada: brillante, rara y llamativa.',
          'scalesPlus.about.superLocrianBb7' =>
            'La más tensa de la armónica: simétrica y disminuida.',
          _ => null,
        } ??
        switch (path) {
          'scalesPlus.about.dorianFlat2' =>
            'Dórica con segunda menor: oscura y cinematográfica.',
          'scalesPlus.about.lydianAugmented' =>
            'Lidia con quinta aumentada: etérea, de acordes maj7#5.',
          'scalesPlus.about.lydianDominant' => 'Mixolidia con cuarta aumentada: dominante brillante de jazz y fusión.',
          'scalesPlus.about.mixolydianFlat6' =>
            'Mixolidia con sexta menor: entre lo mayor y lo menor, aire hindú.',
          'scalesPlus.about.locrianSharp2' =>
            'Locria con segunda mayor: la más suave sobre los acordes m7b5.',
          'scalesPlus.about.altered' =>
            'Toda la tensión de un dominante: b9, #9, b5 y #5 a la vez.',
          'scalesPlus.about.minorPentatonic' =>
            'Cinco notas que nunca fallan: el corazón del rock y el blues.',
          'scalesPlus.about.majorPentatonic' =>
            'Dulce y abierta: country, pop, soul y solos melódicos.',
          'scalesPlus.about.blues' =>
            'Pentatónica menor con la blue note (b5): pura actitud.',
          'scalesPlus.about.majorBlues' => 'Pentatónica mayor con la tercera menor de paso: blues alegre y country.',
          'scalesPlus.about.minorHexatonic' => 'Pentatónica menor con novena: suave y moderna, entre el rock y el jazz.',
          'scalesPlus.about.suspendedPentatonic' =>
            'Sin terceras: abierta, ambigua y muy usada en pop y ambient.',
          'scalesPlus.about.wholeTone' =>
            'Seis tonos seguidos: flotante, sin tónica clara, de ensueño.',
          'scalesPlus.about.diminishedWholeHalf' =>
            'Tono-semitono: simétrica, para acordes disminuidos.',
          'scalesPlus.about.diminishedHalfWhole' => 'Semitono-tono: simétrica, con todas las tensiones de un dominante.',
          'scalesPlus.about.augmentedScale' =>
            'Tercera menor y semitono alternados: simétrica y moderna.',
          'scalesPlus.about.bebopDominant' => 'Mixolidia con la séptima mayor de paso: corcheas que caen en los tiempos.',
          'scalesPlus.about.bebopMajor' =>
            'Mayor con la sexta menor de paso: líneas fluidas de bebop.',
          'scalesPlus.about.hungarianMinor' =>
            'Menor armónica con cuarta aumentada: dramática, gitana y oscura.',
          'scalesPlus.about.doubleHarmonic' =>
            'Dos segundas aumentadas: sabor arábigo, bizantino y flamenco.',
          'scalesPlus.about.hirajoshi' =>
            'Cinco notas japonesas: contemplativa, de koto y de anime.',
          'scalesPlus.about.neapolitanMinor' =>
            'Menor armónica con segunda bemol: clásica y trágica.',
          'scalesPlus.about.persian' =>
            'Siete notas con segunda y quinta bemol: exótica y muy tensa.',
          'scalesPlus.styles.major' =>
            'Pop, folk, country, canciones infantiles.',
          'scalesPlus.styles.dorian' =>
            'Funk, jazz, Santana, Pink Floyd, soul.',
          'scalesPlus.styles.phrygian' => 'Flamenco, metal, música oscura.',
          'scalesPlus.styles.lydian' =>
            'Bandas sonoras, Joe Satriani, indie, jazz.',
          'scalesPlus.styles.mixolydian' =>
            'Rock clásico, blues, country, funk.',
          'scalesPlus.styles.minor' => 'Baladas, rock, metal, pop triste.',
          'scalesPlus.styles.locrian' => 'Metal, jazz sobre acordes m7b5.',
          'scalesPlus.styles.harmonicMinor' =>
            'Clásica, flamenco, metal neoclásico, boleros.',
          'scalesPlus.styles.melodicMinor' => 'Jazz, fusión, música de cine.',
          'scalesPlus.styles.locrianNatural6' =>
            'Jazz avanzado y metal progresivo.',
          'scalesPlus.styles.ionianSharp5' => 'Jazz moderno sobre maj7#5.',
          'scalesPlus.styles.ukrainianDorian' =>
            'Klezmer, música balcánica, metal folk.',
          'scalesPlus.styles.phrygianDominant' =>
            'Flamenco, surf rock, klezmer, metal.',
          'scalesPlus.styles.lydianSharp2' => 'Jazz moderno y fusión.',
          'scalesPlus.styles.superLocrianBb7' =>
            'Jazz avanzado, sobre acordes dim7 con tensión.',
          'scalesPlus.styles.dorianFlat2' =>
            'Jazz moderno, bandas sonoras, metal.',
          'scalesPlus.styles.lydianAugmented' =>
            'Jazz, fusión y pasajes etéreos.',
          'scalesPlus.styles.lydianDominant' =>
            'Jazz, fusión, bossa y funk (7#11).',
          'scalesPlus.styles.mixolydianFlat6' =>
            'Jazz, bandas sonoras y fusión.',
          'scalesPlus.styles.locrianSharp2' =>
            'Jazz sobre acordes m7b5 (el ii de los menores).',
          'scalesPlus.styles.altered' =>
            'Jazz: V7 alterado que resuelve a un acorde menor o mayor.',
          'scalesPlus.styles.minorPentatonic' =>
            'Rock, blues, metal, funk, cualquier solo.',
          'scalesPlus.styles.majorPentatonic' =>
            'Country, pop, soul, gospel, solos dulces.',
          'scalesPlus.styles.blues' => 'Blues, rock, hard rock, funk.',
          'scalesPlus.styles.majorBlues' =>
            'Blues alegre, country, soul, rock sureño.',
          'scalesPlus.styles.minorHexatonic' => 'Rock suave, fusión, neo-soul.',
          'scalesPlus.styles.suspendedPentatonic' =>
            'Pop, ambient, rock progresivo, música étnica.',
          'scalesPlus.styles.wholeTone' =>
            'Impresionismo, jazz (Monk), bandas sonoras oníricas.',
          'scalesPlus.styles.diminishedWholeHalf' =>
            'Jazz, música clásica, metal (acordes dim).',
          'scalesPlus.styles.diminishedHalfWhole' =>
            'Jazz sobre dominantes con b9, #9 y #11.',
          'scalesPlus.styles.augmentedScale' =>
            'Jazz moderno y fusión (Coltrane).',
          'scalesPlus.styles.bebopDominant' =>
            'Jazz bebop sobre acordes dominantes (7).',
          'scalesPlus.styles.bebopMajor' =>
            'Jazz bebop sobre acordes mayores (maj7, 6).',
          'scalesPlus.styles.hungarianMinor' =>
            'Música gitana, metal neoclásico, bandas sonoras.',
          'scalesPlus.styles.doubleHarmonic' =>
            'Música arábiga, flamenco, surf rock, metal.',
          'scalesPlus.styles.hirajoshi' =>
            'Música japonesa, metal, bandas sonoras.',
          'scalesPlus.styles.neapolitanMinor' =>
            'Música clásica, metal neoclásico.',
          'scalesPlus.styles.persian' =>
            'Música persa, árabe y metal oriental.',
          'scalesPlus.groups.major' => 'Mayor y modos',
          'scalesPlus.groups.minor' => 'Menores',
          'scalesPlus.groups.pentatonic' => 'Pentatónicas y blues',
          'scalesPlus.groups.exotic' => 'Exóticas y simétricas',
          'scalesPlus.sections.majorModes' => 'Los siete modos de la mayor',
          'scalesPlus.sections.minors' => 'Menor natural, armónica y melódica',
          'scalesPlus.sections.harmonicModes' => 'Modos de la menor armónica',
          'scalesPlus.sections.melodicModes' => 'Modos de la menor melódica',
          'scalesPlus.sections.pentatonics' =>
            'Pentatónicas, blues y hexatónicas',
          'scalesPlus.sections.symmetric' => 'Simétricas y bebop',
          'scalesPlus.sections.exotic' => 'Exóticas',
          'scalesPlus.notesCount' => ({required Object n}) => '${n} notas',
          'scalesPlus.formulaTitle' => 'Fórmula',
          'scalesPlus.formulaLine' => ({
            required Object degrees,
          }) => '${degrees}',
          'scalesPlus.intervalsLine' => ({
            required Object steps,
          }) => 'Intervalos: ${steps}',
          'scalesPlus.characterTitle' => 'Carácter',
          'scalesPlus.stylesTitle' => 'Dónde se usa',
          'scalesPlus.characteristicNote' => ({
            required Object degree,
          }) => 'Nota característica: ${degree}',
          'scalesPlus.harmonyTitle' => 'Acordes de la escala',
          'scalesPlus.triads' => 'Tríadas',
          'scalesPlus.sevenths' => 'Séptimas',
          'scalesPlus.noHarmony' => ({
            required Object n,
          }) => 'Con ${n} notas no forma acordes por terceras: úsala sobre un acorde fijo, como un color.',
          'scalesPlus.positionsFive' => '5 cajas de dos notas por cuerda',
          'scalesPlus.positionsSeven' =>
            '7 posiciones de tres notas por cuerda',
          'scalesPlus.positionsExtras' => ({
            required Object n,
          }) => '${n} cajas de su escala base más las notas de paso',
          'scalesPlus.positionsWindow' => ({
            required Object n,
          }) => '${n} ventanas de trastes (escala simétrica)',
          'scalesPlus.playUpDown' => 'Sube y baja',
          'scalesPlus.chordScalesTitle' => 'Escala para improvisar',
          'scalesPlus.chordScaleHint' => ({
            required Object chord,
            required Object scale,
          }) => 'Sobre ${chord} suena bien: ${scale}',
          'scalesPlus.chordScaleAlso' => ({
            required Object scales,
          }) => 'También: ${scales}',
          'scalesPlus.openInExplorer' => 'Ver en el explorador',
          'logs.title' => 'Diagnóstico',
          'logs.clear' => 'Vaciar registro',
          'logs.total' => 'Total',
          'logs.errors' => 'Errores',
          'logs.warnings' => 'Avisos',
          'logs.allLevels' => 'Todo',
          'logs.empty' => 'Sin eventos registrados',
          'router.notFound' => 'Ruta no encontrada',
          'router.goHome' => 'Ir al inicio',
          'mic.deniedTitle' => 'Necesito tu micrófono',
          'mic.deniedMessage' => 'Activa el permiso de micrófono en los ajustes del teléfono y vuelve a intentarlo.',
          'mic.errorTitle' => 'No pude escuchar',
          'mic.errorMessage' => 'Algo falló al abrir el micrófono. Comprueba que otra app no lo esté usando.',
          'mic.retry' => 'Reintentar',
          'mic.levelLabel' => 'Nivel del micrófono',
          'mic.levelWaiting' => 'Esperando sonido…',
          'mic.levelQuiet' => 'Apenas te oigo: acerca la guitarra al micrófono',
          'mic.levelGood' => 'Te escucho bien',
          'mic.levelLoud' => 'Suena muy fuerte: aleja un poco la guitarra',
          'tuner.pluckPrompt' => 'Toca una cuerda al aire',
          'tuner.pluckString' => ({
            required Object string,
          }) => 'Toca la ${string}',
          'tuner.stringTitle' => ({
            required Object ordinal,
            required Object note,
          }) => '${ordinal} cuerda · ${note}',
          'tuner.noteE' => 'Mi',
          'tuner.noteA' => 'La',
          'tuner.noteD' => 'Re',
          'tuner.noteG' => 'Sol',
          'tuner.noteB' => 'Si',
          'tuner.tuned' => '¡Afinada!',
          'tuner.upLittle' => 'Sube un poco',
          'tuner.up' => 'Sube',
          'tuner.upALot' => 'Sube mucho',
          'tuner.downLittle' => 'Baja un poco',
          'tuner.down' => 'Baja',
          'tuner.downALot' => 'Baja mucho',
          'tuner.tightenPeg' => 'Aprieta la clavija',
          'tuner.loosenPeg' => 'Afloja la clavija',
          'tuner.holdSteady' => 'Mantén la nota sonando',
          'tuner.heardOther' => ({
            required Object heard,
            required Object target,
          }) => 'Esa suena como la ${heard}. Toca la ${target}.',
          'tuner.flat' => 'Floja',
          'tuner.sharp' => 'Alta',
          'tuner.cents' => ({required Object cents}) => '${cents} cents',
          'tuner.allTunedTitle' => '¡Guitarra afinada!',
          'tuner.allTunedMessage' =>
            'Las seis cuerdas están en su sitio. ¡A tocar!',
          'tuner.peg' => ({
            required Object string,
          }) => 'Clavija de la ${string}',
          'tuner.meterLabel' => ({
            required Object cents,
          }) => 'Afinación: ${cents} cents',
          'tuner.activate' => 'Activar micrófono',
          'tuner.modeAuto' => 'Automático · toca una clavija para fijarla',
          'tuner.modeManual' => ({
            required Object string,
          }) => 'Fijada: ${string}',
          'tuner.chordsTitle' => 'Detectar acordes',
          'tuner.switchToChords' => 'Detectar acordes',
          'tuner.switchToTuner' => 'Volver al afinador',
          'practice.title' => 'Practicar acorde',
          'practice.intro' => 'Toca las cuerdas una a una. Las reconozco en el orden que quieras.',
          'practice.start' => 'Empezar a practicar',
          'practice.stop' => 'Detener',
          'practice.restart' => 'Otra vez',
          'practice.listenChord' => 'Escuchar acorde',
          'practice.listenString' => 'Escuchar cuerda',
          'practice.progress' => ({
            required Object count,
            required Object total,
          }) => '${count} de ${total} cuerdas',
          'practice.nextOpen' => ({
            required Object string,
          }) => 'Ahora toca la ${string} al aire',
          'practice.nextFretted' => ({
            required Object string,
            required Object fret,
            required Object finger,
          }) => 'Ahora toca la ${string}: traste ${fret} con ${finger}',
          'practice.nextFrettedAny' => ({
            required Object string,
            required Object fret,
          }) => 'Ahora toca la ${string}: traste ${fret}',
          'practice.muted' => 'Muda',
          'practice.open' => 'Al aire',
          'practice.fret' => ({required Object fret}) => 'Traste ${fret}',
          'practice.mutedHint' => 'No toques esta cuerda',
          'practice.matched' => 'Bien',
          'practice.doneTitle' => '¡Acorde limpio!',
          'practice.doneMessage' => 'Todas las cuerdas suenan como deben. Repítelo despacio hasta que salga solo.',
          'practice.retune' => 'Reafinar cuerda',
          'practice.tipsTitle' => 'Cómo corregirla',
          'practice.fingerThe' => ({required Object n}) => 'el dedo ${n}',
          'practice.fingerAny' => 'el dedo',
          'practice.tipSoundsOpen' => ({
            required Object string,
            required Object fret,
            required Object finger,
          }) => 'La ${string} suena al aire: pisa el traste ${fret} con ${finger}.',
          'practice.tipMoveUp' =>
            ({
              required num n,
              required Object finger,
            }) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
              n,
              one: 'Suena más grave. Sube ${finger} un traste hacia la caja.',
              other:
                  'Suena más grave. Sube ${finger} ${n} trastes hacia la caja.',
            ),
          'practice.tipMoveDown' =>
            ({
              required num n,
              required Object finger,
            }) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
              n,
              one:
                  'Suena más aguda. Baja ${finger} un traste hacia el clavijero.',
              other:
                  'Suena más aguda. Baja ${finger} ${n} trastes hacia el clavijero.',
            ),
          'practice.tipTooFlat' => ({
            required Object finger,
          }) => 'Suena algo baja. Acerca ${finger} al traste (sin pisarlo) o reafina la cuerda.',
          'practice.tipTooSharp' => 'Suena algo alta. Presiona con menos fuerza, sin estirar la cuerda, o reafínala.',
          'practice.tipRetuneUp' => ({
            required Object string,
          }) => 'La ${string} al aire suena baja: sube un poco la clavija.',
          'practice.tipRetuneDown' => ({
            required Object string,
          }) => 'La ${string} al aire suena alta: baja un poco la clavija.',
          'practice.tipUnknown' => ({
            required Object string,
          }) => 'No reconozco esa nota. Toca solo la ${string}, con calma.',
          'profile.title' => 'Tu perfil',
          'profile.edit' => 'Editar perfil',
          'profile.summary' => ({
            required Object guitar,
            required Object level,
          }) => '${guitar} · ${level}',
          'profile.guitar' => 'Guitarra',
          'profile.play' => 'Forma de tocar',
          'profile.genres' => 'Géneros',
          'profile.experience' => 'Experiencia',
          'profile.personalizedHint' => 'Recomendaciones según tu perfil',
          'profile.setupHint' => 'Cuéntame cómo tocas y personalizo todo',
          'minigames.hubTitle' => 'Jugar',
          'minigames.hubSubtitle' => 'Entrena el oído, el mástil y tus dedos',
          'minigames.starsTotal' => ({
            required Object earned,
            required Object total,
          }) => '${earned} de ${total} estrellas',
          'minigames.chordGameTitle' => 'Toca el acorde',
          'minigames.chordGameSubtitle' =>
            'Encadena una serie de acordes con el micrófono',
          'minigames.earTitle' => 'Entrena el oído',
          'minigames.earSubtitle' => 'Solo escuchas y reconoces: sin guitarra',
          'minigames.fretboardTitle' => 'Mástil y dedos',
          'minigames.fretboardSubtitle' =>
            'Aprende dónde está cada nota y cada dedo',
          'minigames.playTitle' => 'Toca la guitarra',
          'minigames.playSubtitle' => 'El micrófono comprueba lo que tocas',
          'minigames.needsMic' => 'Micrófono',
          'minigames.unplayed' => 'Sin jugar',
          'minigames.levelTitle' => 'Dificultad',
          'minigames.levelEasy' => 'Fácil',
          'minigames.levelMedium' => 'Media',
          'minigames.levelHard' => 'Difícil',
          'minigames.levelBest' => ({
            required Object percent,
          }) => 'Mejor: ${percent}%',
          'minigames.howToPlay' => 'Cómo se juega',
          'minigames.earTip' =>
            'Mejor con auriculares y en un sitio tranquilo.',
          'minigames.micTip' => 'Necesitas tu guitarra afinada y el micrófono.',
          'minigames.start' => 'Empezar',
          'minigames.questionOf' => ({
            required Object n,
            required Object total,
          }) => 'Pregunta ${n} de ${total}',
          'minigames.roundOf' => ({
            required Object n,
            required Object total,
          }) => 'Ronda ${n} de ${total}',
          'minigames.listen' => 'Escuchar',
          'minigames.listenAgain' => 'Escuchar otra vez',
          'minigames.listening' => 'Escuchando…',
          'minigames.streak' => 'Racha',
          'minigames.points' => 'Puntos',
          'minigames.correct' => '¡Correcto!',
          'minigames.wrong' => ({required Object answer}) => 'Era: ${answer}',
          'minigames.wrongSequence' => ({
            required Object sequence,
          }) => 'La secuencia era: ${sequence}',
          'minigames.next' => 'Siguiente',
          'minigames.seeResult' => 'Ver resultado',
          'minigames.yourTurn' => ({
            required Object done,
            required Object total,
          }) => 'Tu turno: ${done} de ${total}',
          'minigames.resultTitle0' => 'Sigue practicando',
          'minigames.resultTitle1' => 'Buen comienzo',
          'minigames.resultTitle2' => '¡Muy bien!',
          'minigames.resultTitle3' => '¡Perfecto!',
          'minigames.resultCorrect' => ({
            required Object correct,
            required Object total,
          }) => '${correct} de ${total} aciertos',
          'minigames.resultStreak' => ({
            required Object n,
          }) => 'Mejor racha: ${n}',
          'minigames.resultPoints' => ({required Object n}) => '${n} puntos',
          'minigames.playAgain' => 'Jugar otra vez',
          'minigames.moreGames' => 'Más juegos',
          'minigames.newBest' => '¡Nuevo récord!',
          'minigames.buildHint' => 'Ver pista',
          'minigames.buildCheck' => 'Comprobar',
          'minigames.buildClear' => 'Borrar todo',
          'minigames.buildPlayIt' => 'Ahora tócalo',
          'minigames.buildTapHint' => 'Toca una casilla para poner un dedo. Toca las marcas de arriba para dejar la cuerda al aire o silenciada.',
          'minigames.buildWrong' => 'Revisa las cuerdas marcadas en rojo.',
          'minigames.buildCorrect' => '¡Así se hace!',
          'minigames.buildCorrectBody' =>
            'Ahora tócalo en tu guitarra y comprueba cómo suena.',
          'minigames.buildHinted' => 'Con pista no suma acierto.',
          'minigames.buildMuted' => 'Silenciada',
          'minigames.buildOpen' => 'Al aire',
          'minigames.buildCell' => ({
            required Object string,
            required Object fret,
          }) => 'Cuerda ${string}, traste ${fret}',
          'minigames.buildMark' => ({
            required Object string,
            required Object state,
          }) => 'Cuerda ${string}: ${state}',
          'minigames.micListening' => 'Toca ahora…',
          'minigames.micHeard' => ({required Object note}) => 'Oigo: ${note}',
          'minigames.micProgress' => ({
            required Object done,
            required Object total,
          }) => '${done} de ${total} notas',
          'minigames.micTimeUp' => 'Se acabó el tiempo',
          'minigames.micSuccess' => '¡Bien tocado!',
          'minigames.micHearIt' => 'Escuchar la nota',
          'minigames.micHearMelody' => 'Escuchar la melodía',
          'minigames.micSkip' => 'Saltar',
          'minigames.micHintFret' => ({
            required Object string,
            required Object fret,
          }) => 'Pista: cuerda ${string}, traste ${fret}',
          'minigames.micHintOpen' => ({
            required Object string,
          }) => 'Pista: cuerda ${string} al aire',
          'minigames.micSeconds' => ({required Object n}) => '${n} s',
          'minigames.prompt.guessNote' => '¿Qué nota suena?',
          'minigames.prompt.whichString' => '¿Qué cuerda suena?',
          'minigames.prompt.whichFret' => ({
            required Object string,
          }) => 'Suena la ${string} al aire y luego pulsada. ¿En qué traste?',
          'minigames.prompt.interval' => '¿Qué intervalo suena?',
          'minigames.prompt.higherLower' => '¿Cuál suena más agudo?',
          'minigames.prompt.chordQuality' => '¿Qué tipo de acorde suena?',
          'minigames.prompt.nameChord' => '¿Qué acorde suena?',
          'minigames.prompt.tuneEar' =>
            'Escucha la referencia. ¿Cómo está la segunda nota?',
          'minigames.prompt.memory' =>
            'Escucha y repite la secuencia de cuerdas',
          'minigames.prompt.noteAtFret' => ({
            required Object string,
            required Object fret,
          }) => '¿Qué nota suena en la ${string}, traste ${fret}?',
          'minigames.prompt.fretOfNote' => ({
            required Object string,
            required Object note,
          }) => '¿En qué traste de la ${string} está ${note}?',
          'minigames.prompt.fingerQuiz' => ({
            required Object string,
          }) => '¿Qué dedo pisa la ${string}?',
          'minigames.prompt.readDiagram' => '¿Qué acorde es este?',
          'minigames.prompt.buildChord' => ({
            required Object chord,
          }) => 'Forma el acorde ${chord}',
          'minigames.prompt.playNote' => ({
            required Object note,
          }) => 'Toca la nota ${note}',
          'minigames.prompt.playStringFret' => ({
            required Object string,
            required Object fret,
          }) => 'Toca la ${string} en el traste ${fret}',
          'minigames.prompt.echo' => 'Escucha y toca la melodía',
          'minigames.prompt.noteAtOpen' => ({
            required Object string,
          }) => '¿Qué nota suena en la ${string} al aire?',
          'minigames.prompt.playStringOpen' => ({
            required Object string,
          }) => 'Toca la ${string} al aire',
          'minigames.prompt.scaleNote' => ({
            required Object scale,
          }) => '¿Qué nota está en ${scale}?',
          'minigames.prompt.keyChord' => ({
            required Object key,
            required Object degree,
          }) => 'En ${key}, ¿cuál es el acorde ${degree}?',
          'minigames.prompt.scaleDegree' => ({
            required Object key,
            required Object note,
          }) => 'En ${key}, ¿qué grado es ${note}?',
          'minigames.prompt.findTonic' =>
            'Escucha la cadencia. ¿Cuál es la tónica?',
          'minigames.prompt.progressionEar' => '¿Qué progresión suena?',
          'minigames.titles.guessNote' => 'Adivina la nota',
          'minigames.titles.whichString' => '¿Qué cuerda es?',
          'minigames.titles.whichFret' => '¿Qué traste es?',
          'minigames.titles.interval' => 'Intervalos',
          'minigames.titles.higherLower' => 'Agudo o grave',
          'minigames.titles.chordQuality' => 'Mayor o menor',
          'minigames.titles.nameChord' => 'Reconoce el acorde',
          'minigames.titles.tuneEar' => 'Oído de afinador',
          'minigames.titles.memory' => 'Memoria de cuerdas',
          'minigames.titles.noteAtFret' => 'Notas del mástil',
          'minigames.titles.fretOfNote' => 'Busca la nota',
          'minigames.titles.fingerQuiz' => '¿Qué dedo?',
          'minigames.titles.readDiagram' => 'Lee el diagrama',
          'minigames.titles.buildChord' => 'Arma el acorde',
          'minigames.titles.playNote' => 'Toca la nota',
          'minigames.titles.playStringFret' => 'Cuerda y traste',
          'minigames.titles.echo' => 'Eco de guitarra',
          'minigames.titles.scaleNote' => 'Notas de la escala',
          'minigames.titles.keyChord' => 'Acordes del tono',
          'minigames.titles.scaleDegree' => '¿Qué grado es?',
          'minigames.titles.findTonic' => 'Encuentra la tónica',
          'minigames.titles.progressionEar' => 'Progresión al oído',
          'minigames.descriptions.guessNote' => 'Suena una nota: ¿cuál es?',
          'minigames.descriptions.whichString' => 'Reconoce la cuerda al aire',
          'minigames.descriptions.whichFret' => 'Oye cuántos trastes sube',
          'minigames.descriptions.interval' => 'Distancia entre dos notas',
          'minigames.descriptions.higherLower' => 'Compara dos notas',
          'minigames.descriptions.chordQuality' =>
            'Distingue mayor, menor y séptima',
          'minigames.descriptions.nameChord' => 'Escucha y nombra el acorde',
          'minigames.descriptions.tuneEar' => '¿Floja, afinada o alta?',
          'minigames.descriptions.memory' => 'Repite la secuencia que oyes',
          'minigames.descriptions.noteAtFret' =>
            'Nombre de la nota en el mástil',
          'minigames.descriptions.fretOfNote' =>
            'Encuentra el traste de la nota',
          'minigames.descriptions.fingerQuiz' => 'Qué dedo pisa cada cuerda',
          'minigames.descriptions.readDiagram' =>
            'De la forma al nombre del acorde',
          'minigames.descriptions.buildChord' => 'Del nombre a la posición',
          'minigames.descriptions.playNote' => 'Toca la nota que se pide',
          'minigames.descriptions.playStringFret' => 'Toca una posición exacta',
          'minigames.descriptions.echo' => 'Escucha y toca la melodía',
          'minigames.descriptions.scaleNote' =>
            'Reconoce qué nota pertenece a cada escala',
          'minigames.descriptions.keyChord' =>
            'El IV de Sol, el V de La… al instante',
          'minigames.descriptions.scaleDegree' =>
            'Pon número a cada nota de la tonalidad',
          'minigames.descriptions.findTonic' =>
            'Escucha y descubre la nota «casa»',
          'minigames.descriptions.progressionEar' =>
            'Distingue el I-IV-V del I-V-vi-IV',
          'minigames.howTo.guessNote' => 'Oirás una nota suelta de la guitarra. Elige su nombre. En fácil solo hay notas naturales; en difícil, las doce.',
          'minigames.howTo.whichString' => 'Oirás una cuerda al aire. Di cuál es, de la 6ª (la más grave) a la 1ª (la más aguda). En fácil hay solo tres.',
          'minigames.howTo.whichFret' => 'Oirás la cuerda al aire y después pulsada en un traste. Cada traste sube un semitono: cuenta cuántos suben.',
          'minigames.howTo.interval' => 'Oirás dos notas seguidas, de grave a aguda. Reconoce la distancia entre ellas: tercera, quinta, octava…',
          'minigames.howTo.higherLower' => 'Oirás dos notas. Di si la primera o la segunda suena más aguda. En difícil casi no hay diferencia.',
          'minigames.howTo.chordQuality' => 'Oirás un acorde. Distingue si es mayor (brillante), menor (triste), séptima y más según subes de nivel.',
          'minigames.howTo.nameChord' => 'Oirás un acorde del banco. Elige su nombre entre varias opciones parecidas.',
          'minigames.howTo.tuneEar' => 'Oirás una nota de referencia y otra que puede estar floja, afinada o alta. Entrena el oído del afinador.',
          'minigames.howTo.memory' => 'Oirás una secuencia de cuerdas al aire. Tócalas en el mismo orden. Cada pregunta añade más notas.',
          'minigames.howTo.noteAtFret' => 'Se te da una cuerda y un traste. Di qué nota es. Aprenderás el mástil sin mirar la guitarra.',
          'minigames.howTo.fretOfNote' => 'Se te da una cuerda y una nota. Di en qué traste está (0 es la cuerda al aire).',
          'minigames.howTo.fingerQuiz' => 'Verás un acorde con una cuerda marcada y sin números. Di qué dedo la pisa: 1 índice, 2 medio, 3 anular, 4 meñique.',
          'minigames.howTo.readDiagram' => 'Verás el diagrama de una posición. Reconoce de qué acorde se trata.',
          'minigames.howTo.buildChord' => 'Se te da el nombre de un acorde. Pon los dedos en el mástil y comprueba. Después tócalo en tu guitarra.',
          'minigames.howTo.playNote' => 'Se te pide una nota. Tócala en cualquier cuerda: el micrófono la reconoce. Puedes escuchar la nota antes.',
          'minigames.howTo.playStringFret' => 'Se te pide una cuerda y un traste exactos. Pisa y toca: el micrófono comprueba que suena la nota correcta.',
          'minigames.howTo.echo' => 'Oirás una melodía corta. Tócala en tu guitarra nota a nota, en el mismo orden.',
          'minigames.howTo.scaleNote' => 'Se indica una escala y su tónica. Elige la única nota de las opciones que pertenece a esa escala. Usa la fórmula o imagina la caja en el mástil.',
          'minigames.howTo.keyChord' => 'Se indica una tonalidad y un grado en números romanos. Elige el acorde que ocupa ese grado. Recuerda: en mayor, I IV V son mayores; ii iii vi, menores.',
          'minigames.howTo.scaleDegree' => 'Se indica una tonalidad y una nota. Di qué grado ocupa (I = tónica, IV = subdominante, V = dominante…).',
          'minigames.howTo.findTonic' => 'Suena una cadencia de cuatro acordes que termina en casa. Elige la nota que suena a reposo: la tónica.',
          'minigames.howTo.progressionEar' => 'Suenan cuatro acordes. Elige qué progresión es, escrita en grados. Fíjate en si empieza en mayor o en menor y en cómo vuelve a casa.',
          'minigames.noteNames.n0' => 'Do',
          'minigames.noteNames.n1' => 'Do♯',
          'minigames.noteNames.n2' => 'Re',
          'minigames.noteNames.n3' => 'Re♯',
          'minigames.noteNames.n4' => 'Mi',
          'minigames.noteNames.n5' => 'Fa',
          'minigames.noteNames.n6' => 'Fa♯',
          'minigames.noteNames.n7' => 'Sol',
          'minigames.noteNames.n8' => 'Sol♯',
          'minigames.noteNames.n9' => 'La',
          'minigames.noteNames.n10' => 'La♯',
          'minigames.noteNames.n11' => 'Si',
          'minigames.intervalNames.i1' => '2ª menor',
          'minigames.intervalNames.i2' => '2ª mayor',
          'minigames.intervalNames.i3' => '3ª menor',
          'minigames.intervalNames.i4' => '3ª mayor',
          'minigames.intervalNames.i5' => '4ª justa',
          'minigames.intervalNames.i6' => 'Tritono',
          'minigames.intervalNames.i7' => '5ª justa',
          'minigames.intervalNames.i8' => '6ª menor',
          'minigames.intervalNames.i9' => '6ª mayor',
          'minigames.intervalNames.i10' => '7ª menor',
          'minigames.intervalNames.i11' => '7ª mayor',
          'minigames.intervalNames.i12' => 'Octava',
          'minigames.choice.fret' => ({required Object n}) => 'Traste ${n}',
          'minigames.choice.fretOpen' => 'Al aire',
          'minigames.choice.finger1' => '1 · Índice',
          'minigames.choice.finger2' => '2 · Medio',
          'minigames.choice.finger3' => '3 · Anular',
          'minigames.choice.finger4' => '4 · Meñique',
          'minigames.choice.first' => 'La primera',
          'minigames.choice.second' => 'La segunda',
          'minigames.choice.flat' => 'Floja (más grave)',
          'minigames.choice.inTune' => 'Afinada',
          'minigames.choice.sharp' => 'Alta (más aguda)',
          'minigames.buildMissed' => 'Así se forma. ¡Memorízalo y sigue!',
          'minigames.micPracticeNote' => 'Esta vez no suma puntos',
          'minigames.micPlayingMelody' => 'Escucha la melodía…',
          'minigames.theoryTitle' => 'Teoría musical',
          'minigames.theorySubtitle' => 'Escalas, tonalidades, grados y progresiones: entiende lo que tocas.',
          'guitar.ready' => 'Toca una cuerda al aire',
          'guitar.waiting' => 'Deja que se apague la nota…',
          'guitar.noMic' => 'No te oigo: revisa el micrófono o usa los botones',
          'guitar.openString' => ({
            required Object string,
          }) => '${string} al aire',
          'guitar.continueLabel' => 'Continuar',
          'guitar.retry' => 'Reintentar',
          'guitar.leave' => 'Salir',
          'guitar.open' => 'Abrir',
          'guitar.previousGame' => 'Anterior',
          'guitar.nextGame' => 'Siguiente',
          'guitar.getReady' => 'Prepara el acorde',
          'guitar.startsIn' => ({required Object n}) => 'Empiezo en ${n}',
          'guitar.imReady' => '¡Ya!',
          'guitar.setting' => 'Controlar con la guitarra',
          'guitar.settingSubtitle' => 'Toca una cuerda al aire para continuar, reintentar o salir sin tocar el móvil',
          'guitar.hubTitle' => 'Navegar con la guitarra',
          'guitar.hubSubtitle' =>
            'Toda la app con la guitarra: una nota aguda abre el menú',
          'guitar.hubSelected' => ({
            required Object name,
            required Object n,
            required Object total,
          }) => '${name} · ${n} de ${total}',
          'guitar.navMenu' => 'Menú',
          'guitar.navTitle' => 'Menú de la guitarra',
          'guitar.navWake' =>
            'Nota aguda (traste 14 o más de la 1ª cuerda): menú',
          'guitar.navHint' =>
            'En cualquier cuerda: Mi al aire y un traste más por destino',
          'guitar.navBack' => 'Atrás',
          'guitar.navClose' => 'Cerrar',
          'guitar.navOff' => 'Apagar',
          'guitar.navProfile' => 'Perfil',
          'guitar.navWakeShort' => 'Nota aguda',
          'guitar.navFretOpen' => 'al aire',
          'guitar.navFret' => ({required Object n}) => 'traste ${n}',
          'guitar.navSetting' => 'Modo guitarra en toda la app',
          'guitar.navSettingSubtitle' => 'Un panel fijo sustituye la barra de navegación: una nota aguda abre el menú y cada nota te lleva a una pantalla',
          'theory.title' => 'Escuela de guitarra',
          'theory.subtitle' =>
            'Entiende lo que tocas: tónica, escalas, posiciones y armonía.',
          'theory.unitBasics' => 'Fundamentos',
          'theory.unitScales' => 'Escalas y posiciones',
          'theory.unitHarmony' => 'Armonía y progresiones',
          'theory.keyPoints' => 'Ideas clave',
          'theory.tryIt' => 'Pruébalo en el mástil',
          'theory.openExplorer' => 'Abrir en el explorador',
          'theory.practiceGame' => ({
            required Object game,
          }) => 'Practica: ${game}',
          'theory.practiceJam' => ({
            required Object name,
          }) => 'Tócalo en el jam: ${name}',
          'theory.markLearned' => 'Marcar como aprendida',
          'theory.learned' => 'Aprendida',
          'theory.lessonsDone' => ({
            required Object done,
            required Object total,
          }) => '${done} de ${total} lecciones aprendidas',
          'theory.harmonyTitle' => ({
            required Object key,
          }) => 'Acordes de ${key}',
          'theory.scaleIn' => ({
            required Object note,
            required Object scale,
          }) => '${note} ${scale}',
          'theory.keyName' => ({
            required Object note,
            required Object mode,
          }) => '${note} ${mode}',
          'theory.majorMode' => 'mayor',
          'theory.minorMode' => 'menor',
          'theory.explorerTitle' => 'Explorador de escalas',
          'theory.explorerTonic' => 'Tónica',
          'theory.explorerScale' => 'Escala',
          'theory.explorerPosition' => 'Posición',
          'theory.allPositions' => 'Todo el mástil',
          'theory.positionN' => ({required Object n}) => 'Posición ${n}',
          'theory.showDegrees' => 'Grados',
          'theory.showNotes' => 'Notas',
          'theory.playScale' => 'Escuchar',
          'theory.stopScale' => 'Parar',
          'theory.explorerHint' => 'Toca una nota del mástil para oírla. Las tónicas van en color principal y la nota característica, resaltada.',
          'theory.formula' => ({
            required Object formula,
          }) => 'Fórmula: ${formula}',
          'theory.notesOf' => ({required Object notes}) => 'Notas: ${notes}',
          'theory.fretboardLabel' => ({
            required Object scale,
          }) => 'Mástil con ${scale}',
          'theory.genresTitle' => 'Géneros',
          'theory.genresSubtitle' => 'Cómo suena cada estilo: tempo, rasgueo, escalas, acordes y progresiones.',
          'theory.tempoRange' => ({
            required Object min,
            required Object max,
          }) => '${min}–${max} BPM',
          'theory.genreRhythmTitle' => 'Ritmo',
          'theory.genreTipTitle' => 'Consejo',
          'theory.genreScales' => 'Escalas para solear',
          'theory.genreChords' => 'Acordes típicos',
          'theory.genreProgressions' => 'Progresiones para jammear',
          'theory.genreSongs' => 'Canciones',
          'theory.genreLibrary' => ({
            required Object genre,
          }) => 'Ver acordes de ${genre} en la biblioteca',
          'theory.strumLabel' => ({required Object name}) => 'Rasgueo: ${name}',
          'theory.scaleNames.major' => 'mayor',
          'theory.scaleNames.minor' => 'menor natural',
          'theory.scaleNames.harmonicMinor' => 'menor armónica',
          'theory.scaleNames.minorPentatonic' => 'pentatónica menor',
          'theory.scaleNames.majorPentatonic' => 'pentatónica mayor',
          'theory.scaleNames.blues' => 'escala de blues',
          'theory.scaleNames.dorian' => 'dórica',
          'theory.scaleNames.phrygian' => 'frigia',
          'theory.scaleNames.lydian' => 'lidia',
          'theory.scaleNames.mixolydian' => 'mixolidia',
          'theory.scaleAbout.major' => 'La base de la armonía: alegre y estable. Pop, folk y canciones infantiles.',
          'theory.scaleAbout.minor' => 'La relativa de la mayor: melancólica y épica. Baladas, rock y metal.',
          'theory.scaleAbout.harmonicMinor' => 'Menor con la séptima elevada: sabor clásico, flamenco y neoclásico.',
          'theory.scaleAbout.minorPentatonic' =>
            'Cinco notas que nunca fallan: el corazón del rock y el blues.',
          'theory.scaleAbout.majorPentatonic' =>
            'Dulce y abierta: country, pop, soul y solos melódicos.',
          'theory.scaleAbout.blues' =>
            'Pentatónica menor con la blue note (b5): pura actitud.',
          'theory.scaleAbout.dorian' =>
            'Menor con sexta mayor: funk, jazz, Santana y Pink Floyd.',
          'theory.scaleAbout.phrygian' =>
            'Menor con segunda menor: flamenco y metal oscuro.',
          'theory.scaleAbout.lydian' =>
            'Mayor con cuarta aumentada: soñadora, de banda sonora.',
          'theory.scaleAbout.mixolydian' =>
            'Mayor con séptima menor: rock clásico, blues y country.',
          'theory.degreeNames.d1' => 'tónica',
          'theory.degreeNames.d2' => 'supertónica',
          'theory.degreeNames.d3' => 'mediante',
          'theory.degreeNames.d4' => 'subdominante',
          'theory.degreeNames.d5' => 'dominante',
          'theory.degreeNames.d6' => 'superdominante',
          'theory.degreeNames.d7' => 'sensible',
          'theory.strumNames.whole' => 'Un golpe por compás',
          'theory.strumNames.quarters' => 'Negras',
          'theory.strumNames.pop' => 'Pop',
          'theory.strumNames.eighths' => 'Corcheas',
          'theory.strumNames.boomChick' => 'Bajo y rasgueo',
          'theory.strumNames.skank' => 'Contratiempo (reggae)',
          'theory.strumNames.bossa' => 'Bossa nova',
          'theory.strumNames.shuffle' => 'Shuffle',
          'theory.strumNames.waltz' => 'Vals 3/4',
          'theory.genreNames.pop' => 'Pop',
          'theory.genreNames.rock' => 'Rock',
          'theory.genreNames.blues' => 'Blues',
          'theory.genreNames.country' => 'Country',
          'theory.genreNames.jazz' => 'Jazz',
          'theory.genreNames.funk' => 'Funk',
          'theory.genreNames.ballad' => 'Balada',
          'theory.genreNames.latin' => 'Latino',
          'theory.genreNames.reggae' => 'Reggae',
          'theory.genreNames.bossa' => 'Bossa nova',
          'theory.genreNames.metal' => 'Metal',
          'theory.genreNames.punk' => 'Punk',
          'theory.genreNames.soul' => 'Soul y R&B',
          'theory.genreNames.gospel' => 'Gospel',
          'theory.genreNames.folk' => 'Folk y tradicional',
          'theory.genreAbout.pop' => 'Canciones pegadizas sobre pocas progresiones (I-V-vi-IV). La guitarra acompaña con acordes abiertos y un rasgueo constante.',
          'theory.genreAbout.rock' => 'Power chords, corcheas con energía y riffs con la pentatónica menor. El I-IV-V y el bVII mandan.',
          'theory.genreAbout.blues' => 'Doce compases, acordes de séptima y la escala de blues. El feeling importa más que la velocidad.',
          'theory.genreAbout.country' => 'Acordes abiertos, bajo alternado y melodías con la pentatónica mayor. Historias sencillas y mucho swing en la mano derecha.',
          'theory.genreAbout.jazz' => 'Cuatriadas (maj7, m7, 7), el ii-V-I y cambios constantes de tonalidad. Se toca ligero y con swing.',
          'theory.genreAbout.funk' => 'Acordes de novena y m7 tocados cortos y percusivos. La guitarra es parte de la batería.',
          _ => null,
        } ??
        switch (path) {
          'theory.genreAbout.ballad' => 'Tempos lentos y acordes que se dejan sonar. Arpegios o un golpe por pulso.',
          'theory.genreAbout.latin' => 'Desde la ranchera en 3/4 hasta la cadencia andaluza y el bolero. Mucha menor armónica.',
          'theory.genreAbout.reggae' => 'El acorde suena solo en los contratiempos, corto y seco. El bajo y la batería llevan el pulso.',
          'theory.genreAbout.bossa' => 'Cuatriadas suaves, bajo con el pulgar y acordes sincopados con los dedos.',
          'theory.genreAbout.metal' => 'Power chords con palm mute, tempos rápidos y escalas menores, frigias y armónicas.',
          'theory.genreAbout.punk' => 'Tres o cuatro power chords, corcheas hacia abajo y mucha velocidad. Actitud ante todo.',
          'theory.genreAbout.soul' => 'Acordes de color (maj7, m7, 9), groove relajado y adornos con la pentatónica mayor.',
          'theory.genreAbout.gospel' => 'Armonía de iglesia: I-IV-V con séptimas, el iv menor y cadencias plagales («amén»).',
          'theory.genreAbout.folk' => 'Canciones de siempre con tres o cuatro acordes abiertos. Ideal para cantar.',
          'theory.genreRhythm.pop' => '↓ ↓↑ ↑↓↑ en 4/4. Acentúa el 2 y el 4.',
          'theory.genreRhythm.rock' =>
            'Corcheas abajo o abajo-arriba, con palm mute en las estrofas.',
          'theory.genreRhythm.blues' =>
            'Shuffle: cada pulso en largo-corto (ta-ka ta-ka).',
          'theory.genreRhythm.country' => 'Boom-chick: bajo en el 1 y el 3, rasgueo en el 2 y el 4, alternando la cuerda del bajo.',
          'theory.genreRhythm.jazz' => 'Cuatro golpes cortos por compás (estilo Freddie Green), con swing.',
          'theory.genreRhythm.funk' => 'Semicorcheas con la mano siempre en marcha; casi todo apagado y unos pocos golpes abiertos.',
          'theory.genreRhythm.ballad' =>
            'Un golpe por compás o arpegio lento de la 6ª a la 1ª cuerda.',
          'theory.genreRhythm.latin' => 'Ranchera: bajo-acorde-acorde (3/4). Rumba: rasgueo con acento en el contratiempo.',
          'theory.genreRhythm.reggae' =>
            'Silencio en el 1, golpe seco en el 2 y el 4 (skank).',
          'theory.genreRhythm.bossa' =>
            'Pulgar en el bajo en cada pulso y acorde sincopado entre medias.',
          'theory.genreRhythm.metal' =>
            'Corcheas o galope (una corchea y dos semicorcheas) con palm mute.',
          'theory.genreRhythm.punk' =>
            'Corcheas todo hacia abajo, rápido y constante.',
          'theory.genreRhythm.soul' =>
            'Golpes suaves en el 2 y el 4 y adornos entre acordes.',
          'theory.genreRhythm.gospel' =>
            'Negras firmes con acentos en el 2 y el 4; llamada y respuesta.',
          'theory.genreRhythm.folk' =>
            'Negras o el patrón pop; en 3/4, bajo y dos golpes.',
          'theory.genreTip.pop' => 'Aprende el I-V-vi-IV en Sol, Do y Re: tocarás cientos de canciones.',
          'theory.genreTip.rock' => 'Apaga las cuerdas con la mano derecha (palm mute) en las estrofas y ábrelas en el estribillo.',
          'theory.genreTip.blues' => 'Haz un bend de la 4ª a la 5ª de la escala y termina las frases en la tónica.',
          'theory.genreTip.country' => 'Alterna el bajo entre la raíz y la quinta del acorde para el típico boom-chick.',
          'theory.genreTip.jazz' => 'Aprende las formas de m7, 7 y maj7 con raíz en la 6ª y la 5ª cuerda: cubren el 90 %.',
          'theory.genreTip.funk' => 'Rasguea muy cerca del puente y relaja la mano izquierda para apagar entre golpes.',
          'theory.genreTip.ballad' => 'Deja sonar los acordes y cambia justo antes del pulso 1, no tarde.',
          'theory.genreTip.latin' => 'En la cadencia andaluza, usa la menor armónica sobre el acorde V (Mi mayor en La menor).',
          'theory.genreTip.reggae' =>
            'Toca el skank en las tres cuerdas agudas y apágalo justo después.',
          'theory.genreTip.bossa' =>
            'Practica el bajo con el pulgar solo antes de añadir los acordes.',
          'theory.genreTip.metal' => 'Afina el palm mute: la mano en el puente, ni muy encima ni muy fuera.',
          'theory.genreTip.punk' =>
            'Mantén la muñeca suelta: la velocidad sale de la relajación.',
          'theory.genreTip.soul' => 'Toca el acorde solo en las tres o cuatro cuerdas agudas para un sonido limpio.',
          'theory.genreTip.gospel' => 'Prueba el IV → iv → I: el cambio de mayor a menor es pura emoción.',
          'theory.genreTip.folk' =>
            'Canta mientras tocas: la mano derecha debe ir en automático.',
          'theory.progressionNames.popAxis' => 'El eje del pop',
          'theory.progressionNames.dooWop' => 'Doo-wop de los 50',
          'theory.progressionNames.rockClassic' => 'Rock clásico I-IV-V',
          'theory.progressionNames.rockMixo' => 'Rock con bVII',
          'theory.progressionNames.blues12' => 'Blues de 12 compases',
          'theory.progressionNames.bluesMinor' => 'Blues menor',
          'theory.progressionNames.countryRoad' => 'Camino country',
          'theory.progressionNames.countryTwoStep' => 'Two-step',
          'theory.progressionNames.jazz251' => 'ii-V-I de jazz',
          'theory.progressionNames.jazzTurnaround' => 'Turnaround',
          'theory.progressionNames.funkDorian' => 'Vamp dórico',
          'theory.progressionNames.balladSad' => 'Balada sentimental',
          'theory.progressionNames.canon' => 'Canon de Pachelbel',
          'theory.progressionNames.andalusian' => 'Cadencia andaluza',
          'theory.progressionNames.ranchera' => 'Ranchera tónica-dominante',
          'theory.progressionNames.reggaeSkank' => 'Skank de reggae',
          'theory.progressionNames.bossaCycle' => 'Ciclo de bossa',
          'theory.progressionNames.metalMinor' => 'Metal en menor',
          'theory.progressionNames.metalPhrygian' => 'Metal frigio',
          'theory.progressionNames.punkPower' => 'Punk a toda velocidad',
          'theory.progressionNames.soulGroove' => 'Groove soul',
          'theory.progressionNames.gospelPlagal' => 'Gospel con iv menor',
          'theory.progressionNames.folkThree' => 'Tres acordes folk',
          'theory.lessonTitles.notes' => 'Las notas y el mástil',
          'theory.lessonTitles.intervals' =>
            'Intervalos: la distancia entre notas',
          'theory.lessonTitles.tonic' => 'La tónica y la tonalidad',
          'theory.lessonTitles.rhythm' => 'Ritmo, compás y rasgueo',
          'theory.lessonTitles.majorScale' => 'La escala mayor',
          'theory.lessonTitles.minorScales' => 'Escalas menores',
          'theory.lessonTitles.pentatonic' =>
            'Pentatónicas: la escala del solista',
          'theory.lessonTitles.positions' =>
            'Las posiciones (cajas) de la escala',
          'theory.lessonTitles.blues' => 'El blues y la blue note',
          'theory.lessonTitles.modes' => 'Los modos griegos',
          'theory.lessonTitles.harmony' =>
            'Armonía: los acordes de una tonalidad',
          'theory.lessonTitles.degrees' => 'Grados y funciones',
          'theory.lessonTitles.progressions' => 'Progresiones famosas',
          'theory.lessonTitles.caged' => 'Sistema CAGED',
          'theory.lessonSummaries.notes' => 'Las 12 notas, sostenidos y bemoles, y cómo encontrarlas en la guitarra.',
          'theory.lessonSummaries.intervals' => 'Semitonos, terceras, quintas y octavas: el ADN de escalas y acordes.',
          'theory.lessonSummaries.tonic' =>
            'La nota «casa» de una canción y cómo descubrir en qué tono está.',
          'theory.lessonSummaries.rhythm' =>
            'Pulso, 4/4 y 3/4, corcheas y los patrones de cada género.',
          'theory.lessonSummaries.majorScale' =>
            'La fórmula T-T-S-T-T-T-S, la madre de la armonía.',
          'theory.lessonSummaries.minorScales' =>
            'Menor natural, menor armónica y la relativa menor.',
          'theory.lessonSummaries.pentatonic' =>
            'Cinco notas que nunca suenan mal: el atajo para improvisar.',
          'theory.lessonSummaries.positions' =>
            'Teoría de posición: cómo dividir el mástil en cajas que encajan.',
          'theory.lessonSummaries.blues' =>
            'La escala de blues, el shuffle y la forma de 12 compases.',
          'theory.lessonSummaries.modes' => 'Siete colores de la misma escala: dórico, frigio, lidio, mixolidio…',
          'theory.lessonSummaries.harmony' =>
            'Cada nota de la escala da un acorde: el campo armónico.',
          'theory.lessonSummaries.degrees' =>
            'Tónica, subdominante y dominante: reposo, movimiento y tensión.',
          'theory.lessonSummaries.progressions' =>
            'Las combinaciones de acordes que suenan en miles de canciones.',
          'theory.lessonSummaries.caged' =>
            'Cinco formas de acorde abierto que recorren todo el mástil.',
          'theory.lessonBodies.notes' => 'La música occidental usa solo 12 notas que se repiten en octavas: Do, Do♯, Re, Re♯, Mi, Fa, Fa♯, Sol, Sol♯, La, La♯ y Si. En inglés se escriben con letras: C D E F G A B.\n\nEntre dos notas seguidas hay un semitono, y en la guitarra un semitono es exactamente un traste; dos trastes son un tono. Entre Mi y Fa, y entre Si y Do, no hay sostenido: están a un semitono.\n\nUn sostenido (♯) sube un semitono y un bemol (♭) lo baja, así que Do♯ y Re♭ son la misma nota con dos nombres. En el traste 12 cada cuerda repite su nota al aire una octava más aguda: ahí el mástil vuelve a empezar.',
          'theory.lessonBodies.intervals' => 'Un intervalo es la distancia entre dos notas, medida en semitonos (trastes). Cada distancia tiene su color: la tercera mayor (4 semitonos) suena alegre, la tercera menor (3) triste y la quinta justa (7) sólida y abierta.\n\nLos acordes se construyen apilando intervalos sobre la raíz: un acorde mayor es raíz + tercera mayor + quinta; uno menor solo cambia la tercera. Por eso mover una sola nota un traste convierte Do en Do menor.\n\nEn la guitarra cada intervalo tiene una forma: la quinta está en la cuerda siguiente (más aguda), dos trastes más arriba, y la octava dos cuerdas más allá y dos trastes arriba. Al cruzar la 2ª cuerda (Si) la forma se desplaza un traste.',
          'theory.lessonBodies.tonic' => 'La tónica es la nota alrededor de la cual gira una canción: la casa a la que todo quiere volver. Cuando la melodía o el acorde llegan a la tónica sentimos reposo; al alejarse, tensión.\n\nLa tonalidad es la tónica más su escala. «Sol mayor» significa que Sol es la casa y que se usan las notas de la escala mayor de Sol. Casi todas las canciones terminan, y muchas empiezan, en el acorde de la tónica.\n\nPara descubrir el tono de una canción busca el acorde que suena a final, comprueba que el resto de acordes pertenecen a esa tonalidad y canta la nota que «cierra» la melodía. Con práctica lo oirás al instante: juega a «Encuentra la tónica».',
          'theory.lessonBodies.rhythm' => 'El pulso es el latido constante de la música. El compás agrupa pulsos: 4/4 (cuatro por compás) es el del pop, el rock y casi todo; 3/4 es el del vals, la ranchera y muchas canciones tradicionales.\n\nCada pulso se divide en dos corcheas: abajo en el pulso («1») y arriba en el contratiempo («y»). La mano derecha se mueve siempre abajo-arriba como un péndulo, aunque no toque las cuerdas en cada viaje: así el ritmo nunca se rompe.\n\nCada género tiene su patrón: pop (↓ ↓↑ ↑↓↑), rock (corcheas), country (bajo y rasgueo), reggae (solo contratiempos) o blues (shuffle). El modo jam te muestra el patrón golpe a golpe mientras tocas.',
          'theory.lessonBodies.majorScale' => 'La escala mayor tiene siete notas y sigue siempre la misma fórmula de tonos (T) y semitonos (S): T T S T T T S. Desde Do salen Do Re Mi Fa Sol La Si, todas naturales.\n\nCon la fórmula puedes construirla desde cualquier nota. Desde Sol: Sol La Si Do Re Mi Fa♯; el Fa♯ aparece para respetar el último tono antes del semitono final.\n\nEn una sola cuerda la escala mayor se toca contando trastes: 2, 2, 1, 2, 2, 2, 1. Pruébalo en la 5ª cuerda desde el traste 3 (Do) y escucha el famoso do-re-mi. En el explorador verás sus siete posiciones de tres notas por cuerda.',
          'theory.lessonBodies.minorScales' => 'La escala menor natural cambia la fórmula: T S T T S T T. La menor de La usa las mismas notas que Do mayor (La Si Do Re Mi Fa Sol), pero al empezar en La todo suena más oscuro: es la relativa menor de Do.\n\nToda tonalidad mayor tiene una relativa menor tres semitonos por debajo (Sol mayor ↔ Mi menor). Comparten notas y acordes; lo que cambia es la casa.\n\nLa menor armónica sube la séptima nota un semitono (Sol♯ en La menor). Esa nota convierte el acorde del quinto grado en mayor (Mi mayor en La menor), que empuja con fuerza hacia la tónica: es el sonido del flamenco, la música clásica y muchos boleros.',
          'theory.lessonBodies.pentatonic' => 'La pentatónica es una escala de cinco notas: quita a la escala mayor o menor las dos notas que crean más tensión. Por eso casi cualquier nota que toques sobre los acordes de la canción sonará bien.\n\nLa pentatónica menor (1 b3 4 5 b7) es la base del rock y del blues: La Do Re Mi Sol en La menor. La pentatónica mayor (1 2 3 5 6) suena dulce y abierta, típica del country y el pop: Do Re Mi Sol La en Do.\n\nTruco clave: la pentatónica menor de La y la mayor de Do tienen las mismas notas. La misma forma, con otra tónica, te da los dos sonidos. Para sonar mayor apóyate en la tónica mayor; para sonar a blues, en la menor.',
          'theory.lessonBodies.positions' => 'Una posición o caja es el grupo de notas de la escala que alcanzas sin mover la mano: cuatro o cinco trastes, un dedo por traste. La pentatónica tiene cinco cajas y las escalas de siete notas, siete posiciones de tres notas por cuerda.\n\nLas cajas encajan como piezas de un puzle: el borde derecho de una es el izquierdo de la siguiente, y tras la última vuelve la primera doce trastes más arriba. Conocerlas todas te permite tocar la escala en todo el mástil.\n\nLa posición 1 de la pentatónica menor empieza con la tónica en la 6ª cuerda bajo el índice. Apréndela primero, después la 2, y conéctalas deslizando un dedo. Para cambiar de tonalidad no hay que aprender nada nuevo: mueve la caja entera hasta la nueva tónica.',
          'theory.lessonBodies.blues' => 'La escala de blues es la pentatónica menor con una nota más: la quinta disminuida (b5), la famosa blue note. En La: La Do Re Re♯ Mi Sol. Úsala de paso, camino de la quinta; no te quedes en ella.\n\nEl blues clásico dura 12 compases con tres acordes de séptima: cuatro de I7, dos de IV7, dos de I7, luego V7, IV7, I7 y V7 para volver a empezar (el «turnaround»).\n\nEl ritmo es el shuffle: cada pulso se divide en un golpe largo y uno corto (ta-ka, ta-ka). Prueba el jam «Blues de 12 compases» y toca la escala de blues encima.',
          'theory.lessonBodies.modes' => 'Si tocas las notas de Do mayor empezando en otra nota obtienes un modo: desde Re el dórico, desde Mi el frigio, desde Fa el lidio, desde Sol el mixolidio, desde La el eólico (menor natural) y desde Si el locrio.\n\nCada modo tiene una nota característica. El dórico es menor con sexta mayor (funk, Santana). El frigio, menor con segunda menor (flamenco, metal). El lidio, mayor con cuarta aumentada (soñador, bandas sonoras). El mixolidio, mayor con séptima menor (rock, blues, country).\n\nPara oírlos, toca el modo sobre un acorde fijo de su tónica: así la nota característica destaca. El explorador la marca con otro color.',
          'theory.lessonBodies.harmony' => 'Si construyes un acorde sobre cada nota de la escala mayor usando solo notas de la escala obtienes siete acordes: I mayor, ii menor, iii menor, IV mayor, V mayor, vi menor y vii disminuido. En Do: C Dm Em F G Am B°.\n\nEsa lista es el campo armónico y explica por qué ciertos acordes suenan bien juntos: pertenecen a la misma tonalidad. Los números romanos permiten escribir progresiones sin depender del tono: «I-V-vi-IV» es igual en Do (C G Am F) que en Sol (G D Em C).\n\nCon cuatro notas aparecen los acordes de jazz: Imaj7, ii7, iii7, IVmaj7, V7, vi7 y viiø. El V7 es el único dominante: el que pide volver a la tónica.',
          'theory.lessonBodies.degrees' => 'Cada grado de la escala cumple una función. La tónica (I) es el reposo. La subdominante (IV) se aleja suavemente. La dominante (V) crea tensión y quiere resolver en la tónica.\n\nLos demás grados sustituyen a estos tres: el vi y el iii comparten notas con el I (función de tónica) y el ii se parece al IV (subdominante). Por eso «I-vi-IV-V» y «I-IV-V» cuentan la misma historia: casa, viaje, tensión y regreso.\n\nCuando entiendes las funciones puedes adivinar el siguiente acorde de una canción, sacar temas de oído y componer tus propias progresiones.',
          'theory.lessonBodies.progressions' => 'Una progresión es una secuencia de acordes que se repite. Unas pocas sostienen gran parte de la música popular: I-V-vi-IV (pop), I-IV-V (rock, country, folk, ranchera), ii-V-I (jazz), vi-IV-I-V (baladas) y la cadencia andaluza i-bVII-bVI-V (flamenco y rock latino).\n\nComo están escritas en grados puedes tocarlas en cualquier tono: elige uno cómodo para cantar. Aprende cada progresión en dos o tres tonos y empezarás a reconocerlas en todo lo que escuches.\n\nEn el jam guiado tienes todas estas progresiones con acompañamiento, metrónomo, el patrón de rasgueo y la escala recomendada para improvisar.',
          'theory.lessonBodies.caged' => 'Las cinco formas de acorde abierto mayor —Do, La, Sol, Mi y Re (C-A-G-E-D)— se pueden mover por el mástil con cejilla. Encadenadas en ese orden cubren los doce trastes con el mismo acorde.\n\nPor ejemplo, Do mayor se toca en forma de Do (abierto), de La (cejilla en el traste 3), de Sol (traste 5), de Mi (traste 8) y de Re (traste 10). Cada forma comparte notas con la siguiente.\n\nCada forma CAGED coincide con una caja de la pentatónica mayor. Así se unen acordes y escalas: siempre sabes qué notas de solo tienes alrededor del acorde que estás tocando.',
          'theory.lessonPoints.notes' => '12 notas: 7 naturales y 5 alteradas\n1 traste = 1 semitono; 2 trastes = 1 tono\nMi–Fa y Si–Do están a un semitono\nTraste 12 = la misma nota una octava arriba\nAprende primero las notas de la 6ª y la 5ª cuerda: son las raíces de las cejillas',
          'theory.lessonPoints.intervals' => 'Tercera menor = 3 semitonos (triste)\nTercera mayor = 4 semitonos (alegre)\nQuinta justa = 7 semitonos (power chord)\nOctava = 12 semitonos: la misma nota más aguda\nLa cuerda Si desplaza las formas un traste',
          'theory.lessonPoints.tonic' => 'Tónica = reposo; alejarse = tensión\nTonalidad = tónica + escala\nEl último acorde suele ser la tónica\nCada tonalidad mayor tiene una relativa menor con las mismas notas\nTransportar = mover todo el mismo número de trastes',
          'theory.lessonPoints.rhythm' => '4/4: cuenta 1 y 2 y 3 y 4 y\n3/4: cuenta 1 y 2 y 3 y\nLa mano nunca para: abajo en el pulso, arriba en el «y»\nEmpieza lento con metrónomo y sube el tempo poco a poco\nCambia de acorde en el último golpe del compás',
          'theory.lessonPoints.majorScale' => 'Fórmula: T T S T T T S (2-2-1-2-2-2-1 trastes)\nSiete notas, una de cada letra\nSus grados se numeran del 1 al 7\nDe ella salen los acordes de la tonalidad\nTiene 7 posiciones de 3 notas por cuerda',
          'theory.lessonPoints.minorScales' => 'Menor natural: T S T T S T T\nRelativa menor = 3 semitonos por debajo de la mayor\nComparten notas, cambia la tónica\nMenor armónica: séptima elevada\nEl V mayor en menor da la cadencia flamenca',
          'theory.lessonPoints.pentatonic' => 'Menor: 1 b3 4 5 b7\nMayor: 1 2 3 5 6\nDos notas por cuerda en cada caja\nPentatónica menor de La = mayor de Do (mismas notas)\nTermina tus frases en la tónica para sonar resuelto',
          'theory.lessonPoints.positions' => 'Una caja = 4-5 trastes, un dedo por traste\nPentatónica: 5 cajas; escalas de 7 notas: 7 posiciones\nLas cajas se solapan y se repiten cada 12 trastes\nLocaliza siempre las tónicas dentro de la caja\nMover la caja entera = cambiar de tonalidad',
          'theory.lessonPoints.blues' => 'Blues = pentatónica menor + b5\n12 compases: I7 – IV7 – I7 – V7 – IV7 – I7\nTodos los acordes son de séptima\nShuffle: largo-corto en cada pulso\nBends y vibrato dan el carácter',
          'theory.lessonPoints.modes' => 'Jónico = mayor · Eólico = menor natural\nDórico: menor con 6ª mayor\nFrigio: menor con b2\nLidio: mayor con #4\nMixolidio: mayor con b7',
          'theory.lessonPoints.harmony' => 'Mayúsculas = mayor · minúsculas = menor\nEn mayor: I ii iii IV V vi vii°\nEn menor: i ii° III iv v VI VII\nNúmeros romanos = progresiones en cualquier tono\nEl V7 empuja hacia el I',
          'theory.lessonPoints.degrees' => 'I tónica: reposo\nIV subdominante: movimiento\nV dominante: tensión que vuelve al I\nvi y iii hacen de tónica; ii, de subdominante\nV → I es la cadencia más fuerte',
          'theory.lessonPoints.progressions' => 'Pop: I – V – vi – IV\nRock y country: I – IV – V\nJazz: ii – V – I\nBalada: vi – IV – I – V\nAndaluza: i – bVII – bVI – V',
          'theory.lessonPoints.caged' => 'Orden: C → A → G → E → D → C…\nCada forma es un acorde abierto movible\nCubren todo el mástil sin huecos\nCada forma se apoya en una caja de pentatónica\nLa raíz siempre está dentro de la forma',
          'studio.sectionTitle' => 'Explora la guitarra',
          'studio.theoryCard' => 'Teoría',
          'studio.theoryCardBody' => 'Tónica, escalas, pentatónicas y armonía',
          'studio.scalesCard' => 'Escalas',
          'studio.scalesCardBody' => 'Mástil interactivo con posiciones',
          'studio.genresCard' => 'Géneros',
          'studio.genresCardBody' => 'Ritmos y acordes de cada estilo',
          'studio.jamCard' => 'Jam guiado',
          'studio.jamCardBody' => 'Toca con acompañamiento y puntuación',
          'studio.songsCard' => 'Canciones',
          'studio.songsCardBody' => 'Acordes y letra para tocar',
          'studio.historyCard' => 'Historial',
          'studio.historyCardBody' => 'Tus acordes recientes',
          'studio.streakDays' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: '${n} día seguido tocando',
                  other: '${n} días seguidos tocando',
                ),
          'studio.streakZero' => 'Toca hoy para empezar tu racha',
          'studio.streakToday' => '¡Hoy ya practicaste!',
          'studio.recentTitle' => 'Acordes recientes',
          'studio.seeAll' => 'Ver todo',
          'studio.clearHistory' => 'Borrar historial',
          'studio.historyTitle' => 'Historial de acordes',
          'studio.historyEmptyTitle' => 'Aún no hay historial',
          'studio.historyEmptyBody' =>
            'Los acordes que abras aparecerán aquí para repasarlos rápido.',
          'studio.historyHint' => 'Del más reciente al más antiguo',
          'jam.title' => 'Jam guiado',
          'jam.subtitle' =>
            'Elige qué tocar, ajusta el tono y el tempo y toca junto a la app.',
          'jam.progressionsTab' => 'Progresiones',
          'jam.songsTab' => 'Canciones',
          'jam.customTab' => 'La tuya',
          'jam.key' => 'Tonalidad',
          'jam.tempo' => 'Tempo',
          'jam.bpm' => ({required Object n}) => '${n} BPM',
          'jam.loops' => ({required Object n}) => 'Vueltas: ${n}',
          'jam.modeBacking' => 'Acompañar',
          'jam.modeBackingBody' =>
            'La app toca los acordes con el rasgueo del estilo.',
          'jam.modeScore' => 'Puntuar',
          'jam.modeScoreBody' =>
            'Tocas tú y el micrófono puntúa cada compás (la app no suena).',
          'jam.metronome' => 'Metrónomo',
          'jam.start' => '¡A tocar!',
          'jam.countIn' => 'Prepárate…',
          'jam.now' => 'Ahora',
          'jam.next' => 'Después',
          'jam.end' => 'Fin',
          'jam.barOf' => ({
            required Object n,
            required Object total,
          }) => 'Compás ${n} de ${total}',
          'jam.pause' => 'Pausa',
          'jam.resume' => 'Seguir',
          'jam.stop' => 'Terminar',
          'jam.points' => ({required Object n}) => '${n} pts',
          'jam.streak' => ({required Object n}) => 'Racha ${n}',
          'jam.gradePerfect' => '¡Perfecto!',
          'jam.gradeGood' => '¡Bien!',
          'jam.gradeMiss' => 'Fallo',
          'jam.gradeSilent' => 'No te oigo',
          'jam.resultTitle' => 'Sesión terminada',
          'jam.accuracy' => ({required Object n}) => 'Precisión: ${n}%',
          'jam.bestStreak' => ({required Object n}) => 'Mejor racha: ${n}',
          'jam.perfectBars' => ({
            required Object n,
          }) => 'Compases perfectos: ${n}',
          'jam.playAgain' => 'Otra vez',
          'jam.slower' => 'Más lento',
          'jam.faster' => 'Más rápido',
          'jam.back' => 'Elegir otra',
          'jam.newBest' => '¡Nuevo récord!',
          'jam.best' => ({required Object n}) => 'Récord: ${n}',
          'jam.scaleHint' => ({
            required Object scale,
          }) => 'Improvisa con: ${scale}',
          'jam.customHint' =>
            'Toca acordes para añadirlos a tu progresión (hasta 8).',
          'jam.customEmpty' => 'Añade al menos un acorde',
          'jam.customTitle' => 'Mi progresión',
          'jam.clear' => 'Borrar',
          'jam.removeLast' => 'Quitar el último',
          'jam.micProblem' => 'Sin acceso al micrófono: la sesión no puntuará.',
          'jam.headphonesTip' => 'Truco: en «Puntuar» la app calla para oírte bien; usa el metrónomo visual.',
          'jam.chooseTrack' => 'Elige qué tocar',
          'jam.strum' => 'Rasgueo',
          'jam.pickTrack' => 'Toca para elegir',
          'songs.title' => 'Cancionero',
          'songs.subtitle' =>
            'Canciones tradicionales y de dominio público con acordes y letra.',
          'songs.searchHint' => 'Busca una canción',
          'songs.all' => 'Todas',
          'songs.traditional' => 'Tradicional',
          'songs.exercise' => 'Ejercicio de Chords',
          'songs.transpose' => 'Tono',
          'songs.transposeReset' => 'Tono original',
          'songs.level' => ({required Object n}) => 'Nivel ${n}',
          'songs.chordsUsed' => 'Acordes de la canción',
          'songs.playJam' => 'Tocar en el jam',
          'songs.empty' => 'Ninguna canción coincide',
          'songs.emptyBody' =>
            'Prueba con otro nombre o quita el filtro de género.',
          'songs.notFound' => 'No encontramos esa canción',
          'songs.exercises.bluesInA' => 'Blues en La · 12 compases',
          'songs.exercises.rockInE' => 'Power chords en Mi',
          'songs.exercises.popFourChords' => 'Los cuatro acordes del pop',
          'songs.exercises.metalGallop' => 'Galope metalero en Mi menor',
          'songs.exercises.funkVamp' => 'Vamp funky en Mi',
          'songs.parts.intro' => 'Intro',
          'songs.parts.verse' => 'Estrofa',
          'songs.parts.chorus' => 'Estribillo',
          'songs.parts.bridge' => 'Puente',
          'songs.parts.outro' => 'Final',
          _ => null,
        };
  }
}
