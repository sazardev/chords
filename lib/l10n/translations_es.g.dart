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

  /// es: 'Modo juego'
  String get gameMode => 'Modo juego';

  /// es: 'Toca el acorde y encadena la serie'
  String get gameSubtitle => 'Toca el acorde y encadena la serie';

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

  /// es: '156 acordes y 581 posiciones verificadas, de los abiertos esenciales a los voicings de jazz.'
  String get slideOneBody =>
      '156 acordes y 581 posiciones verificadas, de los abiertos esenciales a los voicings de jazz.';

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
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
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
      'home.gameMode' => 'Modo juego',
      'home.gameSubtitle' => 'Toca el acorde y encadena la serie',
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
      'home.recommendedEmpty' => 'Completa tu perfil para ver recomendaciones.',
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
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
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
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
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
      'chordDetail.noChordMessage' => 'Vuelve al listado y elige un acorde.',
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
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
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
      'settings.color.systemUnavailable' => 'No disponible en esta plataforma',
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
      'onboarding.slideOneTitle' => 'Todos los acordes, todas las posiciones',
      'onboarding.slideOneBody' => '156 acordes y 581 posiciones verificadas, de los abiertos esenciales a los voicings de jazz.',
      'onboarding.slideTwoTitle' => 'Escucha cada acorde y su arpegio',
      'onboarding.slideTwoBody' => 'Sintetizamos cada cuerda para que reconozcas el sonido antes de tocar.',
      'onboarding.slideThreeTitle' => 'Aprende por niveles y practica',
      'onboarding.slideThreeBody' => 'Itinerario paso a paso, filtro por género y modo juego para encadenar series de acordes.',
      'onboarding.welcomeTitle' => 'Tu guitarra, a tu medida',
      'onboarding.welcomeBody' =>
        'Cinco preguntas rápidas y te recomiendo los acordes ideales para ti.',
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
      'onboarding.guitarAcousticHint' => 'Cuerdas de acero y acordes abiertos',
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
      'onboarding.planBody' => 'Empieza por estos acordes, elegidos para ti.',
      'onboarding.planEmpty' =>
        'Explora la biblioteca y empieza por el que más te guste.',
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
      'data.qualityDescription.minor' => 'Triada menor; color triste o íntimo.',
      'data.qualityDescription.seven' =>
        'Blues y funk; tensión con resolución fuerte.',
      'data.qualityDescription.minorSeven' =>
        'Suave y versátil; columna vertebral del ii-V-I.',
      'data.qualityDescription.majorSeven' => 'Color soñador de pop y jazz.',
      'data.qualityDescription.suspendedFourth' =>
        'Suspensión abierta; suele resolver a mayor.',
      'data.qualityDescription.suspendedSecond' =>
        'Abierta y etérea; habitual en pop y rock.',
      'data.qualityDescription.power' => 'Dos notas; rock, metal y distorsión.',
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
      'tuner.pluckString' => ({required Object string}) => 'Toca la ${string}',
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
      'tuner.peg' => ({required Object string}) => 'Clavija de la ${string}',
      'tuner.meterLabel' => ({
        required Object cents,
      }) => 'Afinación: ${cents} cents',
      'tuner.activate' => 'Activar micrófono',
      'tuner.modeAuto' => 'Automático · toca una clavija para fijarla',
      'tuner.modeManual' => ({required Object string}) => 'Fijada: ${string}',
      'tuner.chordsTitle' => 'Detectar acordes',
      'tuner.switchToChords' => 'Detectar acordes',
      'tuner.switchToTuner' => 'Volver al afinador',
      'practice.title' => 'Practicar acorde',
      'practice.intro' =>
        'Toca las cuerdas una a una. Las reconozco en el orden que quieras.',
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
        ({required num n, required Object finger}) =>
            (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(
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
          one: 'Suena más aguda. Baja ${finger} un traste hacia el clavijero.',
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
      _ => null,
    };
  }
}
