
# Berlin Clock – Spec-Driven Coding Dojo Projekt

Dieses Projekt implementiert die Berliner Uhr mit einem modernen, klar strukturierten Software-Ansatz:
- Backend in Go
- Frontend in Elm
- API und Datenmodelle vollständig spec-driven (OpenAPI)
- klare Trennung zwischen Logik, Darstellung und Struktur

---

# Projektziel

Das Ziel dieses Coding-Dojo-Projekts ist es, eine technisch saubere, nachvollziehbare und moderne Lösung der Berliner Uhr zu erstellen.  
Der Schwerpunkt liegt auf Architekturqualität, Lesbarkeit und einem transparenten Entwicklungsprozess.

---

# Architekturmodell

Das Projekt basiert vollständig auf **Spec-Driven Development (SDD)**:

1. Erstellung einer API-Spezifikation (`spec/openapi.yaml`)
2. Erstellung einer UI-Spezifikation (`spec/ui-spec.md`)
3. Codegenerierung für Backend und Frontend
4. Implementierung der jeweiligen Logik
5. Integration über klare API-Verträge

Repository-Struktur:

/backend → Go Backend (Logik, API, generierter Code)
/frontend → Elm Frontend (Model, View, Update)
/spec → OpenAPI- und UI-Spezifikation
/docs → Entscheidungsdokumente
/ci → Codegenerierungs-Skripte und GitHub Actions


---

# Entscheidungsdokumente

Die Entscheidungen zu Prozess, Sprachen und Tooling befinden sich in:

/docs/process-decision.md
/docs/language-decision.md
/docs/tooling-decision.md


---

# Spezifikationen

Die gesamte Anwendung ist über Spezifikationen definiert:

/spec/openapi.yaml → vollständige API-Spezifikation
/spec/ui-spec.md → Beschreibung der visuellen Darstellung


Diese Dateien bilden die Grundlage für:
- den generierten Go-Server
- den generierten Elm-API-Client
- die gesamte Implementierung

---

# Build & Start (folgt nach Implementierung)

## Backend starten (Go)

cd backend
go run ./cmd/server

## Frontend starten (Elm)

cd frontend
elm reactor

# CI/CD und Codegenerierung

Automatische Codegeneration über GitHub Actions ist vorbereitet:
Skripte unter ci/codegen/
Workflow unter ci/github-actions/codegen.yml
Die Generierung umfasst:
Backend-API-Server (Go)
Frontend-API-Client (Elm)

# Projektstatus

## Stand jetzt:
- Basis-Repository angelegt
- Entscheidungen dokumentiert
- Projektstruktur erstellt
- Spezifikationen vollständig vorhanden
- Codegenerierung vorbereitet (Commit 6 folgt)

## Nächste Schritte:
- Codegenerierung (Commit 6)
- Backend-Skeleton implementieren
- Frontend-Skeleton implementieren
- Integrationstest

# Zielgruppe
Dieses Repository dient als Coding-Dojo-Einreichung.
Besonders bewertet werden:
- die Architektur
- die Struktur des Codes
- klare Dokumentation
- professionelle Vorgehensweise
- technische Qualität


