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
  late final Translations$chordGames$es chordGames =
      Translations$chordGames$es.internal(_root);
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

  /// es: '$count juegos de oído, mástil, acordes y armonía'
  String gameSubtitle({required Object count}) =>
      '${count} juegos de oído, mástil, acordes y armonía';

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

// Path: chordGames
class Translations$chordGames$es {
  Translations$chordGames$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Acordes y variantes'
  String get chordsTitle => 'Acordes y variantes';

  /// es: 'Notas, fórmulas, diagramas, formas CAGED y retos con tiempo'
  String get chordsSubtitle =>
      'Notas, fórmulas, diagramas, formas CAGED y retos con tiempo';

  /// es: 'Progresiones y armonía'
  String get harmonyTitle => 'Progresiones y armonía';

  /// es: 'Grados, transporte, relativos y estilos'
  String get harmonySubtitle => 'Grados, transporte, relativos y estilos';

  /// es: 'Nuevo'
  String get newBadge => 'Nuevo';

  /// es: 'Buscar juegos'
  String get searchHint => 'Buscar juegos';

  /// es: 'Todos'
  String get filterAll => 'Todos';

  /// es: 'Nuevos'
  String get filterNew => 'Nuevos';

  /// es: 'Filtrar por familia'
  String get filterLabel => 'Filtrar por familia';

  /// es: 'Ningún juego coincide'
  String get noResultsTitle => 'Ningún juego coincide';

  /// es: 'Prueba con otra palabra o quita el filtro.'
  String get noResultsBody => 'Prueba con otra palabra o quita el filtro.';

  /// es: 'Quitar la búsqueda'
  String get clearSearch => 'Quitar la búsqueda';

  /// es: '(one) {$n juego} (other) {$n juegos}'
  String gamesCount({required num n}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: '${n} juego',
        other: '${n} juegos',
      );

  /// es: '¡Se acabó el tiempo!'
  String get timeUp => '¡Se acabó el tiempo!';

  /// es: '$n s'
  String timeLeft({required Object n}) => '${n} s';

  /// es: 'Rapidez: +$n puntos'
  String speedBonus({required Object n}) => 'Rapidez: +${n} puntos';

  /// es: 'Tiempo por pregunta: $n s'
  String perQuestion({required Object n}) => 'Tiempo por pregunta: ${n} s';

  /// es: 'Meta: $goal cambios limpios en $seconds s'
  String changesGoal({required Object goal, required Object seconds}) =>
      'Meta: ${goal} cambios limpios en ${seconds} s';

  Map<String, String> get titles => {
    'spellChord': 'Deletrea el acorde',
    'chordFormula': 'Fórmula del acorde',
    'chordVariantEar': '¿Qué variante es?',
    'chordMemory': 'Memoria de acordes',
    'rootAndBass': 'Raíz y bajo',
    'inversion': 'Inversiones',
    'wrongDiagram': 'Diagrama incorrecto',
    'cagedShape': 'Formas CAGED',
    'rushOpen': 'Racha: acordes abiertos',
    'rushBarre': 'Racha: cejillas',
    'rushSeventh': 'Racha: séptimas',
    'fillProgression': 'Completa la progresión',
    'romanDegree': 'Grados romanos',
    'transposeChord': 'Transporta',
    'chordNeighbors': 'Relativos y quintas',
    'styleDuel': 'Duelo de estilos',
    'chordChanges': 'Cambios de acorde',
  };
  Map<String, String> get descriptions => {
    'spellChord': '¿Qué notas forman cada acorde?',
    'chordFormula': 'Del acorde a su fórmula 1-3-5… y al revés',
    'chordVariantEar': 'Oye maj7, 7, 6, sus… y distingue la variante',
    'chordMemory': 'Repite la sucesión de acordes que oyes',
    'rootAndBass': 'Dónde está la raíz y qué nota va en el bajo',
    'inversion': 'Fundamental, 1ª o 2ª inversión',
    'wrongDiagram': 'Encuentra el diagrama con un error',
    'cagedShape': 'Reconoce C, A, G, E, D y dónde va la cejilla',
    'rushOpen': 'Nombra acordes abiertos contra el reloj',
    'rushBarre': 'Nombra acordes con cejilla contra el reloj',
    'rushSeventh': 'Séptimas y extendidos contra el reloj',
    'fillProgression': 'Encuentra el acorde que falta',
    'romanDegree': 'Del IV al acorde y del acorde al IV',
    'transposeChord': 'Sube semitonos y toca con capo',
    'chordNeighbors': 'Relativo, dominante, subdominante y quintas',
    'styleDuel': '¿Qué género suena? Progresión y rasgueo',
    'chordChanges': 'Cambios limpios en 60 segundos',
  };
  Map<String, String> get howTo => {
    'spellChord': 'Verás el nombre de un acorde. En fácil y medio elige el grupo de notas que lo forma: Do6 y La menor 7 comparten notas, así que fíjate en la raíz. En difícil toca las notas del acorde de la raíz hacia arriba.',
    'chordFormula': 'Cada acorde se construye con intervalos desde su raíz: 1-3-5 es mayor, 1-♭3-5 menor, 1-3-5-♭7 séptima… Pasa del acorde a su fórmula o de la fórmula al nombre del acorde.',
    'chordVariantEar': 'Oirás un acorde y se te dice su raíz. Distingue qué variante es: mayor, menor, 7, maj7, 6, sus… Cuanto más subes de nivel, más variantes parecidas hay.',
    'chordMemory': 'Oirás una sucesión de acordes. Pulsa los acordes en el mismo orden en que sonaron. Cada nivel añade más acordes y más opciones.',
    'rootAndBass': 'Verás el diagrama de una posición. Unas veces hay que decir en qué cuerda está la raíz más grave y otras qué nota hace de bajo, que es la cuerda más grave que suena.',
    'inversion': 'Un acorde está en estado fundamental si la raíz va en el bajo; con la tercera en el bajo es la 1ª inversión y con la quinta, la 2ª. En difícil solo lo oyes: fíjate en el bajo.',
    'wrongDiagram': 'Verás varios diagramas del mismo acorde y uno tiene un error: una nota que no es del acorde, una cuerda que debía ir muteada o una nota esencial que falta. Encuéntralo.',
    'cagedShape': 'Los acordes con cejilla se mueven por el mástil con cinco formas: C, A, G, E y D. Reconoce la forma de un diagrama o di en qué traste va la cejilla para tocar un acorde con una forma dada.',
    'rushOpen': 'Reto contra el reloj: aparece el diagrama de un acorde abierto y tienes pocos segundos para nombrarlo. Cuanto más rápido aciertes, más puntos.',
    'rushBarre': 'Reto contra el reloj: aparece el diagrama de un acorde con cejilla y tienes pocos segundos para nombrarlo. Cuanto más rápido aciertes, más puntos.',
    'rushSeventh': 'Reto contra el reloj: aparece el diagrama de una séptima o un acorde extendido y tienes pocos segundos para decir cuál es. Cuanto más rápido aciertes, más puntos.',
    'fillProgression': 'Verás una progresión famosa con un acorde oculto (?). Elige cuál falta; en difícil, elige su grado romano. En fácil y medio puedes oír el resto de la progresión.',
    'romanDegree': 'Los grados romanos nombran los acordes de una tonalidad: en Sol mayor el IV es Do y el V7 es Re7. Pasa del grado al acorde y del acorde al grado; en difícil hay séptimas y acordes prestados como el ♭VII.',
    'transposeChord': 'Transportar es mover un acorde hacia arriba o abajo. Con un capo en el traste N, la forma que tocas suena N semitonos más aguda. Resuelve subidas, bajadas y capos.',
    'chordNeighbors': 'Cada acorde tiene vecinos: su relativo (comparte las notas de la escala), su dominante (V), su subdominante (IV) y los de al lado en el círculo de quintas. Encuentra el que se pide.',
    'styleDuel': 'Oirás los primeros compases de una progresión con su rasgueo. Por los acordes y el ritmo, di de qué género es: pop, rock, blues, reggae…',
    'chordChanges': 'Te pedimos acordes uno tras otro: tócalo y cámbialo cuanto antes. Cada cambio limpio suma; tienes 60 segundos y la meta de cambios da las tres estrellas.',
  };
  late final Translations$chordGames$prompt$es prompt =
      Translations$chordGames$prompt$es.internal(_root);
  late final Translations$chordGames$choice$es choice =
      Translations$chordGames$choice$es.internal(_root);
  late final Translations$chordGames$explain$es explain =
      Translations$chordGames$explain$es.internal(_root);
  late final Translations$chordGames$changes$es changes =
      Translations$chordGames$changes$es.internal(_root);
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

  /// es: 'Técnica y estilo'
  String get unitTechnique => 'Técnica y estilo';

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

  /// es: 'Prueba con otro nombre o con un acorde como Am o E7.'
  String get genresEmptyBody =>
      'Prueba con otro nombre o con un acorde como Am o E7.';

  /// es: 'Ningún género coincide con tu búsqueda'
  String get genresEmpty => 'Ningún género coincide con tu búsqueda';

  /// es: 'Busca un género o un acorde'
  String get genresSearch => 'Busca un género o un acorde';

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

  /// es: '✕ = golpe apagado (percusivo)'
  String get strumMutedHint => '✕ = golpe apagado (percusivo)';

  /// es: 'Detener'
  String get strumStop => 'Detener';

  /// es: 'Ver el rasgueo en movimiento'
  String get strumPlay => 'Ver el rasgueo en movimiento';

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
    'cumbia': 'Cumbia',
    'salsa': 'Salsa (montuno)',
    'reggaeton': 'Reggaetón (dembow)',
    'rumba': 'Rumba flamenca',
    'ska': 'Ska (contratiempos rápidos)',
    'disco': 'Disco (cuatro por el piso)',
    'bolero': 'Bolero',
    'tango': 'Tango (marcato)',
    'valsRanchero': 'Vals ranchero',
    'valsCriollo': 'Vals criollo',
    'merengue': 'Merengue',
    'bachata': 'Bachata',
    'campfire': 'Folk de fogata',
    'funkMuted': 'Funk muteado',
    'arpeggio': 'Balada arpegiada',
    'downstrokes': 'Todo hacia abajo',
    'gallop': 'Galope metalero',
    'lofi': 'Lo-fi perezoso',
    'charleston': 'Charleston (jazz)',
    'trainBeat': 'Tren del country',
    'tresillo': 'Tresillo (habanera)',
    'rockBallad': 'Balada de rock',
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
  Map<String, String> get genreFamilies => {
    'roots': 'Raíces y ritmos latinos',
    'rock': 'Rock y metal',
    'soulJazz': 'Blues, jazz y soul',
    'pop': 'Pop y baile',
  };
  Map<String, String> get strumAbout => {
    'whole': 'Un solo golpe hacia abajo al inicio del compás; deja sonar el acorde. Ideal para cambiar de acorde sin prisa.',
    'quarters': 'Un golpe hacia abajo en cada pulso (1, 2, 3 y 4). Sencillo y firme: la mejor manera de empezar.',
    'pop': 'El rasgueo universal: ↓ ↓↑ ↑↓↑. El brazo no deja de moverse y solo se «pierden» algunos golpes.',
    'eighths': 'Corcheas constantes ↓↑↓↑↓↑↓↑ con el acento en los pulsos: la energía del rock.',
    'boomChick': 'Bajo en el 1 y el 3 y rasgueo en el 2 y el 4: «boom-chick». Alterna la raíz y la quinta en el bajo.',
    'skank': 'Silencio en los pulsos y un golpe seco solo en el contratiempo.',
    'bossa': 'Pulgar en el bajo y acordes sincopados con los dedos: el balanceo suave de la bossa nova.',
    'shuffle': 'Largo-corto en cada pulso, como un tresillo sin la nota central: el balanceo del blues.',
    'waltz': 'En 3/4: bajo en el 1 y dos golpes ligeros en el 2 y el 3, «un-dos-tres».',
    'cumbia': 'Bajo en el 1 y el 3 y rasgueo corto ↓↑ en el contratiempo: «bom-chiqui, bom-chiqui».',
    'salsa': 'Golpes sincopados que se apoyan en el «y» de los pulsos y dejan huecos para el bajo y la clave.',
    'reggaeton': 'El dembow: golpes en el 1, el «y» del 2, el 3 y el 4. Pide un pulso muy estable.',
    'rumba': 'Abajo, abajo-arriba, golpe seco en la tapa (✕), arriba y abajo-arriba: el sello de la rumba flamenca.',
    'ska': 'Solo golpes hacia arriba muy cortos en todos los contratiempos: ·↑·↑·↑·↑.',
    'disco': 'Un golpe fuerte en cada pulso y el contratiempo apagado (✕), como el bombo «cuatro por el piso».',
    'bolero': 'Bajo en el 1 y acordes que caen entre los pulsos con una síncopa suave.',
    'tango': 'Marcato: golpes secos y firmes en los pulsos, algún golpe apagado (✕) y un impulso ↑ al final.',
    'valsRanchero': 'En 3/4: bajo en el 1, acorde en el 2 y un rebote ↓↑ en el 3 que empuja al siguiente compás.',
    'valsCriollo': 'En 3/4: bajo en el 1 y un acorde arrastrado ↓↑↓ que se acerca al tercer pulso.',
    'merengue': 'Pulso constante con la mano pendiente del contratiempo, rápido y alegre.',
    'bachata': 'Bajo en el 1 y golpes ↓↑ enlazados que acentúan el 2 y el 4.',
    'campfire':
        '↓ ↓ ↓↑ ↓↑: el rasgueo que suena en cualquier fogata. Fácil y amplio.',
    'funkMuted': 'Golpes secos (✕) que se arrastran entre acordes abiertos: la mano nunca deja de moverse.',
    'arpeggio': 'Bajo y notas sueltas hacia arriba y hacia abajo, en suave: ideal para baladas.',
    'downstrokes': 'Corcheas siempre hacia abajo: la velocidad y el empuje del punk y el grunge.',
    'gallop': 'Una corchea y dos semicorcheas hacia abajo: el galope del metal, con palm mute.',
    'lofi': 'Acordes perezosos que se arrastran: ↓ ·· ↑ ↓ · ↑. Deja que los huecos respiren.',
    'charleston': 'Acorde en el 1 y en el «y» del 2: el ritmo del jazz anterior al swing.',
    'trainBeat': 'Bajo y dos golpes rápidos ↓↓ en cada mitad del compás: el «chu-chu» del tren del country.',
    'tresillo': '3+3+2: golpes en el 1, el «y» del 2 y el 4; el ritmo de la habanera y la milonga.',
    'rockBallad': 'Dos golpes firmes y un impulso ↓↑↓ hacia el siguiente compás: la balada de rock.',
  };
  Map<String, String> get genreNames => {
    'cumbia': 'Cumbia',
    'salsa': 'Salsa',
    'ranchera': 'Ranchera',
    'flamenco': 'Flamenco',
    'bolero': 'Bolero',
    'tango': 'Tango',
    'ska': 'Ska',
    'indie': 'Indie',
    'grunge': 'Grunge',
    'disco': 'Disco',
    'reggaeton': 'Reggaetón',
    'lofi': 'Lo-fi',
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
    'cumbia': 'Nacida en la costa caribeña de Colombia y adoptada en todo Latinoamérica. Acordes sencillos (i–iv–V7), un bajo marcado en el 1 y el 3 y el rasgueo «chiqui» en el contratiempo. Muy bailable y fácil de aprender.',
    'salsa': 'Música caribeña y neoyorquina de clave, metales y percusión. La guitarra rara vez lleva el protagonismo: toca montunos y acordes sincopados (I–IV–V7, ii–V–I) que dialogan con el bajo y la clave.',
    'ranchera': 'Canción popular mexicana con mariachi, guitarra y guitarrón. Funciona en vals (3/4), polka, corrido o bolero, con acordes mayores, la séptima de dominante y mucha emoción al cantar.',
    'flamenco': 'Música gitano-andaluza con la cadencia frigia (Am–G–F–E) y la escala frigia. La guitarra acompaña al cante y al baile con compases de 12 tiempos o en 4/4 (rumba, tangos), rasgueos de abanico y golpes en la tapa.',
    'bolero': 'Romanticismo cubano y mexicano: tempo lento y acordes que suspiran (I–vi–ii–V7, i–VI–iv–V7). Se toca con guitarra y requinto, con una síncopa suave en la mano derecha.',
    'tango': 'Música rioplatense nacida en Buenos Aires y Montevideo. Armonía menor con dominantes (V7) muy dramáticos, bandoneón, violín y piano. La guitarra marca el compás con firmeza.',
    'ska': 'La Jamaica anterior al reggae, con un ritmo más rápido y alegre. La guitarra toca golpes cortos hacia arriba en todos los contratiempos mientras el bajo camina. Sus olas posteriores (two-tone, tercera ola) lo mezclan con punk.',
    'indie': 'Guitarras brillantes, acordes abiertos con 2ª y 4ª suspendidas, arpegios y progresiones de pop. Suena cercano y cuidado a la vez, con capas de guitarras y mucha textura.',
    'grunge': 'Seattle, años 90: guitarras con distorsión sucia, power chords y un contraste fuerte entre estrofas tranquilas y estribillos enormes. Mezcla punk, metal y pop con letras sombrías.',
    'disco': 'Pista de baile de los 70: bajo en octavas, batería de «cuatro por el piso», cuerdas y una guitarra que marca el contratiempo con acordes cortos (m7, 9, maj7).',
    'reggaeton': 'Nacido en Panamá y Puerto Rico del reggae en español y el dembow. Un patrón de batería muy marcado, acordes menores en bucle y melodías pegadizas.',
    'lofi': 'Beats suaves para estudiar o relajarse: acordes maj7 y m7 con sabor a jazz, un compás perezoso y un sonido ligeramente «gastado». La guitarra repite una progresión corta con mucha calma.',
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
    'cumbia': 'Bajo en el 1 y el 3 y rasgueo corto ↓↑ en el contratiempo: «bom-chiqui, bom-chiqui».',
    'salsa': 'Acordes sincopados que caen en el «y» de los pulsos y dejan huecos para el bajo (tumbao) y la clave 3-2 o 2-3. A menudo, solo las cuerdas agudas.',
    'ranchera': 'En vals: bajo en el 1, acorde en el 2 y rebote ↓↑ en el 3. En polka o corrido, el bajo y el rasgueo se alternan (boom-chick).',
    'flamenco': 'Rumba flamenca: abajo, abajo-arriba, golpe seco en la tapa (✕), arriba y abajo-arriba. Cada acorde se marca con fuerza y silencios precisos.',
    'bolero': 'Bajo en el 1 y acordes que caen entre los pulsos para crear una síncopa suave: bom – chaca – chaca. Tempo lento y sentido.',
    'tango': 'Marcato: golpes secos y firmes en cada pulso, con algún golpe apagado (✕) y un impulso final ↑ antes del siguiente compás.',
    'ska': 'Golpe hacia arriba muy corto en cada contratiempo (el «y» de cada pulso), con el bajo caminando en los pulsos.',
    'indie': 'Rasgueo de fogata (↓ ↓ ↓↑ ↓↑) con la púa blanda, alternado con arpegios que dejan sonar las cuerdas al aire.',
    'grunge': 'Corcheas siempre hacia abajo con power chords; en la estrofa suena suelto y en el estribillo, con acentos muy marcados.',
    'disco': 'Golpe fuerte en cada pulso con el contratiempo apagado (↓ ✕ ↓↑): un groove constante a unos 120 bpm.',
    'reggaeton': 'El «dembow»: golpes en el 1, el «y» del 2, el 3 y el 4. El rasgueo se apoya en esos acentos y deja silencios entre ellos.',
    'lofi': 'Acordes largos y arrastrados con un ritmo perezoso (↓ ·· ↑ ↓ · ↑); deja huecos para que respire.',
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
    'cumbia': 'Apaga las cuerdas con la palma entre golpes para lograr el «chiqui» seco y empieza solo con La menor, Re menor y Mi7.',
    'salsa': 'Aprende un montuno con dos acordes (C6–A7), deja que el bajo marque el 1 y escucha la clave antes de tocar.',
    'ranchera': 'Alterna el bajo entre la raíz y la quinta del acorde y no olvides el V7 que vuelve al I: es el sello de la ranchera.',
    'flamenco': 'Empieza con la cadencia andaluza en La menor y rasguea todo con el mismo patrón antes de añadir adornos; con cejilla cambias de tono sin cambiar de formas.',
    'bolero': 'Lleva el bajo con el pulgar (raíz y quinta) y toca el acorde sincopado con los otros dedos; cuanto más suave, mejor.',
    'tango': 'Practica el final de frase V7 → i y detén la mano un instante antes de cambiar: el silencio también es tango.',
    'ska': 'Rasguea solo las tres cuerdas agudas con la mano relajada y apágalas al instante; practica con metrónomo a 120 antes de subir.',
    'indie': 'Prueba acordes con cuerdas al aire (Dsus2, Asus4, Gsus2) y deja que sigan sonando; una guitarra lleva el ritmo y otra, una línea melódica encima.',
    'grunge': 'Juega con el contraste: estrofa apagada y con pocas notas; en el estribillo, golpes abiertos con todo el brazo.',
    'disco': 'Apaga las cuerdas con la mano izquierda justo después de cada golpe; la limpieza del corte es el groove.',
    'reggaeton': 'Con solo cuatro acordes (Am–F–C–G) lo importante es un pulso muy estable; la guitarra suele doblar la línea del sintetizador.',
    'lofi': 'Toca los acordes con cuatro cuerdas, deja que suenen y añade un adorno de pentatónica cada cuatro compases, nada más.',
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
    'folkWaltz': 'Vals folk',
    'folkScarborough': 'Balada dórica (estilo Scarborough)',
    'folkCampfire': 'Fogata en tres acordes',
    'countryWaltz': 'Vals country',
    'countryTrain': 'Tren de carga (country)',
    'countryBallad': 'Balada country',
    'reggaeAxis': 'Reggae del eje (I–V–vi–IV)',
    'reggaeMinor': 'Reggae menor',
    'bossaTritone': 'Bossa con sustituto de tritono',
    'bossaMinor': 'Bossa menor',
    'latinMinor': 'Menor latino (i–iv–V7)',
    'latinPop': 'Pop latino (I–V–IV–V)',
    'rancheraPolka': 'Polka norteña',
    'rancheraCorrido': 'Corrido en vals',
    'rancheraMinor': 'Ranchera menor',
    'rancheraBolero': 'Bolero ranchero (I–VI7–ii–V7)',
    'cumbiaMajor': 'Cumbia en mayor',
    'cumbiaMinor': 'Cumbia en menor',
    'cumbiaSonidera': 'Cumbia sonidera',
    'cumbiaVillera': 'Cumbia villera',
    'salsaMontuno': 'Montuno clásico (I–IV–V7–IV)',
    'salsaMinor': 'Salsa menor (cadencia andaluza)',
    'salsaRomantica': 'Salsa romántica',
    'salsaTurnaround': 'Vuelta salsera (ii–V–I–VI7)',
    'boleroClassic': 'Bolero clásico (I–vi–ii–V7)',
    'boleroMinor': 'Bolero menor',
    'boleroEight': 'Bolero de ocho compases',
    'tangoMinor': 'Tango menor',
    'tangoVuelta': 'Tango con vuelta',
    'tangoMajor': 'Tango en mayor',
    'flamencoCadence': 'Cadencia andaluza en Mi',
    'flamencoRumba': 'Rumba flamenca',
    'flamencoPorArriba': 'Flamenco «por arriba» (frigio)',
    'flamencoTangos': 'Tangos flamencos',
    'rockMinor': 'Rock menor (i–bVII–bVI–bVII)',
    'rockEpic': 'Himno épico (bVI–bVII–I)',
    'rockRiff': 'Riff de power chords (I–bIII–IV)',
    'grungeMinor': 'Grunge pesado',
    'grungeSlow': 'Grunge a medio tiempo',
    'grungeRiff': 'Riff grunge (i–bIII–bVII–IV)',
    'indieJangle': 'Indie de guitarras brillantes',
    'indieSus': 'Indie con suspendidos',
    'indieDream': 'Indie soñador',
    'punkPop': 'Pop punk (I–V–vi–IV)',
    'punkOi': 'Punk de barrio (Oi!)',
    'skaClassic': 'Ska clásico (I–IV–V7)',
    'skaMinor': 'Ska menor',
    'skaThirdWave': 'Tercera ola (vi–V–IV–I)',
    'metalGallop': 'Galope épico',
    'metalDoom': 'Doom lento (frigio)',
    'bluesQuick': 'Blues con cambio rápido (quick change)',
    'bluesJazz': 'Blues de jazz',
    'blues8bar': 'Blues de ocho compases',
    'jazzRhythmA': 'Cambios de ritmo (sección A)',
    'jazzCircle': 'Círculo de quintas diatónico',
    'jazzMinor251': 'ii–V–i menor',
    'jazzBackdoor': 'Puerta trasera (iv7–bVII7–I)',
    'jazzTritone': 'ii–V con sustituto de tritono',
    'soulMotown': 'Soul de Motown (I–vi–ii–V)',
    'soulNeo': 'Neo-soul (ii7–V7–Imaj7–IVmaj7)',
    'soulMinor': 'Soul menor lento',
    'funkVamp': 'Vamp funk con IV9',
    'funkNinth': 'Funk de novenas dominantes',
    'funkGroove': 'Groove menor (i7–bVII9–IV9)',
    'gospelShout': 'Gospel de palmas (shout)',
    'gospelWaltz': 'Himno en 3/4',
    'gospelMinor': 'Espiritual menor',
    'popRoyalRoad': 'Camino real (IV–V–iii–vi)',
    'popEmo': 'Pop emotivo (vi–iii–IV–I)',
    'popBorrowed': 'Pop con acorde prestado (IV–iv)',
    'balladGentle': 'Balada tierna (I–iii–IV–V)',
    'balladMinor': 'Balada menor (i–bIII–bVII–bVI)',
    'discoMinor': 'Disco menor (i7–iv7–bVII–bIII)',
    'discoStrings': 'Cuerdas de disco (IVmaj7–V7–iii7–vi7)',
    'discoGroove': 'Groove disco en menor',
    'reggaetonMinor': 'Reggaetón menor (i–bVI–bIII–bVII)',
    'reggaetonRomantic': 'Reggaetón romántico (vi–IV–I–V)',
    'reggaetonDark': 'Reggaetón oscuro (i–iv–bVI–V)',
    'lofiDreamy': 'Lo-fi soñador',
    'lofiMinor': 'Lo-fi nocturno',
    'lofiJazzy': 'Lo-fi con ii–V–I',
    'lofiNinth': 'Lo-fi con novena (V9)',
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
    'intervalSongs': 'Intervalos con canciones',
    'subdivision': 'Subdivisión: corcheas, tresillos y swing',
    'modesPractical': 'Modos en la práctica',
    'triads': 'Cómo se construye un acorde',
    'extensions': 'Extensiones, sus y add',
    'inversions': 'Inversiones y bajos slash',
    'circleFifths': 'El círculo de quintas',
    'cadences': 'Cadencias: cómo cierran las frases',
    'relativeParallel': 'Tonalidad relativa y paralela',
    'transposeCapo': 'Transposición y cejilla',
    'styleComping': 'Acompañar según el estilo',
    'tunings': 'Afinaciones alternativas',
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
    'intervalSongs': 'Reconoce cada intervalo por el arranque de una melodía que ya conoces.',
    'subdivision':
        'Divide el pulso en 2, 3 o 4 y entiende la síncopa y el swing.',
    'modesPractical': 'Cuándo y cómo usar dórico, frigio, lidio y mixolidio sobre un acorde fijo.',
    'triads': 'Tríadas y séptimas por apilamiento de terceras, desde la raíz.',
    'extensions':
        'Novenas, onces y trece; acordes suspendidos y con notas añadidas.',
    'inversions': 'Cambia la nota grave del acorde para crear líneas de bajo y enlaces suaves.',
    'circleFifths':
        'El mapa de las 12 tonalidades: alteraciones, vecinos y progresiones.',
    'cadences': 'Auténtica, plagal, semicadencia, rota y andaluza: cada una dice algo distinto.',
    'relativeParallel':
        'Dos formas de emparentar tonalidades y un truco: el préstamo modal.',
    'transposeCapo': 'Cambia de tono sin cambiar de dedos: el capo y la tabla de equivalencias.',
    'styleComping': 'Los mismos acordes suenan a pop, reggae, balada o cumbia según el ritmo.',
    'tunings': 'Drop D, DADGAD y open G: qué cambian y para qué sirven.',
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
    'intervalSongs': 'Un intervalo es la distancia entre dos notas y se cuenta en semitonos (en una misma cuerda, trastes). Aprenderlos con canciones es el atajo para reconocerlos de oído: tu memoria ya sabe cómo suena cada salto.\n\nSegunda menor (1 semitono): el tema de «Tiburón». Segunda mayor (2): el «Frère Jacques» o «Fray Santiago». Tercera mayor (4): el arranque de «When the Saints Go Marching In». Cuarta justa (5): «Amazing Grace» (A-ma-zing) o la marcha nupcial. Tritono (6): «Maria» de West Side Story y el tema de Los Simpson. Quinta justa (7): «Estrellita, ¿dónde estás?» y el tema de La guerra de las galaxias. Sexta mayor (9): «My Bonnie Lies over the Ocean». Octava (12): el «Somewhere over the Rainbow».\n\nPara practicar, toca el primer intervalo en dos cuerdas y cántalo antes de comprobar. En la guitarra, la misma distancia se ve igual en todo el mástil, así que cada forma que aprendes la puedes mover.',
    'subdivision': 'El pulso se puede dividir de varias formas. Negras: un golpe por pulso («1 2 3 4»). Corcheas: dos por pulso («1 y 2 y»), el motor del rock y el pop: abajo en el pulso, arriba en el «y». Semicorcheas: cuatro por pulso («1 e y a»), típicas del funk. Tresillos: tres por pulso («1-tri-ple»), el balanceo del blues lento, el vals criollo y el 6/8.\n\nLa síncopa es acentuar donde no se espera: el contratiempo (el «y»), o dejar en silencio el pulso. Reggae, ska y salsa viven de eso. El swing y el shuffle son corcheas «desiguales»: la primera dura el doble que la segunda (como el primer y el tercer elemento de un tresillo), y por eso suena a balanceo.\n\nTruco de estudio: mantén el brazo en movimiento constante (abajo en el pulso, arriba en el «y») y cambia solo qué golpes tocas y cuáles dejas en silencio. Así los patrones de la guía de géneros salen casi solos.',
    'modesPractical': 'En la práctica un modo se elige por el acorde que suena, no por la teoría. Sobre un acorde menor 7 (Em7) toca dórico: es el menor «con sexta mayor», la receta del funk, el jazz y Santana. Sobre un dominante 7 (G7) o un acorde mayor del rock con bVII toca mixolidio: el mayor «con séptima menor». Sobre un acorde mayor soñador (Fmaj7) toca lidio: mayor con la cuarta aumentada, de banda sonora. Sobre un menor con bII (Em–F) toca frigio: el sabor del flamenco y el metal.\n\nCada modo se distingue por su nota característica: la 6ª mayor en el dórico, la b2 en el frigio, la #4 en el lidio y la b7 en el mixolidio. Insiste en esa nota, resuélvela en la tónica y el modo se oirá enseguida.\n\nReceta rápida: elige un vamp de uno o dos acordes, localiza la tónica en la 6ª cuerda y toca la escala desde ahí; usa el explorador de escalas para ver las posiciones en los 12 tonos.',
    'triads': 'Un acorde se construye apilando terceras a partir de una nota, la raíz. Una tercera mayor son 4 semitonos y una menor, 3. La tríada mayor es raíz + tercera mayor + quinta (0-4-7, como Do–Mi–Sol); la menor cambia la tercera por una menor (0-3-7: Do–Mi♭–Sol). La disminuida apila dos terceras menores (0-3-6) y la aumentada, dos mayores (0-4-8).\n\nSi añades otra tercera encima nacen las séptimas: mayor 7 (0-4-7-11, soñadora), dominante 7 (0-4-7-10, tensa y con ganas de resolver), menor 7 (0-3-7-10, suave) y, con la tríada disminuida, la semidisminuida (m7♭5), típica del ii–V menor. La tercera es la nota que decide si el acorde suena alegre o triste.\n\nAsí puedes deducir cualquier acorde sin memorizarlo: cuenta los semitonos desde la raíz y busca esas notas en las cuerdas. En la tonalidad de Do mayor, apilando terceras sobre cada nota de la escala, salen siete acordes: tres mayores, tres menores y uno disminuido.',
    'extensions': 'Si sigues apilando terceras tras la séptima aparecen las extensiones: la novena (9), la oncena (11) y la trecena (13). Son las notas 2, 4 y 6 una octava más arriba. Un acorde de novena (C9) es un dominante 7 con la novena añadida: más rico y funky que el C7. En la práctica no se tocan todas las notas: se omite la quinta y, en dominantes, la oncena choca con la tercera.\n\nLos acordes suspendidos (sus) sustituyen la tercera por otra nota: sus2 usa la segunda y sus4 la cuarta. No son mayores ni menores; suenan abiertos, en suspenso, y el sus4 suele resolver en el acorde mayor (Dsus4 → D). Los acordes add añaden una nota sin tocar la séptima: Cadd9 es una tríada mayor con la novena, brillante y moderna (muy usada en el indie y el pop).\n\nQué usar y dónde: 9 en funk y soul, maj7 y m7 en jazz y lo-fi, sus2 y sus4 en pop e indie, 6 y m6 en bossa y bolero. Prueba a sustituir un acorde de una progresión por su versión con color y escucha cómo cambia el ambiente.',
    'inversions': 'Un acorde no siempre suena con su raíz en el bajo. Si la nota más grave es la tercera, está en primera inversión; si es la quinta, en segunda inversión. Se escribe con una barra: C/E es un Do con Mi en el bajo, C/G un Do con Sol. La nota tras la barra es siempre la del bajo, y puede ser incluso una nota ajena al acorde (C/D).\n\nSirven para dos cosas: dar movimiento al bajo y suavizar los cambios. Una línea descendente C – G/B – Am – Am/G – F – C/E – Dm – G (la «línea de bajo del canon») suena fluida porque el bajo baja por grados conjuntos. En guitarra, C/E es un Do abierto tocado también con la 6ª cuerda al aire; G/B es un Sol con el Si de la 5ª cuerda (traste 2) y D/F♯ lleva el Fa♯ de la 6ª cuerda (traste 2).\n\nEn el banco de Chords muchos acordes tienen formas en inversión (tríadas movibles con la raíz o la tercera en el bajo). Búscalas en la ficha del acorde y practica el enlace C – G/B – Am.',
    'circleFifths': 'El círculo de quintas ordena las 12 tonalidades de quinta en quinta. Hacia la derecha, cada paso añade un sostenido: Do (ninguno), Sol (1), Re (2), La (3), Mi (4), Si (5), Fa♯ (6). Hacia la izquierda añade un bemol: Fa (1), Si♭ (2), Mi♭ (3), La♭ (4). Dentro de cada tonalidad mayor vive su relativa menor (Do–La menor, Sol–Mi menor…).\n\nEs un mapa de parentescos: dos vecinos del círculo comparten seis de siete notas, así que modular entre ellos es suave. Y te da los acordes de una tonalidad de un vistazo: el I (tu tono) con sus dos vecinos, el IV a la izquierda y el V a la derecha. En Sol mayor, Do (IV) y Re (V) son sus vecinos.\n\nAdemás marca un camino armónico muy natural: las quintas descendentes. iii–vi–ii–V–I (Mim–Lam–Rem–Sol7–Do) sigue el círculo hacia la izquierda y suena a «resolución» en cada paso; es la base del jazz, de las rancheras y de la mitad del pop clásico.',
    'cadences': 'Una cadencia es la fórmula de dos o más acordes con la que termina una frase, como una puntuación. La auténtica (V–I, mejor con V7–I) es el punto final: la más conclusiva, porque la sensible sube a la tónica. La plagal (IV–I) es el «amén» del gospel y suena más suave y solemne.\n\nLa semicadencia acaba en el V (I–V, ii–V…): es una coma, la frase queda abierta y pide continuación. La cadencia rota o engañosa (V–vi) engaña al oído: esperas el I y llega el vi, que suena parecido pero triste, y prolonga la frase. Y la cadencia andaluza (i–♭VII–♭VI–V, Am–G–F–E) baja por grados conjuntos hasta un V mayor: es la cadencia del flamenco, de la rumba y de muchos temas de rock y pop latino.\n\nEscúchalas por la sensación: ¿ha terminado?, ¿falta algo?, ¿me ha sorprendido? Aprende a reconocer cuándo una canción «hace una coma» y cuándo «pone el punto» y te será mucho más fácil acompañar y anticipar los cambios.',
    'relativeParallel': 'La tonalidad relativa comparte las mismas notas pero tiene otra tónica: Do mayor y La menor usan las mismas siete notas. La menor relativa está tres semitonos por debajo de la tónica mayor (o la mayor, tres por encima de la menor). Por eso los mismos acordes sirven en las dos: C, Dm, Em, F, G y Am están tanto en Do mayor como en La menor; solo cambia cuál suena a «casa».\n\nLa tonalidad paralela comparte la tónica pero cambia el modo: Do mayor y Do menor. Aquí cambian las notas (la 3ª, la 6ª y la 7ª se bajan un semitono) y los acordes también: Do mayor tiene F, Do menor tiene Fm.\n\nEso permite el préstamo modal: tomar un acorde de la paralela para dar color. El IV–iv del gospel (F → Fm sobre Do), el ♭VII del rock (B♭ sobre Do) o el ♭VI épico vienen de la paralela menor. Cuando una canción suena «más oscura» de repente, suele estar prestando un acorde.',
    'transposeCapo': 'Transponer es mover una canción entera a otro tono manteniendo los grados: cada acorde sube o baja los mismos semitonos. Se hace para adaptar el tono a la voz del cantante o para tocar con formas más cómodas. En el cancionero de Chords puedes transportar ±6 semitonos con un toque.\n\nLa cejilla (capo) sube todas las cuerdas al aire un semitono por traste: con la cejilla en el traste 2, las formas de Sol suenan como La, las de Do suenan como Re y las de Mi como Fa♯. La fórmula es: tono real = forma + traste de la cejilla. Si la canción está en Re y quieres tocar formas de Do, pon la cejilla en el traste 2.\n\nPara elegir: mira los acordes en el tono original, busca el tono en el que se toquen con formas abiertas (G, C, D, Em, Am) y calcula el traste. El capo además da un timbre brillante y más cuerdas al aire, muy usado en folk y pop.',
    'styleComping': 'Una progresión como I–V–vi–IV puede ser pop, reggae, balada, indie o cumbia: lo que cambia es cómo la tocas. Hay cuatro ingredientes. El patrón de rasgueo (qué golpes tocas y cuáles dejas en silencio), la dinámica (suave en la estrofa, fuerte en el estribillo), el registro (cuerdas graves, agudas o todas) y el apagado (acordes largos o cortos y secos).\n\nEjemplos: el pop usa ↓ ↓↑ ↑↓↑; el reggae calla en los pulsos y toca solo en el contratiempo; la balada arpegia o da un golpe por compás; la cumbia lleva el bajo en 1 y 3 y un «chiqui» en el contratiempo; el funk apaga casi todo y deja unos pocos golpes; el rock pesado usa power chords con palm mute. La guía de géneros reúne el patrón de cada estilo con su tempo.\n\nEjercicio: elige una progresión del jam y toca la misma vuelta con cuatro estilos distintos. Si cambias el patrón y el tempo, cambia hasta el sentido de la canción.',
    'tunings': 'La afinación estándar es Mi–La–Re–Sol–Si–Mi (EADGBE). Cambiar alguna cuerda abre sonidos nuevos. En Drop D bajas solo la 6ª cuerda un tono (Re–La–Re–Sol–Si–Mi): los power chords se tocan con un solo dedo en las tres cuerdas graves y el grave suena más pesado; es la afinación del grunge, el metal y el rock duro.\n\nDADGAD (Re–La–Re–Sol–La–Re) no tiene tercera en sus acordes abiertos: suena abierta, ni mayor ni menor, y por eso se usa en el folk celta y el fingerstyle. En open G (Re–Sol–Re–Sol–Si–Re) las cuerdas al aire forman un acorde de Sol mayor: con un dedo o un slide recorres todos los acordes; es la afinación del blues del Delta y del rock con slide.\n\nConsejos: afina cuerda a cuerda con el afinador de la app, baja el tono despacio (el cuello se adapta) y revisa la afinación pasado un rato. Con un cambio de afinación los acordes que conoces cambian de forma: aprende primero cuatro o cinco formas y vuelve a la estándar al terminar.',
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
    'intervalSongs': 'Intervalo = distancia en semitonos entre dos notas\n2ª m = «Tiburón» · 2ª M = «Frère Jacques» · 3ª M = «When the Saints»\n4ª justa = «Amazing Grace» · 5ª justa = «Estrellita»\nTritono (6) = «Maria»; es el más inestable\nCanta el intervalo antes de tocarlo y comprueba',
    'subdivision': 'Negras = pulso · corcheas = «1 y 2 y» · semicorcheas = «1 e y a»\nTresillo = tres notas en un pulso (blues lento, 6/8)\nSíncopa = acento en el contratiempo o silencio en el pulso\nSwing/shuffle: corchea larga + corta (2 a 1)\nBrazo siempre en movimiento: abajo en el pulso, arriba en el «y»',
    'modesPractical': 'Dórico = menor 7 · sexta mayor (funk, jazz)\nMixolidio = dominante 7 · b7 (rock, blues, country)\nLidio = mayor maj7 · #4 (sonido soñador)\nFrigio = menor con b2 (flamenco, metal)\nToca la nota característica y resuélvela en la tónica',
    'triads': 'Tercera mayor = 4 semitonos · tercera menor = 3\nMayor 0-4-7 · menor 0-3-7 · disminuido 0-3-6 · aumentado 0-4-8\nSéptimas: maj7 (0-4-7-11) · 7 (0-4-7-10) · m7 (0-3-7-10)\nLa tercera decide si suena alegre o triste\nEn una tonalidad mayor: 3 mayores, 3 menores y 1 disminuido',
    'extensions': '9 = 2ª arriba · 11 = 4ª · 13 = 6ª (una octava más arriba)\nC9 = C7 + novena: funk, soul, r&b\nsus2 y sus4 sustituyen la tercera; sus4 suele resolver a mayor\nadd9 = tríada + novena, sin séptima (indie, pop)\nCambia un acorde por su versión con color y compara',
    'inversions': 'Primera inversión = tercera en el bajo · segunda = quinta\nC/E = acorde de Do con Mi en el bajo (la nota tras la barra)\nUn bajo que baja por grados conjuntos suena fluido\nC/E, G/B y D/F♯ son los slash más útiles en guitarra\nBusca las formas en inversión en la ficha de cada acorde',
    'circleFifths': 'Derecha = +1 sostenido por paso · izquierda = +1 bemol\nVecinos del círculo comparten 6 de 7 notas\nI con su IV (izquierda) y su V (derecha) = los tres acordes básicos\nCada mayor lleva dentro su relativa menor\nQuintas descendentes: iii–vi–ii–V–I (jazz, ranchera, pop clásico)',
    'cadences': 'Auténtica V–I (V7–I): el punto final\nPlagal IV–I: el «amén», más suave\nSemicadencia (acaba en V): una coma, queda abierta\nRota V–vi: esperas el I y llega el vi\nAndaluza i–♭VII–♭VI–V (Am–G–F–E): flamenco y rumba',
    'relativeParallel': 'Relativa: mismas notas, otra tónica (Do ↔ La menor)\nLa menor relativa está 3 semitonos bajo la tónica mayor\nParalela: misma tónica, otro modo (Do ↔ Do menor)\nPréstamo modal: IV → iv, ♭VII, ♭VI vienen de la paralela\nSi una canción oscurece de golpe, busca el acorde prestado',
    'transposeCapo': 'Transponer = mismo recorrido de grados en otro tono\nCejilla en el traste N: sube todo N semitonos\nTono real = forma + traste (G + 2 = A, C + 2 = D, D + 2 = E)\nElige formas abiertas (G, C, D, Em, Am) y calcula el traste\nEl cancionero transporta ±6 semitonos',
    'styleComping': 'Cuatro ingredientes: patrón, dinámica, registro y apagado\nPop: ↓ ↓↑ ↑↓↑ · reggae: solo el contratiempo\nBalada: arpegio o un golpe por compás\nCumbia: bajo en 1 y 3 y «chiqui» · funk: casi todo apagado\nToca la misma vuelta en cuatro estilos y compara',
    'tunings': 'Estándar = EADGBE\nDrop D = DADGBE: power chords con un dedo, grave pesado\nDADGAD = acordes abiertos sin tercera (folk, fingerstyle)\nOpen G = DGDGBD: un dedo o slide hace los acordes (blues)\nAfina cuerda a cuerda y baja el tono despacio',
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
    'cumbiaInAm': 'Cumbia en La menor',
    'salsaMontuno': 'Montuno de salsa en Do',
    'rancheraInG': 'Ranchera en vals en Sol',
    'polkaNortena': 'Polka norteña en Sol',
    'flamencoRumba': 'Rumba flamenca en La menor',
    'tangoInDm': 'Tango en Re menor',
    'boleroInC': 'Bolero en Do',
    'reggaetonInAm': 'Dembow en La menor',
    'merengueInG': 'Merengue en Sol',
    'bachataInAm': 'Bachata en La menor',
    'valsCriolloInAm': 'Vals criollo en La menor',
    'discoInAm': 'Disco en La menor',
    'skaInG': 'Ska en Sol',
    'indieInD': 'Indie luminoso en Re',
    'grungeInE': 'Grunge en Mi',
    'lofiInC': 'Lo-fi en Do',
    'punkInE': 'Punk en Mi',
    'folkInG': 'Folk de fogata en Sol',
    'countryInG': 'Country boom-chick en Sol',
    'countryTrainInE': 'Tren de carga en Mi',
    'reggaeInC': 'Reggae en Do',
    'bossaInC': 'Bossa en Do',
    'jazz251InC': 'ii–V–I en Do',
    'soulInC': 'Soul con séptimas mayores',
    'gospelInC': 'Gospel con el IV menor',
    'balladInC': 'Balada arpegiada en Do',
    'andaluzaInAm': 'Cadencia andaluza en La menor',
    'bluesMinorInE': 'Blues menor en Mi',
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

// Path: chordGames.prompt
class Translations$chordGames$prompt$es {
  Translations$chordGames$prompt$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: '¿Qué notas forman $chord?'
  String spellSet({required Object chord}) => '¿Qué notas forman ${chord}?';

  /// es: 'Toca las notas de $chord, de la raíz hacia arriba'
  String spellOrder({required Object chord}) =>
      'Toca las notas de ${chord}, de la raíz hacia arriba';

  /// es: '¿Cuál es la fórmula de $chord?'
  String formulaTo({required Object chord}) =>
      '¿Cuál es la fórmula de ${chord}?';

  /// es: '¿Qué acorde de raíz $note tiene la fórmula $formula?'
  String formulaName({required Object note, required Object formula}) =>
      '¿Qué acorde de raíz ${note} tiene la fórmula ${formula}?';

  /// es: 'Suena un acorde de raíz $note. ¿Qué variante es?'
  String variantEar({required Object note}) =>
      'Suena un acorde de raíz ${note}. ¿Qué variante es?';

  /// es: 'Escucha y repite los acordes en el mismo orden'
  String get chordMemory => 'Escucha y repite los acordes en el mismo orden';

  /// es: '¿En qué cuerda está la raíz más grave de este $chord?'
  String rootString({required Object chord}) =>
      '¿En qué cuerda está la raíz más grave de este ${chord}?';

  /// es: '¿Qué nota hace de bajo (la cuerda más grave que suena) en este $chord?'
  String bassNote({required Object chord}) =>
      '¿Qué nota hace de bajo (la cuerda más grave que suena) en este ${chord}?';

  /// es: '¿En qué inversión está este $chord?'
  String inversionDiagram({required Object chord}) =>
      '¿En qué inversión está este ${chord}?';

  /// es: 'Escucha este $chord. ¿Qué inversión suena?'
  String inversionEar({required Object chord}) =>
      'Escucha este ${chord}. ¿Qué inversión suena?';

  /// es: 'Un diagrama de $chord tiene un error. ¿Cuál?'
  String wrongDiagram({required Object chord}) =>
      'Un diagrama de ${chord} tiene un error. ¿Cuál?';

  /// es: '¿Con qué forma CAGED está tocado este $chord?'
  String cagedShape({required Object chord}) =>
      '¿Con qué forma CAGED está tocado este ${chord}?';

  /// es: 'Para tocar $chord con la forma de $shape, ¿en qué traste va la cejilla?'
  String cagedBarre({required Object chord, required Object shape}) =>
      'Para tocar ${chord} con la forma de ${shape}, ¿en qué traste va la cejilla?';

  /// es: '¿Qué acorde es este?'
  String get rush => '¿Qué acorde es este?';

  /// es: 'Completa la progresión de $genre en $key: ¿qué acorde falta?'
  String fillChord({required Object genre, required Object key}) =>
      'Completa la progresión de ${genre} en ${key}: ¿qué acorde falta?';

  /// es: 'Completa la progresión de $genre en $key: ¿qué grado falta?'
  String fillRoman({required Object genre, required Object key}) =>
      'Completa la progresión de ${genre} en ${key}: ¿qué grado falta?';

  /// es: 'En $key, ¿qué acorde es el $roman?'
  String romanToChord({required Object key, required Object roman}) =>
      'En ${key}, ¿qué acorde es el ${roman}?';

  /// es: 'En $key, ¿qué grado es $chord?'
  String romanToRoman({required Object key, required Object chord}) =>
      'En ${key}, ¿qué grado es ${chord}?';

  /// es: '(one) {Sube $chord un semitono. ¿Qué acorde resulta?} (other) {Sube $chord $n semitonos. ¿Qué acorde resulta?}'
  String transposeUp({required num n, required Object chord}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: 'Sube ${chord} un semitono. ¿Qué acorde resulta?',
        other: 'Sube ${chord} ${n} semitonos. ¿Qué acorde resulta?',
      );

  /// es: '(one) {Baja $chord un semitono. ¿Qué acorde resulta?} (other) {Baja $chord $n semitonos. ¿Qué acorde resulta?}'
  String transposeDown({required num n, required Object chord}) =>
      (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
        n,
        one: 'Baja ${chord} un semitono. ¿Qué acorde resulta?',
        other: 'Baja ${chord} ${n} semitonos. ¿Qué acorde resulta?',
      );

  /// es: 'Con capo en el traste $n tocas la forma de $chord. ¿Qué acorde suena?'
  String capoSounds({required Object n, required Object chord}) =>
      'Con capo en el traste ${n} tocas la forma de ${chord}. ¿Qué acorde suena?';

  /// es: 'Con capo en el traste $n quieres que suene $chord. ¿Qué forma tocas?'
  String capoShape({required Object n, required Object chord}) =>
      'Con capo en el traste ${n} quieres que suene ${chord}. ¿Qué forma tocas?';

  /// es: '¿Cuál es el relativo menor de $chord?'
  String relativeMinor({required Object chord}) =>
      '¿Cuál es el relativo menor de ${chord}?';

  /// es: '¿Cuál es el relativo mayor de $chord?'
  String relativeMajor({required Object chord}) =>
      '¿Cuál es el relativo mayor de ${chord}?';

  /// es: '¿Cuál es la dominante (V) de $chord?'
  String dominant({required Object chord}) =>
      '¿Cuál es la dominante (V) de ${chord}?';

  /// es: '¿Cuál es la subdominante (IV) de $chord?'
  String subdominant({required Object chord}) =>
      '¿Cuál es la subdominante (IV) de ${chord}?';

  /// es: 'En el círculo de quintas, ¿qué acorde está una quinta por encima de $chord?'
  String fifthUp({required Object chord}) =>
      'En el círculo de quintas, ¿qué acorde está una quinta por encima de ${chord}?';

  /// es: 'En el círculo de quintas, ¿qué acorde está una quinta por debajo de $chord?'
  String fifthDown({required Object chord}) =>
      'En el círculo de quintas, ¿qué acorde está una quinta por debajo de ${chord}?';

  /// es: '¿Cuál es el acorde paralelo de $chord (misma nota, otro modo)?'
  String parallel({required Object chord}) =>
      '¿Cuál es el acorde paralelo de ${chord} (misma nota, otro modo)?';

  /// es: '¿Cuál es la sustitución de tritono de $chord?'
  String tritone({required Object chord}) =>
      '¿Cuál es la sustitución de tritono de ${chord}?';

  /// es: 'Escucha la progresión y el rasgueo. ¿De qué género es?'
  String get styleDuel =>
      'Escucha la progresión y el rasgueo. ¿De qué género es?';
}

// Path: chordGames.choice
class Translations$chordGames$choice$es {
  Translations$chordGames$choice$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Fundamental'
  String get inversionRoot => 'Fundamental';

  /// es: '1ª inversión'
  String get inversionFirst => '1ª inversión';

  /// es: '2ª inversión'
  String get inversionSecond => '2ª inversión';

  /// es: '3ª inversión'
  String get inversionThird => '3ª inversión';

  /// es: 'Diagrama $n'
  String diagram({required Object n}) => 'Diagrama ${n}';
}

// Path: chordGames.explain
class Translations$chordGames$explain$es {
  Translations$chordGames$explain$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'En la $string suena $note, que no es una nota de $chord.'
  String alienNote({
    required Object string,
    required Object note,
    required Object chord,
  }) => 'En la ${string} suena ${note}, que no es una nota de ${chord}.';

  /// es: 'La $string debía ir muteada: al aire suena $note, que no es de $chord.'
  String unmutedString({
    required Object string,
    required Object note,
    required Object chord,
  }) =>
      'La ${string} debía ir muteada: al aire suena ${note}, que no es de ${chord}.';

  /// es: 'Falta $note, una de las notas que definen $chord.'
  String missingNote({required Object note, required Object chord}) =>
      'Falta ${note}, una de las notas que definen ${chord}.';

  /// es: 'Era $genre.'
  String styleDuel({required Object genre}) => 'Era ${genre}.';

  /// es: 'Es la forma de $shape.'
  String shape({required Object shape}) => 'Es la forma de ${shape}.';
}

// Path: chordGames.changes
class Translations$chordGames$changes$es {
  Translations$chordGames$changes$es.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// es: 'Prepárate…'
  String get getReady => 'Prepárate…';

  /// es: 'Empieza en $n'
  String startsIn({required Object n}) => 'Empieza en ${n}';

  /// es: 'Toca este acorde'
  String get playThis => 'Toca este acorde';

  /// es: 'Cambios limpios'
  String get clean => 'Cambios limpios';

  /// es: 'Meta: $n'
  String goal({required Object n}) => 'Meta: ${n}';

  /// es: 'Notas oídas: $count de $total'
  String heard({required Object count, required Object total}) =>
      'Notas oídas: ${count} de ${total}';

  /// es: 'Oír el acorde'
  String get hear => 'Oír el acorde';

  /// es: 'Saltar acorde'
  String get skip => 'Saltar acorde';

  /// es: 'Te escucho…'
  String get listening => 'Te escucho…';

  /// es: '¡Cambio limpio!'
  String get cleanChange => '¡Cambio limpio!';

  /// es: 'Se agotó el tiempo con este acorde'
  String get missed => 'Se agotó el tiempo con este acorde';

  /// es: 'Quedan $n s'
  String timeLeft({required Object n}) => 'Quedan ${n} s';
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
          }) => '${count} juegos de oído, mástil, acordes y armonía',
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
          _ => null,
        } ??
        switch (path) {
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
          'chordGames.chordsTitle' => 'Acordes y variantes',
          'chordGames.chordsSubtitle' =>
            'Notas, fórmulas, diagramas, formas CAGED y retos con tiempo',
          'chordGames.harmonyTitle' => 'Progresiones y armonía',
          'chordGames.harmonySubtitle' =>
            'Grados, transporte, relativos y estilos',
          'chordGames.newBadge' => 'Nuevo',
          'chordGames.searchHint' => 'Buscar juegos',
          'chordGames.filterAll' => 'Todos',
          'chordGames.filterNew' => 'Nuevos',
          'chordGames.filterLabel' => 'Filtrar por familia',
          'chordGames.noResultsTitle' => 'Ningún juego coincide',
          'chordGames.noResultsBody' =>
            'Prueba con otra palabra o quita el filtro.',
          'chordGames.clearSearch' => 'Quitar la búsqueda',
          'chordGames.gamesCount' =>
            ({required num n}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: '${n} juego',
                  other: '${n} juegos',
                ),
          'chordGames.timeUp' => '¡Se acabó el tiempo!',
          'chordGames.timeLeft' => ({required Object n}) => '${n} s',
          'chordGames.speedBonus' => ({
            required Object n,
          }) => 'Rapidez: +${n} puntos',
          'chordGames.perQuestion' => ({
            required Object n,
          }) => 'Tiempo por pregunta: ${n} s',
          'chordGames.changesGoal' => ({
            required Object goal,
            required Object seconds,
          }) => 'Meta: ${goal} cambios limpios en ${seconds} s',
          'chordGames.titles.spellChord' => 'Deletrea el acorde',
          'chordGames.titles.chordFormula' => 'Fórmula del acorde',
          'chordGames.titles.chordVariantEar' => '¿Qué variante es?',
          'chordGames.titles.chordMemory' => 'Memoria de acordes',
          'chordGames.titles.rootAndBass' => 'Raíz y bajo',
          'chordGames.titles.inversion' => 'Inversiones',
          'chordGames.titles.wrongDiagram' => 'Diagrama incorrecto',
          'chordGames.titles.cagedShape' => 'Formas CAGED',
          'chordGames.titles.rushOpen' => 'Racha: acordes abiertos',
          'chordGames.titles.rushBarre' => 'Racha: cejillas',
          'chordGames.titles.rushSeventh' => 'Racha: séptimas',
          'chordGames.titles.fillProgression' => 'Completa la progresión',
          'chordGames.titles.romanDegree' => 'Grados romanos',
          'chordGames.titles.transposeChord' => 'Transporta',
          'chordGames.titles.chordNeighbors' => 'Relativos y quintas',
          'chordGames.titles.styleDuel' => 'Duelo de estilos',
          'chordGames.titles.chordChanges' => 'Cambios de acorde',
          'chordGames.descriptions.spellChord' =>
            '¿Qué notas forman cada acorde?',
          'chordGames.descriptions.chordFormula' =>
            'Del acorde a su fórmula 1-3-5… y al revés',
          'chordGames.descriptions.chordVariantEar' =>
            'Oye maj7, 7, 6, sus… y distingue la variante',
          'chordGames.descriptions.chordMemory' =>
            'Repite la sucesión de acordes que oyes',
          'chordGames.descriptions.rootAndBass' =>
            'Dónde está la raíz y qué nota va en el bajo',
          'chordGames.descriptions.inversion' =>
            'Fundamental, 1ª o 2ª inversión',
          'chordGames.descriptions.wrongDiagram' =>
            'Encuentra el diagrama con un error',
          'chordGames.descriptions.cagedShape' =>
            'Reconoce C, A, G, E, D y dónde va la cejilla',
          'chordGames.descriptions.rushOpen' =>
            'Nombra acordes abiertos contra el reloj',
          'chordGames.descriptions.rushBarre' =>
            'Nombra acordes con cejilla contra el reloj',
          'chordGames.descriptions.rushSeventh' =>
            'Séptimas y extendidos contra el reloj',
          'chordGames.descriptions.fillProgression' =>
            'Encuentra el acorde que falta',
          'chordGames.descriptions.romanDegree' =>
            'Del IV al acorde y del acorde al IV',
          'chordGames.descriptions.transposeChord' =>
            'Sube semitonos y toca con capo',
          'chordGames.descriptions.chordNeighbors' =>
            'Relativo, dominante, subdominante y quintas',
          'chordGames.descriptions.styleDuel' =>
            '¿Qué género suena? Progresión y rasgueo',
          'chordGames.descriptions.chordChanges' =>
            'Cambios limpios en 60 segundos',
          'chordGames.howTo.spellChord' => 'Verás el nombre de un acorde. En fácil y medio elige el grupo de notas que lo forma: Do6 y La menor 7 comparten notas, así que fíjate en la raíz. En difícil toca las notas del acorde de la raíz hacia arriba.',
          'chordGames.howTo.chordFormula' => 'Cada acorde se construye con intervalos desde su raíz: 1-3-5 es mayor, 1-♭3-5 menor, 1-3-5-♭7 séptima… Pasa del acorde a su fórmula o de la fórmula al nombre del acorde.',
          'chordGames.howTo.chordVariantEar' => 'Oirás un acorde y se te dice su raíz. Distingue qué variante es: mayor, menor, 7, maj7, 6, sus… Cuanto más subes de nivel, más variantes parecidas hay.',
          'chordGames.howTo.chordMemory' => 'Oirás una sucesión de acordes. Pulsa los acordes en el mismo orden en que sonaron. Cada nivel añade más acordes y más opciones.',
          'chordGames.howTo.rootAndBass' => 'Verás el diagrama de una posición. Unas veces hay que decir en qué cuerda está la raíz más grave y otras qué nota hace de bajo, que es la cuerda más grave que suena.',
          'chordGames.howTo.inversion' => 'Un acorde está en estado fundamental si la raíz va en el bajo; con la tercera en el bajo es la 1ª inversión y con la quinta, la 2ª. En difícil solo lo oyes: fíjate en el bajo.',
          'chordGames.howTo.wrongDiagram' => 'Verás varios diagramas del mismo acorde y uno tiene un error: una nota que no es del acorde, una cuerda que debía ir muteada o una nota esencial que falta. Encuéntralo.',
          'chordGames.howTo.cagedShape' => 'Los acordes con cejilla se mueven por el mástil con cinco formas: C, A, G, E y D. Reconoce la forma de un diagrama o di en qué traste va la cejilla para tocar un acorde con una forma dada.',
          'chordGames.howTo.rushOpen' => 'Reto contra el reloj: aparece el diagrama de un acorde abierto y tienes pocos segundos para nombrarlo. Cuanto más rápido aciertes, más puntos.',
          'chordGames.howTo.rushBarre' => 'Reto contra el reloj: aparece el diagrama de un acorde con cejilla y tienes pocos segundos para nombrarlo. Cuanto más rápido aciertes, más puntos.',
          'chordGames.howTo.rushSeventh' => 'Reto contra el reloj: aparece el diagrama de una séptima o un acorde extendido y tienes pocos segundos para decir cuál es. Cuanto más rápido aciertes, más puntos.',
          'chordGames.howTo.fillProgression' => 'Verás una progresión famosa con un acorde oculto (?). Elige cuál falta; en difícil, elige su grado romano. En fácil y medio puedes oír el resto de la progresión.',
          'chordGames.howTo.romanDegree' => 'Los grados romanos nombran los acordes de una tonalidad: en Sol mayor el IV es Do y el V7 es Re7. Pasa del grado al acorde y del acorde al grado; en difícil hay séptimas y acordes prestados como el ♭VII.',
          'chordGames.howTo.transposeChord' => 'Transportar es mover un acorde hacia arriba o abajo. Con un capo en el traste N, la forma que tocas suena N semitonos más aguda. Resuelve subidas, bajadas y capos.',
          'chordGames.howTo.chordNeighbors' => 'Cada acorde tiene vecinos: su relativo (comparte las notas de la escala), su dominante (V), su subdominante (IV) y los de al lado en el círculo de quintas. Encuentra el que se pide.',
          'chordGames.howTo.styleDuel' => 'Oirás los primeros compases de una progresión con su rasgueo. Por los acordes y el ritmo, di de qué género es: pop, rock, blues, reggae…',
          'chordGames.howTo.chordChanges' => 'Te pedimos acordes uno tras otro: tócalo y cámbialo cuanto antes. Cada cambio limpio suma; tienes 60 segundos y la meta de cambios da las tres estrellas.',
          'chordGames.prompt.spellSet' => ({
            required Object chord,
          }) => '¿Qué notas forman ${chord}?',
          'chordGames.prompt.spellOrder' => ({
            required Object chord,
          }) => 'Toca las notas de ${chord}, de la raíz hacia arriba',
          'chordGames.prompt.formulaTo' => ({
            required Object chord,
          }) => '¿Cuál es la fórmula de ${chord}?',
          'chordGames.prompt.formulaName' => ({
            required Object note,
            required Object formula,
          }) => '¿Qué acorde de raíz ${note} tiene la fórmula ${formula}?',
          'chordGames.prompt.variantEar' => ({
            required Object note,
          }) => 'Suena un acorde de raíz ${note}. ¿Qué variante es?',
          'chordGames.prompt.chordMemory' =>
            'Escucha y repite los acordes en el mismo orden',
          'chordGames.prompt.rootString' => ({
            required Object chord,
          }) => '¿En qué cuerda está la raíz más grave de este ${chord}?',
          'chordGames.prompt.bassNote' => ({
            required Object chord,
          }) => '¿Qué nota hace de bajo (la cuerda más grave que suena) en este ${chord}?',
          'chordGames.prompt.inversionDiagram' => ({
            required Object chord,
          }) => '¿En qué inversión está este ${chord}?',
          'chordGames.prompt.inversionEar' => ({
            required Object chord,
          }) => 'Escucha este ${chord}. ¿Qué inversión suena?',
          'chordGames.prompt.wrongDiagram' => ({
            required Object chord,
          }) => 'Un diagrama de ${chord} tiene un error. ¿Cuál?',
          'chordGames.prompt.cagedShape' => ({
            required Object chord,
          }) => '¿Con qué forma CAGED está tocado este ${chord}?',
          'chordGames.prompt.cagedBarre' => ({
            required Object chord,
            required Object shape,
          }) => 'Para tocar ${chord} con la forma de ${shape}, ¿en qué traste va la cejilla?',
          'chordGames.prompt.rush' => '¿Qué acorde es este?',
          'chordGames.prompt.fillChord' => ({
            required Object genre,
            required Object key,
          }) => 'Completa la progresión de ${genre} en ${key}: ¿qué acorde falta?',
          'chordGames.prompt.fillRoman' => ({
            required Object genre,
            required Object key,
          }) => 'Completa la progresión de ${genre} en ${key}: ¿qué grado falta?',
          'chordGames.prompt.romanToChord' => ({
            required Object key,
            required Object roman,
          }) => 'En ${key}, ¿qué acorde es el ${roman}?',
          'chordGames.prompt.romanToRoman' => ({
            required Object key,
            required Object chord,
          }) => 'En ${key}, ¿qué grado es ${chord}?',
          'chordGames.prompt.transposeUp' =>
            ({required num n, required Object chord}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: 'Sube ${chord} un semitono. ¿Qué acorde resulta?',
                  other: 'Sube ${chord} ${n} semitonos. ¿Qué acorde resulta?',
                ),
          'chordGames.prompt.transposeDown' =>
            ({required num n, required Object chord}) =>
                (_root.$meta.cardinalResolver ??
                PluralResolvers.cardinal('es'))(
                  n,
                  one: 'Baja ${chord} un semitono. ¿Qué acorde resulta?',
                  other: 'Baja ${chord} ${n} semitonos. ¿Qué acorde resulta?',
                ),
          'chordGames.prompt.capoSounds' => ({
            required Object n,
            required Object chord,
          }) => 'Con capo en el traste ${n} tocas la forma de ${chord}. ¿Qué acorde suena?',
          'chordGames.prompt.capoShape' => ({
            required Object n,
            required Object chord,
          }) => 'Con capo en el traste ${n} quieres que suene ${chord}. ¿Qué forma tocas?',
          'chordGames.prompt.relativeMinor' => ({
            required Object chord,
          }) => '¿Cuál es el relativo menor de ${chord}?',
          'chordGames.prompt.relativeMajor' => ({
            required Object chord,
          }) => '¿Cuál es el relativo mayor de ${chord}?',
          'chordGames.prompt.dominant' => ({
            required Object chord,
          }) => '¿Cuál es la dominante (V) de ${chord}?',
          'chordGames.prompt.subdominant' => ({
            required Object chord,
          }) => '¿Cuál es la subdominante (IV) de ${chord}?',
          'chordGames.prompt.fifthUp' => ({
            required Object chord,
          }) => 'En el círculo de quintas, ¿qué acorde está una quinta por encima de ${chord}?',
          'chordGames.prompt.fifthDown' => ({
            required Object chord,
          }) => 'En el círculo de quintas, ¿qué acorde está una quinta por debajo de ${chord}?',
          'chordGames.prompt.parallel' => ({
            required Object chord,
          }) => '¿Cuál es el acorde paralelo de ${chord} (misma nota, otro modo)?',
          'chordGames.prompt.tritone' => ({
            required Object chord,
          }) => '¿Cuál es la sustitución de tritono de ${chord}?',
          'chordGames.prompt.styleDuel' =>
            'Escucha la progresión y el rasgueo. ¿De qué género es?',
          'chordGames.choice.inversionRoot' => 'Fundamental',
          'chordGames.choice.inversionFirst' => '1ª inversión',
          'chordGames.choice.inversionSecond' => '2ª inversión',
          'chordGames.choice.inversionThird' => '3ª inversión',
          'chordGames.choice.diagram' => ({
            required Object n,
          }) => 'Diagrama ${n}',
          'chordGames.explain.alienNote' => ({
            required Object string,
            required Object note,
            required Object chord,
          }) => 'En la ${string} suena ${note}, que no es una nota de ${chord}.',
          'chordGames.explain.unmutedString' => ({
            required Object string,
            required Object note,
            required Object chord,
          }) => 'La ${string} debía ir muteada: al aire suena ${note}, que no es de ${chord}.',
          'chordGames.explain.missingNote' => ({
            required Object note,
            required Object chord,
          }) => 'Falta ${note}, una de las notas que definen ${chord}.',
          'chordGames.explain.styleDuel' => ({
            required Object genre,
          }) => 'Era ${genre}.',
          'chordGames.explain.shape' => ({
            required Object shape,
          }) => 'Es la forma de ${shape}.',
          'chordGames.changes.getReady' => 'Prepárate…',
          'chordGames.changes.startsIn' => ({
            required Object n,
          }) => 'Empieza en ${n}',
          'chordGames.changes.playThis' => 'Toca este acorde',
          'chordGames.changes.clean' => 'Cambios limpios',
          'chordGames.changes.goal' => ({required Object n}) => 'Meta: ${n}',
          'chordGames.changes.heard' => ({
            required Object count,
            required Object total,
          }) => 'Notas oídas: ${count} de ${total}',
          'chordGames.changes.hear' => 'Oír el acorde',
          'chordGames.changes.skip' => 'Saltar acorde',
          'chordGames.changes.listening' => 'Te escucho…',
          'chordGames.changes.cleanChange' => '¡Cambio limpio!',
          'chordGames.changes.missed' => 'Se agotó el tiempo con este acorde',
          'chordGames.changes.timeLeft' => ({
            required Object n,
          }) => 'Quedan ${n} s',
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
          'theory.unitTechnique' => 'Técnica y estilo',
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
          'theory.genresEmptyBody' =>
            'Prueba con otro nombre o con un acorde como Am o E7.',
          'theory.genresEmpty' => 'Ningún género coincide con tu búsqueda',
          'theory.genresSearch' => 'Busca un género o un acorde',
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
          'theory.strumMutedHint' => '✕ = golpe apagado (percusivo)',
          'theory.strumStop' => 'Detener',
          'theory.strumPlay' => 'Ver el rasgueo en movimiento',
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
          'theory.strumNames.cumbia' => 'Cumbia',
          'theory.strumNames.salsa' => 'Salsa (montuno)',
          'theory.strumNames.reggaeton' => 'Reggaetón (dembow)',
          'theory.strumNames.rumba' => 'Rumba flamenca',
          'theory.strumNames.ska' => 'Ska (contratiempos rápidos)',
          'theory.strumNames.disco' => 'Disco (cuatro por el piso)',
          'theory.strumNames.bolero' => 'Bolero',
          'theory.strumNames.tango' => 'Tango (marcato)',
          'theory.strumNames.valsRanchero' => 'Vals ranchero',
          'theory.strumNames.valsCriollo' => 'Vals criollo',
          'theory.strumNames.merengue' => 'Merengue',
          'theory.strumNames.bachata' => 'Bachata',
          'theory.strumNames.campfire' => 'Folk de fogata',
          'theory.strumNames.funkMuted' => 'Funk muteado',
          'theory.strumNames.arpeggio' => 'Balada arpegiada',
          'theory.strumNames.downstrokes' => 'Todo hacia abajo',
          'theory.strumNames.gallop' => 'Galope metalero',
          'theory.strumNames.lofi' => 'Lo-fi perezoso',
          'theory.strumNames.charleston' => 'Charleston (jazz)',
          'theory.strumNames.trainBeat' => 'Tren del country',
          'theory.strumNames.tresillo' => 'Tresillo (habanera)',
          'theory.strumNames.rockBallad' => 'Balada de rock',
          'theory.strumNames.whole' => 'Un golpe por compás',
          'theory.strumNames.quarters' => 'Negras',
          'theory.strumNames.pop' => 'Pop',
          'theory.strumNames.eighths' => 'Corcheas',
          'theory.strumNames.boomChick' => 'Bajo y rasgueo',
          'theory.strumNames.skank' => 'Contratiempo (reggae)',
          'theory.strumNames.bossa' => 'Bossa nova',
          'theory.strumNames.shuffle' => 'Shuffle',
          'theory.strumNames.waltz' => 'Vals 3/4',
          'theory.genreFamilies.roots' => 'Raíces y ritmos latinos',
          'theory.genreFamilies.rock' => 'Rock y metal',
          'theory.genreFamilies.soulJazz' => 'Blues, jazz y soul',
          'theory.genreFamilies.pop' => 'Pop y baile',
          'theory.strumAbout.whole' => 'Un solo golpe hacia abajo al inicio del compás; deja sonar el acorde. Ideal para cambiar de acorde sin prisa.',
          'theory.strumAbout.quarters' => 'Un golpe hacia abajo en cada pulso (1, 2, 3 y 4). Sencillo y firme: la mejor manera de empezar.',
          'theory.strumAbout.pop' => 'El rasgueo universal: ↓ ↓↑ ↑↓↑. El brazo no deja de moverse y solo se «pierden» algunos golpes.',
          'theory.strumAbout.eighths' => 'Corcheas constantes ↓↑↓↑↓↑↓↑ con el acento en los pulsos: la energía del rock.',
          'theory.strumAbout.boomChick' => 'Bajo en el 1 y el 3 y rasgueo en el 2 y el 4: «boom-chick». Alterna la raíz y la quinta en el bajo.',
          'theory.strumAbout.skank' =>
            'Silencio en los pulsos y un golpe seco solo en el contratiempo.',
          'theory.strumAbout.bossa' => 'Pulgar en el bajo y acordes sincopados con los dedos: el balanceo suave de la bossa nova.',
          'theory.strumAbout.shuffle' => 'Largo-corto en cada pulso, como un tresillo sin la nota central: el balanceo del blues.',
          'theory.strumAbout.waltz' => 'En 3/4: bajo en el 1 y dos golpes ligeros en el 2 y el 3, «un-dos-tres».',
          'theory.strumAbout.cumbia' => 'Bajo en el 1 y el 3 y rasgueo corto ↓↑ en el contratiempo: «bom-chiqui, bom-chiqui».',
          'theory.strumAbout.salsa' => 'Golpes sincopados que se apoyan en el «y» de los pulsos y dejan huecos para el bajo y la clave.',
          'theory.strumAbout.reggaeton' => 'El dembow: golpes en el 1, el «y» del 2, el 3 y el 4. Pide un pulso muy estable.',
          'theory.strumAbout.rumba' => 'Abajo, abajo-arriba, golpe seco en la tapa (✕), arriba y abajo-arriba: el sello de la rumba flamenca.',
          'theory.strumAbout.ska' => 'Solo golpes hacia arriba muy cortos en todos los contratiempos: ·↑·↑·↑·↑.',
          'theory.strumAbout.disco' => 'Un golpe fuerte en cada pulso y el contratiempo apagado (✕), como el bombo «cuatro por el piso».',
          'theory.strumAbout.bolero' => 'Bajo en el 1 y acordes que caen entre los pulsos con una síncopa suave.',
          'theory.strumAbout.tango' => 'Marcato: golpes secos y firmes en los pulsos, algún golpe apagado (✕) y un impulso ↑ al final.',
          'theory.strumAbout.valsRanchero' => 'En 3/4: bajo en el 1, acorde en el 2 y un rebote ↓↑ en el 3 que empuja al siguiente compás.',
          'theory.strumAbout.valsCriollo' => 'En 3/4: bajo en el 1 y un acorde arrastrado ↓↑↓ que se acerca al tercer pulso.',
          'theory.strumAbout.merengue' => 'Pulso constante con la mano pendiente del contratiempo, rápido y alegre.',
          'theory.strumAbout.bachata' =>
            'Bajo en el 1 y golpes ↓↑ enlazados que acentúan el 2 y el 4.',
          'theory.strumAbout.campfire' => '↓ ↓ ↓↑ ↓↑: el rasgueo que suena en cualquier fogata. Fácil y amplio.',
          'theory.strumAbout.funkMuted' => 'Golpes secos (✕) que se arrastran entre acordes abiertos: la mano nunca deja de moverse.',
          'theory.strumAbout.arpeggio' => 'Bajo y notas sueltas hacia arriba y hacia abajo, en suave: ideal para baladas.',
          'theory.strumAbout.downstrokes' => 'Corcheas siempre hacia abajo: la velocidad y el empuje del punk y el grunge.',
          'theory.strumAbout.gallop' => 'Una corchea y dos semicorcheas hacia abajo: el galope del metal, con palm mute.',
          'theory.strumAbout.lofi' => 'Acordes perezosos que se arrastran: ↓ ·· ↑ ↓ · ↑. Deja que los huecos respiren.',
          'theory.strumAbout.charleston' => 'Acorde en el 1 y en el «y» del 2: el ritmo del jazz anterior al swing.',
          'theory.strumAbout.trainBeat' => 'Bajo y dos golpes rápidos ↓↓ en cada mitad del compás: el «chu-chu» del tren del country.',
          'theory.strumAbout.tresillo' => '3+3+2: golpes en el 1, el «y» del 2 y el 4; el ritmo de la habanera y la milonga.',
          'theory.strumAbout.rockBallad' => 'Dos golpes firmes y un impulso ↓↑↓ hacia el siguiente compás: la balada de rock.',
          'theory.genreNames.cumbia' => 'Cumbia',
          'theory.genreNames.salsa' => 'Salsa',
          'theory.genreNames.ranchera' => 'Ranchera',
          'theory.genreNames.flamenco' => 'Flamenco',
          'theory.genreNames.bolero' => 'Bolero',
          'theory.genreNames.tango' => 'Tango',
          'theory.genreNames.ska' => 'Ska',
          'theory.genreNames.indie' => 'Indie',
          'theory.genreNames.grunge' => 'Grunge',
          'theory.genreNames.disco' => 'Disco',
          'theory.genreNames.reggaeton' => 'Reggaetón',
          'theory.genreNames.lofi' => 'Lo-fi',
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
          'theory.genreAbout.cumbia' => 'Nacida en la costa caribeña de Colombia y adoptada en todo Latinoamérica. Acordes sencillos (i–iv–V7), un bajo marcado en el 1 y el 3 y el rasgueo «chiqui» en el contratiempo. Muy bailable y fácil de aprender.',
          'theory.genreAbout.salsa' => 'Música caribeña y neoyorquina de clave, metales y percusión. La guitarra rara vez lleva el protagonismo: toca montunos y acordes sincopados (I–IV–V7, ii–V–I) que dialogan con el bajo y la clave.',
          'theory.genreAbout.ranchera' => 'Canción popular mexicana con mariachi, guitarra y guitarrón. Funciona en vals (3/4), polka, corrido o bolero, con acordes mayores, la séptima de dominante y mucha emoción al cantar.',
          'theory.genreAbout.flamenco' => 'Música gitano-andaluza con la cadencia frigia (Am–G–F–E) y la escala frigia. La guitarra acompaña al cante y al baile con compases de 12 tiempos o en 4/4 (rumba, tangos), rasgueos de abanico y golpes en la tapa.',
          'theory.genreAbout.bolero' => 'Romanticismo cubano y mexicano: tempo lento y acordes que suspiran (I–vi–ii–V7, i–VI–iv–V7). Se toca con guitarra y requinto, con una síncopa suave en la mano derecha.',
          'theory.genreAbout.tango' => 'Música rioplatense nacida en Buenos Aires y Montevideo. Armonía menor con dominantes (V7) muy dramáticos, bandoneón, violín y piano. La guitarra marca el compás con firmeza.',
          'theory.genreAbout.ska' => 'La Jamaica anterior al reggae, con un ritmo más rápido y alegre. La guitarra toca golpes cortos hacia arriba en todos los contratiempos mientras el bajo camina. Sus olas posteriores (two-tone, tercera ola) lo mezclan con punk.',
          'theory.genreAbout.indie' => 'Guitarras brillantes, acordes abiertos con 2ª y 4ª suspendidas, arpegios y progresiones de pop. Suena cercano y cuidado a la vez, con capas de guitarras y mucha textura.',
          'theory.genreAbout.grunge' => 'Seattle, años 90: guitarras con distorsión sucia, power chords y un contraste fuerte entre estrofas tranquilas y estribillos enormes. Mezcla punk, metal y pop con letras sombrías.',
          'theory.genreAbout.disco' => 'Pista de baile de los 70: bajo en octavas, batería de «cuatro por el piso», cuerdas y una guitarra que marca el contratiempo con acordes cortos (m7, 9, maj7).',
          'theory.genreAbout.reggaeton' => 'Nacido en Panamá y Puerto Rico del reggae en español y el dembow. Un patrón de batería muy marcado, acordes menores en bucle y melodías pegadizas.',
          'theory.genreAbout.lofi' => 'Beats suaves para estudiar o relajarse: acordes maj7 y m7 con sabor a jazz, un compás perezoso y un sonido ligeramente «gastado». La guitarra repite una progresión corta con mucha calma.',
          'theory.genreAbout.pop' => 'Canciones pegadizas sobre pocas progresiones (I-V-vi-IV). La guitarra acompaña con acordes abiertos y un rasgueo constante.',
          'theory.genreAbout.rock' => 'Power chords, corcheas con energía y riffs con la pentatónica menor. El I-IV-V y el bVII mandan.',
          'theory.genreAbout.blues' => 'Doce compases, acordes de séptima y la escala de blues. El feeling importa más que la velocidad.',
          'theory.genreAbout.country' => 'Acordes abiertos, bajo alternado y melodías con la pentatónica mayor. Historias sencillas y mucho swing en la mano derecha.',
          'theory.genreAbout.jazz' => 'Cuatriadas (maj7, m7, 7), el ii-V-I y cambios constantes de tonalidad. Se toca ligero y con swing.',
          'theory.genreAbout.funk' => 'Acordes de novena y m7 tocados cortos y percusivos. La guitarra es parte de la batería.',
          'theory.genreAbout.ballad' => 'Tempos lentos y acordes que se dejan sonar. Arpegios o un golpe por pulso.',
          'theory.genreAbout.latin' => 'Desde la ranchera en 3/4 hasta la cadencia andaluza y el bolero. Mucha menor armónica.',
          'theory.genreAbout.reggae' => 'El acorde suena solo en los contratiempos, corto y seco. El bajo y la batería llevan el pulso.',
          'theory.genreAbout.bossa' => 'Cuatriadas suaves, bajo con el pulgar y acordes sincopados con los dedos.',
          'theory.genreAbout.metal' => 'Power chords con palm mute, tempos rápidos y escalas menores, frigias y armónicas.',
          'theory.genreAbout.punk' => 'Tres o cuatro power chords, corcheas hacia abajo y mucha velocidad. Actitud ante todo.',
          'theory.genreAbout.soul' => 'Acordes de color (maj7, m7, 9), groove relajado y adornos con la pentatónica mayor.',
          'theory.genreAbout.gospel' => 'Armonía de iglesia: I-IV-V con séptimas, el iv menor y cadencias plagales («amén»).',
          'theory.genreAbout.folk' => 'Canciones de siempre con tres o cuatro acordes abiertos. Ideal para cantar.',
          'theory.genreRhythm.cumbia' => 'Bajo en el 1 y el 3 y rasgueo corto ↓↑ en el contratiempo: «bom-chiqui, bom-chiqui».',
          'theory.genreRhythm.salsa' => 'Acordes sincopados que caen en el «y» de los pulsos y dejan huecos para el bajo (tumbao) y la clave 3-2 o 2-3. A menudo, solo las cuerdas agudas.',
          'theory.genreRhythm.ranchera' => 'En vals: bajo en el 1, acorde en el 2 y rebote ↓↑ en el 3. En polka o corrido, el bajo y el rasgueo se alternan (boom-chick).',
          'theory.genreRhythm.flamenco' => 'Rumba flamenca: abajo, abajo-arriba, golpe seco en la tapa (✕), arriba y abajo-arriba. Cada acorde se marca con fuerza y silencios precisos.',
          'theory.genreRhythm.bolero' => 'Bajo en el 1 y acordes que caen entre los pulsos para crear una síncopa suave: bom – chaca – chaca. Tempo lento y sentido.',
          'theory.genreRhythm.tango' => 'Marcato: golpes secos y firmes en cada pulso, con algún golpe apagado (✕) y un impulso final ↑ antes del siguiente compás.',
          'theory.genreRhythm.ska' => 'Golpe hacia arriba muy corto en cada contratiempo (el «y» de cada pulso), con el bajo caminando en los pulsos.',
          'theory.genreRhythm.indie' => 'Rasgueo de fogata (↓ ↓ ↓↑ ↓↑) con la púa blanda, alternado con arpegios que dejan sonar las cuerdas al aire.',
          'theory.genreRhythm.grunge' => 'Corcheas siempre hacia abajo con power chords; en la estrofa suena suelto y en el estribillo, con acentos muy marcados.',
          'theory.genreRhythm.disco' => 'Golpe fuerte en cada pulso con el contratiempo apagado (↓ ✕ ↓↑): un groove constante a unos 120 bpm.',
          'theory.genreRhythm.reggaeton' => 'El «dembow»: golpes en el 1, el «y» del 2, el 3 y el 4. El rasgueo se apoya en esos acentos y deja silencios entre ellos.',
          'theory.genreRhythm.lofi' => 'Acordes largos y arrastrados con un ritmo perezoso (↓ ·· ↑ ↓ · ↑); deja huecos para que respire.',
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
          'theory.genreTip.cumbia' => 'Apaga las cuerdas con la palma entre golpes para lograr el «chiqui» seco y empieza solo con La menor, Re menor y Mi7.',
          'theory.genreTip.salsa' => 'Aprende un montuno con dos acordes (C6–A7), deja que el bajo marque el 1 y escucha la clave antes de tocar.',
          'theory.genreTip.ranchera' => 'Alterna el bajo entre la raíz y la quinta del acorde y no olvides el V7 que vuelve al I: es el sello de la ranchera.',
          'theory.genreTip.flamenco' => 'Empieza con la cadencia andaluza en La menor y rasguea todo con el mismo patrón antes de añadir adornos; con cejilla cambias de tono sin cambiar de formas.',
          'theory.genreTip.bolero' => 'Lleva el bajo con el pulgar (raíz y quinta) y toca el acorde sincopado con los otros dedos; cuanto más suave, mejor.',
          'theory.genreTip.tango' => 'Practica el final de frase V7 → i y detén la mano un instante antes de cambiar: el silencio también es tango.',
          'theory.genreTip.ska' => 'Rasguea solo las tres cuerdas agudas con la mano relajada y apágalas al instante; practica con metrónomo a 120 antes de subir.',
          'theory.genreTip.indie' => 'Prueba acordes con cuerdas al aire (Dsus2, Asus4, Gsus2) y deja que sigan sonando; una guitarra lleva el ritmo y otra, una línea melódica encima.',
          'theory.genreTip.grunge' => 'Juega con el contraste: estrofa apagada y con pocas notas; en el estribillo, golpes abiertos con todo el brazo.',
          'theory.genreTip.disco' => 'Apaga las cuerdas con la mano izquierda justo después de cada golpe; la limpieza del corte es el groove.',
          'theory.genreTip.reggaeton' => 'Con solo cuatro acordes (Am–F–C–G) lo importante es un pulso muy estable; la guitarra suele doblar la línea del sintetizador.',
          'theory.genreTip.lofi' => 'Toca los acordes con cuatro cuerdas, deja que suenen y añade un adorno de pentatónica cada cuatro compases, nada más.',
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
          'theory.progressionNames.folkWaltz' => 'Vals folk',
          'theory.progressionNames.folkScarborough' =>
            'Balada dórica (estilo Scarborough)',
          'theory.progressionNames.folkCampfire' => 'Fogata en tres acordes',
          'theory.progressionNames.countryWaltz' => 'Vals country',
          'theory.progressionNames.countryTrain' => 'Tren de carga (country)',
          'theory.progressionNames.countryBallad' => 'Balada country',
          'theory.progressionNames.reggaeAxis' => 'Reggae del eje (I–V–vi–IV)',
          'theory.progressionNames.reggaeMinor' => 'Reggae menor',
          'theory.progressionNames.bossaTritone' =>
            'Bossa con sustituto de tritono',
          'theory.progressionNames.bossaMinor' => 'Bossa menor',
          'theory.progressionNames.latinMinor' => 'Menor latino (i–iv–V7)',
          'theory.progressionNames.latinPop' => 'Pop latino (I–V–IV–V)',
          _ => null,
        } ??
        switch (path) {
          'theory.progressionNames.rancheraPolka' => 'Polka norteña',
          'theory.progressionNames.rancheraCorrido' => 'Corrido en vals',
          'theory.progressionNames.rancheraMinor' => 'Ranchera menor',
          'theory.progressionNames.rancheraBolero' =>
            'Bolero ranchero (I–VI7–ii–V7)',
          'theory.progressionNames.cumbiaMajor' => 'Cumbia en mayor',
          'theory.progressionNames.cumbiaMinor' => 'Cumbia en menor',
          'theory.progressionNames.cumbiaSonidera' => 'Cumbia sonidera',
          'theory.progressionNames.cumbiaVillera' => 'Cumbia villera',
          'theory.progressionNames.salsaMontuno' =>
            'Montuno clásico (I–IV–V7–IV)',
          'theory.progressionNames.salsaMinor' =>
            'Salsa menor (cadencia andaluza)',
          'theory.progressionNames.salsaRomantica' => 'Salsa romántica',
          'theory.progressionNames.salsaTurnaround' =>
            'Vuelta salsera (ii–V–I–VI7)',
          'theory.progressionNames.boleroClassic' =>
            'Bolero clásico (I–vi–ii–V7)',
          'theory.progressionNames.boleroMinor' => 'Bolero menor',
          'theory.progressionNames.boleroEight' => 'Bolero de ocho compases',
          'theory.progressionNames.tangoMinor' => 'Tango menor',
          'theory.progressionNames.tangoVuelta' => 'Tango con vuelta',
          'theory.progressionNames.tangoMajor' => 'Tango en mayor',
          'theory.progressionNames.flamencoCadence' =>
            'Cadencia andaluza en Mi',
          'theory.progressionNames.flamencoRumba' => 'Rumba flamenca',
          'theory.progressionNames.flamencoPorArriba' =>
            'Flamenco «por arriba» (frigio)',
          'theory.progressionNames.flamencoTangos' => 'Tangos flamencos',
          'theory.progressionNames.rockMinor' => 'Rock menor (i–bVII–bVI–bVII)',
          'theory.progressionNames.rockEpic' => 'Himno épico (bVI–bVII–I)',
          'theory.progressionNames.rockRiff' =>
            'Riff de power chords (I–bIII–IV)',
          'theory.progressionNames.grungeMinor' => 'Grunge pesado',
          'theory.progressionNames.grungeSlow' => 'Grunge a medio tiempo',
          'theory.progressionNames.grungeRiff' =>
            'Riff grunge (i–bIII–bVII–IV)',
          'theory.progressionNames.indieJangle' =>
            'Indie de guitarras brillantes',
          'theory.progressionNames.indieSus' => 'Indie con suspendidos',
          'theory.progressionNames.indieDream' => 'Indie soñador',
          'theory.progressionNames.punkPop' => 'Pop punk (I–V–vi–IV)',
          'theory.progressionNames.punkOi' => 'Punk de barrio (Oi!)',
          'theory.progressionNames.skaClassic' => 'Ska clásico (I–IV–V7)',
          'theory.progressionNames.skaMinor' => 'Ska menor',
          'theory.progressionNames.skaThirdWave' => 'Tercera ola (vi–V–IV–I)',
          'theory.progressionNames.metalGallop' => 'Galope épico',
          'theory.progressionNames.metalDoom' => 'Doom lento (frigio)',
          'theory.progressionNames.bluesQuick' =>
            'Blues con cambio rápido (quick change)',
          'theory.progressionNames.bluesJazz' => 'Blues de jazz',
          'theory.progressionNames.blues8bar' => 'Blues de ocho compases',
          'theory.progressionNames.jazzRhythmA' =>
            'Cambios de ritmo (sección A)',
          'theory.progressionNames.jazzCircle' =>
            'Círculo de quintas diatónico',
          'theory.progressionNames.jazzMinor251' => 'ii–V–i menor',
          'theory.progressionNames.jazzBackdoor' =>
            'Puerta trasera (iv7–bVII7–I)',
          'theory.progressionNames.jazzTritone' =>
            'ii–V con sustituto de tritono',
          'theory.progressionNames.soulMotown' => 'Soul de Motown (I–vi–ii–V)',
          'theory.progressionNames.soulNeo' => 'Neo-soul (ii7–V7–Imaj7–IVmaj7)',
          'theory.progressionNames.soulMinor' => 'Soul menor lento',
          'theory.progressionNames.funkVamp' => 'Vamp funk con IV9',
          'theory.progressionNames.funkNinth' => 'Funk de novenas dominantes',
          'theory.progressionNames.funkGroove' => 'Groove menor (i7–bVII9–IV9)',
          'theory.progressionNames.gospelShout' => 'Gospel de palmas (shout)',
          'theory.progressionNames.gospelWaltz' => 'Himno en 3/4',
          'theory.progressionNames.gospelMinor' => 'Espiritual menor',
          'theory.progressionNames.popRoyalRoad' => 'Camino real (IV–V–iii–vi)',
          'theory.progressionNames.popEmo' => 'Pop emotivo (vi–iii–IV–I)',
          'theory.progressionNames.popBorrowed' =>
            'Pop con acorde prestado (IV–iv)',
          'theory.progressionNames.balladGentle' =>
            'Balada tierna (I–iii–IV–V)',
          'theory.progressionNames.balladMinor' =>
            'Balada menor (i–bIII–bVII–bVI)',
          'theory.progressionNames.discoMinor' =>
            'Disco menor (i7–iv7–bVII–bIII)',
          'theory.progressionNames.discoStrings' =>
            'Cuerdas de disco (IVmaj7–V7–iii7–vi7)',
          'theory.progressionNames.discoGroove' => 'Groove disco en menor',
          'theory.progressionNames.reggaetonMinor' =>
            'Reggaetón menor (i–bVI–bIII–bVII)',
          'theory.progressionNames.reggaetonRomantic' =>
            'Reggaetón romántico (vi–IV–I–V)',
          'theory.progressionNames.reggaetonDark' =>
            'Reggaetón oscuro (i–iv–bVI–V)',
          'theory.progressionNames.lofiDreamy' => 'Lo-fi soñador',
          'theory.progressionNames.lofiMinor' => 'Lo-fi nocturno',
          'theory.progressionNames.lofiJazzy' => 'Lo-fi con ii–V–I',
          'theory.progressionNames.lofiNinth' => 'Lo-fi con novena (V9)',
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
          'theory.lessonTitles.intervalSongs' => 'Intervalos con canciones',
          'theory.lessonTitles.subdivision' =>
            'Subdivisión: corcheas, tresillos y swing',
          'theory.lessonTitles.modesPractical' => 'Modos en la práctica',
          'theory.lessonTitles.triads' => 'Cómo se construye un acorde',
          'theory.lessonTitles.extensions' => 'Extensiones, sus y add',
          'theory.lessonTitles.inversions' => 'Inversiones y bajos slash',
          'theory.lessonTitles.circleFifths' => 'El círculo de quintas',
          'theory.lessonTitles.cadences' =>
            'Cadencias: cómo cierran las frases',
          'theory.lessonTitles.relativeParallel' =>
            'Tonalidad relativa y paralela',
          'theory.lessonTitles.transposeCapo' => 'Transposición y cejilla',
          'theory.lessonTitles.styleComping' => 'Acompañar según el estilo',
          'theory.lessonTitles.tunings' => 'Afinaciones alternativas',
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
          'theory.lessonSummaries.intervalSongs' => 'Reconoce cada intervalo por el arranque de una melodía que ya conoces.',
          'theory.lessonSummaries.subdivision' =>
            'Divide el pulso en 2, 3 o 4 y entiende la síncopa y el swing.',
          'theory.lessonSummaries.modesPractical' => 'Cuándo y cómo usar dórico, frigio, lidio y mixolidio sobre un acorde fijo.',
          'theory.lessonSummaries.triads' =>
            'Tríadas y séptimas por apilamiento de terceras, desde la raíz.',
          'theory.lessonSummaries.extensions' =>
            'Novenas, onces y trece; acordes suspendidos y con notas añadidas.',
          'theory.lessonSummaries.inversions' => 'Cambia la nota grave del acorde para crear líneas de bajo y enlaces suaves.',
          'theory.lessonSummaries.circleFifths' => 'El mapa de las 12 tonalidades: alteraciones, vecinos y progresiones.',
          'theory.lessonSummaries.cadences' => 'Auténtica, plagal, semicadencia, rota y andaluza: cada una dice algo distinto.',
          'theory.lessonSummaries.relativeParallel' => 'Dos formas de emparentar tonalidades y un truco: el préstamo modal.',
          'theory.lessonSummaries.transposeCapo' => 'Cambia de tono sin cambiar de dedos: el capo y la tabla de equivalencias.',
          'theory.lessonSummaries.styleComping' => 'Los mismos acordes suenan a pop, reggae, balada o cumbia según el ritmo.',
          'theory.lessonSummaries.tunings' =>
            'Drop D, DADGAD y open G: qué cambian y para qué sirven.',
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
          'theory.lessonBodies.intervalSongs' => 'Un intervalo es la distancia entre dos notas y se cuenta en semitonos (en una misma cuerda, trastes). Aprenderlos con canciones es el atajo para reconocerlos de oído: tu memoria ya sabe cómo suena cada salto.\n\nSegunda menor (1 semitono): el tema de «Tiburón». Segunda mayor (2): el «Frère Jacques» o «Fray Santiago». Tercera mayor (4): el arranque de «When the Saints Go Marching In». Cuarta justa (5): «Amazing Grace» (A-ma-zing) o la marcha nupcial. Tritono (6): «Maria» de West Side Story y el tema de Los Simpson. Quinta justa (7): «Estrellita, ¿dónde estás?» y el tema de La guerra de las galaxias. Sexta mayor (9): «My Bonnie Lies over the Ocean». Octava (12): el «Somewhere over the Rainbow».\n\nPara practicar, toca el primer intervalo en dos cuerdas y cántalo antes de comprobar. En la guitarra, la misma distancia se ve igual en todo el mástil, así que cada forma que aprendes la puedes mover.',
          'theory.lessonBodies.subdivision' => 'El pulso se puede dividir de varias formas. Negras: un golpe por pulso («1 2 3 4»). Corcheas: dos por pulso («1 y 2 y»), el motor del rock y el pop: abajo en el pulso, arriba en el «y». Semicorcheas: cuatro por pulso («1 e y a»), típicas del funk. Tresillos: tres por pulso («1-tri-ple»), el balanceo del blues lento, el vals criollo y el 6/8.\n\nLa síncopa es acentuar donde no se espera: el contratiempo (el «y»), o dejar en silencio el pulso. Reggae, ska y salsa viven de eso. El swing y el shuffle son corcheas «desiguales»: la primera dura el doble que la segunda (como el primer y el tercer elemento de un tresillo), y por eso suena a balanceo.\n\nTruco de estudio: mantén el brazo en movimiento constante (abajo en el pulso, arriba en el «y») y cambia solo qué golpes tocas y cuáles dejas en silencio. Así los patrones de la guía de géneros salen casi solos.',
          'theory.lessonBodies.modesPractical' => 'En la práctica un modo se elige por el acorde que suena, no por la teoría. Sobre un acorde menor 7 (Em7) toca dórico: es el menor «con sexta mayor», la receta del funk, el jazz y Santana. Sobre un dominante 7 (G7) o un acorde mayor del rock con bVII toca mixolidio: el mayor «con séptima menor». Sobre un acorde mayor soñador (Fmaj7) toca lidio: mayor con la cuarta aumentada, de banda sonora. Sobre un menor con bII (Em–F) toca frigio: el sabor del flamenco y el metal.\n\nCada modo se distingue por su nota característica: la 6ª mayor en el dórico, la b2 en el frigio, la #4 en el lidio y la b7 en el mixolidio. Insiste en esa nota, resuélvela en la tónica y el modo se oirá enseguida.\n\nReceta rápida: elige un vamp de uno o dos acordes, localiza la tónica en la 6ª cuerda y toca la escala desde ahí; usa el explorador de escalas para ver las posiciones en los 12 tonos.',
          'theory.lessonBodies.triads' => 'Un acorde se construye apilando terceras a partir de una nota, la raíz. Una tercera mayor son 4 semitonos y una menor, 3. La tríada mayor es raíz + tercera mayor + quinta (0-4-7, como Do–Mi–Sol); la menor cambia la tercera por una menor (0-3-7: Do–Mi♭–Sol). La disminuida apila dos terceras menores (0-3-6) y la aumentada, dos mayores (0-4-8).\n\nSi añades otra tercera encima nacen las séptimas: mayor 7 (0-4-7-11, soñadora), dominante 7 (0-4-7-10, tensa y con ganas de resolver), menor 7 (0-3-7-10, suave) y, con la tríada disminuida, la semidisminuida (m7♭5), típica del ii–V menor. La tercera es la nota que decide si el acorde suena alegre o triste.\n\nAsí puedes deducir cualquier acorde sin memorizarlo: cuenta los semitonos desde la raíz y busca esas notas en las cuerdas. En la tonalidad de Do mayor, apilando terceras sobre cada nota de la escala, salen siete acordes: tres mayores, tres menores y uno disminuido.',
          'theory.lessonBodies.extensions' => 'Si sigues apilando terceras tras la séptima aparecen las extensiones: la novena (9), la oncena (11) y la trecena (13). Son las notas 2, 4 y 6 una octava más arriba. Un acorde de novena (C9) es un dominante 7 con la novena añadida: más rico y funky que el C7. En la práctica no se tocan todas las notas: se omite la quinta y, en dominantes, la oncena choca con la tercera.\n\nLos acordes suspendidos (sus) sustituyen la tercera por otra nota: sus2 usa la segunda y sus4 la cuarta. No son mayores ni menores; suenan abiertos, en suspenso, y el sus4 suele resolver en el acorde mayor (Dsus4 → D). Los acordes add añaden una nota sin tocar la séptima: Cadd9 es una tríada mayor con la novena, brillante y moderna (muy usada en el indie y el pop).\n\nQué usar y dónde: 9 en funk y soul, maj7 y m7 en jazz y lo-fi, sus2 y sus4 en pop e indie, 6 y m6 en bossa y bolero. Prueba a sustituir un acorde de una progresión por su versión con color y escucha cómo cambia el ambiente.',
          'theory.lessonBodies.inversions' => 'Un acorde no siempre suena con su raíz en el bajo. Si la nota más grave es la tercera, está en primera inversión; si es la quinta, en segunda inversión. Se escribe con una barra: C/E es un Do con Mi en el bajo, C/G un Do con Sol. La nota tras la barra es siempre la del bajo, y puede ser incluso una nota ajena al acorde (C/D).\n\nSirven para dos cosas: dar movimiento al bajo y suavizar los cambios. Una línea descendente C – G/B – Am – Am/G – F – C/E – Dm – G (la «línea de bajo del canon») suena fluida porque el bajo baja por grados conjuntos. En guitarra, C/E es un Do abierto tocado también con la 6ª cuerda al aire; G/B es un Sol con el Si de la 5ª cuerda (traste 2) y D/F♯ lleva el Fa♯ de la 6ª cuerda (traste 2).\n\nEn el banco de Chords muchos acordes tienen formas en inversión (tríadas movibles con la raíz o la tercera en el bajo). Búscalas en la ficha del acorde y practica el enlace C – G/B – Am.',
          'theory.lessonBodies.circleFifths' => 'El círculo de quintas ordena las 12 tonalidades de quinta en quinta. Hacia la derecha, cada paso añade un sostenido: Do (ninguno), Sol (1), Re (2), La (3), Mi (4), Si (5), Fa♯ (6). Hacia la izquierda añade un bemol: Fa (1), Si♭ (2), Mi♭ (3), La♭ (4). Dentro de cada tonalidad mayor vive su relativa menor (Do–La menor, Sol–Mi menor…).\n\nEs un mapa de parentescos: dos vecinos del círculo comparten seis de siete notas, así que modular entre ellos es suave. Y te da los acordes de una tonalidad de un vistazo: el I (tu tono) con sus dos vecinos, el IV a la izquierda y el V a la derecha. En Sol mayor, Do (IV) y Re (V) son sus vecinos.\n\nAdemás marca un camino armónico muy natural: las quintas descendentes. iii–vi–ii–V–I (Mim–Lam–Rem–Sol7–Do) sigue el círculo hacia la izquierda y suena a «resolución» en cada paso; es la base del jazz, de las rancheras y de la mitad del pop clásico.',
          'theory.lessonBodies.cadences' => 'Una cadencia es la fórmula de dos o más acordes con la que termina una frase, como una puntuación. La auténtica (V–I, mejor con V7–I) es el punto final: la más conclusiva, porque la sensible sube a la tónica. La plagal (IV–I) es el «amén» del gospel y suena más suave y solemne.\n\nLa semicadencia acaba en el V (I–V, ii–V…): es una coma, la frase queda abierta y pide continuación. La cadencia rota o engañosa (V–vi) engaña al oído: esperas el I y llega el vi, que suena parecido pero triste, y prolonga la frase. Y la cadencia andaluza (i–♭VII–♭VI–V, Am–G–F–E) baja por grados conjuntos hasta un V mayor: es la cadencia del flamenco, de la rumba y de muchos temas de rock y pop latino.\n\nEscúchalas por la sensación: ¿ha terminado?, ¿falta algo?, ¿me ha sorprendido? Aprende a reconocer cuándo una canción «hace una coma» y cuándo «pone el punto» y te será mucho más fácil acompañar y anticipar los cambios.',
          'theory.lessonBodies.relativeParallel' => 'La tonalidad relativa comparte las mismas notas pero tiene otra tónica: Do mayor y La menor usan las mismas siete notas. La menor relativa está tres semitonos por debajo de la tónica mayor (o la mayor, tres por encima de la menor). Por eso los mismos acordes sirven en las dos: C, Dm, Em, F, G y Am están tanto en Do mayor como en La menor; solo cambia cuál suena a «casa».\n\nLa tonalidad paralela comparte la tónica pero cambia el modo: Do mayor y Do menor. Aquí cambian las notas (la 3ª, la 6ª y la 7ª se bajan un semitono) y los acordes también: Do mayor tiene F, Do menor tiene Fm.\n\nEso permite el préstamo modal: tomar un acorde de la paralela para dar color. El IV–iv del gospel (F → Fm sobre Do), el ♭VII del rock (B♭ sobre Do) o el ♭VI épico vienen de la paralela menor. Cuando una canción suena «más oscura» de repente, suele estar prestando un acorde.',
          'theory.lessonBodies.transposeCapo' => 'Transponer es mover una canción entera a otro tono manteniendo los grados: cada acorde sube o baja los mismos semitonos. Se hace para adaptar el tono a la voz del cantante o para tocar con formas más cómodas. En el cancionero de Chords puedes transportar ±6 semitonos con un toque.\n\nLa cejilla (capo) sube todas las cuerdas al aire un semitono por traste: con la cejilla en el traste 2, las formas de Sol suenan como La, las de Do suenan como Re y las de Mi como Fa♯. La fórmula es: tono real = forma + traste de la cejilla. Si la canción está en Re y quieres tocar formas de Do, pon la cejilla en el traste 2.\n\nPara elegir: mira los acordes en el tono original, busca el tono en el que se toquen con formas abiertas (G, C, D, Em, Am) y calcula el traste. El capo además da un timbre brillante y más cuerdas al aire, muy usado en folk y pop.',
          'theory.lessonBodies.styleComping' => 'Una progresión como I–V–vi–IV puede ser pop, reggae, balada, indie o cumbia: lo que cambia es cómo la tocas. Hay cuatro ingredientes. El patrón de rasgueo (qué golpes tocas y cuáles dejas en silencio), la dinámica (suave en la estrofa, fuerte en el estribillo), el registro (cuerdas graves, agudas o todas) y el apagado (acordes largos o cortos y secos).\n\nEjemplos: el pop usa ↓ ↓↑ ↑↓↑; el reggae calla en los pulsos y toca solo en el contratiempo; la balada arpegia o da un golpe por compás; la cumbia lleva el bajo en 1 y 3 y un «chiqui» en el contratiempo; el funk apaga casi todo y deja unos pocos golpes; el rock pesado usa power chords con palm mute. La guía de géneros reúne el patrón de cada estilo con su tempo.\n\nEjercicio: elige una progresión del jam y toca la misma vuelta con cuatro estilos distintos. Si cambias el patrón y el tempo, cambia hasta el sentido de la canción.',
          'theory.lessonBodies.tunings' => 'La afinación estándar es Mi–La–Re–Sol–Si–Mi (EADGBE). Cambiar alguna cuerda abre sonidos nuevos. En Drop D bajas solo la 6ª cuerda un tono (Re–La–Re–Sol–Si–Mi): los power chords se tocan con un solo dedo en las tres cuerdas graves y el grave suena más pesado; es la afinación del grunge, el metal y el rock duro.\n\nDADGAD (Re–La–Re–Sol–La–Re) no tiene tercera en sus acordes abiertos: suena abierta, ni mayor ni menor, y por eso se usa en el folk celta y el fingerstyle. En open G (Re–Sol–Re–Sol–Si–Re) las cuerdas al aire forman un acorde de Sol mayor: con un dedo o un slide recorres todos los acordes; es la afinación del blues del Delta y del rock con slide.\n\nConsejos: afina cuerda a cuerda con el afinador de la app, baja el tono despacio (el cuello se adapta) y revisa la afinación pasado un rato. Con un cambio de afinación los acordes que conoces cambian de forma: aprende primero cuatro o cinco formas y vuelve a la estándar al terminar.',
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
          'theory.lessonPoints.intervalSongs' => 'Intervalo = distancia en semitonos entre dos notas\n2ª m = «Tiburón» · 2ª M = «Frère Jacques» · 3ª M = «When the Saints»\n4ª justa = «Amazing Grace» · 5ª justa = «Estrellita»\nTritono (6) = «Maria»; es el más inestable\nCanta el intervalo antes de tocarlo y comprueba',
          'theory.lessonPoints.subdivision' => 'Negras = pulso · corcheas = «1 y 2 y» · semicorcheas = «1 e y a»\nTresillo = tres notas en un pulso (blues lento, 6/8)\nSíncopa = acento en el contratiempo o silencio en el pulso\nSwing/shuffle: corchea larga + corta (2 a 1)\nBrazo siempre en movimiento: abajo en el pulso, arriba en el «y»',
          'theory.lessonPoints.modesPractical' => 'Dórico = menor 7 · sexta mayor (funk, jazz)\nMixolidio = dominante 7 · b7 (rock, blues, country)\nLidio = mayor maj7 · #4 (sonido soñador)\nFrigio = menor con b2 (flamenco, metal)\nToca la nota característica y resuélvela en la tónica',
          'theory.lessonPoints.triads' => 'Tercera mayor = 4 semitonos · tercera menor = 3\nMayor 0-4-7 · menor 0-3-7 · disminuido 0-3-6 · aumentado 0-4-8\nSéptimas: maj7 (0-4-7-11) · 7 (0-4-7-10) · m7 (0-3-7-10)\nLa tercera decide si suena alegre o triste\nEn una tonalidad mayor: 3 mayores, 3 menores y 1 disminuido',
          'theory.lessonPoints.extensions' => '9 = 2ª arriba · 11 = 4ª · 13 = 6ª (una octava más arriba)\nC9 = C7 + novena: funk, soul, r&b\nsus2 y sus4 sustituyen la tercera; sus4 suele resolver a mayor\nadd9 = tríada + novena, sin séptima (indie, pop)\nCambia un acorde por su versión con color y compara',
          'theory.lessonPoints.inversions' => 'Primera inversión = tercera en el bajo · segunda = quinta\nC/E = acorde de Do con Mi en el bajo (la nota tras la barra)\nUn bajo que baja por grados conjuntos suena fluido\nC/E, G/B y D/F♯ son los slash más útiles en guitarra\nBusca las formas en inversión en la ficha de cada acorde',
          'theory.lessonPoints.circleFifths' => 'Derecha = +1 sostenido por paso · izquierda = +1 bemol\nVecinos del círculo comparten 6 de 7 notas\nI con su IV (izquierda) y su V (derecha) = los tres acordes básicos\nCada mayor lleva dentro su relativa menor\nQuintas descendentes: iii–vi–ii–V–I (jazz, ranchera, pop clásico)',
          'theory.lessonPoints.cadences' => 'Auténtica V–I (V7–I): el punto final\nPlagal IV–I: el «amén», más suave\nSemicadencia (acaba en V): una coma, queda abierta\nRota V–vi: esperas el I y llega el vi\nAndaluza i–♭VII–♭VI–V (Am–G–F–E): flamenco y rumba',
          'theory.lessonPoints.relativeParallel' => 'Relativa: mismas notas, otra tónica (Do ↔ La menor)\nLa menor relativa está 3 semitonos bajo la tónica mayor\nParalela: misma tónica, otro modo (Do ↔ Do menor)\nPréstamo modal: IV → iv, ♭VII, ♭VI vienen de la paralela\nSi una canción oscurece de golpe, busca el acorde prestado',
          'theory.lessonPoints.transposeCapo' => 'Transponer = mismo recorrido de grados en otro tono\nCejilla en el traste N: sube todo N semitonos\nTono real = forma + traste (G + 2 = A, C + 2 = D, D + 2 = E)\nElige formas abiertas (G, C, D, Em, Am) y calcula el traste\nEl cancionero transporta ±6 semitonos',
          'theory.lessonPoints.styleComping' => 'Cuatro ingredientes: patrón, dinámica, registro y apagado\nPop: ↓ ↓↑ ↑↓↑ · reggae: solo el contratiempo\nBalada: arpegio o un golpe por compás\nCumbia: bajo en 1 y 3 y «chiqui» · funk: casi todo apagado\nToca la misma vuelta en cuatro estilos y compara',
          'theory.lessonPoints.tunings' => 'Estándar = EADGBE\nDrop D = DADGBE: power chords con un dedo, grave pesado\nDADGAD = acordes abiertos sin tercera (folk, fingerstyle)\nOpen G = DGDGBD: un dedo o slide hace los acordes (blues)\nAfina cuerda a cuerda y baja el tono despacio',
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
          'songs.exercises.cumbiaInAm' => 'Cumbia en La menor',
          'songs.exercises.salsaMontuno' => 'Montuno de salsa en Do',
          'songs.exercises.rancheraInG' => 'Ranchera en vals en Sol',
          'songs.exercises.polkaNortena' => 'Polka norteña en Sol',
          'songs.exercises.flamencoRumba' => 'Rumba flamenca en La menor',
          'songs.exercises.tangoInDm' => 'Tango en Re menor',
          'songs.exercises.boleroInC' => 'Bolero en Do',
          'songs.exercises.reggaetonInAm' => 'Dembow en La menor',
          'songs.exercises.merengueInG' => 'Merengue en Sol',
          'songs.exercises.bachataInAm' => 'Bachata en La menor',
          'songs.exercises.valsCriolloInAm' => 'Vals criollo en La menor',
          'songs.exercises.discoInAm' => 'Disco en La menor',
          'songs.exercises.skaInG' => 'Ska en Sol',
          'songs.exercises.indieInD' => 'Indie luminoso en Re',
          'songs.exercises.grungeInE' => 'Grunge en Mi',
          'songs.exercises.lofiInC' => 'Lo-fi en Do',
          'songs.exercises.punkInE' => 'Punk en Mi',
          'songs.exercises.folkInG' => 'Folk de fogata en Sol',
          'songs.exercises.countryInG' => 'Country boom-chick en Sol',
          'songs.exercises.countryTrainInE' => 'Tren de carga en Mi',
          'songs.exercises.reggaeInC' => 'Reggae en Do',
          'songs.exercises.bossaInC' => 'Bossa en Do',
          'songs.exercises.jazz251InC' => 'ii–V–I en Do',
          'songs.exercises.soulInC' => 'Soul con séptimas mayores',
          'songs.exercises.gospelInC' => 'Gospel con el IV menor',
          'songs.exercises.balladInC' => 'Balada arpegiada en Do',
          'songs.exercises.andaluzaInAm' => 'Cadencia andaluza en La menor',
          'songs.exercises.bluesMinorInE' => 'Blues menor en Mi',
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
