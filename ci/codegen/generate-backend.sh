#!/usr/bin/env bash
set -euo pipefail

# Run from repo root
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

SPEC_FILE="spec/openapi.yaml"
CONFIG_FILE="openapitools.json"
OUT_DIR="backend/gen/api/go"

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

echo "==> Generating Go backend from '$SPEC_FILE' into '$OUT_DIR' ..."
openapi-generator-cli generate \
  -i "$SPEC_FILE" \
  -g go-server \
  -o "$OUT_DIR" \
  -c "$CONFIG_FILE"

echo
echo "==> Backend codegen finished."
echo "    Bitte 'git diff' prüfen und Änderungen manuell committen."
