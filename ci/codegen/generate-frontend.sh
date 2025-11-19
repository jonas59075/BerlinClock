#!/bin/bash
set -e

echo "Generating Elm frontend client from OpenAPI..."

openapi-generator-cli generate \
  -i spec/openapi.yaml \
  -g elm \
  -o frontend/src/Api

echo "Frontend codegeneration complete."
