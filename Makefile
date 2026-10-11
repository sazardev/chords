# Makefile de desarrollo para Chords.
# Ejecuta `make help` para ver todos los objetivos disponibles.

SHELL := /bin/bash
FLAVOR ?= dev
DEVICE ?= linux

.PHONY: help setup deps gen validate audit audit-report fmt analyze test check run \
         run-linux run-android hooks build-apk build-appbundle build-linux build-web clean version

help: ## Muestra esta ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

setup: deps gen l10n hooks ## Configuración inicial completa (deps + banco + i18n + hooks)

deps: ## Descarga dependencias
	flutter pub get

gen: ## Genera el banco extenso de acordes (assets/chords/chords_db.json)
	dart run bin/chords_cli.dart db generate

validate: ## Valida la integridad del banco de acordes
	dart run bin/chords_cli.dart db validate

l10n: ## Regenera las traducciones tipadas (lib/l10n/*.g.dart)
	dart run slang

audit: ## Auditoría de arquitectura (tamaño, complejidad y capas)
	dart run bin/chords_cli.dart audit --root .

audit-report: AUDIT_FILE ?= docs/audit-report.md
audit-report: ## Auditoría + informe Markdown en docs/audit-report.md
	dart run bin/chords_cli.dart audit --root . --markdown $(AUDIT_FILE)

fmt: ## Formatea todo el código (dart format)
	dart format .

analyze: ## Análisis estático estricto (falla con cualquier warning)
	flutter analyze --fatal-infos --fatal-warnings

test: ## Ejecuta los tests
	flutter test

check: fmt analyze l10n audit test ## Pipeline completo (formato + análisis + i18n + auditoría + tests)

run: ## Ejecuta en el dispositivo por defecto ($(DEVICE))
	flutter run -d $(DEVICE) --flavor $(FLAVOR) -t lib/main_$(FLAVOR).dart

run-linux: flutter ## Ejecuta flavour dev en Linux (escritorio)
	flutter run -d linux --flavor $(FLAVOR) -t lib/main_$(FLAVOR).dart

run-android: flutter ## Ejecuta flavour dev en Android (móvil)
	flutter run -d android --flavor $(FLAVOR) -t lib/main_$(FLAVOR).dart

build-apk: ## Compila APK de release por flavor
	flutter build apk --release --flavor $(FLAVOR) -t lib/main_$(FLAVOR).dart

build-appbundle: ## Compila el App Bundle (AAB) de release por flavor (Play Store)
	flutter build appbundle --release --flavor $(FLAVOR) -t lib/main_$(FLAVOR).dart

build-linux: ## Compila binario Linux de release por flavor
	flutter build linux --release --flavor $(FLAVOR) -t lib/main_$(FLAVOR).dart

build-web: ## Compila la web de release (entrada del flavor)
	flutter build web --release -t lib/main_$(FLAVOR).dart

hooks: ## Instala los git hooks (pre-commit y pre-push)
	bash tool/hooks/install_hooks.sh

clean: ## Limpia artefactos de build
	flutter clean

version: ## Muestra la versión de la app y del CLI
	@dart run bin/chords_cli.dart version
