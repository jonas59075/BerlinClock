#!/bin/bash
set -e

echo "Generating Elm frontend client from OpenAPI..."

# 1. Generate into temporary folder
openapi-generator-cli generate \
  -i spec/openapi.yaml \
  -g elm \
  -o frontend/.generated_api

echo "Post-processing Elm API structure..."

# 2. Remove old flattened API folder
rm -rf frontend/src/Api
mkdir -p frontend/src/Api
mkdir -p frontend/src/Api/Request

# 3. Copy generated Elm files into flat structure

# Root file
cp frontend/.generated_api/src/Api.elm frontend/src/Api/Api.elm

# First-level API modules
cp frontend/.generated_api/src/Api/Data.elm frontend/src/Api/Data.elm
cp frontend/.generated_api/src/Api/Time.elm frontend/src/Api/Time.elm

# Nested Request module
cp frontend/.generated_api/src/Api/Request/Default.elm frontend/src/Api/Request/Default.elm

echo "Fixing Elm module names..."

# Fix module names according to file paths
sed -i '' 's/^module Api exposing/module Api.Api exposing/' frontend/src/Api/Api.elm
sed -i '' 's/^module Data exposing/module Api.Data exposing/' frontend/src/Api/Data.elm
sed -i '' 's/^module Time exposing/module Api.Time exposing/' frontend/src/Api/Time.elm
sed -i '' 's/^module Request.Default exposing/module Api.Request.Default exposing/' frontend/src/Api/Request/Default.elm

echo "Elm module namespace fix complete."

# 4. Remove generated folder
rm -rf frontend/.generated_api

echo "Elm client generation and cleanup complete."
