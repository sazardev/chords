# Chords

**Banco extenso de acordes de guitarra con sonido y afinación en vivo.**
Fundación Flutter (Android + Linux) construida con arquitectura limpia,
diseño atómico y Material 3 Expressive.

![Flutter](https://img.shields.io/badge/Flutter-3.47-6750A4?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)
![tests](https://img.shields.io/badge/tests-25-1DB954)
![acordes](https://img.shields.io/badge/acordes-156-8B5CF6)
![posiciones](https://img.shields.io/badge/posiciones-581-8B5CF6)

## Funciones

- **Banco extenso**: 156 acordes (12 raíces × 13 cualidades) y 581 posiciones
  verificadas (cejillas, formas movibles, power chords, triadas e inversiones),
  cada una con su nivel de dificultad (1-5).
- **Sonido de cada acorde**: síntesis por cuerda tipo Karplus-Strong con
  envolvente realista, mezclada y codificada a WAV (SoLoud).
- **Micrófono en vivo**: captura PCM16 + detector de tono YIN: nota, cents y
  acordes sugeridos en tiempo real.
- **Diseño Material 3 Expressive adaptable**: esquema semilla púrpura, formas
  amplias, curva de énfasis; barra inferior en móvil y rijado lateral en
  escritorio, diagramas en espejo para zurdos.
- **Rutas profundas y deep links**: `chords://...`, `https://chords.app/...`,
  query params (`?root=E&quality=min&difficulty=1&q=blues`).
- **Flavors**: `dev`, `staging` y `prod` con `applicationId` y nombre propios.
- **Calidad**: análisis estático estricto (0 issues), git hooks pre-commit y
  pre-push, Makefile, CLI propia y 25 tests (unitarios, widget y smoke).

## Arranque rápido

```bash
make setup                     # deps + banco de acordes + hooks
make run-linux                 # flavor dev en Linux (escritorio)
make run-android              # flavor dev en Android (móvil)
make check                    # formato + analyze + tests
```

## Estructura

```
lib/
├── config/            Flavors, parámetros de app y deep links
├── domain/            Entidades, repositorios (abstractos) y casos de uso
├── data/              Datasource de assets, modelos, síntesis de audio, YIN
├── presentation/
│   ├── theme/         Color, tipografía, formas, movimiento, tema M3
│   ├── router/        Rutas, rutas profundas y deep links
│   ├── widgets/       Sistema de diseño atómico (atoms→organisms)
│   └── features/      home · chords · chords/detalle · live · settings
├── app/               Widget raíz (MaterialApp.router)
├── di/                Composición de dependencias
└── main_dev.dart      Puntos de entrada por flavor (dev/staging/prod)

tool/                   Generador del banco, validador y hooks versionados
bin/chords_cli.dart     CLI de desarrollo
docs/                   Web de presentación (GitHub Pages)
assets/chords/          Banco de acordes generado (156/581)
```

Regla del proyecto: **1 archivo = 1 responsabilidad** (una clase o una
concern por archivo).

## CLI propia

```bash
dart run bin/chords_cli.dart db generate   # regenera el banco
dart run bin/chords_cli.dart db validate   # valida integridad
dart run bin/chords_cli.dart hooks install # instala los hooks de git
dart run bin/chords_cli.dart flavor list
```

## Build

```bash
make build-linux   # binario Linux release por flavor
make build-apk     # APK release por flavor
```

## Licencia

MIT
