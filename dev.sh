#!/usr/bin/env bash
set -e

echo "🚀 Starte Backend..."
(cd backend/gen/api && go run main.go &) 

echo "🚀 Baue Frontend..."
(cd frontend && elm make src/Main.elm --output=dist/app.js)

echo "✔️  Backend läuft auf Port 8080"
echo "✔️  Frontend gebaut"
echo "▶️  Zum Beenden: kill aller go/elm-Prozesse mit CTRL+C"
wait
