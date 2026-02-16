# 📋 GitHub Issues Roadmap
_Sortiert nach Priorität (High > Medium > Low)_

## 🔥 #15: Master: Alle 33 Spielstufen implementieren [balancing, content, prio: 1-high, prio: 2-medium]
---
**Status / Description:**
Fortschritt bei der Implementierung der Spielstufen:
- [x] Stufe 0 (Tutorial/Der Ruf)
- [x] Stufe 1 (Gemeinschaftsgruppe)
- [x] Stufe 2 (Der Clan/Geistesgaben)
- [x] Stufe 3 (Die Gemeinde/Delegation)

---

## 🔥 #16: Content: Stufen 4-10 (Wachstumsphase) [content, prio: 1-high, prio: 2-medium, prio: 3-low]
---
**Status / Description:**
Implementierung der Wachstumsphase begonnen. Neue Datei `stages_growth.dart` erstellt und Stage 4 (Die Pastoral-Barriere) integriert.

---

## 🔥 ✨ #27: Feature: Implement 'Congratulations' Dialog on Stage-Up [enhancement, ui, prio: 1-high]
---
**Status / Description:**
Wenn ein Spieler eine neue Stufe erreicht, gibt es aktuell kein klares visuelles Feedback. 

**Lösung:**
- In Game.levelListener eine neue Benachrichtigung auslösen.
- Einen SimpleDialog oder eine animierte Einblendung erstellen, die den neuen Stufen-Namen und die Belohnung anzeigt.

---

## 🔥 #31: UI: Visuelle Kennzeichnung von Blocker-Tasks [ui, prio: 1-high]
---
**Status / Description:**
Spieler müssen sofort erkennen, welche Aufgabe den Stufenaufstieg ermöglicht.

**Vorschlag:**
- Rote Umrandung oder spezielles Icon für Blocker-Tasks in der TaskList.
- Erklärungstext im Subtitle ergänzen.

---

## 🔥 🔴 #5: Refactor: Finale JSON-Persistenz-Prüfung [bug, critical, prio: 1-high]
---
**Status / Description:**
Die Basis-Serialisierung wurde auf Null Safety umgestellt. Es muss nun im Langzeittest geprüft werden, ob alle Task-Zustände (Animationen) nach App-Restart perfekt erhalten bleiben.

---

## 🔥 #22: UX & Balancing: Der Ruf (Tutorial-Onboarding) [balancing, content, prio: 1-high]
---
**Status / Description:**
Das Onboarding muss den geistlichen Dienst widerspiegeln.

**Phasen:**
1. Stille Zeit (Bibellesen)
2. Gebets-Motor (Beten)
3. Jüngerschaft (Hausbesuche)
4. Zeitmanagement (Schlafen)
5. Gemeinde-Keimzelle (Essen in Wohnung ab 5 Pers.)

**Fokus:** Weg von Organisation (Kasse), hin zur geistlichen Basis.

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

## ⚡ #8: UX: Tab-Navigation vervollständigen [ui, prio: 2-medium]
---
**Status / Description:**
Zwei Tabs (TaskList & LevelList) sind aktiv. Prüfung, ob weitere Ansichten für die Beta nötig sind.

---

## ⚡ #24: Logic: Jüngerschafts- & Wachstumslogik (nach Samy El-Daour) [documentation, balancing, prio: 2-medium]
---
**Status / Description:**
Jüngerschafts-Logik in Stage 4 implementiert:
- Task '1-zu-1 Mentoring' als Basis für Leiterentwicklung.
- Task 'Aufgaben abgeben' generiert nun Zeit-Ressourcen


---

## ⚡ #29: Logic: Stage-Fallback bei Ressourcenverlust [balancing, prio: 2-medium]
---
**Status / Description:**
Prüfung, ob ein Zurückfallen in eine niedrigere Stufe sinnvoll ist.

**Szenario:**
- Durch 'Streit' sinkt die Mitgliederzahl unter die Schwelle der aktuellen Stufe.
- Konsequenzen für Status und Aufgaben-Pool definieren.

---

## ⚡ ✨ #28: Feature: Implement automatic number formatting (K, M, B) [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Für große Zahlen (Mitglieder, Geld) ist eine Formatierung nötig (z.B. 1.5k, 1.2M).

**Lösung:**
- Eine NumberFormat Helper-Funktion erstellen.
- Diese in den Text-Widgets der Ressourcen-Anzeige anwenden.

---

## ☕ #7: Balancing: Task-Werte [balancing, prio: 3-low]
---
**Status / Description:**
Rebalancing der Kosten/Nutzen-Rechnung (z.B. studieren vs. Kasse führen).

---

## ☕ #2: Assets: Icon Credits integrieren [documentation, prio: 3-low]
---
**Status / Description:**
Credits aus globals.dart in ein About-Menü überführen.

---

## ☕ ✨ #32: Enhancement: Stage-Fallback System [enhancement, prio: 3-low]
---
**Status / Description:**
Prüfung, ob ein Zurückfallen in eine niedrigere Stufe sinnvoll ist.

**Konsequenz:**
- Bei Unterschreitung der Mitgliederschwelle gehen Aufgaben der höheren Stufe wieder verloren.
- Markiert als Low Priority Enhancement.

---

## ☕ #18: Content: Stufen 21-32 (Globales Finale) [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Globale Größe (2.500.000) bis Weltkirche/Spielende (7,6 Mrd).

---

## ☕ #17: Content: Stufen 11-20 (Bewegungsphase) [content, prio: 3-low]
---
**Status / Description:**
Implementierung der Stufen: Beeinflussende Kirche (4.500) bis Globale Bewegung Level 3 (1.500.000).

---

## ☕ #9: Code Cleanup: Mock-Data verschieben [refactor, prio: 3-low]
---
**Status / Description:**
testTasks aus der Produktionslogik in eine dedizierte Mock-Klasse verschieben.

---

## #34: UI: Gatekeeper-Tasks Gold markieren [ui]
---
**Status / Description:**
Aufgaben, die ein Ressourcen-Limit erhöhen (SetMax enthalten), sollen als motivierende Meilensteine mit goldener Umrandung hervorgehoben werden.

---

## #33: Logic: Integration von SetMax/SetMin in den Stufenverlauf [refactor]
---
**Status / Description:**
Nutze vorhandene SetMax Modifier, um Fortschritts-Gatter (Gates) zu realisieren. Ein Task mit SetMax erhöht das Ressourcen-Limit und ermöglicht so den Aufstieg in die nächste Stage.

---

## 🔴 #26: BLOCKER: Task cost UI does not update in real-time [bug, critical, prio: 0-blocker]
---
**Status / Description:**
Die Ressourcen-Anzeige in Tasks (z.B. Kosten) bleibt rot, obwohl der Spieler genug Ressourcen hat. Das RessourceItem Widget muss auf Änderungen der *globalen* Ressourcen im Game-Model hören, nicht nur auf seine eigenen props.

**Lösung:**
- RessourceItem muss einen Listener auf Game.ressources registrieren.
- setState muss bei jeder Änderung der globalen Ressource getriggert werden.

---

## 🔴 #25: BLOCKER: Stage Progression broken due to SetMax Modifier not triggering [bug, critical, prio: 0-blocker]
---
**Status / Description:**
Der Spieler kann nicht über Stage 0 aufsteigen, da der finale Task ('Essen in meiner Wohnung') den SetMax Modifier für die Mitgliederzahl nicht korrekt auslöst.

**Lösung:**
- SetMax Modifier zum modifier-Array des Schlüssel-Tasks hinzufügen.
- Sicherstellen, dass der neue max-Wert im Member-Ressourcenobjekt ankommt.

---

## #30: Logic: Blocker-Tasks (Stage-Gates) implementieren [balancing, refactor, prio: 0-blocker]
---
**Status / Description:**
Mitgliederzahl wird durch die aktuelle Stufe begrenzt.

**Mechanik:**
- Ein Blocker-Task (z.B. 'Essen in Wohnung') muss beendet werden, um das Mitglieder-Maximum für die nächste Stufe anzuheben.
- Erst danach ist ein Stage-Up möglich.

---

