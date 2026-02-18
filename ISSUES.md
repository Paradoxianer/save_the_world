# 📋 GitHub Issues Roadmap
_Sortiert nach Priorität (High > Medium > Low)_

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

## 🔥 #41: UX: Implement Immersive Onboarding & Story Intro [ui, content, prio: 1-high]
---
**Status / Description:**
Show mandatory DSGVO on first start. Add a comic-style intro dialog explaining the goal: 'Grow your members to save the world!'

---

## 🔥 🔴 #47: Bug: Stage resource icon in AppBar stays at 0 after loading [bug, prio: 1-high]
---
**Status / Description:**
The stage resource item does not update its visual value when a savegame is loaded, even though the internal stage index is correct.

---

## 🔥 #49: UX: Implement Story Intro Dialog [ui, content, prio: 1-high]
---
**Status / Description:**
Add a comic-style intro dialog explaining the game's core loop at the first start.

---

## ⚡ ✨ #1: Logic: Miss-Mechanik verfeinern [enhancement, prio: 2-medium]
---
**Status / Description:**
Basis-Migration der miss-Logik in den Modifikatoren vorbereitet.

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

## ⚡ ✨ #39: Feature: Stage Score & Trophy System [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Implement a scoring system based on active time and click count per stage. Award Bronze, Silber, or Gold trophies based on performance. Display trophies in the LevelList.

---

## ⚡ #46: Feature: German localized NumberFormatter (B -> Mrd) [ui, prio: 2-medium]
---
**Status / Description:**
Adjust NumberFormatter suffixes to match German naming conventions (Mio, Mrd instead of M, B).

---

## ⚡ #48: Feature: German localized NumberFormatter (B -> Mrd) [ui, prio: 2-medium]
---
**Status / Description:**
Adjust NumberFormatter suffixes to match German naming conventions (Mio, Mrd instead of M, B).

---

## ⚡ ✨ #50: UI: Add Confetti Effect to Level-Up [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Integrate a particle system (e.g. confetti package) to celebrate stage completion.

---

## ⚡ ✨ #42: Feature: Visual Celebration & Stage Scoring [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Implement confetti/fireworks effects on level up. Add a scoring algorithm (Time vs Clicks) and display Score/Trophies in CelebrationDialog and LevelList.

---

## ⚡ ✨ #44: UX: Comic-style About Dialog with dynamic Version [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Redesign the Info/About dialog to match the 'Living Cartoon' look. Display the current app version read from package_info.

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

## ☕ #9: Code Cleanup: Mock-Data verschieben [refactor, prio: 3-low]
---
**Status / Description:**
testTasks aus der Produktionslogik in eine dedizierte Mock-Klasse verschieben.

---

## ☕ ✨ #32: Enhancement: Stage-Fallback System [enhancement, prio: 3-low]
---
**Status / Description:**
Prüfung, ob ein Zurückfallen in eine niedrigere Stufe sinnvoll ist.

**Konsequenz:**
- Bei Unterschreitung der Mitgliederschwelle gehen Aufgaben der höheren Stufe wieder verloren.
- Markiert als Low Priority Enhancement.

---

## ✨ #38: ✨ Feature: Full Internationalization (i18n) Support [enhancement, ui]
---
**Status / Description:**
### Status / Description
Die App unterstützt bereits Locales (DE/EN) in der main.dart, aber viele Inhalte und Logiken sind noch hartkodiert.

### To-Do
- [ ] **Lokalisiertes Zahlenformat:** Der NumberFormatter muss Suffixe (K, M, B) basierend auf der Locale anpassen (z.B. 1.5 Mrd statt 1.5B).
- [ ] **ARB-Dateien:** Extraktion aller Hardcoded Strings (z.B. in MessageModifier oder Task-Beschreibungen) in ARB-Dateien.
- [ ] **Pluralisierung:** Korrekte Handhabung von Ressourcen-Texten (z.B. '1 Mitglied' vs '2 Mitglieder').
- [ ] **intl Package:** Integration des intl Packages in die pubspec.yaml für robuste Formatierung.

---

