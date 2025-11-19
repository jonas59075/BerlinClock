# Entscheidungsdokument: Entwicklungsprozess

## Ziel
Dieses Dokument beschreibt den strukturierten Entscheidungsprozess zur Wahl der geeigneten Entwicklungsstrategie für das Berlin-Uhr-Projekt. Verschiedene Methoden wurden anhand der Anforderungen aus der Coding-Dojo-Aufgabe bewertet.

---

## Bewertete Methoden
1. Iterative Entwicklung  
2. Testgetriebene Entwicklung (TDD)  
3. Prototyping / explorative Entwicklung  
4. Spec-Driven Development (SDD)

---

## Anforderungen aus der Aufgabe
- klare Trennung von Frontend und Backend  
- gute Nachvollziehbarkeit für Reviewer  
- moderne, strukturierte Architektur  
- Einsatz neuer Technologien  
- dokumentierter Entscheidungsweg  
- Fokus auf Codequalität  
- eindeutige Logikdarstellung der Berlin-Uhr  

---

## Bewertung

### Iterative Entwicklung  
+ flexibel, einfach  
– wenig dokumentierbar  
– Architektur entsteht „nebenher“

### TDD  
+ hohe Codequalität  
– hoher Initialaufwand  
– weniger geeignet für Architekturentscheidungen

### Prototyping  
+ schnelle Ergebnisse  
– chaotisch, wenig nachvollziehbar  
– ungeeignet für Reviewer-Transparenz

### Spec-Driven Development (SDD)  
+ Spezifikation ist die zentrale Wahrheitsquelle  
+ klare Trennung: Spec → Codegen → Implementierung  
+ sehr gut nachvollziehbar  
+ ideal für neue Sprachen (Go, Elm)  
+ OpenAPI-Integration möglich  
+ klare Architekturdisziplin

---

## Ergebnis
**Gewählte Methode:**  
# ✔ Spec-Driven Development (SDD)

Begründung:  
SDD bietet maximale Klarheit, starke Architekturdisziplin und die beste Nachvollziehbarkeit für Reviewer im Coding-Dojo-Kontext.

