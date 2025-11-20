# Berlin Clock API

Eine vollständig spec-driven entwickelte Backend- und Frontend-Implementierung der Berliner Uhr.  
Technologien: **Go (API)**, **Elm (Frontend)**, **OpenAPI 3**, **SDD Codegen**, **Swagger UI**.

## Features
- Echtzeit-Berechnung der Berliner Uhr
- Vollständige OpenAPI-Spezifikation
- Automatische API-Generierung (Backend)
- Elm-Frontend zur Visualisierung
- Docker-Compose Multi-Service Setup
- CI-Pipeline inkl. OpenAPI-Linting

## Development

### Backend starten
```sh
go run ./backend/cmd/api
Swagger-UI:
http://localhost:8080/swagger
Frontend starten (Elm)
cd frontend
elm-live src/Main.elm --open --port=3000
Code generieren
./ci/codegen/generate-backend.sh
./ci/codegen/generate-frontend.sh
Docker
docker-compose up --build
API: http://localhost:8080
Frontend: http://localhost:8081
Health & Version
/healthz
/version
