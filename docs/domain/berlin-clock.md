# Domain Specification – Berlin Clock (Fachliche Spezifikation)

## 1. Zweck
Die Berlin-Uhr stellt die aktuelle Uhrzeit in einem speziellen Lampenraster dar.
Diese Spezifikation definiert die Businesslogik, die später automatisch über Spec-Driven Development (SDD) generiert wird:
- Datenmodell
- Regeln
- Schnittstellen
- Zustandslogik
- Fehlerfälle (falls erweitert wie Custom-Zeitinput)

## 2. Domain-Struktur
Die Uhr besteht aus fünf Bereichen:
- Sekundenlampe (1 Lampe, gelb)
- 5er-Stundenblock (4 Lampen, rot)
- 1er-Stundenblock (4 Lampen, rot)
- 5er-Minutenblock (11 Lampen, gelb/rot)
- 1er-Minutenblock (4 Lampen, gelb)

## 3. Lampen-Definitionen
3.1 Grundstruktur einer Lampe
Eine Lampe hat immer:
Eigenschaft	Typ	Beschreibung
active	boolean	ob die Lampe leuchtet
color	enum	red oder yellow

## 4. Regeln pro Segment
### 4.1 Sekunden (Top-Lampe)
Farbe: Gelb
Regeln:
an, wenn Sekunde gerade (sec % 2 == 0)
aus, wenn Sekunde ungerade (sec % 2 == 1)

### 4.2 Stundenanzeige (oben)
#### 4.2.1 5er-Stunden
4 Lampen
Jede Lampe repräsentiert 5 Stunden
Formel:
activeCount = hours / 5
Lampenstatus:
i < activeCount → active = true
else → active = false

#### 4.2.2 1er-Stunden
4 Lampen
Jede Lampe repräsentiert 1 Stunde
Formel:
activeCount = hours % 5

### 4.3 Minutenanzeige (unten)
#### 4.3.1 5er-Minuten
11 Lampen
Jede Lampe repräsentiert 5 Minuten
Farbe:
Standard → gelb
Viertelstunden → rot (Lampen 3, 6, 9)
Formel:
activeCount = minutes / 5
Farbe pro Position:
if position in {3,6,9} → red
else → yellow

#### 4.3.2 1er-Minuten
4 Lampen
Formel:
activeCount = minutes % 5

## 5. Datenmodell
Die Domain beschreibt ihren Zustand als Objekt:
BerlinClockState
mit folgenden Feldern:
### 5.1 Sekunden:
{
  "seconds": {
    "active": true,
    "color": "yellow"
  }
}
### 5.2 Stunden:
{
  "hours": {
    "five":   [true, true, false, false],
    "one":    [true, false, false, false]
  }
}
### 5.3 Minuten:
{
  "minutes": {
    "five": [
      {"active": true,  "color": "yellow"},
      {"active": true,  "color": "yellow"},
      {"active": true,  "color": "red"},
      ...
    ],
    "one": [true, true, false, false]
  }
}

## 6. Berechnung der Uhrzeit
Aus der Systemzeit:
hours   = now.Hour()
minutes = now.Minute()
seconds = now.Second()
werden die Lampenreihen über die oben definierten Regeln berechnet.

## 7. Beispiel-Ausgabe
Für
17:23:40
ist:
Sekunden:
sec = 40 → even → active = true
Stunden:
17/5 = 3 → five = [1,1,1,0]
17%5 = 2 → one  = [1,1,0,0]
Minuten:
23/5 = 4 → first 4 lamps active
23%5 = 3 → first 3 lamps active

## 8. Erweiterbarkeit
Die Domain erlaubt Erweiterungen:
Uhrzeit als Input (/berlin-clock/{hh:mm})
Animationen
Simulation
History
Farbenwechselthemes
JSON-RPC / MQTT / WebSocket
