# Chords

**Banco extenso de acordes de guitarra con sonido, arpegios y afinación en vivo.**
Fundación Flutter (Android + Linux + Web) construida con arquitectura limpia,
diseño atómico y Material 3 Expressive.

![Flutter](https://img.shields.io/badge/Flutter-3.47-6750A4?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)
![tests](https://img.shields.io/badge/tests-25-1DB954)
![acordes](https://img.shields.io/badge/acordes-156-8B5CF6)
![posiciones](https://img.shields.io/badge/posiciones-581-8B5CF6)

## Funciones

- **Banco extenso**: 156 acordes (12 raíces × 13 cualidades) y 581 posiciones
  verificadas (cejillas, formas movibles, power chords, triadas e inversiones),
  cada una con su nivel de dificultad (1-5) y géneros asociados
  (Pop, Rock, Blues, Funk, Jazz, Balada, Latino, Metal…).
- **Onboarding**: introducción de 3 pantallas al primer arranque (persistida).
- **Aprender**: itinerario por 5 niveles (🌱 primeros acordes → 🎷 jazz),
  progreso persistente por acorde dominado, guía paso a paso
  (dedos → rasgueo → cambio) y **arpegios guiados** (ascendente, descendente,
  alterno y fingerstyle) con audio real por cuerda.
- **Modo juego "toca el acorde"**: elige el acorde, escucha 5 s por el
  micrófono, puntúa por notas reconocidas y encadena series con racha y récord.
- **Sonido de cada acorde**: síntesis por cuerda tipo Karplus-Strong con
  envolvente realista, codificada a WAV (SoLoud). Funciona en Android, Linux
  y Web (WASM).
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
│   └── l10n/          Persistencia del idioma elegido
├── l10n/              Catálogos JSON (es.i18n.json, en.i18n.json)
│                      + translations*.g.dart generado por slang
├── presentation/
│   ├── l10n/          LocaleController, aplicador de idioma y mappers
│   ├── theme/         Color, tipografía, formas, movimiento, tema M3
│   ├── router/        Rutas, rutas profundas y deep links
│   ├── widgets/       Sistema de diseño atómico (atoms→organisms)
│   └── features/      home · chords · chords/detalle · live · settings
├── app/               Widget raíz (MaterialApp.router)
├── di/                Composición de dependencias
└── main_dev.dart      Puntos de entrada por flavor (dev/staging/prod)

tool/                   Generador del banco, validador, auditoría y hooks
bin/chords_cli.dart     CLI de desarrollo
docs/                   Web de presentación (GitHub Pages)
assets/chords/          Banco de acordes generado (156/581)
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
