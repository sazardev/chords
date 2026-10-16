# Chords

**Banco extenso de acordes de guitarra con sonido, arpegios y afinación en vivo.**
Fundación Flutter (Android + Linux + Web) construida con arquitectura limpia,
diseño atómico y Material 3 Expressive.

![Flutter](https://img.shields.io/badge/Flutter-3.47-6750A4?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)
![tests](https://img.shields.io/badge/tests-698-1DB954)
![acordes](https://img.shields.io/badge/acordes-396-8B5CF6)
![posiciones](https://img.shields.io/badge/posiciones-3455-8B5CF6)
![escalas](https://img.shields.io/badge/escalas-38-8B5CF6)

## Funciones

- **Banco extenso**: 396 acordes (12 raíces × 33 tipos) y 3.455 posiciones
  verificadas, cada una con su dificultad (1-5, coherente con lo que exige la
  mano) y los géneros del tipo de acorde (Pop, Rock, Blues, Funk, Jazz,
  Balada, Latino, Metal…). Además de mayor, menor, 7, m7, maj7, sus2/sus4,
  6, m6, dim, aug, 9 y power chord, trae **add9, madd9, 6/9, m9, maj9, 11,
  m11, 13, 7sus4, 9sus4, mMaj7, m7b5, dim7, 7b9, 7#9, 7#5, 7b5, 7#11, maj7#11
  y maj7#5**. Cada acorde tiene hasta 12 posiciones más todas sus formas del
  catálogo: formas abiertas, CAGED y movibles con cejilla, power chords de
  tres, cuatro y cinco cuerdas, tríadas e inversiones en cuerdas medias y
  agudas, shells (1-3-7) y voicings de cuatro cuerdas (drop 2, drop 3 e
  inversiones) para el jazz.
- **Ficha de acorde**: el diagrama y el sonido de siempre más las notas con su
  grado (`1 b3 5 b7`) y la fórmula, las tonalidades donde el acorde cae en un
  grado (`IVmaj7 en Sol mayor`), las variantes con filtros (abierta, cejilla,
  movible, inversión, tríada, shell, drop 2/3, cuerdas agudas), los acordes
  parientes (misma raíz con otro color y la relativa) con salto a su ficha,
  dónde se usa (géneros y progresiones del catálogo que lo incluyen, con
  enlace al jam) y la escala para improvisar encima con salto al explorador.
- **Onboarding**: introducción de 3 pantallas al primer arranque (persistida).
- **Aprender**: itinerario por 5 niveles (🌱 primeros acordes → 🎷 jazz),
  progreso persistente por acorde dominado, guía paso a paso
  (dedos → rasgueo → cambio) y **arpegios guiados** (ascendente, descendente,
  alterno y fingerstyle) con audio real por cuerda.
- **Escuela de guitarra** (desde *Aprender* e *Inicio*): 14 lecciones en tres
  bloques —fundamentos (notas, intervalos, tónica y tonalidad, ritmo),
  escalas y posiciones (mayor, menores, pentatónicas, las 5 cajas, blues,
  modos) y armonía (campo armónico, grados y funciones, progresiones, CAGED)—
  con ideas clave, demostración en el mástil, juego o jam para practicar y
  progreso de lecciones aprendidas.
- **Explorador de escalas**: 38 escalas y modos en los 12 tonos sobre un
  mástil de 18 trastes, agrupadas en cuatro familias (mayor y modos; menores
  con los modos de la armónica y de la melódica; pentatónicas, blues y
  hexatónicas; exóticas y simétricas: tonos enteros, disminuidas, aumentada,
  bebop, húngara, doble armónica, hirajoshi…). Muestra la fórmula de grados,
  los pasos (T/S), el carácter, los estilos donde se usa y la nota
  característica; reparte el mástil en 5 cajas (pentatónicas), 7 posiciones
  de tres notas por cuerda (heptatónicas), las cajas de la escala base más
  sus notas de paso (blues, hexatónicas y bebop) o ventanas de trastes (las
  simétricas); enseña los acordes de la escala en tríadas y séptimas
  (`Imaj7 ii7 … viiø7`, con alteraciones en los modos), suena la escala
  ascendente y descendente y centra el mástil en la posición elegida.
- **Guía de géneros**: 15 estilos (pop, rock, blues, country, jazz, funk,
  balada, latino, reggae, bossa, metal, punk, soul/R&B, gospel, folk) con
  tempo, rasgueo animado, escalas para solear, acordes típicos, progresiones
  para jammear, canciones y enlace a la biblioteca filtrada.
- **Jam guiado** (estilo Rocksmith/Yousician): 23 progresiones por género,
  canciones o una progresión propia; tono, tempo y vueltas; cuenta atrás,
  acorde actual y siguiente con diagrama, carril de compases, rasgueo golpe a
  golpe, letra y escala sugerida. Modo *acompañar* (la app rasguea con el
  patrón del estilo, bajo y metrónomo) o *puntuar* (la app calla y el
  micrófono califica cada compás: perfecto/bien/fallo, racha, multiplicador
  ×1-×4, precisión, estrellas y récord por pista).
- **Cancionero**: canciones tradicionales y de dominio público (Cielito lindo,
  La bamba, Las mañanitas, La Llorona, Amazing Grace, Oh! Susanna, Red River
  Valley, Greensleeves…) y ejercicios por género, con acordes por compás,
  letra, diagramas, transporte ±6 semitonos y tocar en el jam.
- **Historial y racha**: acordes abiertos recientemente (en Inicio, en la
  biblioteca y en su pantalla) y días seguidos practicando.
- **22 minijuegos** (pestaña *Jugar*), cada uno con tres dificultades,
  partidas de 6-10 preguntas, racha, puntos y hasta 3 estrellas guardadas:
  - **Entrena el oído** (sin guitarra): adivina la nota, qué cuerda suena, qué
    traste es, intervalos, agudo o grave, mayor o menor (calidad del acorde),
    reconoce el acorde, oído de afinador (¿floja, afinada o alta?) y memoria
    de cuerdas (repite la secuencia).
  - **Mástil y dedos**: notas del mástil (cuerda + traste → nota), busca la
    nota (cuerda + nota → traste), ¿qué dedo?, lee el diagrama (forma → acorde)
    y **arma el acorde** (nombre → coloca los dedos en un tablero tocable y,
    después, practícalo con el micrófono).
  - **Toca la guitarra** (micrófono): toca la nota, cuerda y traste exactos y
    eco de guitarra (escucha una melodía y tócala).
  - **Teoría musical**: notas de la escala, acordes del tono, ¿qué grado es?,
    encuentra la tónica (de oído) y progresión al oído.
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
  catálogo con la guitarra (Re siguiente · La anterior · Mi abrir) y todo se
  puede desactivar en Ajustes (los botones siguen).
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
- **Micrófono en vivo**: captura PCM16 + detector de tono YIN: nota, cents y
  acordes sugeridos en tiempo real.
- **Biblioteca con filtros**: búsqueda por cifrado (`Cm7`, `F#m7b5`, `Bb7`,
  `CM7` frente a `Cm7`), por nombre en español o inglés (`Do mayor`, `Re
  menor 7`, `Lam`, `D minor 7`), por notas (`C E G`, `do mi sol`) o por texto
  libre (tipo, género, tipo de posición); los resultados salen por relevancia.
  Cuatro órdenes (esenciales, más fáciles, por nota y por tipo, estos dos con
  encabezados), selector rápido de nota y tipo agrupado por familias (con
  botón para abrir la ficha), chips por género (incluido Country, R&B, Soul,
  Bossa, Punk y Gospel), acordes recientes, por nivel y por tipo agrupado por
  familias, más slider de dificultad máxima; los esenciales salen primero.
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
│   └── l10n/          Idioma soportado (AppLanguage) y su repositorio
├── data/              Datasource de assets, modelos, síntesis de audio, YIN
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
assets/chords/          Banco de acordes generado (396/3.455, ~350 KB)
```

Regla del proyecto: **1 archivo = 1 responsabilidad** (una clase o una
concern por archivo).

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

Los nombres de las posiciones del banco también se traducen: el banco solo
guarda el nombre de cada forma en español (`Forma de Mi menor`) y la app
compone el resto (`Drop 2 · cuerdas 4-3-2-1 · 1ª inversión`, `E minor shape ·
fret 8`) a partir del identificador de la posición, con las claves de
`chordTheory`.

## Banco de acordes

`dart run bin/chords_cli.dart db generate` construye `assets/chords/chords_db.json`
sin datos escritos a mano posición a posición:

1. **Formas del catálogo** (`tool/src/shapes/`): cada forma se escribe como un
   acorde de referencia (`refShape('maj7', 'c-maj7-shape', 'Forma de Do maj7',
   'x32000', 'C')`); el generador deduce cuerda de anclaje y desplazamientos y
   la transpone a las 12 raíces (también por debajo de la referencia cuando no
   usa cuerdas al aire). Las digitaciones las busca un solucionador de dedos
   con las reglas físicas del validador.
2. **Buscador de voicings** (`tool/src/builder/`): para cada acorde reparte
   las notas imprescindibles entre grupos de cuerdas (tríadas, shells 1-3-7,
   cuatro cuerdas), elige la forma más cómoda de cada inversión y reconoce los
   drop 2 y drop 3 por sus alturas.
3. **Dificultad**: la de la mano (dedos, cejillo, meñique, apertura, cuerdas
   mudas en medio) con un mínimo por tipo de acorde; el validador rechaza una
   dificultad menor que la que exige la mano o exagerada.
4. **Formato compacto (v2)**: solo guarda lo que no se puede deducir
   (identificador, trastes, dedos, dificultad, cejillo y el nombre de cada
   forma); la app calcula notas, etiquetas, nombres y alias. Pasa de ~417 KB
   con 561 posiciones a ~350 KB con 3.455, y se lee y construye en otro isolate
   al arrancar (en la VM, ~55 ms en caliente y ~170 ms en frío).

`db validate` comprueba, además de lo musical y físico de siempre (solo notas
del acorde, todas las que lo definen —con las omisiones que admite cada tipo
(quinta, novena…)—, raíz en el bajo salvo inversiones declaradas, un dedo = un
traste, máximo 4 trastes de apertura), que estén las 396 combinaciones, que no
haya posiciones repetidas, que cada forma tenga nombre y que vayan de la más
fácil a la más difícil (formas primero, voicings después).

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
dart run bin/chords_cli.dart db show C-maj7 maj9 # muestra las posiciones
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
