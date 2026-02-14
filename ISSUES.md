# 📋 GitHub Issues Roadmap

## #18: Content: Stufen 21-32 (Globales Finale) 🏷️ 🏷️  [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Globale Gr├Â├ƒe (2.500.000) bis Weltkirche/Spielende (7,6 Mrd).

---

## #17: Content: Stufen 11-20 (Bewegungsphase) 🏷️ 🏷️  [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Beeinflussende Kirche (4.500) bis Globale Bewegung Level 3 (1.500.000).

---

## #16: Content: Stufen 4-10 (Wachstumsphase) 🏷️ 🏷️  [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Mittelgro├ƒe Gemeinde (200) bis MegaChurch Level 4 (2.800).

---

## #15: Master: Alle 33 Spielstufen implementieren 🏷️ 🏷️ 🏷️  [balancing, content, prio: 2-medium]
---
**Status / Description:**
Zentrales Issue f├╝r den Ausbau der Spielstufen (0-32).

### Meilensteine:
- [ ] Stufen 4-10: Wachstumsphase
- [ ] Stufen 11-20: Bewegungsphase
- [ ] Stufen 21-32: Globales Finale

---

## #9: Code Cleanup: Mock-Data verschieben 🏷️ 🏷️  [refactor, prio: 3-low]
---
**Status / Description:**
testTasks aus der Produktionslogik in eine dedizierte Mock-Klasse verschieben.

---

## #8: UX: Tab-Navigation vervollst├ñndigen 🏷️ 🏷️  [ui, prio: 2-medium]
---
**Status / Description:**
Die TabBarView zeigt aktuell nur die TaskList an. Die anderen Tabs m├╝ssen implementiert werden.

---

## #7: Balancing: Task-Werte 🏷️ 🏷️  [balancing, prio: 3-low]
---
**Status / Description:**
Rebalancing der Kosten/Nutzen-Rechnung (z.B. studieren vs. Kasse f├╝hren).

---

## #6: UI-Feedback: Fehlende Visualisierung bei Kosten ✨ 🏷️ 🏷️  [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Wenn Ressourcen f├╝r einen Task abgezogen werden, gibt es kein visuelles Feedback f├╝r den Spieler.

---

## #5: Refactor: Robuste JSON-Persistenz 🔴 🏷️ 🏷️  [bug, critical, prio: 1-high]
---
**Status / Description:**
Die aktuelle loadState/saveState Logik nutzt manuelle String-Keys. Dies sollte auf eine robustere Serialisierung (z.B. Task.fromJson Verfeinerung) umgestellt werden, um Type-Crashes zu vermeiden.

---

## #4: Validation: Task-Duplikation 🔴 🏷️ 🏷️  [bug, critical, prio: 1-high]
---
**Status / Description:**
In addTask (Game-Model) fehlt die Logik, um zu verhindern, dass der gleiche Task mehrfach gleichzeitig l├ñuft.

---

## #2: Assets: Icon Credits integrieren 🏷️ 🏷️  [documentation, prio: 3-low]
---
**Status / Description:**
Credits aus globals.dart in ein About-Men├╝ ├╝berf├╝hren.

---

## #1: Logic: Miss-Mechanik verfeinern ✨ 🏷️  [enhancement, prio: 2-medium]
---
**Status / Description:**
Basis-Migration der miss-Logik in den Modifikatoren vorbereitet.

---

