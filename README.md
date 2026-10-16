# Chords

**Banco extenso de acordes de guitarra con sonido, arpegios y afinación en vivo.**
Fundación Flutter (Android + Linux + Web) construida con arquitectura limpia,
diseño atómico y Material 3 Expressive.

![Flutter](https://img.shields.io/badge/Flutter-3.47-6750A4?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)
![tests](https://img.shields.io/badge/tests-845-1DB954)
![acordes](https://img.shields.io/badge/acordes-156-8B5CF6)
![posiciones](https://img.shields.io/badge/posiciones-561-8B5CF6)

## Funciones

- **Banco extenso**: 156 acordes (12 raíces × 13 cualidades) y 561 posiciones
  verificadas (cejillas, formas movibles, power chords, triadas e inversiones),
  cada una con su nivel de dificultad (1-5) y géneros asociados
  (Pop, Rock, Blues, Funk, Jazz, Balada, Latino, Metal…).
- **Onboarding**: introducción de 3 pantallas al primer arranque (persistida).
- **Aprender**: itinerario por 5 niveles (🌱 primeros acordes → 🎷 jazz),
  progreso persistente por acorde dominado, guía paso a paso
  (dedos → rasgueo → cambio) y **arpegios guiados** (ascendente, descendente,
  alterno y fingerstyle) con audio real por cuerda.
- **Escuela de guitarra** (desde *Aprender* e *Inicio*): 26 lecciones en
  cuatro bloques —fundamentos (notas, intervalos y sus canciones, tónica y
  tonalidad, ritmo y subdivisión: negras, corcheas, tresillos, síncopa y
  swing), escalas y posiciones (mayor, menores, pentatónicas, las 5 cajas,
  blues, modos y modos en la práctica), armonía (construcción de acordes por
  terceras, extensiones y sus/add, inversiones y bajos slash, campo armónico,
  grados y funciones, progresiones, círculo de quintas, cadencias, tonalidad
  relativa y paralela, CAGED) y técnica y estilo (transposición y cejilla,
  acompañamiento por estilos y afinaciones alternativas: drop D, DADGAD,
  open G)— con ideas clave, demostración en el mástil, juego o jam para
  practicar y progreso de lecciones aprendidas.
- **Explorador de escalas**: 10 escalas (mayor, menor natural y armónica,
  pentatónicas, blues, dórica, frigia, lidia, mixolidia) en los 12 tonos sobre
  un mástil de 15 trastes; posición a posición (5 cajas de pentatónica, 7 de
  tres notas por cuerda), notas o grados, tónica y nota característica
  resaltadas, sonido de la escala y de cada nota, y acordes de la tonalidad.
- **Guía de géneros**: 27 estilos en cuatro familias —raíces y ritmos
  latinos (folk, country, latino, ranchera, cumbia, salsa, bolero, tango,
  flamenco, bossa, reggae), rock y metal (rock, grunge, indie, punk, ska,
  metal), blues, jazz y soul (blues, jazz, soul, funk, gospel) y pop y baile
  (pop, balada, disco, reggaetón, lo-fi)— con búsqueda, tempo, rasgueo que se
  puede animar y explicado (**31 patrones**, incluido el golpe apagado `✕`),
  escalas para solear, acordes típicos, progresiones para jammear, canciones
  y enlace a la biblioteca filtrada.
- **Jam guiado** (estilo Rocksmith/Yousician): 105 progresiones por género,
  canciones o una progresión propia; tono, tempo y vueltas; cuenta atrás de
  0-2 compases, acorde actual y siguiente con diagrama, carril de compases,
  rasgueo golpe a golpe, letra y escala sugerida. Modo *acompañar* (una
  **banda completa sintetizada por género**, ver [Banda del jam](#banda-del-jam))
  o *puntuar* (la app calla y el micrófono califica cada compás:
  perfecto/bien/fallo, racha, multiplicador ×1-×4, precisión, estrellas y
  récord por pista).
- **Cancionero**: 59 canciones tradicionales y de dominio público —clásicos
  mexicanos (Cielito lindo, La bamba, Las mañanitas, La Llorona, La Adelita,
  La Valentina, La golondrina), rondas e infantiles en español, folk anglo
  (Scarborough Fair, Shenandoah, Danny Boy…), country, blues tradicional,
  spirituals y villancicos (Amazing Grace, Swing Low, Silent Night…)— y 33
  ejercicios «solo acordes», uno por cada género de la guía; con acordes por
  compás, letra, diagramas, transporte ±6 semitonos y tocar en el jam.
- **Historial y racha**: acordes abiertos recientemente (en Inicio, en la
  biblioteca y en su pantalla) y días seguidos practicando.
- **39 minijuegos** (pestaña *Jugar*), cada uno con tres dificultades,
  partidas de 6-10 preguntas, racha, puntos, hasta 3 estrellas y récord
  guardado por juego y dificultad. El catálogo se divide en seis familias y
  tiene **buscador**, chips de filtro (todos, nuevos y cada familia) y la
  marca *Nuevo* en los juegos recién añadidos:
  - **Entrena el oído** (sin guitarra): adivina la nota, qué cuerda suena, qué
    traste es, intervalos, agudo o grave, mayor o menor (calidad del acorde),
    reconoce el acorde, oído de afinador (¿floja, afinada o alta?) y memoria
    de cuerdas (repite la secuencia).
  - **Mástil y dedos**: notas del mástil (cuerda + traste → nota), busca la
    nota (cuerda + nota → traste), ¿qué dedo?, lee el diagrama (forma → acorde)
    y **arma el acorde** (nombre → coloca los dedos en un tablero tocable y,
    después, practícalo con el micrófono).
  - **Acordes y variantes** (11, nuevos), construidos sobre el banco real: se
    recorren sus calidades y posiciones, así que las que se añadan al banco
    entran solas en los juegos y las más complejas salen en difícil.
    *Deletrea el acorde* (qué notas lo forman; en difícil se tocan de la raíz
    hacia arriba), *fórmula del acorde* (`1-♭3-5-♭7` ↔ nombre), *¿qué variante
    es?* (maj7, 7, 6, sus… de oído sobre una misma raíz), *memoria de acordes*,
    *raíz y bajo* (qué cuerda lleva la raíz y qué nota hace de bajo),
    *inversiones* (fundamental, 1ª, 2ª o 3ª, leyendo el diagrama o de oído),
    *diagrama incorrecto* (cuatro diagramas del mismo acorde, uno con una nota
    ajena, una cuerda sin mutear o sin una nota esencial), *formas CAGED*
    (forma de un diagrama y traste de la cejilla) y tres **retos con tiempo**
    —*racha* de acordes abiertos, de cejillas y de séptimas— con puntos extra
    por rapidez.
  - **Progresiones y armonía** (5, nuevos): *completa la progresión* (una del
    catálogo con un acorde oculto, en distintos tonos; en difícil, por grado
    romano), *grados romanos* (grado ↔ acorde, con séptimas y acordes
    prestados), *transporta* (semitonos y capo), *relativos y quintas*
    (relativo, dominante, subdominante, círculo de quintas, paralelo y
    sustitución de tritono) y *duelo de estilos* (género por la progresión y el
    rasgueo, con el ritmo del patrón).
  - **Toca la guitarra** (micrófono): toca la nota, cuerda y traste exactos,
    eco de guitarra (escucha una melodía y tócala) y **cambios de acorde**
    (60 s: el juego pide acordes sucesivos y cuenta los cambios limpios; el
    juez exige las notas nuevas del acorde para que el eco del anterior no
    puntúe y el oído de acordes es intercambiable por un detector polifónico).
  - **Teoría musical**: notas de la escala, acordes del tono, ¿qué grado es?,
    encuentra la tónica (de oído) y progresión al oído (en difícil, también
    las progresiones del catálogo: rock, blues de 12 compases, ii-V-I…).
  - Además, el modo **"toca el acorde"**: elige el acorde, escucha 5 s por el
    micrófono, puntúa por notas reconocidas y encadena series con racha y
    récord.
- **Control con la guitarra (manos libres)**: las cuerdas al aire son las
  teclas de la app. En los juegos con micrófono, en "toca el acorde" y en la
  práctica de acordes, al terminar cada reto aparece una barra con la nota y
  la cuerda de cada acción: **Mi (6ª) continuar · La (5ª) reintentar · Re (4ª)
  escuchar · Sol (3ª) saltar o practicar · Si (2ª) salir**. Los retos empiezan
  a escuchar solos (el eco suena su melodía antes) y "toca el acorde" arranca
  cada ronda tras una cuenta atrás; no hay botones de "estoy listo". La app
  espera a que la nota anterior se apague antes de aceptar una orden y se
  silencia mientras suena su propia referencia. En *Jugar* se puede recorrer el
  catálogo con la guitarra (Re siguiente · La anterior · Mi abrir), solo por
  los juegos que deja ver el buscador o el filtro, y todo se puede desactivar
  en Ajustes (los botones siguen). "Cambios de acorde" se maneja con los
  botones mientras corre el reloj y con las cuerdas en la bienvenida.
- **Modo guitarra en toda la app**: con el interruptor de *Jugar* o de Ajustes
  un panel fijo sustituye a la barra de navegación en todas las pantallas
  (también sobre juegos y práctica). Dice qué hace cada cuerda en la pantalla
  y cómo abrir el menú: una **nota aguda** (traste 14 o más de la 1ª cuerda,
  más allá de lo que piden los juegos) lo abre y la misma nota lo cierra. Con
  el menú abierto, **en una cuerda: Mi al aire = Inicio y un traste más por
  destino** (Fa Aprender · Fa♯ Acordes · Sol Jugar · Sol♯ Afinar · La Ajustes ·
  La♯ Perfil · Si Atrás · Do cerrar menú · Do♯ apagar el modo). El menú se
  cierra solo a los 20 s y las pantallas con micrófono ignoran lo que se toca
  mientras está abierto. Todo también se puede pulsar.
- **El móvil no se oye a sí mismo**: todo lo que la app reproduce (acordes,
  arpegios, notas de referencia y melodías de los retos) pasa por una puerta
  de eco que descarta el audio del micrófono mientras suena el altavoz. Tras
  el sonido espera una cola mínima y se reabre cuando el nivel cae por debajo
  del 30 % del máximo con el que el altavoz llegó al micrófono (tope 1 s), así
  que se adapta al volumen y a la sala; el recorte usa la duración audible de
  cada sonido, no la del archivo.
- **Sonido de cada acorde**: síntesis por cuerda tipo Karplus-Strong afinada
  al cent en todo el mástil (retardo fraccionario con pasa-todo; antes las
  notas agudas llegaban a desafinar medio semitono), púa con espectro
  realista, rasgueo escalonado, caja de resonancia de acústica y una sala
  corta. Nota, acorde y arpegio se igualan en volumen con un limitador suave
  y fundidos sin clics; se codifica a WAV (SoLoud). Funciona en Android, Linux
  y Web (WASM).
- **Posiciones revisadas y guiadas**: `db validate` comprueba cada posición
  con reglas musicales (solo notas del acorde, todas las que lo definen, raíz
  en el bajo salvo inversiones) y físicas (un dedo = un traste, dedos en
  orden, el cejillo no tapa cuerdas al aire, máximo 4 trastes de apertura).
  El generador busca una digitación tocable cuando la del catálogo no lo es
  y descarta lo imposible. Las posiciones de cada acorde van de la más sencilla
  a la más difícil y la ficha abre con la recomendada. La ficha explica
  "Cómo colocarlo": qué dedo en qué traste y cuerda, cejillo, cuerdas al aire
  y cuerdas que no se tocan, con la nota de cada cuerda bajo el diagrama.
- **Afinador por cuerdas**: cabezal de guitarra con las 6 clavijas (nota y
  número de cuerda); reconoce solo qué cuerda suena, mide los cents contra su
  nota real (aguanta cuerdas a más de medio tono y errores de octava), dice
  "sube/baja" y qué hacer con la clavija, con margen tolerante (±7¢), marca
  cada cuerda afinada y permite fijar una cuerda o escuchar su nota de
  referencia.
- **Modo práctica de acorde**: desde la ficha (y desde el juego al fallar),
  el diagrama ilumina cada cuerda según la tocas —en cualquier orden—, dice
  qué cuerda toca ahora (traste y dedo) y da tips concretos: "suena al aire",
  "sube/baja N trastes", "acerca el dedo al traste", "presiona más suave" o
  "reafina" (abre el afinador en una hoja sin perder el progreso).
- **Micrófono guiado**: medidor de nivel con pistas ("acerca la guitarra",
  "suena muy fuerte"), aviso claro si falta el permiso o falla la captura con
  reintento, y detección sensible a notas suaves (puerta de ruido + confianza
  YIN en lugar de exigir volumen alto).
- **Micrófono en vivo**: captura PCM16 + detector de tono YIN (afinador y
  juegos de una sola nota).
- **Reconocimiento polifónico de acordes** (Afinar → *Detectar acordes*): lo
  que rasgueas se reconoce en tiempo real, también con varias notas a la vez.
  Núcleo puro en `domain/audio/services`: FFT radix-2 propia (sin asignaciones
  por trama, FFT de 16384 a 44,1 kHz y un análisis cada 100 ms), ventana de
  Hann, picos del espectro entre 70 y 2000 Hz, una regresión no negativa sobre
  un diccionario de notas con sus armónicos (la fundamental de una cuerda grave
  llega muy débil a un móvil y sus armónicos no deben contar como notas
  nuevas), cromagrama de 12 notas con compensación de afinación de ±50 cents,
  suavizado temporal y puerta de ruido. El emparejado compara con las 12 raíces
  × todas las calidades de `ChordQuality` por *presencia* de notas (la 3.ª o la
  7.ª suelen sonar en una sola cuerda), usa el bajo para desempatar (Am7 frente
  a C6) y una histéresis evita el parpadeo entre C, Cmaj7 y Am7. Se engancha al
  mismo PCM16 y a la misma puerta de eco que el afinador, y solo trabaja
  mientras alguien escucha `AudioRepository.chordReadings`. La pantalla muestra
  el acorde en grande con su confianza, las 12 notas en vivo con las del acorde
  marcadas, alternativas probables, el diagrama de la posición más cercana (con
  modo zurdo), el historial de los últimos acordes (chips que abren la ficha) y
  estados claros (sin permiso, "toca un acorde", escuchando). Además, "toca el
  acorde" da por buena la ronda al oír de golpe el acorde pedido.
  Precisión sobre el banco sintetizado con `ChordAudioSynthesizer` (561
  posiciones, 12 raíces): 92,7 % contando como acierto el acorde con las mismas
  notas y 80,6 % con el nombre exacto; la novena se lee como séptima porque su
  9.ª es el 3.er armónico de la quinta (ver `chord_recognition_accuracy_test`).
- **Biblioteca con filtros**: búsqueda libre, chips por género (incluido
  Country, R&B, Soul, Bossa, Punk y Gospel), acordes recientes, por nivel y
  por calidad, más slider de dificultad máxima; los esenciales salen primero.
- **Diseño Material 3 Expressive adaptable**: esquema semilla púrpura, formas
  amplias, curva de énfasis; barra inferior en móvil y riel lateral en
  escritorio, diagramas en espejo para zurdos.
- **Rutas profundas y deep links**: `chords://...`, `https://chords.app/...`,
  query params (`?root=E&quality=min&difficulty=1&q=blues`).
- **Internacionalización completa (es / en)**: tipada en compilación, con
  selector de idioma en ajustes, plurales y textos del sistema traducidos;
  preparada para añadir idiomas sin tocar la app (ver [i18n](#internacionalización-i18n)).
- **Flavors**: `dev`, `staging` y `prod` con `applicationId` y nombre propios.
- **Calidad**: análisis estático estricto (0 issues), git hooks pre-commit y
  pre-push, Makefile, CLI propia y tests (unitarios, widget, smoke y audit
  responsive en móvil).

## Arranque rápido

```bash
make setup                     # deps + banco de acordes + i18n + hooks
make run-linux                 # flavor dev en Linux (escritorio)
make run-android              # flavor dev en Android (móvil)
make check                    # formato + analyze + i18n + audit + tests
```

## Estructura

```
lib/
├── config/            Flavors, parámetros de app y deep links
├── domain/            Entidades, repositorios (abstractos) y casos de uso
│   ├── band/          Banda del jam: patrones, presets por género, director y reloj
│   └── l10n/          Idioma soportado (AppLanguage) y su repositorio
├── data/              Datasource de assets, modelos, síntesis de audio (acordes y
│                      banda en `audio/band/`), YIN y el adaptador del
│                      reconocedor de acordes
│   ├── analytics/     Backend Firebase de analíticas (Analytics + Crashlytics)
│   └── l10n/          Persistencia del idioma elegido
├── core/              Núcleo puro sin Flutter: logging y analíticas
├── l10n/              Catálogos JSON (es.i18n.json, en.i18n.json)
│                      + translations*.g.dart generado por slang
├── presentation/
│   ├── l10n/          LocaleController, aplicador de idioma y mappers
│   ├── theme/         Color, tipografía, formas, movimiento, tema M3
│   ├── router/        Rutas, rutas profundas y deep links
│   ├── widgets/       Sistema de diseño atómico (atoms→organisms)
│   └── features/      home · chords · learn · game · minigames · live · settings
├── app/               Widget raíz (MaterialApp.router)
├── di/                Composición de dependencias
└── main_dev.dart      Puntos de entrada por flavor (dev/staging/prod)

tool/                   Generador del banco, validador, auditoría y hooks
bin/chords_cli.dart     CLI de desarrollo
docs/                   Web de presentación (GitHub Pages)
assets/chords/          Banco de acordes generado (156/561)
```

Regla del proyecto: **1 archivo = 1 responsabilidad** (una clase o una
concern por archivo).

## Banda del jam

En modo *acompañar* el jam toca una banda entera, generada en Dart (sin
muestras externas) y cargada en SoLoud:

| Canal | Instrumentos |
| --- | --- |
| Batería | bombo, caja, aro (cross-stick), palmada, charles cerrado/abierto/pedal, ride y campana, crash, 3 toms; kits acústico, jazz y caja de ritmos |
| Percusión | shaker, pandereta, cencerro, claves, congas (abierta/slap/apagada), bongós, timbal, güiro, palmas claras y sordas, cajón |
| Bajo | eléctrico de dedos, de púa, contrabajo y sintetizado/sub (808) |
| Guitarra | acústica (Karplus-Strong + caja), eléctrica limpia con coro, saturada (power chords y palm-mute) y nailon con rasgueado de flamenco |
| Teclados | piano, piano eléctrico tipo Rhodes (FM), órgano de ruedas (barras de armónicos + Leslie) y cuerdas |
| Vientos | acordeón (musette) y metales cortos |
| Clic | metrónomo con acento en el primer pulso |

**27 géneros con su propia banda** (`lib/domain/band/presets/`, indexados por
id de género; un id desconocido usa el preset de pop): pop, rock, blues,
country, jazz, funk, balada (`ballad`), latino (`latin`), reggae, bossa,
metal, punk, soul, gospel, folk, cumbia, salsa, ranchera, flamenco, disco,
ska, indie, grunge, reggaetón, lofi, tango y bolero. Cada preset define, en
rejilla de semicorcheas (16 pasos en 4/4, 12 en 3/4), dos variantes de
batería y su relleno (cada 4 u 8 compases, con plato al empezar cada vuelta),
la línea de bajo consciente del acorde (raíz-quinta, octavas de disco, bajo
caminante de jazz/blues/ska, tumbao de salsa, dembow, bolero, tango, skank
de reggae…), el comping de teclado, el rasgueo de guitarra (el de la pista
cuando no es el del género), los vientos, el swing y la fuerza del género.

- **Reloj**: `TickScheduler` calcula cada semicorchea contra un reloj
  monótono (`ancla + n·intervalo`, aritmética entera en µs) y arma el aviso
  para el siguiente plazo absoluto: no hay jitter acumulado ni deriva. Swing
  real (corcheas o semicorcheas), cambio de tempo sin saltos (la siguiente
  semicorchea conserva su hora), pausa sin perder el hueco, adelanto para
  humanizar ±9 ms y reanclado tras paradas largas.
- **Precarga**: al empezar se sintetizan y cargan todas las muestras de la
  pista en isolates (`compute`, por lotes y en paralelo) con barra de
  progreso; lo de los canales silenciados se carga después en segundo plano.
  Durante la sesión solo se hace `play`. En un equipo de escritorio una
  pista de 8 acordes y 2 vueltas tarda 50-470 ms (26-77 muestras, 1,6-6,4
  MiB de WAV); un compás de cualquier género, 30-200 ms.
- **Mezclador** (panel *Banda* en la preparación, persistido en
  `band_config_v1`): por canal activar/silenciar y volumen; atajos *Banda
  completa / Solo ritmo / Sin guitarra / Solo clic*; estilo de la banda y tipo
  de kit, bajo, guitarra, teclado y viento; swing, humanización, intensidad
  (suave/normal/fuerte) y rellenos; cuenta atrás (0/1/2), vueltas,
  transposición/capo (±6) y metrónomo con su volumen. En la escena cada
  instrumento se ilumina al sonar y se silencia o activa al tocarlo, y el
  tempo se ajusta con ±1, ±5 o escribiéndolo.
- **Modo puntuar**: la banda (clic incluido) calla, igual que antes: sus
  golpes cada semicorchea mantendrían cerrada la `PlaybackEchoGate` y el
  micrófono no oiría la guitarra. `BandAudioRepositoryImpl` acepta una
  `PlaybackEchoGate` y la avisa en cada golpe por si se quisiera permitir.

```bash
# Mezcla un fragmento de cada género y lo guarda como WAV para escucharlo:
BAND_DEMO_DIR=/tmp/banda flutter test test/data/audio/band/band_mix_test.dart
```

## Internacionalización (i18n)

La app se internacionaliza con [slang](https://pub.dev/packages/slang), que
**genera código tipado a partir de JSON**: si se borra o se renombra una clave,
el proyecto no compila. Los textos viven en `lib/l10n/<idioma>.i18n.json` y el
código Dart en `lib/l10n/translations*.g.dart` (versionado, no hace falta
compilar nada para construir).

```bash
make l10n              # regenera translations*.g.dart tras tocar los JSON
```

Uso en la interfaz (reconstruye el widget al cambiar de idioma):

```dart
final Translations t = context.t;      // extensión generada por slang
Text(t.home.question);                 // clave tipada
Text(t.chords.positionCount(n: 3));    // plural: "3 posiciones"
Text(t.home.nextChord(name: 'C-maj')); // interpolación con parámetros
```

### Añadir un idioma

1. Copia `lib/l10n/es.i18n.json` a `lib/l10n/<código>.i18n.json` y tradúcelo.
2. Añade el valor al enum `AppLanguage` (`lib/domain/l10n/entities/`).
3. `make l10n`.
4. Pon el nombre nativo del idioma en `data.language.<código>` de **todos** los
   catálogos (aparece en el selector de ajustes).

`test/l10n/translations_test.dart` falla si un catálogo
tiene claves de más, de menos, vacías o con parámetros repetidos: es la red de
seguridad para escalar a más idiomas.

### Cómo está montado (SOLID)

| Pieza | Responsabilidad |
| --- | --- |
| `domain/l10n/entities/app_language.dart` | qué idiomas existen (`system`, `es`, `en`) |
| `domain/l10n/repositories/locale_repository.dart` | abstracción de la preferencia guardada |
| `data/l10n/locale_repository_impl.dart` | persistencia sobre `SharedPreferences` |
| `presentation/l10n/language_applier.dart` | abstracción del traductor |
| `presentation/l10n/slang_language_applier.dart` | implementación sobre slang |
| `presentation/l10n/locale_controller.dart` | estado: aplica, persiste y notifica |
| `presentation/l10n/chord_labels.dart` | etiquetas de géneros, calidades, niveles… |
| `presentation/l10n/preference_labels.dart` | etiquetas de idioma, tema, acento y texto |

El estado se cablea en `bootstrap.dart` (provider + `TranslationProvider` de
slang) y en `app.dart` (`locale`, `supportedLocales` y las delegadas de
`GlobalMaterialLocalizations`, que traducen también los textos del sistema).

**Pendiente de traducción:** las etiquetas de posición del banco
(`Forma de Mi`, `Triada {…}`, `… · traste 8`) son datos generados; migrarlas a
identificadores estables permitiría traducirlas sin cambiar el banco.

## Registro y analíticas

Dos capas complementarias cuentan lo que pasa en la app:

- **Registro local** (`lib/core/logging/`): cada acción deja un `LogEntry` con
  canal (`router`, `chords`, `audio`, `microphone`, `game`, `learn`…), nivel,
  contexto y duración. Los sinks son enchufables (consola, memoria, y el puente
  a analíticas); el visor de diagnóstico integrado (Ajustes → Diagnóstico, solo
  en dev/staging) muestra el buffer en caliente. Los errores del framework, la
  plataforma y la zona asíncrona se capturan en `runAppGuarded`.
- **Analíticas remotas** (`lib/core/analytics/` + `lib/data/analytics/`): una
  fachada pura (`AnalyticsService`) emite eventos semánticos del catálogo
  central —rutas, acordes vistos/reproducidos, búsquedas, filtros, dominio de
  acordes, partidas y rondas del juego (con lo que el micrófono escuchó frente
  a lo esperado), sesiones de afinación, ajustes y onboarding— y el backend de
  Firebase los envía a **Analytics** y **Crashlytics** (errores con contexto).

```bash
make run-android FLAVOR=prod   # envía analíticas a chords-qa
make run-linux                 # backend silencioso (sin soporte Firebase)
```

Las analíticas están activas en **staging y prod** (`AppConfig.enableAnalytics`)
y desactivadas en dev; en Linux/Windows el backend es silencioso. El micrófono
solo aporta la nota detectada y su desviación: el audio nunca sale del
dispositivo (ver `docs/privacy.html`). El catálogo de eventos está en
`lib/core/analytics/analytics_events.dart` y se valida en los tests.

> Nota: al habilitar Analytics en un proyecto con una app web ya registrada,
> el SDK web obtiene el `measurementId` del servidor con retraso (caché de
> propagación de Firebase); los datos de Android no se ven afectados.

## CLI propia

```bash
dart run bin/chords_cli.dart db generate   # regenera el banco
dart run bin/chords_cli.dart db validate   # valida integridad
dart run bin/chords_cli.dart hooks install # instala los hooks de git
dart run bin/chords_cli.dart flavor list
make l10n                                  # regenera las traducciones (slang)
```

## Auditoría de arquitectura

`make audit` revisa el código sin abrir el analizador de Dart: recorre
`lib/`, `bin/` y `tool/`, mide cada archivo y aplica reglas independientes.
Sin AST y sin procesos externos, así corre en milisegundos dentro del
pre-commit.

```bash
make audit                 # informe en consola (falla si hay warning)
make audit-report          # además escribe docs/audit-report.md
dart run bin/chords_cli.dart audit --root . --fail-on error
dart run bin/chords_cli.dart audit --max-function-lines 40 --max-class-lines 200
```

| Regla | Qué vigila | Por defecto |
| --- | --- | --- |
| `layer-boundary` (error) | que `presentation/` no importe `data/`, `domain/` no importe `presentation/`, etc.: las dependencias apuntan hacia dentro | error |
| `file-length` | archivos más largos que el presupuesto | 400 líneas |
| `class-size` | clases largas o con demasiadas operaciones públicas (los adaptadores que implementan una interfaz están exentos) | 250 líneas · 12 ops |
| `function-length` | funciones y métodos largos: extrae un paso por función | 60 líneas |
| `complexity` (error) | puntos de decisión por cuerpo (`if`, `for`, `case`, `&&`, `||`, ternarios) | 10 |
| `switch-size` | `switch` con demasiados casos: usa una tabla de estrategias | 7 casos |

Las reglas de forma sólo se aplican al código que se ejecuta en la app
(`lib/`, `bin/`, `tool/`): en los tests los `main` agrupan casos y los dobles
implementan interfaces anchas. Cada regla vive en su propio archivo bajo
`tool/src/audit/rules/`, las métricas en `tool/src/audit/metrics/` y el motor
las orquesta: añadir una regla nueva es crear un archivo y apuntarlo en
`default_rules.dart`.

Los presupuestos se pueden ajustar por invocación (`--max-function-lines`, …)
mientras se migra deuda existente, y `--fail-on` decide qué gravedad bloquea.

## Build

```bash
make build-linux       # binario Linux release por flavor
make build-apk         # APK release por flavor
make build-appbundle   # AAB release para Play Store (usa android/key.properties)
make build-web         # web de release
```

## Compatibilidad

| Plataforma | Build | Sonido | Micrófono |
| --- | --- | --- | --- |
| Android (dev/staging/prod) | APK release | SoLoud | RECORD_AUDIO en runtime |
| Linux (x64) | binario release | SoLoud | PulseAudio/PipeWire |
| Web (Chrome/Edge/Firefox) | `flutter build web` | SoLoud WASM | AudioWorklet PCM16 |

## Licencia

MIT
