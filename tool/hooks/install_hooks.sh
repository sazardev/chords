#!/usr/bin/env bash
# Instala los git hooks versionados (pre-commit y pre-push).
set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
cd "$PROJECT_ROOT"

dart run bin/chords_cli.dart hooks install
