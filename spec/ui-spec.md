# UI-Spezifikation – Berliner Uhr

## Ziel
Diese UI-Spezifikation definiert die visuelle Darstellung der Berliner Uhr für das Elm-Frontend.

---

# 1. Darstellungskomponenten

Die Berliner Uhr besteht aus folgenden Elementen:

1. Sekunden-Lampe (1 gelb)
2. 5-Stunden-Reihe (4 rote Lampen)
3. 1-Stunden-Reihe (4 rote Lampen)
4. 5-Minuten-Reihe (11 Lampen, gelb und rot)
5. 1-Minuten-Reihe (4 gelbe Lampen)

---

# 2. Farbkonzept

- **R = Rot**
- **Y = Gelb**
- **O = Aus (grau)**

Empfohlene Farben für das Frontend:

Rot: #FF4444
Gelb: #FFCC00
Aus: #333333

---

# 3. Layout

Das Frontend zeigt die Uhr wie folgt:

(Sekunden) ●
5h ● ● ● ●
1h ● ● ● ●

5m ● ● ● ● ● ● ● ● ● ● ●
1m ● ● ● ●


Jede Lampe entspricht einem Element aus:

- `secondsLamp`
- `fiveHoursRow[]`
- `singleHoursRow[]`
- `fiveMinutesRow[]`
- `singleMinutesRow[]`

---

# 4. Datenfluss (Elm MVU)

## Model
Das Model enthält:

```elm
type alias BerlinClockState =
    { secondsLamp : String
    , fiveHoursRow : List String
    , singleHoursRow : List String
    , fiveMinutesRow : List String
    , singleMinutesRow : List String
    }
Update
jede Sekunde GET /berlin-clock
Model aktualisieren
View
jede Lampe als farbiges Rechteck rendern
Farben aus Mapping:
"R" → rot  
"Y" → gelb  
"O" → grau  
5. Interaktion
Die Uhr ist rein passiv:
keine Buttons
keine User-Events
automatische Aktualisierung
6. Ziel der Spezifikation
klare Trennung von Logik (Backend) und Darstellung (Frontend)
eindeutiges Mapping Frontend ↔ API
deterministische Darstellung der Berlin Uhr
