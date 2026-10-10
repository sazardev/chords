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

  /// es: 'En vivo'
  String get live => 'En vivo';

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

  /// es: 'Afinación en vivo'
  String get liveTitle => 'Afinación en vivo';

  /// es: 'Detecta la nota con tu micrófono'
  String get liveSubtitle => 'Detecta la nota con tu micrófono';
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

  /// es: 'En vivo'
  String get title => 'En vivo';

  /// es: 'Escuchar guitarra'
  String get listen => 'Escuchar guitarra';

  /// es: 'Detener'
  String get stop => 'Detener';

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
      'nav.live' => 'En vivo',
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
      'home.liveTitle' => 'Afinación en vivo',
      'home.liveSubtitle' => 'Detecta la nota con tu micrófono',
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
      'live.title' => 'En vivo',
      'live.listen' => 'Escuchar guitarra',
      'live.stop' => 'Detener',
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
      _ => null,
    };
  }
}
