# 📋 GitHub Issues Roadmap
_Sortiert nach Priorität (High > Medium > Low)_

## 🔥 #15: Master: Alle 33 Spielstufen implementieren [balancing, content, prio: 1-high, prio: 2-medium]
---
**Status / Description:**
Zentrales Issue für den Ausbau der Spielstufen (0-32).

### Meilensteine:
- [ ] Stufen 4-10: Wachstumsphase
- [ ] Stufen 11-20: Bewegungsphase
- [ ] Stufen 21-32: Globales Finale

---

## 🔥 🔴 #5: Refactor: Finale JSON-Persistenz-Prüfung [bug, critical, prio: 1-high]
---
**Status / Description:**
Die Basis-Serialisierung wurde auf Null Safety umgestellt. Es muss nun im Langzeittest geprüft werden, ob alle Task-Zustände (Animationen) nach App-Restart perfekt erhalten bleiben.

---

## 🔥 #22: Balancing: Stage 0 als Tutorial-Onboarding umgestalten [balancing, content, prio: 1-high]
---
**Status / Description:**
Der Spielstart ist aktuell zu stressig. Stage 0 muss den Spieler sanft einführen.

**Ziele:**
-`activeTasks` in Stage 0 auf 1-2 Kernaufgaben reduzieren (Onboarding).
- Weitere Mechaniken sukzessive via Modifier freischalten.
- Komplexität und Zeitdruck in den ersten 5 Minuten drastisch senken.
- Ressourcen-Startwerte für ein Erfolgserlebnis optimieren.

---

## 🔥 #23: Architecture: Stages in Module auslagern [refactor, prio: 1-high]
---
**Status / Description:**
Die aktuelle `lib/stages.dart` ist zu groß. Um 32 Stufen wartbar zu machen, muss die Datenstruktur modularisiert werden.

**Vorschlag:**
- Aufteilung in Phase-Dateien (z.B. `stages_intro.dart`, `stages_growth.dart`, etc.).
- Nutzung von `part` und `part of` oder einer Registry-Klasse.
- Optional: Laden der Tasks aus JSON-Assets zur besseren Übersicht.

---

## ⚡ #8: UX: Tab-Navigation vervollständigen [ui, prio: 2-medium]
---
**Status / Description:**
Zwei Tabs (TaskList & LevelList) sind aktiv. Prüfung, ob weitere Ansichten für die Beta nötig sind.

---

## ⚡ ✨ #1: Logic: Miss-Mechanik verfeinern [enhancement, prio: 2-medium]
---
**Status / Description:**
Basis-Migration der miss-Logik in den Modifikatoren vorbereitet.

---

## ⚡ ✨ #6: UI-Feedback: Fehlende Visualisierung bei Kosten [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Wenn Ressourcen für einen Task abgezogen werden, gibt es kein visuelles Feedback für den Spieler.

---

## ⚡ #21: UI: Zahlen-Sichtbarkeit & Layout-Verschiebung fixen [ui, prio: 2-medium]
---
**Status / Description:**
Im Web-Build sind die Ressourcen-Zahlen schwer lesbar und das Layout wirkt verschoben. 

**To-Do:**
- Spaltenbreite in `RessourceTable` dynamisch anpassen.
- Kontrast und Schriftgröße der Ressourcen-Werte prüfen.
- Alignment in der AppBar für Web optimieren.

---

## ⚡ #16: Content: Stufen 4-10 (Wachstumsphase) [content, prio: 2-medium, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Mittelgroße Gemeinde (200) bis MegaChurch Level 4 (2.800).

---

## ☕ #9: Code Cleanup: Mock-Data verschieben [refactor, prio: 3-low]
---
**Status / Description:**
testTasks aus der Produktionslogik in eine dedizierte Mock-Klasse verschieben.

---

## ☕ #2: Assets: Icon Credits integrieren [documentation, prio: 3-low]
---
**Status / Description:**
Credits aus globals.dart in ein About-Menü überführen.

---

## ☕ #17: Content: Stufen 11-20 (Bewegungsphase) [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Beeinflussende Kirche (4.500) bis Globale Bewegung Level 3 (1.500.000).

---

## ☕ #7: Balancing: Task-Werte [balancing, prio: 3-low]
---
**Status / Description:**
Rebalancing der Kosten/Nutzen-Rechnung (z.B. studieren vs. Kasse führen).

---

## ☕ #18: Content: Stufen 21-32 (Globales Finale) [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Globale Größe (2.500.000) bis Weltkirche/Spielende (7,6 Mrd).

---

