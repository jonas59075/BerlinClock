#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

SPEC_FILE="spec/openapi.yaml"
OUT_DIR="frontend/src/Api"

if ! command -v openapi-generator-cli >/dev/null 2>&1; then
  echo "ERROR: openapi-generator-cli not found in PATH."
  echo "Install it e.g. via:"
  echo "  npm install -g @openapitools/openapi-generator-cli"
  echo "or see https://openapi-generator.tech/docs/installation/"
  exit 1
fi

if [ ! -f "$SPEC_FILE" ]; then
  echo "ERROR: Spec file '$SPEC_FILE' not found."
  exit 1
fi

echo "==> Generating Elm client from '$SPEC_FILE' into '$OUT_DIR' ..."
openapi-generator-cli generate \
  -i "$SPEC_FILE" \
  -g elm \
  -o "$OUT_DIR"

echo
echo "==> Frontend codegen finished."
echo "    Bitte 'git diff' prüfen und Änderungen manuell committen."
