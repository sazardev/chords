# Chords

**Banco extenso de acordes de guitarra con sonido, arpegios y afinación en vivo.**
Fundación Flutter (Android + Linux + Web) construida con arquitectura limpia,
diseño atómico y Material 3 Expressive.

![Flutter](https://img.shields.io/badge/Flutter-3.47-6750A4?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)
![tests](https://img.shields.io/badge/tests-381-1DB954)
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
- **17 minijuegos** (pestaña *Jugar*), cada uno con tres dificultades,
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
  catálogo con la guitarra (Re siguiente · La anterior · Mi abrir) activando
  el interruptor, y todo se puede desactivar en Ajustes (los botones siguen).
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
- **Biblioteca con filtros**: búsqueda libre, chips por género, por nivel y
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
assets/chords/          Banco de acordes generado (156/561)
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
