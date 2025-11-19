# Berlin Clock – Spec-Driven Coding Dojo Projekt

Dieses Projekt implementiert die Berliner Uhr in zwei klar getrennten Komponenten:

- **Backend:** Go  
- **Frontend:** Elm  
- **Entwicklungsprozess:** Spec-Driven Development (SDD)

Die Entscheidungen für Prozess, Sprachen und Tooling wurden systematisch evaluiert und dokumentiert.  
Alle Entscheidungsdokumente befinden sich im Ordner /docs.

---

# Projektziel

Das Ziel dieses Coding Dojos ist es:

- Eine nachvollziehbare, klar strukturierte und gut dokumentierte Lösung zu entwickeln  
- Moderne, (vom Autor) bisher nicht verwendete Programmiersprachen einzusetzen  
- DÜden gesamten Weg vom Prozessentscheid bis zur implementierten Uhr sichtbar zu machen  
- über eine OpenAPI-Spezifikation Frontend und Backend sauber zu koppeln  

---

# Architekturüberblick

Die Architektur folgt einem **Spec-Driven Development**-Ansatz:

Spec → Codegeneration → Implementierung


Struktur des Repositories:**
- /backend → Go Backend (API, Logik, Models)
- /frontend → Elm Frontend (Model, View, Update)
- /spec → OpenAPI Spec + UI Spec
- /docs → Entscheidungsdokumente
- /ci → Pipelines & Codegeneration

Die API-Schnittstelle wird vollständig über eine OpenAPI-Datei definiert:

/spec/openapi.yaml

Die Darstellung (UI-Konzept) wird über ein weiteres Dokument beschrieben:

/spec/ui-spec.md

---

# Entscheidungsdokumente

Alle Herleitungen und Vergleiche liegen transparent im Ordner:
- /docs/process-decision.md
- /docs/language-decision.md
- /docs/tooling-decision.md

Diese beschreiben:

- Auswahl und Begründung des Entwicklungsprozesses  
- Auswahl und Begründung der beiden Programmiersprachen  
- Auswahl von Tooling, IDE und CI/CD  

---

# Build & Start (wird nach Implementierung ergänzt)

## Backend (Go)

bash
cd backend
go run ./cmd/server

## Frontend (Elm)

cd frontend
elm reactor
(Die konkrete Startanleitung wird ergänzt, sobald Backend und Frontend implementiert sind.)

## Zielgruppe

Dieses Projekt ist als Coding Dojo Einreichung konzipiert.
Wichtige Bewertungskriterien sind:
saubere Architektur
klare Trennung von Frontend/Backend
transparente Entscheidungen
moderne, neue Technologien
Lesbarkeit und Codequalität

# Status

- [x] Entscheidungsphase abgeschlossen
- [x] Repo-Struktur erstellt
- [x] Dokumentation begonnen
- [ ] Spec erstellen
- [ ] Codegenerierung einrichten
- [ ] Backend implementieren
- [ ] Frontend implementieren

Weitere Schritte folgen in kommenden Commits.
