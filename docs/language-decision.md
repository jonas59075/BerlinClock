
# Entscheidungsdokument: Programmiersprachen

## Ziel
Dieses Dokument beschreibt die Auswahl der Programmiersprachen für Frontend und Backend. Die Aufgabe verlangt ausdrücklich den Einsatz von Technologien, die bisher nicht verwendet wurden.

---

## Anforderungen
- neue Sprachen (nicht im bisherigen Repertoire)  
- klare Trennung von Backend und Frontend  
- gute Tool-Unterstützung (JetBrains bevorzugt)  
- starke Lesbarkeit und Eleganz  
- spec-driven Tauglichkeit  
- gute Dokumentationsmöglichkeiten  

---

## Backend – Analyse

Kandidaten: Go, Rust, F#, Elixir, Zig

**Go** wurde gewählt, weil:  
- sehr klare Syntax  
- ausgezeichnete Tool-Unterstützung (GoLand)  
- ideal für APIs und Microservices  
- sehr gute OpenAPI-Codegeneration  
- leicht nachvollziehbar für Reviewer  
- robust, minimalistisch, professionell

---

## Frontend – Analyse

Kandidaten: Elm, ClojureScript, ReScript, Kotlin/JS

**Elm** wurde gewählt, weil:  
- 100% funktionale Sprache  
- extrem deterministisch und gut lesbar  
- hervorragende Darstellung für logikgetriebene Aufgaben  
- ideales MVU-Modell (Model-View-Update)  
- perfekt für Reviewer, da klar und strukturiert

---

## Ergebnis

Backend-Sprache:  
# ✔ Go

Frontend-Sprache:  
# ✔ Elm
