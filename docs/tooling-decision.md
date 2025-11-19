
# Entscheidungsdokument: Tools, IDEs & CI/CD Pipeline

## Ziel
Dieses Dokument definiert die Toolchain, die IDEs und die CI/CD Pipeline.

---

## Anforderungen
- JetBrains bevorzugt  
- moderne, verständliche Pipeline  
- gute Integration mit Spec-Driven Development  
- klare, nachvollziehbare Build-Struktur  

---

## IDEs

### Backend: GoLand  
Beste Unterstützung für Go, einfache Integration von Tests und Codegen.

### Frontend: WebStorm  
Elm-Plugin verfügbar, klarer Workflow, ideal für Webprojekte.

---

## CI/CD

Optionen: GitHub Actions, GitLab CI, Bitbucket Pipelines, Jenkins.

**Gewählt:**  
# ✔ GitHub Actions

Begründung:  
- direkt im Repo sichtbar  
- leicht verständlich  
- unterstützt OpenAPI-Generator  
- Reviewer können alles online einsehen  

---

## Repository-Struktur

/backend
/frontend
/spec
/docs
/ci

---

## Codegenerierung
- OpenAPI Generator  
- Stubs für Go  
- Types/Clients für Elm  
- Integration in CI

---

## Ergebnis
Die Toolchain unterstützt einen klaren, modernen, nachvollziehbaren Workflow und ist optimal für das Coding Dojo.
