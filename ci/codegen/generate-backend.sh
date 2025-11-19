#!/bin/bash
set -e

echo "Generating Go backend code from OpenAPI..."

openapi-generator-cli generate \
  -i spec/openapi.yaml \
  -g go-server \
  -o backend/gen/api \
  --additional-properties=featureCORS=true,router=chi

echo "Backend codegeneration complete."
